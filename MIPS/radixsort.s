#           RADIXSORT


	.data
array: .word 154135, 167332, 923456, 924654 #Martnummer hier durch Komma getrennt
#----------dont touch me------------
n:     .word 4
text1: .asciiz "Welcome\nYour Radixsort has the following output\n"
newline: .asciiz "\n"

#
# main
#
	.text
	.globl main

radix:

###
# Insert your code here
###


	sll		$t0, $a1, 2		       # Left Shift n by 2 to get the number of bytes!
	add	  $t1, $t0, $t0        # bytes for the input array
	add		$t1, $t1, 40	       # bytes for the count array
	sub		$sp, $sp, $t1	       # finally decrement the stack to make space for count and input array
	lw		$s0, ($a0)		       # let first number in array be the max number
	li		$s1, 1			         # make the exponent as 1
	move	$s2, $sp		         # let s2 have the count array
	add		$s3, $s2, 40	       # let s3 have the input array
	add		$s4, $s3, $t0	       # finally s4 has the output array
	# Scanning the Input       
	li		$s5, 0				       # let s5 have the initial index
	scan_input:
	bge		$s5, $a1, scan_input_end
	sll		$t0, $s5, 2		       # get the index (aligned to byte) 
	add 	$t1, $t0, $a0	       # get the array_in[index]
	lw		$t1, ($t1)		       # get the value at array_in[index]
	add 	$t0, $t0, $s3	       # get the array_in[i] pointer
	sw		$t1, ($t0)		       # finally store the value
	addi	$s5,$s5,1		         # increment the index
	j	scan_input	
	scan_input_end:
	# Get the maximum value
	li		$s5, 0				       #let s5 have the initial index 
	get_max:
	bge		$s5, $a1, get_max_end
	sll		$t0, $s5, 2		       # Get the index (aligned to byte)
	add 	$t0, $t0, $s3	       # get the array_in[index]
	lw		$t0, ($t0)		       # get the value at array_in[index]
	addi	$s5, $s5, 1		       # increment the index
	ble		$t0, $s0, get_max    # if array_in[index] < current_max
	move	$s0, $t0		         # New Maximum number
	j get_max	
	get_max_end:
	# Compute the exponent
  li    $t9, 0
	compute_exp:
	bgt		$s1, $s0,	compute_exp_end 
	sw		$0, 0($s2)   # space for digit 0		            
  sw		$0, 4($s2)	 # space for digit 1	            
  sw		$0, 8($s2)	 # space for digit 2           
  sw		$0, 12($s2)	 # space for digit 3	           
  sw		$0, 16($s2)	 # space for digit 4	            
  sw		$0, 20($s2)	 # space for digit 5            
  sw		$0, 24($s2)	 # space for digit 6           
  sw		$0, 28($s2)	 # space for digit 7          
  sw		$0, 32($s2)	 # space for digit 8         
  sw		$0, 36($s2)	 # space for digit 9        
  # Get the digits 	 
	li		$s5, 0			  #let s5 have the initial index 
	digit_loop:
	bge		$s5, $a1, digit_loop_terminate
	sll		$t0, $s5, 2		# Get the index (aligned to byte)
	add 	$t0, $t0, $s3	# get the array_in[index]
	lw		$t0, ($t0)		# get the value at array_in[index]
	div		$t0, $t0, $s1	
	rem		$t0, $t0, 10	# New index is (array_in[i]/current_exponent)%10
	sll		$t0, $t0, 2		# Get the index (aligned to byte)
	add		$t0, $t0, $s2	
	lw		$t1, ($t0)		
	addi	$t1, $t1, 1		# Increment the count
	sw		$t1, ($t0)		# Store the value
	addi	$s5, $s5, 1		# Increment the index
	j	digit_loop
  digit_loop_terminate:
	# Generate Count
	li		$s5, 1			  #let s5 have the initial index 
	generate_count:
	bge		$s5, 10, generate_count_end
	sll		$t0, $s5, 2		# Get the index (aligned to byte)
	add 	$t0, $t0, $s2	# get the array_in[index]
	addi 	$t1, $t0, -4	# Get the value at array_in[index]
	lw		$t1, ($t1)		# Get the count at index - 1
	lw		$t2, ($t0)		# Get the count at present index
	add		$t2, $t2, $t1	# Generate the new count
	sw		$t2, ($t0)		# Store the new count
	addi	$s5, $s5, 1		# Increment the count
	j	generate_count
	generate_count_end:
	# Finally store the results in the output stack
	move	$s5, $a1				# Let s5 have the initial index
	generate_output:
	beq		$s5, $0, generate_output_end
	addi	$s5, $s5, -1	  # Decrement the index
	sll		$t0, $s5, 2		  # Generate the index (aligned to byte)
	add 	$t0, $t0, $s3	  # Get the array_in[index]
	lw		$t0, ($t0)		  # Get the value at array_in[index]
	div		$t1, $t0, $s1	  # Do array_in[index] / current_exponent
	rem		$t1, $t1, 10	  # Do array_in[index]/current_exponent%10
	sll		$t1, $t1, 2		  # Get the index aligned to byte
	add 	$t1, $t1, $s2	  # Get the count[(array_in[index]/current_exponent)%10] pointer
	lw		$t2, ($t1)		  # Get the value at count[(array_in[index]/current_exponent)%10]
	addi	$t2, $t2, -1	  # Decrement the count array
	sw		$t2, ($t1)		  # Finally update the count array
	sll		$t1, $t2, 2		  # Get the index aligned to byte
	add 	$t1, $t1, $s4	  # compute output[count[ (arr[i]/exp)%10 ] - 1] pointer
	sw		$t0, ($t1)      # store the new count
	j	generate_output
	generate_output_end:
	# Load the output array in the stack
	li		$s5, 0			    # let s5 have the initial index 
	load_output:
  addu  $t9, $t9, 1
	bge		$s5, $a1, load_output_end
	sll		$t0, $s5, 2		  # Generate the index (aligned to byte)
	add 	$t1, $t0, $s4	  # Get the output the array index
	lw		$t1, ($t1)		  # Get the value at array_out[index]
	add 	$t0, $t0, $s3	  # Get the array_in[index]
	sw		$t1, ($t0)		  # Copy the values
	addi	$s5,$s5,1		    # Increment the index
	j		load_output
	load_output_end:
	mul		$s1, $s1, 10	  # Generate the new exponent (current_exponent * 10)
	j		compute_exp
	compute_exp_end:
	move	$sp, $s4




jr 		$ra #return to main
main:

# Tttle 
	la 		$a0, text1
	li 		$v0, 4
	syscall
#end title

	addi	$sp, $sp, -4		# save return adress
	sw		$ra, 0($sp)

	la		$a0, array		# array adress
	lw		$a1, n	

	jal	radix

# print 1
	lw 		$a0, 0($sp)
	addi 	$sp,$sp,4
	li		$v0, 1
	syscall
	la 		$a0, newline
	li 		$v0,4
	syscall

# print 2
	lw 		$a0, 0($sp)
	addi 	$sp,$sp,4
	li		$v0, 1
	syscall
	la 		$a0, newline
	li 		$v0,4
	syscall
# print 3
	lw 		$a0, 0($sp)
	addi 	$sp,$sp,4
	li		$v0, 1
	syscall
	la 		$a0, newline
	li 		$v0,4
	syscall
# print 4
	lw 		$a0, 0($sp)
	addi 	$sp,$sp,4
	li		$v0, 1
	syscall
	la 		$a0, newline
	li 		$v0,4
	syscall

	lw		$ra, 0($sp)
	addi	$sp, $sp, 4
	jr		$ra

#
# end main
#
