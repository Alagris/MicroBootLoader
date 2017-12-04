.code16
.section .text
.global debughexb
.global debughexw
.global debughexab
.global debughexaw
.global debughexline
.global debughexlines
.extern println
.include "control_flow.asm"
.include "utils.asm"
/*
Usage: 
	prints first 4 bits (nibble) of %al
	(and destroys contents of %ax ,
	so you will have to save them somewhere ,
	if you need them later)
*/
debugnibble:
	cmp $0xA,%al
	jl debughex_digit
	debughex_letter:
		//%al-0xA+'A'=
		//%al-0xA+0x41=
		//%al+0x37
		add $0x37,%al
		jmp end
	debughex_digit:
		//%al+'0'=
		//%al+0x30
		add $0x30,%al
	end:
	movb $0x0e, %ah
	int $0x10
	ret

/*debug hex byte
Usage: 
	mov $value,%al
	call debughexb
*/
debughexb:
	push %ax
		shr $4,%al
		call debugnibble
		mov (%esp),%ax
		and $0x0F,%al
		call debugnibble
	pop %ax
	ret


/*debug hex word
Usage: 
	mov $value,%ax
	call debughexw
*/
debughexw:
	push %ax
		mov %ah,%al
		call debughexb
	pop %ax
	call debughexb
	ret

/*debug hex array of bytes
Usage: 
	mov $length-1,%cx
	mov $pointer, %si
	call debughexab
*/
debughexab:
	LOOP_BEGIN debughexab
		lodsb
		call debughexb
		lodsb
		call debughexb
		PRINTC $' '
	LOOP_END debughexab
	lodsb
	call debughexb
	lodsb
	call debughexb
	ret

/*debug hex array of words
The distinction bewteen debughexaw and debughexab
is important because of endianess of multi-byte numbers
Usage: 
	mov $length-1,%cx
	mov $pointer, %si
	call debughexaw
*/
debughexaw:
	LOOP_BEGIN debughexaw
		lodsw
		call debughexw
		PRINTC $' '
	LOOP_END debughexaw
	lodsw
	call debughexw
	ret
/*
Usage: 
	mov $pointer, %si
	call debughexa
*/
debughexline:
	push %ax
	push %cx
		movw %si,%ax
		call debughexw
		PRINTC $':'
		mov $__words_per_line_ld-1,%cx
		call debughexab
		call println
	pop %cx
	pop %ax
	ret

/*
Usage: 
	mov $lines_count,%cx
	mov $pointer, %si
	call debughexa
*/
debughexlines:
	LOOP_BEGIN debughexlines
		call debughexline
	LOOP_END debughexlines
	ret