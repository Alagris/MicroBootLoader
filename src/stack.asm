
/* Push registers ax, bx, cx and dx. Lightweight `pusha`. */
.macro PUSH_ADX
    push %ax
    push %bx
    push %cx
    push %dx
.endm

/*
Pop registers dx, cx, bx, ax. Inverse order from PUSH_ADX,
so this cancels that one.
*/
.macro POP_DAX
    pop %dx
    pop %cx
    pop %bx
    pop %ax
.endm

// .macro PUSH_EADX
//     push %eax
//     push %ebx
//     push %ecx
//     push %edx
// .endm

// .macro POP_EDAX
//     pop %edx
//     pop %ecx
//     pop %ebx
//     pop %eax
// .endm
