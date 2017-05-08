.data

num1: .word 0
num2: .word 0
text1: .asciiz "\nProduct "
text2:.asciiz "\nQuotient"
name: .asciiz "\nName"
endline: .asciiz "\n"
prompt: .asciiz "\nEnter positive number"

.text
.globl main
main:
    lui     $a0, 0x1001         # get start of data
    addiu   $a0, $a0,0x1c       # get start of name
    andi    $a2, $a0, 0         # set flag to false
    jal print                   # print name
    ori     $s0, $0, 5          # repeat 5 times
    top:    
      beq     $s0, $0, end      # if counter is zero, stop loop
      lui     $a0, 0x1001       # set address of first word
      addiu   $a1, $a0, 4       # set address of second word
      jal getinput              # call function to get input, store into memory
      lui     $t0, 0x1001       # get address of first word
      lw      $a0, 0($t0)       # get the first value from memory
      lw      $a1, 4($t0)       # get the second value from memory
      jal multiply              # multiply the values, result in $v0
      addi    $a1, $v0, 0       # get value to print from $v0
      lui     $a0, 0x1001       # get start of data section
      addi    $a0, $a0, 8       # get start of product output string
      ori     $a2, $0, 1        # set flag to true
      jal print                 # print result
      lui     $t0, 0x1001       # get address of first word
      lw      $a0, 0($t0)       # get the first value from memory
      lw      $a1, 4($t0)       # get the second value from memory
      jal divide                # divide the values, result in $v0
      addi    $a1, $v0, 0       # get value to print from $v0
      lui     $a0, 0x1001       # get start of data section
      addi    $a0, $a0, 0x12    # get start of quotient output string
      ori     $a2, $0, 1        # set flag to true
      jal print                 # print result
      addi    $s0, $s0, -1      # decrement counter
      j top                     # repeat
    
    end: 
      ori     $v0, $0, 10       # set command to stop program,
      syscall
    
    getinput: 
      addiu   $sp, $sp, -4
      sw      $ra, 0($sp)        # store $ra into the stack
      jal getpos
      sw      $v0, ($a0)         # store the positive integer on memory
      jal getpos
      sw      $v0, ($a1)         # store the positive integer on memory
      lw      $ra, ($sp)         # copy from stack to $ra
      addi    $sp, $sp, 4        # increment stack pointer by 4
      jr      $ra #stub
    
    getpos: 
      addiu   $sp, $sp, -4
      sw      $ra, 0($sp)        # store $ra into the stack
      addiu   $sp, $sp, -4
      sw      $a0, 0($sp)        # store $ra into the stack
      addiu   $sp, $sp, -4
      sw      $a1, 0($sp)        # store $ra into the stack
      addiu   $sp, $sp, -4
      sw      $a2, 0($sp)        # store $ra into the stack
neg_:
      lui     $a0, 0x1001        # start of data section
      addiu   $a0, $a0, 0x24     # prompt string
      ori     $a2, $0, 0         # don't set the flag
      jal print
      ori     $v0, $0, 5         # opcode to read user i/p
      syscall
      slt     $t3, $v0, $0       # set $t3 if $v0 < 0
      bne     $t3, $0, neg_      # branch to neg if inp < 0
      lw      $a2, ($sp)         # copy from stack to $ra
      addi    $sp, $sp, 4        # increment stack pointer by 4
      lw      $a1, ($sp)         # copy from stack to $ra
      addi    $sp, $sp, 4        # increment stack pointer by 4
      lw      $a0, ($sp)         # copy from stack to $ra
      addi    $sp, $sp, 4        # increment stack pointer by 4
      lw      $ra, ($sp)         # copy from stack to $ra
      addi    $sp, $sp, 4        # increment stack pointer by 4
      jr      $ra #stub

    print: 
      addiu   $sp, $sp, -4
      sw      $ra, 0($sp)        # store $ra into the stack
      ori     $v0, $0, 4         # opcode to print user string
      syscall
      beq     $a2, $0, clr       # branch to clr if $a2 is 0
      ori     $a0, $a1, 0        # store the value of $a1 in $a0
      ori     $v0, $0, 1         # opcode to print int
      syscall
clr:  lui     $a0, 0x1001        # start of data section
      addiu   $a0, $a0, 0x22     # prompt string
      ori     $v0, $0, 4         # opcode to print int
      syscall
      lw      $ra, ($sp)         # copy from stack to $ra
      addi    $sp, $sp, 4        # increment stack pointer by 4
      jr $ra #stub
    
    multiply: 
      ori     $v0, $0, 0         # move 1 to $t1
      #addi    $a1, $a1, -1       # subtract 1 from $a1
m_cont:
      beq     $a1, $0, m_done    # branch to m_done if $a1 is 0
      add     $v0, $v0, $a0      # add $a0 with $a0 and store in $v0
      addi    $a1, $a1, -1       # subtract 1 from $a1
      j m_cont                   # loop back 
m_done:
      jr $ra #stub
    
    divide: 
      ori     $t1, $0, 1         # move 1 to $t1
      ori     $t0, $0, 0         # move 1 to $t1
      ori     $v0, $0, 0         # move 1 to $t1
d_cont:
      beq     $a0, $0, d_done    # branch to d_done if $t0 = $t1 
      beq     $t0, $t1, d_done   # branch to d_done if $t0 = $t1 
      addi    $v0, $v0, 1        # add 1 to $v0
      sub     $a0, $a0, $a1      # subtract a1 from $a0
      slt     $t0, $a0, $0       # set if $t0 < 0
      j d_cont                   # loop back 
d_done:
      jr $ra #stub
