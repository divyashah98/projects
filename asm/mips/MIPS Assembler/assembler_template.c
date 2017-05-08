#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define XSTR(x) STR(x)		//used for MAX_ARG_LEN in sscanf 
#define STR(x) #x 

#define MAX_PROG_LEN 100	//maximum number of lines a program can have
#define MAX_LINE_LEN 50		//maximum number of characters a line of code may have
#define MAX_OPCODE   8		//number of opcodes supported (length of opcode_str and opcode_func)
#define MAX_REGISTER 32		//number of registers (size of register_str) 
#define MAX_ARG_LEN  20		//used when tokenizing a program line, max size of a token 

#define ADDR_TEXT    0x00000000 //where the .text area starts in which the program lives 
#define ADDR_DATA    0x00000014 //where the .data area starts in which the data lives 

const char *register_str[] = {	"$0", 
  "$at",
  "$v0", "$v1",
  "$a0", "$a1", "$a2", "$a3",
  "$t0", "$t1", "$t2", "$t3", "$t4", "$t5", "$t6", "$t7",
  "$s0", "$s1", "$s2", "$s3", "$s4", "$s5", "$s6", "$s7"
  "$t8", "$t9",
  "$k0", "$k1",
  "$gp",
  "$sp",
  "$fp",
  "$ra",
};

//A 4KB RAM initialized with the byte 
//0x0 RAM is byte accessible
int data_ram [4096] = {0x00};
char var_ram [100][100];
int num_vars = 0;

typedef int (*opcode_function)(unsigned int, unsigned int*, char*, char*, char*, char*);

/* Space for the assembler program */
char prog[MAX_PROG_LEN][MAX_LINE_LEN];
int prog_len=0;

/* Function to get the register number from
 * the parsed register string according to 
 * the MIPS physical register implementation */
int get_reg_num (char *reg_str) {
  int i = 0;
  for (i = 0; i < 31; i++) {
    if (strcmp(reg_str, register_str[i]) == 0) {
      return i;
    }
  }
  return -1;
}

/* Function to extract the register from the
 * string of the type - imm($t0) where $t0
 * could be any valid MIPS register implementation */
int extract_reg(char *reg_str) {
  int reg_num;
  char *token;
  token = strtok(reg_str, ")");
  /* walk through other tokens */
  while( token != NULL ) {
    reg_num = get_reg_num(token);
    token = strtok(token, "("); 
    token = strtok(NULL, ")");
  }
  return reg_num;
}

/* Function to extract the imm from the
 * string of the type - imm($t0) where $t0
 * could be any valid MIPS register implementation */
int extract_imm(char *reg_str) {
  int imm;
  char *token;
  token = strtok(reg_str, "(");
  /* walk through other tokens */
  while( token != NULL ) {
    imm = atoi(token);
    token = strtok(token, "("); 
    token = strtok(NULL, "(");
  }
  return imm;
}

int get_data_addr(char *var_name) {
  int i = 0;
  for (i = 0; i < num_vars; i++) {
    if ((strcmp(var_ram[i], var_name)) == 0) {
      return (ADDR_DATA + (data_ram[i]*i));
    }
  }
}

/* function to create bytecode for instruction nop
   conversion result is passed in bytecode
   function always returns 0 (conversion OK) */
int opcode_nop(unsigned int offset, unsigned int *bytecode, char *opcode, char *arg1, char *arg2, char *arg3 ){
	*bytecode=0;
	return (0);
}

/* function to create bytecode for instruction add
   conversion result is passed in bytecode
   function always returns 0 (conversion OK) 
   Add is a R type instruction with the following 
   encoding - 
   31-26 opcode (0)
   25-21 arg2 (rs)
   20-16 arg3 (rt)
   15-11 arg1 (rd)
   10-6 shamt
   5-0 funct*/
