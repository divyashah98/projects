.data
heap_addr:  .word   0x10040000

.text
init:
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    la      $t0, heap_addr      # set the starting address of the heap_addr in $t0
    ori     $v0, $0, 5          # opcode to read user i/p
    syscall
    add     $s0, $v0, $0        # get user input into $s0
    loop:
      beq     $s0, $0, end      # if counter is zero, stop loop
      ori     $v0, $0, 5        # opcode to read user i/p
      syscall
      sw      $v0, 0($t0)       # store the input value at heap
      addiu   $t0, $t0, 0x4     # increment the heap by 4
      addi    $s0, $s0, -1      # decrement the counter
      j loop                    # repeat
    end:
    lw      $ra, ($sp)          # copy from stack to $ra
    addi    $sp, $sp, 4         # increment stack pointer by 4
    jr      $ra                 # return
