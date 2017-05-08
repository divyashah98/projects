.data  
.align 4
fname:    .asciiz "LoremIpsum.txt"      # filename for input
.align 4
out_file: .asciiz "work.txt"
.align 4
msg_a:    .asciiz "Occurences of a"
msg_e:    .asciiz "Occurences of e"
msg_i:    .asciiz "Occurences of i"
msg_o:    .asciiz "Occurences of o"
msg_u:    .asciiz "Occurences of u"
new_line: .asciiz "\n"
space:    .asciiz " "
buffer:   .space 1024
int_buf:  .space 32

.text
#open a file for writing
.globl	main
main:
    #Initialising Registers
    li    $s1, 0 
    li    $s2, 0 
    li    $s3, 0 
    li    $s4, 0 
    li    $s5, 0 
    li    $s7, 0 
    #Calling all the differenct sub
    jal   file_open_reading
    jal   file_read
    j     file_process
comp:    
    jal   file_close
    jal   file_open_writing
    jal   file_write
    jal   file_close
    jal   end

file_open_reading:
    li    $v0, 13          # syscall for opening file
    la    $a0, fname       # file name
    li    $a1, 0           # Open for reading
    li    $a2, 0
    syscall                # open a file
    move  $s6, $v0         # save the file descriptor 
    jr    $ra

file_read:
    li    $v0, 14          # syscall for read from file
    move  $a0, $s6         # file descriptor 
    la    $a1, buffer      # address of buffer to which to read
    li    $a2, 1024        # buffer length to read a byte (ASCII character only)
    syscall                # read from file
    jr    $ra

file_process:
    li    $t1, 97          # ascii value of letter 'a'
    li    $t2, 101         # ascii value of letter 'e'
    li    $t3, 105         # ascii value of letter 'i'
    li    $t4, 111         # ascii value of letter 'o'
    li    $t5, 117         # ascii value of letter 'u'
    lb    $t0, buffer($s7) # loading a byte of data from the buffer
    beq   $s7, $v0, comp   # branch to "comp" sub if equal
    addi  $s7, $s7, 1      # increment the counter
    beq   $t1, $t0, incr_a # if 'a' then increment counter for 'a'
    beq   $t2, $t0, incr_e # if 'e' then increment counter for 'e'
    beq   $t3, $t0, incr_i # if 'i' then increment counter for 'i'
    beq   $t4, $t0, incr_o # if 'o' then increment counter for 'o'
    beq   $t5, $t0, incr_u # if 'u' then increment counter for 'u'
    j     file_process     # loop back until complete

file_open_writing:         # sub to open a file for writing
    li    $v0, 13
    la    $a0, out_file
    li    $a1, 1
    li    $a2, 0
    syscall                # File descriptor gets returned in $v0
    move  $s6, $v0         # save the file descriptor 
    jr    $ra

file_write:
# write 'A' message to the file
    sw    $ra, 4($sp)
    li    $v0, 15          # Syscall 15 requieres file descriptor in $a0
    move  $a0, $s6      
    la    $a1, msg_a
    li    $a2, 15
    syscall

# print ' ' to the file
    li    $v0, 15
    move  $a0, $s6      
    la    $a1, space
    li    $a2, 1
    syscall

# print 'a' counter to the file
    li    $v0, 15
    move  $a0, $s6      
    move  $t8, $s1
    jal   itoa             # convert the integer value to ASCII for printing
    li    $a2, 2
    syscall

# print new_line to the file
    li    $v0, 15
    move  $a0, $s6      
    la    $a1, new_line
    li    $a2, 1
    syscall

# write 'E' message to the file
    li    $v0, 15
    move  $a0, $s6      
    la    $a1, msg_e
    li    $a2, 15
    syscall

# print ' ' to the file
    li    $v0, 15
    move  $a0, $s6      
    la    $a1, space
    li    $a2, 1
    syscall

# print 'e' counter to the file
    li    $v0, 15
    move  $a0, $s6      
    move  $t8, $s2
    jal   itoa
    li    $a2, 2
    syscall

# print new_line to the file
    li    $v0, 15
    move  $a0, $s6      
    la    $a1, new_line
    li    $a2, 1
    syscall

# write 'I' message to the file
    li    $v0, 15
    move  $a0, $s6      
    la    $a1, msg_i
    li    $a2, 15
    syscall
    
# print ' ' to the file
    li    $v0, 15
    move  $a0, $s6      
    la    $a1, space
    li    $a2, 1
    syscall

# print 'i' counter to the file
    li    $v0, 15
    move  $a0, $s6      
    move  $t8, $s3
    jal   itoa
    li    $a2, 2
    syscall

# print new_line to the file
    li    $v0, 15
    move  $a0, $s6      
    la    $a1, new_line
    li    $a2, 1
    syscall

# write 'O' message to the file
    li    $v0, 15
    move  $a0, $s6      
    la    $a1, msg_o
    li    $a2, 15
    syscall

# print ' ' to the file
    li    $v0, 15
    move  $a0, $s6      
    la    $a1, space
    li    $a2, 1
    syscall

# print 'o' counter to the file
    li    $v0, 15
    move  $a0, $s6      
    move  $t8, $s4
    jal   itoa
    li    $a2, 2
    syscall

# print new_line to the file
    li    $v0, 15
    move  $a0, $s6      
    la    $a1, new_line
    li    $a2, 1
    syscall

# write 'U' message to the file
    li    $v0, 15
    move  $a0, $s6      
    la    $a1, msg_u
    li    $a2, 15
    syscall
    
# print ' ' to the file
    li    $v0, 15
    move  $a0, $s6      
    la    $a1, space
    li    $a2, 1
    syscall

# print 'u' counter to the file
    li    $v0, 15
    move  $a0, $s6      
    move  $t8, $s5
    jal   itoa
    li    $a2, 2
    syscall

# print new_line to the file
    lw    $ra, 4($sp)
    jr    $ra

file_close:
    li    $v0, 16       # $a0 should have the file descriptor
    move  $a0, $s6      # move the descriptor to close
    syscall
    jr    $ra

incr_a:                 # Sub to increment counter for 'a'
    addi  $s1, $s1, 1
    j     file_process

incr_e:                 # Sub to increment counter for 'e'
    addi  $s2, $s2, 1
    j     file_process

incr_i:                 # Sub to increment counter for 'i'
    addi  $s3, $s3, 1
    j     file_process
                  
incr_o:                 # Sub to increment counter for 'o'          
    addi  $s4, $s4, 1
    j     file_process
                  
incr_u:                 # Sub to increment counter for 'u'         
    addi  $s5, $s5, 1
    j     file_process

#sub to convert integer to ASCII
itoa:
  la      $t0, int_buf   # load buf
  add     $t0, $t0, 30   # seek the end
  sb      $0, 1($t0)     # null-terminated str
  li      $t1, '0'  
  sb      $t1, ($t0)     # init. with ascii 0
  li      $t3, 10        # preload 10
  beq     $t8, $0, iend  # end if 0
loop:
  div     $t8, $t3       # a /= 10
  mflo    $t8
  mfhi    $t4            # get remainder
  add     $t4, $t4, $t1  # convert to ASCII digit
  sb      $t4, ($t0)     # store it
  sub     $t0, $t0, 1    # dec. buf ptr
  bne     $t8, $0, loop  # if not zero, loop
  addi    $t0, $t0, 1    # adjust buf ptr
iend:
  move    $a1, $t0       # return the addr.
  jr      $ra            # of the string

end:
	li	    $v0,10		     # Code for syscall: exit
	syscall