int opcode_add(unsigned int offset, unsigned int *bytecode, char *opcode, char *arg1, char *arg2, char *arg3 ){
  int reg_number1, reg_number2, reg_number3;
  reg_number1 = get_reg_num(arg1);
  reg_number2 = get_reg_num(arg2);
  reg_number3 = get_reg_num(arg3);
	*bytecode = (reg_number2<<21) + (reg_number3<<16) + (reg_number1<<11) + 0x20;
	return (0);
}

/* function to create bytecode for instruction nor
   conversion result is passed in bytecode
   function always returns 0 (conversion OK) 
   NOR is a R type instruction with the following 
   encoding - 
   31-26 opcode (0)
   25-21 arg2 (rs)
   20-16 arg3 (rt)
   15-11 arg1 (rd)
   10-6 shamt
   5-0 funct*/
int opcode_nor(unsigned int offset, unsigned int *bytecode, char *opcode, char *arg1, char *arg2, char *arg3 ){
  int reg_number1, reg_number2, reg_number3;
  reg_number1 = get_reg_num(arg1);
  reg_number2 = get_reg_num(arg2);
  reg_number3 = get_reg_num(arg3);
	*bytecode = (reg_number2<<21) + (reg_number3<<16) + (reg_number1<<11) + 0x27;
	return (0);
}

/* function to create bytecode for instruction addi
   conversion result is passed in bytecode
   function always returns 0 (conversion OK) 
   Add is a I type instruction with the following 
   encoding - 
   31-26 opcode (0x8)
   25-21 arg2 (rs)
   20-16 arg1 (rt)
   15-0  arg3 (imm) */
int opcode_addi(unsigned int offset, unsigned int *bytecode, char *opcode, char *arg1, char *arg2, char *arg3 ){
  int reg_number1, reg_number2, sign_imm;
  reg_number1 = get_reg_num(arg1);
  reg_number2 = get_reg_num(arg2);
  sign_imm = atoi(arg3);
	*bytecode = (0x8<<26) + (reg_number2<<21) + (reg_number1<<16) + sign_imm;
	return (0);
}

/* function to create bytecode for instruction ori
   conversion result is passed in bytecode
   function always returns 0 (conversion OK) 
   ORI is a I type instruction with the following 
   encoding - 
   31-26 opcode (0xd)
   25-21 arg2 (rs)
   20-16 arg1 (rt)
   15-0  arg3 (imm) */
int opcode_ori(unsigned int offset, unsigned int *bytecode, char *opcode, char *arg1, char *arg2, char *arg3 ){
  int reg_number1, reg_number2;
  unsigned int zeroext_imm;
  reg_number1 = get_reg_num(arg1);
  reg_number2 = get_reg_num(arg2);
  zeroext_imm = atoi(arg3);
  if ((strcmp(opcode, (char *)"la")) == 0) {
    zeroext_imm = get_data_addr(arg3)&0xFFFF;
  }
	*bytecode = (0xd<<26) + (reg_number2<<21) + (reg_number1<<16) + zeroext_imm;
	return (0);
}

/* function to create bytecode for instruction lui
   conversion result is passed in bytecode
   function always returns 0 (conversion OK) 
   LUI is a I type instruction with the following 
   encoding - 
   31-26 opcode (0xf)
   25-21 N/A  (rs)
   20-16 arg1 (rt)
   15-0  arg2 (imm) */
int opcode_lui(unsigned int offset, unsigned int *bytecode, char *opcode, char *arg1, char *arg2, char *arg3 ){
  int reg_number1;
  int lui_imm;
  reg_number1 = get_reg_num(arg1);
  lui_imm = get_data_addr(arg2)& 0xFFFF0000;
	*bytecode = (0xf<<26) + (0<<21) + (reg_number1<<16) + lui_imm;
	return (0);
}

/* function to create bytecode for instruction lw
   conversion result is passed in bytecode
   function always returns 0 (conversion OK) 
   LW is a I type instruction with the following 
   encoding - 
   31-26 opcode (0x23)
   25-21 arg2 (rs)
   20-16 arg1 (rt)
   15-0  arg3 (imm) 
   although rs and imm 
   usually appear as -
   imm(rs)*/
