
/*    DATA section containing variable declarations and    		*/
/*    assignment of values							*/

.data

.balign 4
mcand:
 .word 0xFFFFFFFF 

.balign 4
mplier:
  .word 20xFFFFFFFF

.balign 4
prod:
  .word 0


/*	CODE section								*/
.text

.balign 4
.global main

main:
  ldr r9, multiplicand  /* load multiplicand address          */
  ldr r10, multiplier   /* load multiplier address            */
  ldr r11, product      /* load product address               */
  ldr r3, [r9]          /* load multiplicand                  */
  ldr r2, [r10]         /* load multiplier                    */
  mov r1, #0            /* clear running product	        */
  mov r0, #0            /* clear multiplier counter	        */
  

while:
  cmp r0, r2
  beq endwhile        /* branch if multiplication complete    */
  add r1, r1, r3      /* add multiplicand to running product  */
  add r0, #1          /* decrement multiplier counter         */
  b while
  endwhile:
  str r1, [r11]       /* save product counter                 */
  mov r0, r1          /* copy product to output register      */
//  bkpt              /* insert software breakpoint           */
  bx lr               /* end program                          */

multiplicand : .word mcand
multiplier : .word  mplier
product : .word prod 
