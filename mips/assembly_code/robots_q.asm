.data
robo_q:     .word   'A', 'B', 'C', 'D', 'E', 'F', 'G'
robo_q_cnt: .word   7
user_q:     .word   0, 0, 0
user_q_cnt: .word   0
user_q_val: .word   '1'
out_rob_cnt:.word   0
id_arr:     .word   0, 0, 0, 0, 0, 0, 0
time_arr:   .word   0, 0, 0, 0, 0, 0, 0
out_rob_arr:.word   0, 0, 0, 0, 0, 0, 0
uid:        .word   1
num_arr:    .word   0, 0, 0, 0, 0, 0, 0
max_rob_q:  .word   7
max_usr_q:  .word   3

prompt_1:   .asciiz "Enter a command: "
prompt_out: .asciiz "Checking out the Robot: "
prompt_id:  .asciiz "The ID number is: "
space:      .asciiz " "
new_line:   .asciiz "\n"
chkin_err:  .asciiz "ERROR: No checked out robot found with above ID\n"
robo_q_msg: .asciiz "Current status of the Robot Queue: "
user_q_msg: .asciiz "Current status of the User Queue: "
num_msg:    .asciiz "Checkout count of each Robot: "
q_full_err: .asciiz "ERROR: No space in any of the queues\n"

.text

main:
    la      $a0, prompt_1       # get the addr of prompt_1 in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall
    li      $v0, 5          # opcode to read user i/p
    syscall
    move    $s0, $v0            # move the user i/p in $s0
    li      $t0, -1
    beq     $v0, $t0, exit      # exit the program if inp = -1
    beq     $v0, $0, check_out  # branch to check_out if inp = 0
    jal     check_in            # else branch to checkin ($v0 - uid)
  check_out:
    jal     checkOut
    la      $a0, robo_q_msg     # get the addr of robo_q_msg in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall
    la      $a0, robo_q         # store addr of q 
    la      $a1, robo_q_cnt     # get the addr of robo_q_cnt
    lw      $a1, 0($a1)         # get the count value
    jal     print
    la      $a0, user_q_msg     # get the addr of user_q_msg in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall
    la      $a0, user_q         # store addr of q 
    la      $a1, user_q_cnt     # get the addr of user_q_cnt
    lw      $a1, 0($a1)         # get the count value
    jal     print
    #jal     print_time
    jal     print_count
    j       main
  check_in:
    move    $v0, $s0
    jal     checkIn
    la      $a0, robo_q_msg     # get the addr of robo_q_msg in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall
    la      $a0, robo_q         # store addr of q 
    la      $a1, robo_q_cnt     # get the addr of robo_q_cnt
    lw      $a1, 0($a1)         # get the count value
    jal     print
    la      $a0, user_q_msg     # get the addr of user_q_msg in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall
    la      $a0, user_q         # store addr of q 
    la      $a1, user_q_cnt     # get the addr of user_q_cnt
    lw      $a1, 0($a1)         # get the count value
    jal     print
    #jal     print_time
    jal     print_count
    j       main
  exit:
    la      $a0, robo_q         # store addr of q 
    la      $a1, robo_q_cnt     # get the addr of robo_q_cnt
    lw      $a1, 0($a1)         # get the count value
    jal     print
    li      $v0, 10             # set command to stop program,
    syscall

