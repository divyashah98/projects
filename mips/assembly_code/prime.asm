.data
prompt_1:	  .asciiz "\n\nPlease enter a number: "
prime:	    .asciiz "The number is prime."
not_prime:	.asciiz "The number is not prime."

# Registers Used: $a1=num; $s0=i; $s1=f; $s2=(num/2)+1;

.text

main:	
	li $v0, 4         # Command to print string
	la $a0, prompt_1  # GEt addr of prompt_1 in $a0
	syscall
	li $v0, 5         # Command to get int
	syscall
	move $a1, $v0     # Store the number in $a1
	
	move $s0, $zero   # Load $s0 with 0
	addi $s0, $s0, 2  # $s2 = 2
	move $s1, $zero   # load $s0 with 0
	div $s2, $a1, 2   # $s2 = ($s2)/ 2 + 1
	addi $s2, $s2, 1
	j loop

loop:
	slt $s3, $s0, $s2 # set $s3 if $s0 < $s2
	beq $s3, $0, end  # if 0 branch to end
	div $a1, $s0      # divide the number by $s0
	mfhi $t0				  # $t0 stores ($a1 % $s0)
	
	beq $t0, $0, add1 # if 0 jump to add1
	addi $s0, $s0, 1  # add 1 to $s0
	j loop

add1:
	addi $s1, $s1, 1  # add 1 to $s1
	j end

end:
	beq $s1, $zero, print_prime
	li $v0, 4
	la $a0, not_prime
	syscall
	j exit

print_prime:
	li $v0, 4
	la $a0, prime
	syscall	
	j exit

exit:
	li $v0, 10
	syscall
