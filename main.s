    .syntax unified

    @ Template file for Lab 2 Integer Calculator
    @ by students Sebastian Baumann, Korbinian Karl, Ehsan Moslehi

    .arch armv6
    .fpu vfp
    .text                     		@ marks executable code section



    .global main			@ start of main function
main:

	@ prepare stack and memory before entering the program -----------------------------------------
	
	str	lr, [sp, #-4]!		@ used for main function
	sub	sp, sp, #12		@ we want to store 3 values: number 1, number 2 and an operation



	@ section to ask for and save two operands and an operation ------------------------------------

loop:	
	ldr	r0, printdata		@ load message "Enter Number 1" in r0
	bl	printf			@ call print-function printf

	ldr	r0, =patternScanDec	@ load adress of pattern to scan a decimal in r0
	mov	r1, sp			@ load adress of first free space on stack to store first number in r1
	bl	scanf			@ call scan-function scanf

	ldr	r0, printdata+4		@ load message "Enter Number 2" in r0
	bl	printf			@ call print-function printf

	ldr	r0, =patternScanDec	@ load adress of pattern to scan a decimal in r0
	add	r1, sp, #4		@ load adress of second free space on stack to store second number in r1
	bl	scanf			@ call scan-function scanf

	ldr	r0, printdata+8		@ load message "Enter Operation" in r0
	bl	printf			@ call print-function printf

	ldr	r0, =patternScanChar	@ load adress of pattern to scan a char in r0
	add	r1, sp, #8		@ load adress of third free space on stack to store operation in r1
	bl	scanf			@ call scan-function scanf



	@ section to check if a valid operation was entered --------------------------------------------

	ldrb	r0, [sp, #8]		@ load entered operation from stack in r0
	ldr	r1, =compareWithPlus	@ load adress of byte "+" in r1 to compare with entered operation
	ldrb	r1, [r1]		@ load byte "+" in r1
	cmp	r0, r1			@ compare entered operation with byte "+"
	beq	plus			@ jump to label "plus" which calls source code file intadd.s

	ldr	r1, =compareWithMinus	@ load adress of byte "-" in r1 to compare with entered operation
	ldrb	r1, [r1]		@ load byte "-" in r1
	cmp	r0, r1			@ compare entered operation with byte "-"
	beq	minus			@ jump to label "minus" which calls source code file intsub.s

	ldr	r1, =compareWithMult	@ load adress of byte "*" in r1 to compare with entered operation
	ldrb	r1, [r1]		@ load byte "*" in r1
	cmp	r0, r1			@ compare entered operation with byte "*"
	beq	mult			@ jump to label "mult" which calls source code file mult.s

	ldr	r0, printdata+20	@ load message "Invalid Operation Entered." in r1
	bl	printf			@ call print-function printf
	
	b	again			@ jump to label "again" to ask if user wants to do another calculation



	@ section to ask for another calculation -------------------------------------------------------

again:	
	ldr	r0, printdata+16	@ load message "Again?" in r0
	bl	printf			@ call print-function printf

	ldr	r0, =patternScanChar	@ load adress of pattern to scan a char in r0
	add	r1, sp, #8		@ load adress of third free space on stack to store operation in r1
	bl	scanf			@ call scan-function scanf

	ldr	r0, [sp, #8]		@ load entered operation from stack in r0
	ldr	r1, =compareWithYes	@ load adress of byte "y" in r1 to compare with entered operation
	ldrb	r1, [r1]		@ load byte "y" in r1
	cmp	r0, r1			@ compare entered operation with byte "y"
	beq	loop			@ if equal jump to start and ask again for numbers and an operation

	ldr	r1, =compareWithNo	@ load adress of byte "n" in r1 to compare with entered operation
	ldrb	r1, [r1]		@ load byte "n" in r1
	cmp	r0, r1			@ compare entered operation with byte "n"
	beq	exit			@ if equal jump to end of program

	ldr	r0, printdata+24	@ load message "No Valid Command." in r0
	bl	printf			@ call print-function printf
	b	again			@ neither "y" nor "n" was entered so we jump back to again



	@ section to print the result of the operation -------------------------------------------------

result:	
	mov	r1, r0			@ dummy result for testing! here we have to load the right result
	ldr	r0, printdata+12	@ load message "Result Is:" in r1
	bl	printf			@ call print-function printf
	b	again			@ jump to label "again" to ask if user wants to do another calculation


	
	@ section to prepare registers and call arithmetic functions in several source files ----------- 

plus:	
	ldr	r0, [sp]		@ load value of number 1 in r0
	ldr	r1, [sp, #4]		@ load value of number 2 in r1
	bl	intadd			@ call add function in intadd.s
	b	result			@ jump to label result to display calculated result

minus:	
	ldr	r0, [sp]		@ load value of number 1 in r0
	ldr	r1, [sp, #4]		@ load value of number 2 in r1
	bl	intsub			@ call sub function in intsub.s
	b	result			@ jump to label result to display calculated result

mult:	
	ldr	r0, [sp]		@ load value of number 1 in r0
	ldr	r1, [sp, #4]		@ load value of number 2 in r1
	bl	intmul			@ call mul function in intsub.s
	b	result			@ jump to label result to display calculated result


	
	@ clean up stack and memory before exiting the program -----------------------------------------

exit:	
	add	sp, sp, #12
	ldr	pc, [sp], #4
end:










@ defionition of global functions scanf and printf -----------------------------------------------------

	.global scanf
	.global printf



@ definition of strings as word ------------------------------------------------------------------------

printdata:
	.word	printEnterNum1		@ printdata
	.word	printEnterNum2		@ printdata+4
	.word	printEnterOp		@ printdata+8
	.word	printResultIs		@ printdata+12
	.word	printAgain		@ printdata+16
	.word	printErrorMessage	@ printdata+20
	.word	printNoValidCommand	@ printdata+24



@ definition of serveral messages to print for user interface ------------------------------------------

printEnterNum1:				@ message which demands to enter first number
	.asciz "Enter Number 1: "
	.space 1

printEnterNum2:				@ message which demands to enter second number
	.asciz "Enter Number 2: "
	.space 1

printEnterOp:				@ message which demands to enter a valid operation (+, -, *)
	.asciz "Enter Operation: "
	.space 1

printResultIs:				@ message to show the calculated result
	.asciz "Result is: %d\n"

printAgain:				@ message which asks, if user wants to do another calculation
	.asciz "Again? "
	.space 1

printErrorMessage:			@ error message -> invalid operation was entered (anything but +, -, *)
	.asciz "Invalid Operation Entered.\n"

printNoValidCommand:			@ error message -> invalid command was entered (anything but y or n)
	.asciz "No Valid Command.\n"



@ patterns used to scan elements entered by the user ---------------------------------------------------

patternScanDec:				@ pattern used to scan a decimal
	.asciz "%d"

patternScanChar:			@ pattern used to scan a char
	.asciz " %c"



@ patterns used to see if the user has entered a valid operation ---------------------------------------

compareWithPlus:			@ pattern to compare with "+"
	.byte '+'

compareWithMinus:			@ pattern to compare with "-"
	.byte '-'

compareWithMult:			@ pattern to compare with "*"
	.byte '*'



@ patterns used to see if the user wants to do another calculation or end the program ------------------

compareWithYes:				@ pattern to compare with "y"
	.byte 'y'

compareWithNo:				@ pattern to compare with "n"
	.byte 'n'