# Inputs:
#   $v0 - uid of the robot
# Outputs:
#   none
checkIn:
    addi    $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    addi    $sp, $sp, -4
    sw      $s0, 0($sp)         # store $s0 into the stack
    addi    $sp, $sp, -4
    sw      $s1, 0($sp)         # store $s1 into the stack
    addi    $sp, $sp, -4
    sw      $s2, 0($sp)         # store $s2 into the stack
    addi    $sp, $sp, -4
    sw      $s3, 0($sp)         # store $s3 into the stack
    addi    $sp, $sp, -4
    sw      $s4, 0($sp)         # store $s4 into the stack
    addi    $sp, $sp, -4
    sw      $s5, 0($sp)         # store $s5 into the stack
    move    $s0, $v0            # get the uid in $s0
    la      $a0, id_arr         # get the ID_arr addr in $a0
    la      $a1, out_rob_arr    # get the out_rob_arr addr in $a1
    lw      $s1, 0($a0)         # get the first ID
    li      $t0, 7              # set the max count value
  cmp_id:
    beq     $s0, $s1, id_match  # if uid match - check-in the robot
    beq     $t0, $0, exit_cmp   # if all out robots ID checked - exit
    addi    $a0, $a0, 4         # else increment to the next ID
    addi    $a1, $a1, 4         # also increment the out_rob_arr
    addi    $t0, $t0, -1        # decrement the count of out robots
    lw      $s1, 0($a0)         # load the next ID
    j       cmp_id              # loop back
  id_match:
    lw      $a2, 0($a1)         # get the element to be pushed
    sw      $0, 0($a0)          # remove that ID from the arr
    la      $a0, robo_q         # store addr of q 
    la      $a1, robo_q_cnt     # get the addr of robo_q_cnt
    lw      $a1, 0($a1)         # get the count value
    jal     push                # push back the robot
    la      $a0, robo_q_cnt     # get the addr of robo_q_cnt
    sw      $v1, 0($a0)         # store the updated count
    la      $a0, out_rob_cnt    # get the out_rob_cnt addr in $a0
    lw      $t0, 0($a0)         # get the count value
    addi    $t0, $t0, -1        # decrement the out count value
    sw      $t0, 0($a0)         # store the updated out count value
    la      $a0, user_q         # get the addr of usr q
    la      $a1, user_q_cnt     # get the addr of usr q cnt
    lw      $a1, 0($a1)         # get the count value
    beq     $a1, $0, exit_usr_q # q empty - no need to pop
    jal     pop                 # pop the user from q
    la      $a1, user_q_cnt     # get the addr of usr q cnt
    sw      $v1, 0($a1)         # store the updated count value
  exit_usr_q:
    j       exit_checkIn
  exit_cmp:
    la      $a0, chkin_err      # get the addr of chkin_err in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall
  exit_checkIn:
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

# Inputs:
#   none
# Outputs:
#   none
checkOut:
    addi   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    addi   $sp, $sp, -4
    sw      $s0, 0($sp)         # store $s0 into the stack
    addi   $sp, $sp, -4
    sw      $s1, 0($sp)         # store $s1 into the stack
    addi   $sp, $sp, -4
    sw      $s2, 0($sp)         # store $s2 into the stack
    addi   $sp, $sp, -4
    sw      $s3, 0($sp)         # store $s3 into the stack
    addi   $sp, $sp, -4
    sw      $s4, 0($sp)         # store $s4 into the stack
    addi   $sp, $sp, -4
    sw      $s5, 0($sp)         # store $s5 into the stack

    la      $a0, robo_q         # get addr of robot q
    la      $a1, robo_q_cnt     # get the addr of robot counter
    lw      $a1, 0($a1)         # get the current count value
    jal     pop                 # try to checkout a robot
    beq     $v0, $0, chk_fail   # branch if pop failed to execute
    la      $a1, robo_q_cnt     # else get the addr of robot counter
    sw      $v1, 0($a1)         # store the updated count value
    la      $a0, out_rob_cnt    # get the addr of out robot counts
    lw      $t0, 0($a0)         # get the current counter value
    addi    $t0, $t0, 1         # update the counter value
    sw      $t0, 0($a0)         # store the updated count value
    move    $s0, $a2            # move the popped element in $s0
    addi    $a2, $a2, -65       # get the int value
    sll     $a2, $a2, 2         # get word aligned
    la      $a0, num_arr        # load addr of num_arr
    add     $a0, $a0, $a2       # get the required addr
    lw      $t0, 0($a0)         # load the value
    addi    $t0, $t0, 1         # incr the popped count
    sw      $t0, 0($a0)         # store it back
    la      $a0, prompt_out     # get the addr of promp_out in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall
    move    $a0, $s0            # get the popped element in $a0
    li      $v0, 11             # command to print a char
    syscall
    la      $a0, new_line       # get the addr of newline in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall
    la      $a0, prompt_id      # get the addr of promp_id in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall
    la      $a0, uid            # get the addr of uid in $a0
    lw      $a0, 0($a0)         # load the current uid
    li      $v0, 1              # command to print int
    syscall
    la      $a0, id_arr         # set the base addr in ID arr
    lw      $t0, 0($a0)         # get the first ID here
    la      $a1, out_rob_arr    # get the out_rob_arr addr
    la      $a2, uid            # get the addr of uid in $a2
    lw      $a2, 0($a2)         # load the current uid
  find_space:
    beq     $t0, $0, empty      # branch to empty if $t0 = 0
    addi    $a0, $a0, 4         # else move to next pos
    addi    $a1, $a1, 4         # move to next pos for out_rob_arr
    lw      $t0, 0($a0)         # get the next ID
    j       find_space          # loop back
  empty:
    sw      $a2, 0($a0)         # store the UID at that addr
    sw      $s0, 0($a1)         # store the popped element at that addr
    addi    $a2, $a2, 1         # update the ID
    la      $a0, uid            # set the base addr of UID
    sw      $a2, 0($a0)         # update the ID in mem
    la      $a0, new_line       # get the addr of newline in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall
    j       end_chkout          # end the checkout code
  chk_fail:                     # insert it into user q
    la      $s0, user_q         # get the addr of user_q
    la      $s1, user_q_cnt     # get the user q count addr
    lw      $s1, 0($s1)         # get the user q count
    la      $s2, user_q_val     # get the user q val addr
    lw      $s2, 0($s2)         # get the user q val
    li      $t0, 3              # max value of user q
    beq     $s1, $t0, no_space  # branch to no_space if curr count = 3
    move    $a0, $s0            # else push in the element
    move    $a1, $s1
    move    $a2, $s2
    jal     push_usr            # put the usr in the q
    la      $s1, user_q_cnt     # get the user q count addr
    sw      $v1, 0($s1)         # store the updated count value    
    la      $s2, user_q_val     # get the user q val addr
    lw      $t0, 0($s2)         # get the user q val
    addi    $t0, $t0, 1         # increment the user val
    sw      $t0, 0($s2)         # store the updated val
    j       end_chkout
  no_space:
    la      $a0, q_full_err
    li      $v0, 4
    syscall
  end_chkout:
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