int opcode_lw(unsigned int offset, unsigned int *bytecode, char *opcode, char *arg1, char *arg2, char *arg3 ){
  int reg_number1, reg_number2;
  int lw_imm;
  reg_number1 = get_reg_num(arg1);
  reg_number2 = extract_reg(arg2);
  lw_imm = extract_imm(arg2);
	*bytecode = (0x23<<26) + (reg_number2<<21) + (reg_number1<<16) + lw_imm;
	return (0);
}

/* function to create bytecode for instruction sw
   conversion result is passed in bytecode
   function always returns 0 (conversion OK) 
   SW is a I type instruction with the following 
   encoding - 
   31-26 opcode (0x2b)
   25-21 arg2 (rs)
   20-16 arg1 (rt)
   15-0  arg3 (imm) 
   although rs and imm 
   usually appear as -
   imm(rs)*/
int opcode_sw(unsigned int offset, unsigned int *bytecode, char *opcode, char *arg1, char *arg2, char *arg3 ){
  int reg_number1, reg_number2;
  int sw_imm;
  reg_number1 = get_reg_num(arg1);
  reg_number2 = extract_reg(arg2);
  sw_imm = extract_imm(arg2);
	*bytecode = (0x2b<<26) + (reg_number2<<21) + (reg_number1<<16) + sw_imm;
	return (0);
}

/* function to create bytecode for instruction J
   conversion result is passed in bytecode
   function always returns 0 (conversion OK)
   J is a J type instruction with the following 
   encoding - 
   31-26 opcode (0x2)
   25-0  arg1 (imm) */
int opcode_j(unsigned int offset, unsigned int *bytecode, char *opcode, char *arg1, char *arg2, char *arg3 ){
  int i;
  strcat(arg1, (char *)":");
	char label[MAX_ARG_LEN+1];
  memset(label,0,sizeof(label)); 
  for (i = 0; i < prog_len; i++) {
		if (strchr(&prog[i][0], ':')) { //check if the line contains a label
			sscanf(&prog[i][0],"%" XSTR(MAX_ARG_LEN) "s", label);
      if (strcmp(arg1, label) == 0) {
        break;
      }
    }
  }
  int jump_addr = (ADDR_TEXT + (4 * i)) & 0xFFFFFFC;
	*bytecode = (0x2<<26) + jump_addr;
	return (0);
}

/* function to create bytecode for instruction bne
   conversion result is passed in bytecode
   function always returns 0 (conversion OK)
   Add is a I type instruction with the following 
   encoding - 
   31-26 opcode (0x5)
   25-21 arg1 (rs)
   20-16 arg2 (rt)
   15-0  arg3 (imm) */
int opcode_bne(unsigned int offset, unsigned int *bytecode, char *opcode, char *arg1, char *arg2, char *arg3 ){
  int reg_number1, reg_number2, i;
  reg_number1 = get_reg_num(arg1);
  reg_number2 = get_reg_num(arg2);
  strcat(arg3, (char *)":");
	char label[MAX_ARG_LEN+1];
  memset(label,0,sizeof(label)); 
  for (i = 0; i < prog_len; i++) {
		if (strchr(&prog[i][0], ':')) { //check if the line contains a label
			sscanf(&prog[i][0],"%" XSTR(MAX_ARG_LEN) "s", label);
      if (strcmp(arg3, label) == 0) {
        break;
      }
    }
  }
  int branch_imm = (((ADDR_TEXT + (4 * i)) - (ADDR_TEXT + (4* (offset+1))))>>2) & 0xFFFF;
	*bytecode = (0x5<<26) + (reg_number1<<21) + (reg_number2<<16) + branch_imm;
	return (0);
}

/* function to create bytecode for instruction sll
   conversion result is passed in bytecode
   function always returns 0 (conversion OK) 
   Add is a R type instruction with the following 
   encoding - 
   31-26 opcode (0)
   25-21 (rs)
   20-16 arg2 (rt)
   15-11 arg1 (rd)
   10-6  arg3 (shamt)
   5-0   funct (0x0)*/
