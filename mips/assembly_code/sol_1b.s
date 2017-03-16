.data
heap_addr:  .word   0x10040000
space:  .asciiz   " "
new_line:  .asciiz   "\n"

.text
.globl main
main:
    jal     init
    add     $s0, $v0, $0
    ori     $a0, $s0, 0
    jal     print
    ori     $v0, $0, 10       # set command to stop program,
    syscall

init:
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    li      $a0, 100
    li      $v0, 9
    syscall
    ori     $t0, $v0, 0
    ori     $v1, $v0, 0
    ori     $v0, $0, 5          # opcode to read user i/p
    syscall
    add     $s0, $v0, $0        # get user input into $s0
    add     $s1, $v0, $0
    loop:
      beq     $s0, $0, end      # if counter is zero, stop loop
      ori     $v0, $0, 5        # opcode to read user i/p
      syscall
      sw      $v0, 0($t0)       # store the input value at heap
      addiu   $t0, $t0, 4       # increment the heap by 4
      addi    $s0, $s0, -1      # decrement the counter
      j loop                    # repeat
    end:
    ori     $v0, $s1, 0
    lw      $ra, ($sp)          # copy from stack to $ra
    addi    $sp, $sp, 4         # increment stack pointer by 4
    jr      $ra                 # return

print:    
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    ori     $t0, $v1, 0
    ori     $t1, $a0, 0         # get the number of elements from $a0 to $t1
    li      $t2, 0
print_loop:    
    beq     $t2, $t1, exit
    lw      $a0, 0($t0)
    ori     $v0, $0, 1
    syscall
    la      $a0, space
    ori     $v0, $0, 4
    syscall
    addiu   $t0, $t0, 4
    addiu   $t2, $t2, 1
    j       print_loop
exit:
    la      $a0, new_line
    ori     $v0, $0, 4
    syscall
    lw      $ra, ($sp)          # copy from stack to $ra
    addi    $sp, $sp, 4         # increment stack pointer by 4
    jr      $ra                 # return