# Inputs:
#   $a0 - starting address of Q
#   $a1 - number of elements in the Q
#   $a2 - element to be inserted
# Output:
#   $v0 - If push was successful or not
#       0 - failed
#       1 - passed
#   $v1 - updated number of elements in Q
push:
    addi   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    addi   $sp, $sp, -4
    sw      $s0, 0($sp)         # store $s0 into the stack
    addi   $sp, $sp, -4
    sw      $s1, 0($sp)         # store $s1 into the stack
    addi   $sp, $sp, -4
    sw      $s2, 0($sp)         # store $s2 into the stack
    addi   $sp, $sp, -4
    sw      $s3, 0($sp)         # store $s3 into the stack
    addi   $sp, $sp, -4
    sw      $s4, 0($sp)         # store $s4 into the stack
    addi   $sp, $sp, -4
    sw      $s5, 0($sp)         # store $s5 into the stack

    move    $s0, $a0            # get the starting address in $s0
    move    $s1, $a1            # get the count in $s1
    move    $s2, $a2            # get the input in $s2
    li      $t0, 7              # set max count in $t0
    beq     $s1, $t0, q_full    # exit if current count = max count
    sll     $t0, $s1, 2         # get the word aligned count
    add     $s0, $s0, $t0       # get to the end of the q
    sw      $s2, 0($s0)         # store the input in the q
    li      $v0, 1              # set the pass status in $v0
    addi    $v1, $s1, 1         # update the counter in $v1
    j       exit_push           # exit
  q_full:
    li      $v0, 0              # return 0 in $v0
  exit_push:
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

# Inputs:
#   $a0 - starting address of Q
#   $a1 - number of elements in the Q
#   $a2 - element to be inserted
# Output:
#   $v0 - If push was successful or not
#       0 - failed
#       1 - passed
#   $v1 - updated number of elements in Q
push_usr:
    addi   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    addi   $sp, $sp, -4
    sw      $s0, 0($sp)         # store $s0 into the stack
    addi   $sp, $sp, -4
    sw      $s1, 0($sp)         # store $s1 into the stack
    addi   $sp, $sp, -4
    sw      $s2, 0($sp)         # store $s2 into the stack
    addi   $sp, $sp, -4
    sw      $s3, 0($sp)         # store $s3 into the stack
    addi   $sp, $sp, -4
    sw      $s4, 0($sp)         # store $s4 into the stack
    addi   $sp, $sp, -4
    sw      $s5, 0($sp)         # store $s5 into the stack

    move    $s0, $a0            # get the starting address in $s0
    move    $s1, $a1            # get the count in $s1
    move    $s2, $a2            # get the input in $s2
    li      $t0, 3              # set max count in $t0
    beq     $s1, $t0, q_full_1  # exit if current count = max count
    sll     $t0, $s1, 2         # get the word aligned count
    add     $s0, $s0, $t0       # get to the end of the q
    sw      $s2, 0($s0)         # store the input in the q
    li      $v0, 1              # set the pass status in $v0
    addi    $v1, $s1, 1         # update the counter in $v1
    j       exit_push_1         # exit
  q_full_1:
    li      $v0, 0              # return 0 in $v0
  exit_push_1:
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

