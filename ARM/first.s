/* ex2a.s */
/* This is a comment */
.global main
.func main
main:
	mov r3, #0x1   		/* load first number    */
	mov r2, #0x2  		/* load second number   */
	adds r0, r2, r3	/* add numbers together */
	bx lr			/* end program          */
