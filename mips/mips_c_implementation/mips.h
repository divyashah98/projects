// Header file for mips.c
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <math.h>

// Declare the global variables here
// All the memories and variables to
// hold arhcitectural state of the 
// CPU should be decalred.

typedef struct ARCHState_struct {
  int PC;         /* Program Counter */
  int REGS[31];   /* Register File. */
} ARCHState;

ARCHState CURRENT_STATE;
ARCHState NEXT_STATE;

// Declare the data/instruction memory
int memory[1023];

// Declare all the implemented functions
void init_state ();
void usage ();
void parse_binary_file (FILE *);
void execute_instr ();
void bin_str_to_hex (char *);
void mem_dump (int, int);
void reg_dump ();