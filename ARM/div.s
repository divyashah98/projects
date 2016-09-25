.data

.balign 4
divid:
.word 68

.balign 4
divis:
  .word 7
  .balign 4
quot:
  .word 0

/* CODE section                                          	    */
.text

/* Subroutine div							    */
/* Dividend and divisor passed in via registers r1 and r2 */
/* Quotient returned in register r0				    */

div:			    /* start of subroutine		    */	
  push {lr}		    
  mov r0, #0          /* clear quotient fer           */
  while:
    subs r1, r1, r2   /* subtract divisor from dividend   */
    bcc endwhile      /* branch when division complete    */
    add  r0, #1       /* increment quotient counter       */
    b while
  endwhile:
  pop {pc}
bx lr                 /* return from subroutine           */

/* End of subroutine div					    */	

/* Main program							 */

.global main
main:
  push {lr}
  ldr r9, dividend    /* load dividend address          */
  ldr r10, divisor    /* load divisor address           */
  ldr r11, quotient   /* load quotient address          */
  ldr r1, [r9]        /* load dividend                  */
  ldr r2, [r10]       /* load divisor                   */
  bl div		    /* call subroutine			  */	
  str r0, [r11]       /* save quotient counter          */
  pop {pc}
  bx lr               /* end program                    */

/* End of main program						  */	

dividend : .word divid
divisor : .word  divis
quotient : .word quot
