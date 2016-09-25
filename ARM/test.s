.data /* variable declarations */

.balign 4
num1:
	.word 7	/* create variable num1 & put 2 into it */

.balign 4
num2:
	.word 3 	/* create variable num2 & put 5 into it */

.text /* code starts here */
.balign 4
.global main

main:
	ldr r1, number1   	/* load address of number1 */
	ldr r2, [r1]		/* load first number       */
	ldr r3, number2	/* load address of number2 */
	ldr r4, [r3]		/* load second number      */
	subs r0, r2, r4	/* subtract numbers        */
	bx lr			/* end program             */

/* labels needed to access data */
number1 :  .word num1 /* put addr of num1 into number1 */
number2 :  .word num2 /* put addr of num2 into number2 */
