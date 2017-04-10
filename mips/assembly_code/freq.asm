.data
  frequencies:	.byte		0:104
  prompt:	      .asciiz	"Please enter string (should end with $):\n"

.text
  .globl main  

main:
  la $a0, prompt          # Load addr of prompt in $a0
  li $v0, 4			          # Set output to print a string
  syscall			            
  la $s0, frequencies		  # Hold the base address of frequencies array in $s0
  addi $s1, $s0, 100		  # Get the addr of last word in $s1

loop:				              
  li $v0, 12			        # Command to read a character
  syscall			            
  beq $v0, '$', print		  # End the loop if "$" is entered
  bgt $v0, 96, lowercase	# Branch to lowercase since ASCII > 96
  blt $v0, 91, uppercase	# Branch to uppercase since ASCII < 91 (for a character)
  j loop			            # Loop

lowercase:			          
  bgt $v0, 123, loop		  # Consider next character if not a lowercase one
  sub $v0, $v0, 32		    # Convert to uppercase

uppercase:			          
  blt $v0, 65, loop		    # Coniser next character if not a uppercase one
  sub $v0, $v0, 65		    # Subtract 65 to get the integer equivalent of character
  add $v0, $v0, $v0		    # Multiply by two
  add $v0, $v0, $v0		    # Get the correct word aligned address
  add $v0, $v0, $s0		    # Add the offset to the base addr
  lw $t0, ($v0)			      # Get the previous frequency of the letter
  addi $t0, $t0, 1		    # Increase its frequency
  sw $t0, ($v0)			      # Update the frequency
  j loop			            # Loop

print:				            
  li $s2, 65			        # Print for A
  li $s4, 0			          # Offset for frequencies array

printloop:			          
  add $a0, $s2, $zero		  # Move $s2 to $a0
  li $v0, 11			        # command to output a char
  syscall			            
  li $v0, 11		  	      # command to output a char
  li $a0, 58			        # ASCII equivalent of :
  syscall			            
  li $a0, 32			        # ASCII equivalent of space
  li $v0, 11			        # Command to print char
  syscall			           
  li $v0, 1			          # Command to print int
  lw $a0, frequencies ($s4)	# Get the frequency of the letter
  syscall			              
  li $a0, 10			          # ASCII equivalent of new line
  li $v0, 11			          # Command to print char
  syscall			             
  addi $s2, $s2, 1		      # Go to the next letter
  addi $s4, $s4, 4		      # Get the next word aligned addr
  blt $s2, 91, printloop	  
  
exit:
  li $v0, 10			          # Command to end the program
  syscall
