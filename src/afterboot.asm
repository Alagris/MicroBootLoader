.include "stack.asm"
.section .afterboot

.macro BEGIN
    .code16
    cli
    // the following instruction (ljmp) should 
    // not be used in this case, because we are not sure
    // where this code will be loaded to in RAM
    // ljmp $0, $1f
    // 1:
    xor %ax, %ax
    // We must zero %ds for any data access. 
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    
    mov %ax, %bp
    // Automatically disables interrupts until the end of the next instruction. 
    mov %ax, %ss
    // We should set SP because BIOS calls may depend on that. TODO confirm. 
    mov %bp, %sp
    // Store the initial dl to load stage 2 later on. 
    mov %dl, initial_dl
    jmp after_locals
    initial_dl: .byte 0
    after_locals:
.endm

.macro CURSOR_POSITION x=$0, y=$0
    PUSH_ADX
    mov $0x02, %ah
    mov $0x00, %bh
    mov \x, %dh
    mov \y, %dl
    int $0x10
    POP_DAX
.endm

.macro CLEAR
    PUSH_ADX
    mov $0x0600, %ax
    mov $0x7, %bh
    mov $0x0, %cx
    mov $0x184f, %dx
    int $0x10
    CURSOR_POSITION
    POP_DAX
.endm

.macro VGA_PRINT_STRING s
    PUSH_EADX
    mov \s, %ecx
    mov vga_current_line, %eax
    mov $0, %edx
    // Number of horizontal lines.
    mov $25, %ebx
    div %ebx
    mov %edx, %eax
    // 160 == 80 * 2 == line width * bytes per character on screen 
    mov $160, %edx
    mul %edx
    // 0xb8000 == magic video memory address which shows on the screen. 
    lea 0xb8000(%eax), %edx
    // White on black. 
    mov $0x0f, %ah
loop:
    mov (%ecx), %al
    cmp $0, %al
    je end
    mov %ax, (%edx)
    add $1, %ecx
    add $2, %edx
    jmp loop
end:
    incl vga_current_line
    POP_EDAX
.endm

.macro PROTECTED_MODE
    // Must come before they are used. 
    .equ CODE_SEG, 8
    .equ DATA_SEG, gdt_data - gdt_start
    // Tell the processor where our Global Descriptor Table is in memory. 
    lgdt gdt_descriptor
    
    // Set PE (Protection Enable) bit in CR0 (Control Register 0),
    // effectively entering protected mode.
    
    mov %cr0, %eax
    orl $0x1, %eax
    mov %eax, %cr0
    ljmp $CODE_SEG, $protected_mode

// Our GDT contains:
// - a null entry to fill the unusable entry 0
// - a code and data. Both are necessary, because:
//   - it is impossible to write to the code segment
//   - it is impossible execute the data segment
//   Both start at 0 and span the entire memory,
//   allowing us to access anything without problems.
// A real OS might have 2 extra segments: user data and code.
// This is the case for the Linux kernel.
// This is better than modifying the privilege bit of the GDT
// as we'd have to reload it several times, losing cache.

gdt_start:
gdt_null:
    .long 0x0
    .long 0x0
gdt_code:
    .word 0xffff
    .word 0x0
    .byte 0x0
    .byte 0b10011010
    .byte 0b11001111
    .byte 0x0
gdt_data://this is in fact not needed
    //because the only thing we plan to do is tp
    //display "hello protected mode". We don't need variables for that
    .word 0xffff
    .word 0x0
    .byte 0x0
    .byte 0b10010010
    .byte 0b11001111
    .byte 0x0
gdt_end:
gdt_descriptor:
    .word gdt_end - gdt_start
    .long gdt_start
vga_current_line:
    //this variable also isn't really needed
    .long 0
.code32
protected_mode:
    // Setup the other segments.
    // Those movs are mandatory because they update the descriptor cache:
    
    mov $DATA_SEG, %ax
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss
    
    //TODO detect the last memory address available properly.
    //It depends on how much RAM we have.
    
    mov $0X7000, %ebp
    mov %ebp, %esp
.endm


BEGIN
    CLEAR
    PROTECTED_MODE
    VGA_PRINT_STRING $message
    jmp .
message:
    .asciz "hello protected mode"
