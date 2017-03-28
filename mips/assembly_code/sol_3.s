.data
space:  .asciiz   " "
new_line:  .asciiz   "\n"

.text
.globl main
main:
    ori     $v0, $0, 5          # opcode to read user i/p
    syscall
    ori     $a0, $v0, 0
    jal     suite
    ori     $v0, $0, 10         # set command to stop program,
    syscall

suite:
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    addiu   $sp, $sp, -4
    sw      $s0, 0($sp)         # store $s0 into the stack
    addiu   $sp, $sp, -4
    sw      $s1, 0($sp)         # store $s1 into the stack
    
    ori     $s0, $a0, 0         # Save the value of n in $s0
    beq     $s0, $0, ret
      sll   $s1, $s0, 1         # 2 * n
      addi  $a0, $s0, -1        # $a0 = n -1
      jal   suite
      add   $v0, $s1, $v0       # suite(n-1) + 2*n
      addi  $t0, $0, 7
      mod:
          blt     $v0, $t0, exit
          subu    $v0, $v0, $t0
      j   mod
    exit:
    jal     print
    lw      $s1, ($sp)          # copy from stack to $s1
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $s0, ($sp)          # copy from stack to $s0
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $ra, ($sp)          # copy from stack to $ra
    addi    $sp, $sp, 4         # increment stack pointer by 4
    jr      $ra                 # return

    ret:
    addi    $v0, $0, 1          # return 1
    j       exit

print:    
    addiu   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    addiu   $sp, $sp, -4
    sw      $v0, 0($sp)         # store $v0 into the stack
    
    ori     $a0, $v0, 0
    ori     $v0, $0, 1
    syscall
    la      $a0, space
    ori     $v0, $0, 4
    syscall
    la      $a0, new_line
    ori     $v0, $0, 4
    syscall

    lw      $v0, ($sp)          # copy from stack to $v0
    addi    $sp, $sp, 4         # increment stack pointer by 4
    lw      $ra, ($sp)          # copy from stack to $ra
    addi    $sp, $sp, 4         # increment stack pointer by 4
    jr      $ra                 # return
