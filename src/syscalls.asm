.code16


.section .text

.global prints
.global clear
.global readdisk
.global println
.global resetdisk

.include "stack.asm"

/*Procedure for printing string
USAGE:
 	mov $message, %si
    call prints
*/
// prints:
//   movb $0x0e, %ah
//   cld
// prints_loop:
//     lodsb
//     cmp %al, '\0'
//     or %al, %al
//     je prints_end
//     int $0x10
//     jmp prints_loop
// prints_end:
//   ret



println:
  push %ax
  movb $0x0e, %ah
  movb $'\n'  , %al
  int $0x10
  movb $'\r'  , %al
  int $0x10
  pop %ax
  ret



clear:
  PUSH_ADX
  mov $0x0600, %ax
  mov $0x7, %bh
  mov $0x00, %cx
  mov $0x184f, %dx
  int $0x10
  mov $0x00, %dh
  mov $0x00, %dl
  mov $0x02, %ah
  mov $0x00, %bh
  int $0x10
  POP_DAX
  ret