@ All work done by Ehsan Moslehi and Sebastian Baumann
@ This is our subtract function named intsub

@ To calculate "a - b" we negate one of the operands (we decided to use the second one, 
@ the operand b) and call our implemented and testet add function in source file intadd.s:

	.global intsub

intsub:
	push	{lr}		@ save callee-save registers to stack

	NEG	r1, r1		@ negate the second operand
	bl	intadd		@ call add function in source file intadd.s
	
	pop	{lr}		@ restore callee-save registers from stack
	bx	lr		@ jump back to caller
