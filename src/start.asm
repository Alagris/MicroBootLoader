.code16
.section .text
.include "utils.asm"
boot_begin:
    INIT
    //sectors count
    pushw $1
    //sector
    pushw $1
    //disk
    pushw $0x80  
    //RAM pointer
    pushw $__afterboot_begin_ld
    loop:
        mov $3,%cx
        mov %esp, %esi
        call debughexaw
        call println
        mov $__screenheight_ld,%cx
        mov (%esp), %si
        call debughexlines
        READ_KEY
        call clear
        cmp $'w ,%al
        je w_pressed
        cmp $'s ,%al
        je s_pressed
        cmp $'e ,%al
        je e_pressed
        cmp $'d ,%al
        je d_pressed
        cmp $'r ,%al
        je r_pressed
        cmp $'f ,%al
        je f_pressed
        cmp $'t ,%al
        je t_pressed
        cmp $'g ,%al
        je g_pressed
        cmp $'l ,%al
        je l_pressed
        cmp $'j ,%al
        je j_pressed
        cmp $'z ,%al
        je z_pressed
        cmp $'x ,%al
        je x_pressed
        cmp $'q ,%al
        je q_pressed
        cmp $'a ,%al
        je a_pressed
        jmp continue_loop
        w_pressed:
            subw $__byte_per_scroll_ld,(%esp)
            jmp continue_loop
        s_pressed:
            addw $__byte_per_scroll_ld,(%esp)
            jmp continue_loop
        e_pressed:
            incw 2(%esp)
            jmp continue_loop
        d_pressed:
            decw 2(%esp)
            jmp continue_loop
        r_pressed:
            incw 4(%esp)
            jmp continue_loop
        f_pressed:
            decw 4(%esp)
            jmp continue_loop
        t_pressed:
            incw 6(%esp)
            jmp continue_loop
        g_pressed:
            decw 6(%esp)
            jmp continue_loop
        z_pressed:
            incw (%esp)
            jmp continue_loop
        x_pressed:
            decw (%esp)
            jmp continue_loop
        q_pressed:
            subw $__bytes_per_line_ld,(%esp)
            jmp continue_loop
        a_pressed:
            addw $__bytes_per_line_ld,(%esp)
            jmp continue_loop
        l_pressed:
            READDISK 6(%esp), (%esp), 2(%esp), 4(%esp), $0, $0
            jmp continue_loop
        j_pressed:
            pop %ax
            mov $0,%sp
            jmp %ax
        continue_loop:
        jmp loop