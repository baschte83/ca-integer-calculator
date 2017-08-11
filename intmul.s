@ This is our multiplication function named intmul

	.global intmul
intmul:
	PUSH	{r4,r5,r6,lr}	@ save callee-save registers to stack

	MOV	r6, #1		@ Register to save signe of result
	CMP	r0, #0		@ checks if first operand is negative
	BGE	nextCheck	@ if first operand is positive, we jump forward to check the second operand
	NEG	r0, r0		@ first operand is negative -> we negate it to calculate with positive values
	NEG	r6, r6		@ r6 stores the fact, that the first operand is negative

nextCheck:
	CMP	r1, #0		@ checks if second operand is negative
	BGE	start		@ if second operand is positive, we jump forward to begin with multiplication
	NEG	r1, r1		@ second operand is negative -> we negate it to calculate with positive values
	NEG	r6, r6		@ r6 stores the fact, that the second operand is negative

start:
	MOV	r2, r0		@ save multiplicand in r2
	MOV	r3, r1		@ save multiplier in r3
	MOV	r0, #0		@ r0 = product
	MOV	r4, #1		@ bitmask to take lsb

loop:
	CMP	r3, #0		@ if multiplier == 0
	BEQ	end		@ jump to end, if multiplier == 0 -> multiplication is done
	AND	r5, r3, r4	@ isolates lsb of multiplier	
	CMP	r5 , #1		@ checks if lsb == 1
	BNE	shift		@ if not just do shift
	MOV	r1, r2		@ saves multiplicand to r1 to handle it over to intadd.s
	BL	intadd		@ product = product + multiplicand -> addition done with intadd.s

shift:
	LSL	r2, r2, #1	@ shift left multiplicand by one 
	LSR	r3, r3, #1	@ shift right multiplier by one
	B	loop

end:
	CMP	r6, #0		@ check, if one (or both) of the operands was negative
	BGT	out		@ if neither first nor second operand was negative, result mustn't be modified
	NEG	r0, r0		@ at least one of the operands was negative, so the result has to be nagated

out:
	POP	{r4,r5,r6,lr}	@ restore callee-save registers from stack
	BX 	lr		@ jump back to caller
