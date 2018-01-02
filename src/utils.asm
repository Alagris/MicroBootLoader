
// .altmacro
.include "stack.asm"

.macro INIT   
    jmp $0x0000,$__start_16
__start_16:
    cli
    xor %ax, %ax
    /* We must zero %ds for any data access. */
    mov %ax, %ds
    /* TODO is it really need to clear all those segment registers, e.g. for BIOS calls? */
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    /*
    TODO What to move into BP and SP?
    http://stackoverflow.com/questions/10598802/which-value-should-be-used-for-sp-for-booting-process
    */
    mov %ax, %bp
    /* Automatically disables interrupts until the end of the next instruction. */
    mov %ax, %ss
    /* We should set SP because BIOS calls may depend on that. TODO confirm. */
    mov %bp, %sp
    /* Store the initial dl to load stage 2 later on. */
    // movl %dl
.endm


.macro PRINTC char
	push %ax
	movb \char  , %al
	movb $0x0e, %ah
	int $0x10
	pop %ax
.endm

 /*
AL  Sectors To Read Count
CH  Cylinder number
CL  Sector number
DH  Head number
DL  Drive number Starts at 0x80,
ES:BX   Buffer Address Pointer
*/
.macro READDISK sectorsCount, destination, drive=0x80, sector=1, head=0, cylinder=0 
    mov $2, %ah
    mov \sectorsCount, %al
    mov \drive, %dl
    mov \cylinder, %ch
    mov \head, %dh
    mov \sector, %cl
    mov \destination, %bx
    int $0x13
.endm


.macro RESETDISK drive=0x80
    // reset function
    mov $0x00,%ah  
    mov \drive,%dl  
    int $0x13
.endm

.macro READ_KEY
    mov $0x00, %ah
    int $0x16
.endm


/*
Print a null terminated string.
Use as:
        PRINT_STRING $s
        hlt
    s:
        .asciz "string"
*/
.macro PRINT_STRING s
    mov \s, %si
    cld
    push %ax
    mov $0x0e, %ah
1:
    lodsb
    or %al, %al
    jz 1f
    int $0x10
    jmp 1b
1:
    pop %ax
.endm


