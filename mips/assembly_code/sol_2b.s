.data
space:  .asciiz   " "
new_line:  .asciiz   "\n"

.text
.globl main
main:
    jal     init
    ori     $s0, $v0, 0         # get the no of elements in $s0
    ori     $a0, $s0, 0         # set $a0 = $s0
    jal     print
    ori     $a0, $s0, 0         # set $a0 = $s0
    jal     sort
    ori     $a0, $s0, 0         # set $a0 = $s0
    jal     print
    ori     $v0, $0, 10         # set command to stop program,
    syscall

init:
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    addiu   $sp, $sp, -4
    sw      $s0, 0($sp)         # store $s0 into the stack
    addiu   $sp, $sp, -4
    sw      $s1, 0($sp)         # store $s1 into the stack
    addiu   $sp, $sp, -4
    sw      $s2, 0($sp)         # store $s2 into the stack
    addiu   $sp, $sp, -4
    sw      $s3, 0($sp)         # store $s3 into the stack
    addiu   $sp, $sp, -4
    sw      $s4, 0($sp)         # store $s4 into the stack
    addiu   $sp, $sp, -4
    sw      $s5, 0($sp)         # store $s5 into the stack
    
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
      addiu   $t0, $t0, 0x4     # increment the heap by 4
      addi    $s0, $s0, -1      # decrement the counter
      j loop                    # repeat
    end:
    ori     $v0, $s1, 0

    lw      $s5, ($sp)          # copy from stack to $s5
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s4, ($sp)          # copy from stack to $s4
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s3, ($sp)          # copy from stack to $s3
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s2, ($sp)          # copy from stack to $s2
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s1, ($sp)          # copy from stack to $s1
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s0, ($sp)          # copy from stack to $s0
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $ra, ($sp)          # copy from stack to $ra
    addi    $sp, $sp, 4         # increment stack pointer by 4
    jr      $ra                 # return

fixHeap:
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    addiu   $sp, $sp, -4
    sw      $s0, 0($sp)         # store $s0 into the stack
    addiu   $sp, $sp, -4
    sw      $s1, 0($sp)         # store $s1 into the stack
    addiu   $sp, $sp, -4
    sw      $s2, 0($sp)         # store $s2 into the stack
    addiu   $sp, $sp, -4
    sw      $s3, 0($sp)         # store $s3 into the stack
    addiu   $sp, $sp, -4
    sw      $s4, 0($sp)         # store $s4 into the stack
    addiu   $sp, $sp, -4
    sw      $s5, 0($sp)         # store $s5 into the stack
    
    ori     $t0, $v1, 0         # set the starting address of the heap_addr in $t0
    ori     $s0, $a0, 0         # save the rootindex in $s0 - index
    ori     $s1, $a1, 0         # save the lastindex in $s1
    sll     $a0, $a0, 0x2       # shift the rootIndex by 4 to get aligned addr
    add     $t0, $t0, $a0       # move the arr to point at rootIndex
    lw      $s2, 0($t0)         # load the value from arr[rootIndex] in $s2
    ori     $s5, $s0, 0         # index = rootIndex
