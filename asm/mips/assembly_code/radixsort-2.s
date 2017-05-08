#            -------------------RADIXSORT--------------------
# Template for Radix Sort


	.data
array: .word 154135, 167332, 923456, 924654 #4 Sample 6 number sets
#----------DO NOT change anything here-------------
n:     .word 4
text1: .asciiz "Welcome to the sorting program.\nRadixsort has sorted it like this.\n"
newline: .asciiz "\n"

#
# main
#
	.text
	.globl main

radix:

###
# Insert your code ONLY here
###

#--------------------------------------------------------------------
#--###---#---###----------#------------------------------------------
#-#-----###-----#----##--###-----------------------------------------
#--###---#---####---#-----#------------------------------------------
#-----#--#--#---#---#-----#------------------------------------------
#--###----#--#####--#------#-----------------------------------------
#--------------------------------------------------------------------

# Is assumed that:
	#- All the registers can be modified
	#- The result is a array allocated in the stack

	sll		$t0, $a1, 2		# number of bytes of (output) array
	add		$t1, $t0, $t0	# number of bytes of (input) array
	add		$t1, $t1, 40	# bytes to assign = 10 x 4 for the count array
	sub		$sp, $sp, $t1	# alloc space in the stack
	
	move	$a0, $a0		# $a0 = array
	move	$a1, $a1		# $a1 = length of array
	lw		$s0, ($a0)		# $s0 = maximum number, initially = to the first array element, later will be set to maximum
	li		$s1, 1			# $s1 = exponent = 1
	move	$s2, $sp		# $s2 = count array
	add		$s3, $s2, 40	# $s3 = input array
	add		$s4, $s3, $t0	# $s4 = output array
	
	# copy input loop
	li		$s5, 0				# $s5 = i = 0
	copyin_loop:
		bge		$s5, $a1, copyin_loop_end
		sll		$t0, $s5, 2		# compute byte sized index
		add 	$t1, $t0, $a0	# compute array[i] pointer
		lw		$t1, ($t1)		# load array[i]
		add 	$t0, $t0, $s3	# compute input array[i] pointer
		sw		$t1, ($t0)		# store input array[i]=array[i]
		addi	$s5,$s5,1		# i++
		j		copyin_loop
	copyin_loop_end:
	
	# findmax loop
	li		$s5, 0				# $s5 = i = 0
	findmax:
		bge		$s5, $a1, findmax_end
		sll		$t0, $s5, 2		# compute byte sized index
		add 	$t0, $t0, $s3	# compute input array[i] pointer
		lw		$t0, ($t0)		# load element value
		addi	$s5, $s5, 1		# i++
		ble		$t0, $s0, findmax	# current element is not greater that the maximum number
		move	$s0, $t0		# update maximum number
		j	findmax
	findmax_end:
	
	# exponent loop
	exp_loop:
			bgt		$s1, $s0,	exp_loop_end	# until exponent > maximum number, same thing that while(max/exp>0)
			sw		$0, 0($s2)		# count[0]=0
			sw		$0, 4($s2)		# count[1]=0
			sw		$0, 8($s2)		# count[2]=0
			sw		$0, 12($s2)		# count[3]=0
			sw		$0, 16($s2)		# count[4]=0
			sw		$0, 20($s2)		# count[5]=0
			sw		$0, 24($s2)		# count[6]=0
			sw		$0, 28($s2)		# count[7]=0
			sw		$0, 32($s2)		# count[8]=0
			sw		$0, 36($s2)		# count[9]=0
			
			# count digits loop
			li		$s5, 0				# $s5 = i = 0
			count_loop:
				bge		$s5, $a1, count_loop_end
				sll		$t0, $s5, 2		# compute byte sized index
				add 	$t0, $t0, $s3	# compute input array[i] pointer
				lw		$t0, ($t0)		# load element value
				div		$t0, $t0, $s1	#
				rem		$t0, $t0, 10	# index = (input array[i]/exponent)%10
				sll		$t0, $t0, 2		# compute byte sized index
				add		$t0, $t0, $s2	#
				lw		$t1, ($t0)		#
				addi	$t1, $t1, 1		# count[index]++
				sw		$t1, ($t0)		#
				addi	$s5, $s5, 1		# i++
				j	count_loop
			count_loop_end:
			
			# count accumulate loop
			li		$s5, 1				# $s5 = i = 1
			countac_loop:
				bge		$s5, 10, countac_loop_end
				sll		$t0, $s5, 2		# compute byte sized index
				add 	$t0, $t0, $s2	# compute count[i] pointer
				addi 	$t1, $t0, -4	# compute count[i-1] pointer
				lw		$t1, ($t1)		# load count[i-1]
				lw		$t2, ($t0)		# load count[i]
				add		$t2, $t2, $t1	# count[i] = count[i] + count[i-1] // accumulate the digit count
				sw		$t2, ($t0)		# store count[i]
				addi	$s5, $s5, 1		# i++
				j	countac_loop
			countac_loop_end:
			
			# build the output array loop
			move	$s5, $a1				# $s5 = i = array length
			makeout_loop:
				beq		$s5, $0, makeout_loop_end
				addi	$s5, $s5, -1	# i--
				sll		$t0, $s5, 2		# compute byte sized index
				add 	$t0, $t0, $s3	# compute input array[i] pointer
				lw		$t0, ($t0)		# load array[i]
				div		$t1, $t0, $s1	# array[i]/exponent
				rem		$t1, $t1, 10	# (array[i]/exponent)%10
				sll		$t1, $t1, 2		# compute byte sized index
				add 	$t1, $t1, $s2	# compute count[(array[i]/exponent)%10] pointer
				lw		$t2, ($t1)		# load count[(array[i]/exponent)%10]
				addi	$t2, $t2, -1	# count[(array[i]/exponent)%10]--
				sw		$t2, ($t1)		# store count[(array[i]/exponent)%10]
				sll		$t1, $t2, 2		# compute byte sized index
				add 	$t1, $t1, $s4	# compute output[count[ (arr[i]/exp)%10 ] - 1] pointer
				sw		$t0, ($t1)
				j	makeout_loop
			makeout_loop_end:
			
			# copy output loop
			li		$s5, 0				# $s5 = i = 0
			copyout_loop:
				bge		$s5, $a1, copyout_loop_end
				sll		$t0, $s5, 2		# compute byte sized index
				add 	$t1, $t0, $s4	# compute output array[i] pointer
				lw		$t1, ($t1)		# load output array[i]
				add 	$t0, $t0, $s3	# compute input array[i] pointer
				sw		$t1, ($t0)		# store input array[i]=output array[i]
				addi	$s5,$s5,1		# i++
				j		copyout_loop
			copyout_loop_end:
			
			mul		$s1, $s1, 10	# exponent = exponent x 10
			j		exp_loop
	exp_loop_end:
	
	move	$sp, $s4
	
#--------------------------------------------------------------------
#-####---------#-----------------------------------------------------
#-#------------#-----------------------------------------------------
#-###---##---###-----------------------------------------------------
#-#----#--#-#--#-----------------------------------------------------
#-####-#--#--##------------------------------------------------------
#--------------------------------------------------------------------
jr 		$ra #jump in main
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
