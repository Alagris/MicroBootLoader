.code16


.macro LOOP_BEGIN loop_name counter_reg=%cx
	cmp $0 , \counter_reg 
	je \loop_name\()_end
	\loop_name\()_loop:
.endm

.macro LOOP_END loop_name counter_reg=%cx
	dec \counter_reg
	jne \loop_name\()_loop
	\loop_name\()_end:
.endm