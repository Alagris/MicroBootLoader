.code32
.global vga_print_string
.section .afterboot
/* VGA */

/*
Print a NULL terminated string to position 0 in VGA.
s: 32-bit register or memory containing the address of the string to print.
Clobbers: none.
Uses and updates vga_current_line to decide the current line.
Loops around the to the top.

Usage:
	mov string, %ecx
    mov line, %eax
    call vga_print_string
*/
    
vga_print_string:
	push %edx
	push %ebx
    mov $0, %edx
    /* Number of horizontal lines. */
    mov $25, %ebx
    div %ebx
    mov %edx, %eax
    /* 160 == 80 * 2 == line width * bytes per character on screen */
    mov $160, %edx
    mul %edx
    /* 0xb8000 == magic video memory address which shows on the screen. */
    lea 0xb8000(%eax), %edx
    /* White on black. */
    mov $0x0f, %ah
	vga_print_string_loop:
	    mov (%ecx), %al
	    cmp $0, %al
	    je vga_print_string_end
	    mov %ax, (%edx)
	    add $1, %ecx
	    add $2, %edx
	    jmp vga_print_string_loop
	vga_print_string_end:
	pop %ebx
	pop %edx
	ret
    // POP_EDAX
// .endm


/*
.include "stack.asm"
.global vga_print_string
.section .text
Usage:
	mov \string, %ecx
    mov \line, %eax
    call vga_print_string
vga_print_string:
    mov $0, %edx
    mov $25, %ebx
    div %ebx
    mov %edx, %eax
    mov $160, %edx
    mul %edx
    lea 0xb8000(%eax), %edx
    mov $0x0f, %ah
vga_print_string_loop:
    mov (%ecx), %al
    cmp $0, %al
    je vga_print_string_end
    mov %ax, (%edx)
    add $1, %ecx
    add $2, %edx
    jmp vga_print_string_loop
vga_print_string_end:
	ret
*/



/*
Enter protected mode.
Use the simplest GDT possible.
*/
// .macro PROTECTED_MODE
//     /* Must come before they are used. */
//     .equ CODE_SEG, 8
//     .equ DATA_SEG, gdt_data - gdt_start
//     /* Tell the processor where our Global Descriptor Table is in memory. */
//     lgdt gdt_descriptor
//     /*
//     Set PE (Protection Enable) bit in CR0 (Control Register 0),
//     effectively entering protected mode.
//     */
//     mov %cr0, %eax
//     orl $0x1, %eax
//     mov %eax, %cr0
//     ljmp $CODE_SEG, $protected_mode

// .code32
// protected_mode:
//     /*
//     Setup the other segments.
//     Those movs are mandatory because they update the descriptor cache:
//     http://wiki.osdev.org/Descriptor_Cache
//     */
//     mov $DATA_SEG, %ax
//     mov %ax, %ds
//     mov %ax, %es
//     mov %ax, %fs
//     mov %ax, %gs
//     mov %ax, %ss
//     /*
//     TODO detect the last memory address available properly.
//     It depends on how much RAM we have.
//     */
//     mov $0X7000, %ebp
//     mov %ebp, %esp
// .endm



