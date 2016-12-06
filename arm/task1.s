.data /* variable declarations */
//Make sure that the alignment is correct
.balign 4
//Declare the first variable
num1:
    .word 0x3        
//Make sure that the alignment is correct
.balign 4
//Declare the second variable
num2:
    .word 0x5

.section .init/* code starts here */
.global _start

_start:
        ldr r1, =num1       /* load address of num1 */
        ldr r2, [r1]        /* load the first number */
        ldr r3, =num2       /* load address of num2 */
        ldr r4, [r3]        /* load the second number */
        mul r0, r2, r4      /* multiply the two  numbers and store the result in r0 */
loop:   b   loop            /* end program */