more:
    ori     $a0, $s5, 0
    jal     getLeftChildIndex
    ori     $s3, $v0, 0         # save child index in $s3
    bgt     $s3, $s1, end_more  # if (childIndex <= lastIndex)
      ori   $a0, $s5, 0
      jal   getRightChildIndex
      ori   $s4, $v0, 0         # save right child index in $s4
      bgt   $s4, $s1, end_if_2  # if (rightChildIndex <= lastIndex)
      ori   $t0, $v1, 0
      sll   $t1, $s4, 0x2
      add   $t0, $t0, $t1
      lw    $t2, 0($t0)         # $t2 contains a[rightChildIndex]
      ori   $t0, $v1, 0
      sll   $t1, $s3, 0x2
      add   $t0, $t0, $t1
      lw    $t3, 0($t0)         # $t3 contains a[ChildIndex]
      blt   $t2, $t3, end_if_2  # && a[rightChildIndex] > a[childIndex]
      beq   $t2, $t3, end_if_2
        ori $s3, $s4, 0         # child index = rightChildIndex
      end_if_2:
      ori   $t0, $v1, 0
      sll   $t1, $s3, 0x2
      add   $t0, $t0, $t1
      lw    $t2, 0($t0)         # $t2 contains a[ChildIndex]
      blt   $t2, $s2, end_if_3  # if (a[childIndex] > rootValue)
      beq   $t2, $s2, end_if_3
        ori $t0, $v1, 0
        sll $t1, $s5, 0x2       # Left shift index by 2
        add $t0, $t0, $t1       # Get the a[index]
        sw  $t2, 0($t0)         # a[index] = a[childIndex]
        ori $s5, $s3, 0         # index = childIndex
        j   skip_else_3
      end_if_3:
        j   end_more
      skip_else_3:
      j     more
    end_more:
    ori     $t0, $v1, 0
    sll     $t1, $s5, 0x2       # Left shift index by 2
    add     $t0, $t0, $t1       # Get to the a[index] position
    sw      $s2, 0($t0)         # a[index] = rootValue
    
    lw      $s5, ($sp)          # copy from stack to $s5
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s4, ($sp)          # copy from stack to $s4
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s3, ($sp)          # copy from stack to $s3
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s2, ($sp)          # copy from stack to $s2
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s1, ($sp)          # copy from stack to $s1
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s0, ($sp)          # copy from stack to $s0
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $ra, ($sp)          # copy from stack to $ra
    addi    $sp, $sp, 4         # increment stack pointer by 4
    jr      $ra                 # return

sort:
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    addiu   $sp, $sp, -4
    sw      $s0, 0($sp)         # store $s0 into the stack
    addiu   $sp, $sp, -4
    sw      $s1, 0($sp)         # store $s1 into the stack
    addiu   $sp, $sp, -4
    sw      $s2, 0($sp)         # store $s2 into the stack
    addiu   $sp, $sp, -4
    sw      $s3, 0($sp)         # store $s3 into the stack
    addiu   $sp, $sp, -4
    sw      $s4, 0($sp)         # store $s4 into the stack
    addiu   $sp, $sp, -4
    sw      $s5, 0($sp)         # store $s5 into the stack
    
    ori     $s0, $a0, 0         # save the array length in $s0
    addi    $s0, $s0, -1        # n = a.length - 1
    addi    $s1, $s0, -1        # i = (n - 1)
    srl     $s1, $s1, 1         # i = i / 2
    for:
      blt   $s1, $0, end_for
      ori   $a0, $s1, 0         # fixHeap (i, n)
      ori   $a1, $s0, 0
      jal   fixHeap
      addi  $s1, $s1, -1
      j     for
    end_for:
    while:
      beq   $s0, $0, end_while
      ori   $a0, $0, 0
      ori   $a1, $s0, 0
      jal   swap
      addi  $s0, $s0, -1
      ori   $a0, $0, 0
      ori   $a1, $s0, 0
      jal   fixHeap
      j     while
    end_while:

    lw      $s5, ($sp)          # copy from stack to $s5
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s4, ($sp)          # copy from stack to $s4
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s3, ($sp)          # copy from stack to $s3
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s2, ($sp)          # copy from stack to $s2
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s1, ($sp)          # copy from stack to $s1
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s0, ($sp)          # copy from stack to $s0
    addi    $sp, $sp, 4         # increment stack pointer by 4
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

swap:
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    ori     $t0, $v1, 0      # set the starting address of the heap_addr in $t0
    sll     $a0, $a0, 0x2       # shift the index by 4 to get aligned addr
    add     $t0, $t0, $a0       # move the arr to i index
    lw      $t1, 0($t0)         # load the value from arr[i]
    ori     $t0, $v1, 0      # set the starting address of the heap_addr in $t0
    sll     $a1, $a1, 0x2       # shift the index by 4 to get aligned addr
    add     $t0, $t0, $a1       # move the arr to i index
    lw      $t2, 0($t0)         # load the value from arr[i]
    sw      $t1, 0($t0)         # store the earlier value into arr[j]
    ori     $t0, $v1, 0      # set the starting address of the heap_addr in $t0
    add     $t0, $t0, $a0       # move the arr to i index
    sw      $t2, 0($t0)         # store the value into arr[i]
    lw      $ra, ($sp)          # copy from stack to $ra
    addi    $sp, $sp, 4         # increment stack pointer by 4
    jr      $ra                 # return

print:    
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    ori     $t0, $v1, 0      # set the starting address of the heap_addr in $t0
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

