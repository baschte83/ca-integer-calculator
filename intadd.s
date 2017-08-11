@ This is our addition function named intadd

	.global	intadd
intadd:
	PUSH	{lr}		@ Save callee-save registers to stack
	
loop:	
	EOR	r2,r0,r1	@ Partialsum PS
	AND	r1,r0,r1	@ Carry C
	MOV	r0,r2		@ move PS to r0
	LSL	r1,r1,#1	@ shift carry left by one
	CMP	r1, #0		@ if carry==0 end, otherwise do it again
	BNE	loop

end:
	POP	{lr}		@ restore callee-save registers from stack
	BX	lr		@ jump back to caller


