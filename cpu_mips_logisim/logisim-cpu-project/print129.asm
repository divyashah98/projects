

# The program should print out 129
MAIN:
  addiu $a0, $0, 0x0081
  jal PRINT
  j EXIT



DIV:
  #This function divides a0 by a1, returning
  # the quotient in v0 and the remainder in v1
  addu  $t0, $0, $0
  addu  $t1, $0, $0
  addiu $t7, $0, 1 #constant
DIVLOOP:
  slt   $t2, $a0, $t0
  beq   $t2, $t7, DIVRETURN
  addiu $t1, $t1, 0x0001
  addu  $t0, $t0, $a1
  j DIVLOOP
DIVRETURN:
  addiu $t2, $0, 0x0001
  subu  $v0, $t1, $t2
  subu  $v1, $t0, $a1
  subu  $v1, $a0, $v1
  jr $ra


TIMES:
  #This function returns a0*a1, computed by repeatedly 
  # adding a0
  addu  $v0, $0, $0
  addiu $t1, $0, 0x0001
TIMESLOOP:
  beq   $a1, $0, TIMESRETURN
  subu  $a1, $a1, $t1
  addu  $v0, $v0, $a0
  j TIMESLOOP
TIMESRETURN:
  jr $ra





PRINT:
  #This function prints a 3-digit number, one digit at
  # a time
  sw    $ra, 4($sp)

  #100s
  # first multiply 10 by 10 to get 100.
  sw    $a0, 8($sp)
  addiu $a0, $0, 0x000a
  addiu $a1, $0, 0x000a
  jal TIMES
  
  #divide the input by 100
  lw    $a0, 8($sp)
  addu  $a1, $0, $v0
  jal DIV  #should return 1 and 29

  # print the quotient and replace input with remainder
  addiu $v0, $v0, 0x0030 #convert the 1 to a char
  addiu $t1, $0,  0xffff
  sw    $v0, 0($t1) #print the 1
  addu  $a0, $0, $v1 #put the 29 in a0


  #10s
  #divide new input(old remainder) by 10
  sw    $a0, 8($sp)
  addiu $a1, $0, 0x000a
  jal DIV #should return 2 and 9

  #print the new quotient and replace input with new
  # remainder
  lw    $a0, 8($sp)
  addiu $v0, $v0, 0x0030 #convert the 2 to char
  addiu $t1, $0,  0xffff
  sw    $v0, 0($t1) #print the 2
  addu  $a0, $0, $v1 #put the 9 in a0


  #1s
  #print the remaining digit
  addiu $v0, $a0, 0x0030 #convert the 9 to char
  addiu $t1, $0,  0xffff
  sw    $v0, 0($t1) #print it

  lw    $ra, 4($sp)
  jr $ra

EXIT:
	