int opcode_sll(unsigned int offset, unsigned int *bytecode, char *opcode, char *arg1, char *arg2, char *arg3 ){
  int reg_number1, reg_number2;
  reg_number1 = get_reg_num(arg1);
  reg_number2 = get_reg_num(arg2);
  int shamt = atoi(arg3);
	*bytecode = (reg_number2<<16) + (reg_number1<<11) + (shamt<<6);
	return (0);
}

const char *opcode_str[] = {"add", "addi", "nor", "ori", "j", "bne", "sll", "lw", "sw", "la", "lui"};
opcode_function opcode_func[] = {&opcode_add, &opcode_addi, &opcode_nor, &opcode_ori, &opcode_j, &opcode_bne, &opcode_sll, &opcode_lw, &opcode_sw, &opcode_lui};

void strreplace(char s[], char chr, char repl_chr) {
  int i=0;
  while(s[i]!='\0') {
    if(s[i]==chr) {
      s[i]=repl_chr;
    }
    i++; 
  }
}

void init_data_rams () {
  int j = 0, i = 0;
	char var_name[MAX_ARG_LEN+1];
	char directive[MAX_ARG_LEN+1];
  char bytes[MAX_ARG_LEN+1];
  char text[MAX_ARG_LEN+1];
  int data_section = 0;

	while(j<prog_len){
		memset(var_name,0,sizeof(var_name)); 
		memset(directive,0,sizeof(directive)); 
		memset(bytes,0,sizeof(bytes)); 
		memset(text,0,sizeof(text)); 
    sscanf(&prog[j][0],"%" XSTR(MAX_ARG_LEN) "s", text);
    if ((strcmp(text, (char *)".data")) == 0) {
      data_section = 1;
      j++;
    }
    if (data_section) {
      if ((sscanf(&prog[j][0],"%" XSTR(MAX_ARG_LEN) "[^:]: %" XSTR(MAX_ARG_LEN) "s %" XSTR(MAX_ARG_LEN) "s", var_name, directive, bytes) != 3)){ //parse the line with var_name
        printf("Error! Wrong data declaration\n");
      }
      if ((strcmp(directive, (char *)".space")) == 0) {
        strcpy(var_ram[i], var_name);
        data_ram[i] = atoi(bytes);
        i++;
        num_vars++;
      }
      else if ((strcmp(directive, (char *)".word")) == 0) {
        strcpy(var_ram[i], var_name);
        data_ram[i] = atoi(bytes);
        i++;
        num_vars++;
      }
    }
    j++;
  }
}