# Inputs:
#   $a0 - starting address of Q
#   $a1 - number of elements in the Q
# Output:
#   $v0 - If pop was successful or not
#       0 - failed
#       1 - passed
#   $v1 - updated number of elements in Q
#   $a2 - popped element
pop:
    addi   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    addi   $sp, $sp, -4
    sw      $s0, 0($sp)         # store $s0 into the stack
    addi   $sp, $sp, -4
    sw      $s1, 0($sp)         # store $s1 into the stack
    addi   $sp, $sp, -4
    sw      $s2, 0($sp)         # store $s2 into the stack
    addi   $sp, $sp, -4
    sw      $s3, 0($sp)         # store $s3 into the stack
    addi   $sp, $sp, -4
    sw      $s4, 0($sp)         # store $s4 into the stack
    addi   $sp, $sp, -4
    sw      $s5, 0($sp)         # store $s5 into the stack

    move    $s0, $a0            # get the starting address in $s0
    move    $s1, $a1            # get the count in $s1
    beq     $s1, $0, q_empty    # exit if current count = min_count
    li      $v0, 1              # set the pass status in $v0
    lw      $a2, 0($s0)         # get the first element from q
    li      $t0, 0              # set the counter to 0
  q_up:
    beq     $t0, $s1, end_up    # exit if counter = curr count
    lw      $t1, 4($s0)         # get the next element from q
    sw      $t1, 0($s0)         # store it one place up
    addi    $t0, $t0, 1         # increment the counter
    addi    $s0, $s0, 4         # increment the q
    j       q_up                # loop back
  end_up:
    addi    $v1, $s1, -1        # update the counter in $v1
    j       exit_pop            # exit
  q_empty:
    li      $v0, 0              # return 0 in $v0
  exit_pop:
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

# Inputs:
#   $a0 - starting address of Q
#   $a1 - number of elements in the Q
# Outputs:
#   none
print:    
    addi   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    addi   $sp, $sp, -4
    sw      $s0, 0($sp)         # store $s0 into the stack
    addi   $sp, $sp, -4
    sw      $s1, 0($sp)         # store $s1 into the stack
    addi   $sp, $sp, -4
    sw      $s2, 0($sp)         # store $s2 into the stack
    addi   $sp, $sp, -4
    sw      $s3, 0($sp)         # store $s3 into the stack
    addi   $sp, $sp, -4
    sw      $s4, 0($sp)         # store $s4 into the stack
    addi   $sp, $sp, -4
    sw      $s5, 0($sp)         # store $s5 into the stack

    move    $t0, $a0            # store addr of q in $t0
    move    $t1, $a1            # get the current counter value
  loop_p1:
    beq     $t1, $0, end_p1     # if (0) exit from loop
    lw      $a0, 0($t0)         # get the first element
    li      $v0, 11             # put 11 in $v0 for printing a char
    syscall
    la      $a0, space          # get the addr of space in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall
    addi    $t1, $t1, -1        # decrement the counter
    addi    $t0, $t0, 4         # move to the next element
    j       loop_p1
  end_p1:
    la      $a0, new_line       # get the addr of newline in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall

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

# Inputs:
#   $a0 - starting address of Q
#   $a1 - number of elements in the Q
# Outputs:
#   none
print_count:    
    addi   $sp, $sp, -4
    sw      $ra, 0($sp)         # store $ra into the stack
    addi   $sp, $sp, -4
    sw      $s0, 0($sp)         # store $s0 into the stack
    addi   $sp, $sp, -4
    sw      $s1, 0($sp)         # store $s1 into the stack
    addi   $sp, $sp, -4
    sw      $s2, 0($sp)         # store $s2 into the stack
    addi   $sp, $sp, -4
    sw      $s3, 0($sp)         # store $s3 into the stack
    addi   $sp, $sp, -4
    sw      $s4, 0($sp)         # store $s4 into the stack
    addi   $sp, $sp, -4
    sw      $s5, 0($sp)         # store $s5 into the stack

    la      $a0, num_msg
    li      $v0, 4
    syscall
    la      $s0, num_arr
    li      $t0, 7              # set the max count here
    li      $s1, 'A'            # starting robot name
  loop_p2:
    beq     $t0, $0, end_p2     # if (0) exit from loop
    move    $a0, $s1
    li      $v0, 11
    syscall
    li      $a0, ':'
    li      $v0, 11
    syscall
    lw      $a0, 0($s0)         # get the first element
    li      $v0, 1              # put 11 in $v0 for printing a char
    syscall
    la      $a0, space          # get the addr of space in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall
    addi    $t0, $t0, -1        # decrement the counter
    addi    $s0, $s0, 4         # move to the next element
    addi    $s1, $s1, 1
    j       loop_p2
  end_p2:
    la      $a0, new_line       # get the addr of newline in $a0
    li      $v0, 4              # put 4 in $v0 for printing string
    syscall

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
