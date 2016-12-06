.data

.balign 4
.global printf
.global scanf

.balign 4
mess1:
.asciz "Please enter a number\n"

.balign 4
mess2:
.asciz "The sum is:\n"

.balign 4
pat:
.asciz "%d"

.balign 4
num_arr:
.skip 10

.text
count:
   push {lr}
   mov r4, #5			    /* Initialise counter 	*/
   while:
      cmp r4, #0			/* End of string reached?           */
      beq endwhile		    /* Count complete			        */	
      ldrb r0, [r2], #4     /* Load next number from the array  */
      add r3, r3, r0		/* Add 1 to count	                */
      add r4, r4, #-1		/* Add 1 to count	                */
      b while
   endwhile:
   pop {pc}
   bx lr

.global main
main:
   push {lr}
   mov r4, #5	    /* Initialise counter */
   for:
      cmp r4, #0	    /* End of loop?                             */
      beq endfor
      ldr r0, message1	/* load start address of first string	    */
      bl printf		    /* call printf function to output message	*/
      ldr r0, pattern	/* Tell scanf we want an integer            */
      ldr r1, number    /* Tell scanf where to store the num        */
      bl scanf			/* Call scanf to get the keyboard input	    */
      add r1, r1, #4
      add r4, r4, #-1
   endfor:
   ldr r0, message2	/* load start address of second string	    */
   bl printf		/* call printf function to output message	*/
   
   ldr r2, number   /* Tell scanf where to store the number*/
   bl add
   mov r0, r3       /* Move the final count in the output register */
   pop {pc}
   bx lr

message1:   .word mess1
message2:   .word mess2
pattern:    .word pat
number:     .word num_arr
