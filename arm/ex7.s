.data

.balign 4
.global printf
.global scanf

.balign 4
mess1:
.asciz "Please enter a string\n"

.balign 4
mess2:
.asciz "The length of the string is\n"

.balign 4
pat:
.asciz "%[^\n]c"

.balign 4
strg:    /* declare strg as an array to store the bytes of the string */
.skip 9

.text
count:
   push {lr}
   mov r4, #0			/* Initialise character counter 	*/
   while:
      ldrb r3, [r2], #+1      /* Load next character in string  	*/
      cmp r3, #0			/* End of string reached?		*/
      beq endwhile		/* Y: Count complete			*/	
      add r4, r4, #1		/* N: Add 1 to character count	*/
      b while
   endwhile:
   
   pop {pc}
   bx lr

.global main
main:
   push {lr}
   ldr r0, message1	/* load start address of first string	*/
   bl printf		/* call printf function to output message	*/

   ldr r0, pattern	/* Tell scanf we want a string*/
   ldr r1, string /* Tell scanf where to store the string*/
   bl scanf			/* Call scanf to get the keyboard input	*/

   ldr r0, message2	/* load start address of second string	*/
   bl printf		/* call printf function to output message	*/
   
   ldr r2, string /* Tell scanf where to store the string*/
   bl count
   mov r0, r4 /* Move the final count in the output register */
   pop {pc}
   bx lr

message1: .word mess1
message2: .word mess2
pattern: .word pat
string : .word strg 
