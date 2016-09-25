
/*    DATA section containing variable declarations and    		*/
/*    assignment of values							*/

.data

.balign 4
mcand:
 .word 0xFFFFFFFE

.balign 4
mplier:
  .word 0xFFFFFFFF

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
  mul r1, r2, r3 
  str r1, [r11]       /* save product counter                 */
  ldr r0, [r11]          /* copy product to output register      */
  //bkpt              /* insert software breakpoint           */
  bx lr               /* end program                          */

multiplicand : .word mcand
multiplier : .word  mplier
product : .word prod 
