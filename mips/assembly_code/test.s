.data

array   : .space 40
name    : .asciiz "Name\n"
prompt  : .asciiz "\nEnter a number"
endline : .asciiz "\n"
space   : .asciiz " "

.text
.globl main
main:
    lui     $a0, 0x1001         # get start of data
    addiu   $a0, $a0,0x28       # get start of name
    ori     $v0, $0, 4          # opcode to print user string
    syscall
    lui     $a0, 0x1001         # get start of array
    jal getData                 # call getData
    lui     $a0, 0x1001         # get start of array
    jal print                   # call print
    ori     $v0, $0, 10         # set command to stop program,
    syscall
    
getData: 
    ori     $s0, $0, 0         # set the counter to zero
    ori     $s1, $0, 10        # set the counter value
    lui     $a1, 0x1001        # start of data section
loop:
    beq     $s0, $s1, exit     # branch to exit if $s0 is 10
    lui     $a0, 0x1001        # start of data section
    addiu   $a0, $a0, 0x2e     # prompt string
    ori     $v0, $0, 4         # opcode to print user string
    syscall
    lui     $a0, 0x1001        # start of data section
    addiu   $a0, $a0, 0x40     # space
    ori     $v0, $0, 4         # opcode to print user string
    syscall
    ori     $v0, $0, 5         # opcode to read user i/p
    syscall
    sw      $v0, 0($a1)        # store the i/p to mem
    addiu   $s0, $s0, 0x1      # increment the counter by 1
    addiu   $a1, $a1, 0x4      # increment the array addr by 1
    j loop
exit:
    jr      $ra                # jump back to caller

print: 
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)        # store $ra into the stack
    jal average
    ori     $s0, $0, 0         # set the counter to zero
    ori     $s1, $0, 10        # set the counter value
next:
    beq     $s0, $s1, done     # branch to exit if $s0 is 10
    addiu   $sp, $sp, -4
    sw      $a0, 0($sp)        # store $a0 into the stack
    lw      $a0, 0($a0)        # load the first int from the array
    ori     $v0, $0, 1         # opcode to print int
    syscall
    lui     $a0, 0x1001        # start of data section
    addiu   $a0, $a0, 0x40     # space string
    ori     $v0, $0, 4         # opcode to print string
    syscall
    lw      $a0, ($sp)         # copy from stack to $a0
    addi    $sp, $sp, 4        # increment stack pointer by 4
    addiu   $s0, $s0, 0x1      # increment the counter by 1
    addiu   $a0, $a0, 0x4      # increment the array addr by 4
    j next
done:
    lui     $a0, 0x1001        # start of data section
    addiu   $a0, $a0, 0x3e     # endline
    ori     $v0, $0, 4         # opcode to print user string
    syscall
    ori     $v0, $0, 2         # opcode to print user float
    syscall
    lui     $a0, 0x1001        # start of data section
    addiu   $a0, $a0, 0x3e     # endline
    ori     $v0, $0, 4         # opcode to print user string
    syscall
    lw      $ra, ($sp)         # copy from stack to $ra
    addi    $sp, $sp, 4        # increment stack pointer by 4
    jr $ra #stub

average:
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)        # store $ra into the stack
    addiu   $sp, $sp, -4
    sw      $a0, 0($sp)        # store $a0 into the stack
    ori     $s0, $0, 0         # set the counter to zero
    ori     $s1, $0, 10        # set the counter value
    ori     $t0, $0, 0         # set the sum to zero
sum:
    beq     $s0, $s1, avg      # branch to exit if $s0 is 10
    addiu   $sp, $sp, -4
    sw      $a0, 0($sp)        # store $a0 into the stack
    lw      $a0, 0($a0)        # load the first int from the array
    add     $t0, $t0, $a0      # sum = sum + element_loaded
    lw      $a0, ($sp)         # copy from stack to $a0
    addi    $sp, $sp, 4        # increment stack pointer by 4
    addiu   $s0, $s0, 0x1      # increment the counter by 1
    addiu   $a0, $a0, 0x4      # increment the array addr by 4
    j sum
avg:
    mtc1    $t0, $f0           # move from $t0 to $f0
    mtc1    $s1, $f1           # move from $t1 to $f1  
    cvt.s.w $f0, $f0           # convert int to float
    cvt.s.w $f1, $f1           # convert int to float
    div.s   $f12, $f0, $f1     # $f0 = $f0/$f1 = average
    lw      $a0, ($sp)         # copy from stack to $a0
    addi    $sp, $sp, 4        # increment stack pointer by 4
    lw      $ra, ($sp)         # copy from stack to $ra
    addi    $sp, $sp, 4        # increment stack pointer by 4
    jr $ra #stub