/* function to create bytecode */ 
int make_bytecode(){
	unsigned int bytecode; // holds the bytecode for each converted program instruction 
  int j=0; //instruction counter (equivalent to program line)

	char label[MAX_ARG_LEN+1];
	char opcode[MAX_ARG_LEN+1];
  char arg1[MAX_ARG_LEN+1];
  char arg2[MAX_ARG_LEN+1];
  char arg3[MAX_ARG_LEN+1];
  char text[MAX_ARG_LEN+1];
  int code_started = 0;
  int num_j = 0;

  //printf("ASSEMBLING PROGRAM ...\n");
  init_data_rams();
	while(j<prog_len){
		memset(label,0,sizeof(label)); 
		memset(opcode,0,sizeof(opcode)); 
		memset(arg1,0,sizeof(arg1)); 
		memset(arg2,0,sizeof(arg2)); 
		memset(arg3,0,sizeof(arg3));	

		bytecode=0;
    sscanf(&prog[j][0],"%" XSTR(MAX_ARG_LEN) "s", text);
    if ((strcmp(text, (char *)".text")) == 0) {
      code_started = 1;
      j++;
    }
    if ((strcmp(text, (char *)".data")) == 0) {
      code_started = 0;
      j++;
    }
    if (code_started) {
		  if (strchr(&prog[j][0], ':')){ //check if the line contains a label
		  	if ((sscanf(&prog[j][0],"%" XSTR(MAX_ARG_LEN) "[^:]: %" XSTR(MAX_ARG_LEN) "s %" XSTR(MAX_ARG_LEN) "s %" XSTR(MAX_ARG_LEN) 
		  		"s %" XSTR(MAX_ARG_LEN) "s", label, opcode, arg1, arg2, arg3) != 5) && (sscanf(&prog[j][0],"%" XSTR(MAX_ARG_LEN) "[^:]: %" XSTR(MAX_ARG_LEN) "s %" XSTR(MAX_ARG_LEN) "s %" XSTR(MAX_ARG_LEN) "s %" XSTR(MAX_ARG_LEN) "s", label, opcode, arg1, arg2, arg3) != 4)){ //parse the line with label
		  			printf("parse error line %d\n", j);
		  			return(-1);
		  	}
		  }
		  else { 
		  	if ((sscanf(&prog[j][0],"%" XSTR(MAX_ARG_LEN) "s %" XSTR(MAX_ARG_LEN) "s %" XSTR(MAX_ARG_LEN)
		  		"s %" XSTR(MAX_ARG_LEN) "s", opcode, arg1, arg2, arg3) != 4) && (sscanf(&prog[j][0],"%" XSTR(MAX_ARG_LEN) "s %" XSTR(MAX_ARG_LEN) "s %" XSTR(MAX_ARG_LEN) 
          "s %" XSTR(MAX_ARG_LEN) "s", opcode, arg1, arg2, arg3) != 3)){ //parse the line without label
		  			printf("parse error line %d\n", j);
		  			return(-1);
		  	}
		  }
		  // debug printout; remove in final program	
		  //printf("executing with tokens: |%s|%s|%s|%s|%s|\n", label, opcode, arg1, arg2, arg3);
		  // executing nop for all lines (replace this with your code!)
		  // find the right function pointer for the right opcode!
      if (strcmp(opcode, (char*)"add") == 0) {
		    if ((*opcode_func[0])(j,&bytecode,opcode,arg1,arg2,arg3)<0) {
		    	printf("%d: opcode error (assembly: %s %s %s %s)\n", j, opcode, arg1, arg2, arg3);
		    	return(-1);
		    }
        printf("0x%08X:\t0x%08X\n", (ADDR_TEXT + 4 *num_j), bytecode);
      }
      else if (strcmp(opcode, (char*)"addi") == 0) {
		    if ((*opcode_func[1])(j,&bytecode,opcode,arg1,arg2,arg3)<0) {
		    	printf("%d: opcode error (assembly: %s %s %s %s)\n", j, opcode, arg1, arg2, arg3);
		    	return(-1);
		    }
        printf("0x%08X:\t0x%08X\n", (ADDR_TEXT + 4 *num_j), bytecode);
      }
      else if (strcmp(opcode, (char*)"nor") == 0) {
		    if ((*opcode_func[2])(j,&bytecode,opcode,arg1,arg2,arg3)<0) {
		    	printf("%d: opcode error (assembly: %s %s %s %s)\n", j, opcode, arg1, arg2, arg3);
		    	return(-1);
		    }
        printf("0x%08X:\t0x%08X\n", (ADDR_TEXT + 4 *num_j), bytecode);
      }
      else if (strcmp(opcode, (char*)"ori") == 0) {
		    if ((*opcode_func[3])(j,&bytecode,opcode,arg1,arg2,arg3)<0) {
		    	printf("%d: opcode error (assembly: %s %s %s %s)\n", j, opcode, arg1, arg2, arg3);
		    	return(-1);
		    }
        printf("0x%08X:\t0x%08X\n", (ADDR_TEXT + 4 *num_j), bytecode);
      }
      else if (strcmp(opcode, (char*)"j") == 0) {
		    if ((*opcode_func[4])(j,&bytecode,opcode,arg1,arg2,arg3)<0) {
		    	printf("%d: opcode error (assembly: %s %s %s %s)\n", j, opcode, arg1, arg2, arg3);
		    	return(-1);
		    }
        printf("0x%08X:\t0x%08X\n", (ADDR_TEXT + 4 *num_j), bytecode);
      }
      else if (strcmp(opcode, (char*)"bne") == 0) {
		    if ((*opcode_func[5])(j,&bytecode,opcode,arg1,arg2,arg3)<0) {
		    	printf("%d: opcode error (assembly: %s %s %s %s)\n", j, opcode, arg1, arg2, arg3);
		    	return(-1);
		    }
        printf("0x%08X:\t0x%08X\n", (ADDR_TEXT + 4 *num_j), bytecode);
      }
      else if (strcmp(opcode, (char*)"sll") == 0) {
		    if ((*opcode_func[6])(j,&bytecode,opcode,arg1,arg2,arg3)<0) {
		    	printf("%d: opcode error (assembly: %s %s %s %s)\n", j, opcode, arg1, arg2, arg3);
		    	return(-1);
		    }
        printf("0x%08X:\t0x%08X\n", (ADDR_TEXT + 4 *num_j), bytecode);
      }
      else if (strcmp(opcode, (char*)"lw") == 0) {
		    if ((*opcode_func[7])(j,&bytecode,opcode,arg1,arg2,arg3)<0) {
		    	printf("%d: opcode error (assembly: %s %s %s %s)\n", j, opcode, arg1, arg2, arg3);
		    	return(-1);
		    }
        printf("0x%08X:\t0x%08X\n", (ADDR_TEXT + 4 *num_j), bytecode);
      }
      else if (strcmp(opcode, (char*)"sw") == 0) {
		    if ((*opcode_func[8])(j,&bytecode,opcode,arg1,arg2,arg3)<0) {
		    	printf("%d: opcode error (assembly: %s %s %s %s)\n", j, opcode, arg1, arg2, arg3);
		    	return(-1);
		    }
        printf("0x%08X:\t0x%08X\n", (ADDR_TEXT + 4 *num_j), bytecode);
      }
      else if (strcmp(opcode, (char*)"lui") == 0) {
		    if ((*opcode_func[9])(j,&bytecode,opcode,arg1,arg2,arg3)<0) {
		    	printf("%d: opcode error (assembly: %s %s %s %s)\n", j, opcode, arg1, arg2, arg3);
		    	return(-1);
		    }
        printf("0x%08X:\t0x%08X\n", (ADDR_TEXT + 4 *num_j), bytecode);
      }
      else if (strcmp(opcode, (char*)"la") == 0) {
		    if ((*opcode_func[9])(j,&bytecode,opcode,arg1,arg2,arg3)<0) {
		    	printf("%d: opcode error (assembly: %s %s %s %s)\n", j, opcode, arg1, arg2, arg3);
		    	return(-1);
		    }
        printf("0x%08X:\t0x%08X\n", (ADDR_TEXT + 4 *num_j), bytecode);
        num_j++;
		    if ((*opcode_func[3])(j,&bytecode,opcode,arg1,arg1,arg2)<0) {
		    	printf("%d: opcode error (assembly: %s %s %s %s)\n", j, opcode, arg1, arg2, arg3);
		    	return(-1);
		    }
        printf("0x%08X:\t0x%08X\n", (ADDR_TEXT + 4 *num_j), bytecode);
      }
      num_j++;
    }
		j++;
  }
  //printf("... DONE!\n");
  return(0);
}

/* loading the program into memory */
int load_program(){
  int j=0;
  while(fgets(&prog[prog_len][0], MAX_LINE_LEN, stdin)) {
    strreplace(&prog[prog_len][0], ',', ' ');
    prog_len++;
  }
  return(0);
}

int main(){
	if (load_program()<0) 	return(-1);        
	if (make_bytecode()<0) 	return(-1); 
  return(0);
}
