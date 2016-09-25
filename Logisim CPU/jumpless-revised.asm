# This test program does some printing, math, reads and writes.
## You can use it to test your "jumpless" cpu implementation.

## In ASCII:
# 0x000a  is line feed
# 0x0020  is space
# 0x0021  is !
# 0x0030  is 0
# 0x0041  is A
# 0x0061  is a


# print "Hello, world!"
  addiu $1, $0, 0xffff   # now $1 contains the IO device address
  addiu $2, $0, 0x0030   # digits
  addiu $3, $0, 0x0041   # uppercase
  addiu $4, $0, 0x0061   # lowercase

  addiu $5, $3, 0x0007   # H
  sw    $5, 0($1)

  addiu $5, $4, 0x0004   # e
  sw    $5, 0($1)

  addiu $5, $4, 0x000b   # l
  sw    $5, 0($1)

  addiu $5, $4, 0x000b   # l
  sw    $5, 0($1)

  addiu $5, $4, 0x000e   # o
  sw    $5, 0($1)

  addiu $5, $0, 0x0021   # !
  sw    $5, 0($1)

  addiu $5, $0, 0x000a   # newline
  sw    $5, 0($1)

  addiu $5, $0, 0x002e   # .
  sw    $5, 4($0)        # store the dot in data memory at address 4

  addiu $6, $0, 0x0004   # set $6 = 4
  lw    $5, 0($6)        #load the dot from addr 4 into $5
  sw    $5, 0($1)        #and print it.


  addiu   $7, $0, 0x0002        #set $7 = 2
  addu  $8, $7, $6       #    $8 = 6

  addu  $5,  $2, $8
  sw    $5, 0($1)        #print 6

  slt   $5, $7, $8       #2 < 6, so print 1
  addu  $5, $5, $2
  sw    $5, 0($1)

  slt   $5, $6, $7       #4 > 2, so print 0
  addu  $5, $5, $2
  sw    $5, 0($1)

  addiu $5, $0, 0x000a   # newline
  sw    $5, 0($1)

  subu  $5, $8, $7    #6-2 = 4
  addu  $5, $5, $2
  sw    $5, 0($1)

  subu  $5, $8, $7    #6-2 = 4
  slti  $5, $5, 0x0005 # less than 5, so print 1
  addu  $5, $5, $2
  sw    $5, 0($1)

  subu  $5, $8, $7    #6-2 = 4
  slti  $5, $5, 0x0003 # more than 3, so print 0
  addu  $5, $5, $2
  sw    $5, 0($1)




