.data
heap_addr:    .word   4, 50, 200, 1, 5, 2, 4, 1, 5, 3
space:  .asciiz   " "
new_line:  .asciiz   "\n"

.text
.globl main
main:
    jal     print
    li      $a0, 4
    li      $a1, 0
    jal     swap
    jal     print
    li      $a0, 3
    jal     getRightChildIndex
    ori     $s0, $v0, 0
    li      $a0, 2
    jal     getLeftChildIndex
    ori     $a1, $v0, 0
    ori     $a0, $s0, 0
    jal     swap
    jal     print
    ori     $v0, $0, 10         # set command to stop program,
    syscall

print:    
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    la      $t0, heap_addr      # set the starting address of the heap_addr in $t0
    li      $t1, 10
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

swap:
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    la      $t0, heap_addr      # set the starting address of the heap_addr in $t0
    sll     $a0, $a0, 0x2       # shift the index by 4 to get aligned addr
    add     $t0, $t0, $a0       # move the arr to i index
    lw      $t1, 0($t0)         # load the value from arr[i]
    la      $t0, heap_addr      # set the starting address of the heap_addr in $t0
    sll     $a1, $a1, 0x2       # shift the index by 4 to get aligned addr
    add     $t0, $t0, $a1       # move the arr to i index
    lw      $t2, 0($t0)         # load the value from arr[i]
    sw      $t1, 0($t0)         # store the earlier value into arr[j]
    la      $t0, heap_addr      # set the starting address of the heap_addr in $t0
    add     $t0, $t0, $a0       # move the arr to i index
    sw      $t2, 0($t0)         # store the value into arr[i]
    lw      $ra, ($sp)          # copy from stack to $ra
    addi    $sp, $sp, 4         # increment stack pointer by 4
    jr      $ra                 # return

getLeftChildIndex:
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    sll     $v0, $a0, 0x1       # index * 2
    addi    $v0, $v0, 0x1       # $v0 + 1
    lw      $ra, ($sp)          # copy from stack to $ra
    addi    $sp, $sp, 4         # increment stack pointer by 4
    jr      $ra                 # return

getRightChildIndex:
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    sll     $v0, $a0, 0x1       # index * 2
    addi    $v0, $v0, 0x2       # $v0 + 2
    lw      $ra, ($sp)          # copy from stack to $ra
    addi    $sp, $sp, 4         # increment stack pointer by 4
    jr      $ra                 # return

