// A simple MIPS Assembler and Processor
// Input: File giving instructions in binary
// Output: Result of executing those instruction
#include "mips.h"

// Main Function
int main (int argc, char *argv[]) {
    // File pointer to the input file
    FILE *bin_instr;
    // Only the input file should be given
    // as the run-time option
    if ((argc > 2) || (argc == 1)) {
        printf ("\nERROR:\n\tMore than one or zero input(s) detected!\n");
        usage ();
        return 1;
    }
    // Open the binary file and parse the 
    // instructions. Note that the data is 
    // present after the BREAK instruction.
    else {
        if (!(bin_instr = fopen (argv[1], "r"))) {
            printf ("Failed\n");
        }
    }
    // Parse the file and update the internal memory
    parse_binary_file (bin_instr);
    //// Execute the instructions from the memory
    execute_instr ();
    return 0;
}

// A simple Usage function
void usage () {
    printf ("\nUSAGE:\n");
    printf ("\tPass the input file as the run-time option\n");
    printf ("\t./mips <binary_file_name>\n\n");
}

// Function to parse the input binary file
void parse_binary_file (FILE *bin_instr) {
    char * instruction;
    instruction = malloc (32*sizeof (char *));
    fscanf (bin_instr, "%s", instruction);
    while (fscanf (bin_instr, "%s", instruction)!=EOF) {
        printf ("%s\n", instruction);
        bin_str_to_hex (instruction);
    }
}

// Function to convert binary string to hex
void bin_str_to_hex (char *str) {
    int i = 0;
    int instr_hex = 0;
    for (i = 0; i < 32; i++) {
        int n = (str[31-i] == '1');
        instr_hex = instr_hex | (n << i);
    }
    memory[CURRENT_STATE.PC] = instr_hex;
    CURRENT_STATE.PC+=4;
    //printf ("instruction is 0x%.8x\n", instr_hex);
}

// Function to execute the MIPS instructions
void execute_instr () {
}

// Memory dump
void mem_dump (int mem_start, int mem_end) {
    int i = 0;
    printf ("Data\n");
    for (i = mem_start; i <= mem_end; i = i + 32) {
        printf ("%3d:\t", i); 
        int j;
        for (j = i; j < 8; j++) {
            printf ("%d\t", memory[i+j]);
        }
        printf ("\n");
    }
    printf ("\n--------------------\n");
}

// Register File dump
void reg_dump () {
    int i = 0;
    printf ("Registers\n");
    for (i = 0; i < 32; i = i + 8) {
        printf ("R%.2d:\t", i); 
        int j;
        for (j = i; j < 8; j++) {
            printf ("%d\t", CURRENT_STATE.REGS[i+j]);
        }
        printf ("\n");
    }
}

int decode_instr_type (int instr_opcode) {
    int type;
    if ((instr_opcode >> 26) == 0) { //R type
        type = R_TYPE;
        return type;
    }
    else if (((instr_opcode >> 26) == 2 ) || ((instr_opcode >> 26) == 3)) { //J type
        type = J_TYPE;
        return type;
    }
    else { //I type
        type = I_TYPE;
        return type;
    }
    printf("No valid type found for instruction: %32x\n", instr_opcode);
    type = -1;
    return type;
}

int shift_const (unsigned int shamt) {
    switch (shamt) {
        case 1 : return 0x80000000;          case 2 : return 0xC0000000;          case 3 : return 0xE0000000;          case 4 : return 0xF0000000;
        case 5 : return 0xF8000000;          case 6 : return 0xFC000000;          case 7 : return 0xFE000000;          case 8 : return 0xFF000000;
        case 9 : return 0xFF800000;          case 10: return 0xFFC00000;          case 11: return 0xFFE00000;          case 12: return 0xFFF00000;
        case 13: return 0xFFF80000;          case 14: return 0xFFFC0000;          case 15: return 0xFFFE0000;          case 16: return 0xFFFF0000;
        case 17: return 0xFFFF8000;          case 18: return 0xFFFFC000;          case 19: return 0xFFFFE000;          case 20: return 0xFFFFF000;
        case 21: return 0xFFFFF800;          case 22: return 0xFFFFFC00;          case 23: return 0xFFFFFE00;          case 24: return 0xFFFFFF00;
        case 25: return 0xFFFFFF80;          case 26: return 0xFFFFFFC0;          case 27: return 0xFFFFFFE0;          case 28: return 0xFFFFFFF0;
        case 29: return 0xFFFFFFF8;          case 30: return 0xFFFFFFFC;          case 31: return 0xFFFFFFFE;          case 0 : return 0x00000000;
    }
    return 0;
}


void execute_r (int rs, int rt, int rd, unsigned int shamt, unsigned int funct) {
    int sign;
    int shift_val;
    int64_t mul_res;
    switch (funct) {
        case (SLL): //SLL
            NEXT_STATE.REGS[rd] = CURRENT_STATE.REGS[rt] << shamt;
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t SLL R%-2d, R%-2d, 0x%-x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rd,
                rt,
                shamt
            );
        break;
        case (SRL): //SRL
            NEXT_STATE.REGS[rd] = CURRENT_STATE.REGS[rt] >> shamt;
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t SRL R%-2d, R%-2d, 0x%-x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rd,
                rt,
                shamt
            );
        break;
        case (SRA): //SRA
            sign = (CURRENT_STATE.REGS[rs] & 0x10000000)>>31;
            shift_val = shift_const(shamt);
            NEXT_STATE.REGS[rd] = CURRENT_STATE.REGS[rt] >> shamt;
            NEXT_STATE.REGS[rd] = (sign == 1) ? NEXT_STATE.REGS[rd] | shift_val: NEXT_STATE.REGS[rd]; 
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t SRA R%-2d, R%-2d, 0x%-x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rd,
                rt,
                shamt
            );
        break;
        case (ADD): //ADD
            NEXT_STATE.REGS[rd] = (int32_t)(CURRENT_STATE.REGS[rs] + CURRENT_STATE.REGS[rt]);
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t ADD R%-2d, R%-2d, R%-2d\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rd,
                rs,
                rt
            );
        break;
        case (SUB): //SUB
            NEXT_STATE.REGS[rd] = (int32_t)(CURRENT_STATE.REGS[rs] - CURRENT_STATE.REGS[rt]);
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t SUB R%-2d, R%-2d, R%-2d\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rd,
                rs,
                rt
            );
        break;
        case (AND): //AND
            NEXT_STATE.REGS[rd] = CURRENT_STATE.REGS[rs] & CURRENT_STATE.REGS[rt];
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t AND R%-2d, R%-2d, R%-2d\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rd,
                rs,
                rt
            );
        break;
        case (OR): //OR
            NEXT_STATE.REGS[rd] = CURRENT_STATE.REGS[rs] | CURRENT_STATE.REGS[rt];
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t OR R%-2d, R%-2d, R%-2d\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rd,
                rs,
                rt
            );
        break;
        case (XOR): //XOR
            NEXT_STATE.REGS[rd] = CURRENT_STATE.REGS[rs] ^ CURRENT_STATE.REGS[rt];
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t XOR R%-2d, R%-2d, R%-2d\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rd,
                rs,
                rt
            );
        break;
        case (NOR): //NOR
            NEXT_STATE.REGS[rd] = ~(CURRENT_STATE.REGS[rs] | CURRENT_STATE.REGS[rt]);
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t NOR R%-2d, R%-2d, R%-2d\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rd,
                rs,
                rt
            );
        break;
        case (SLT): //SLT
            NEXT_STATE.REGS[rd] = ((signed)CURRENT_STATE.REGS[rs] < (signed)CURRENT_STATE.REGS[rt]) ? 1 : 0;
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t SLT R%-2d, R%-2d, R%-2d\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rd,
                rs,
                rt
            );
        break;
        case (MULT): //MULT
            mul_res = (long long int)(CURRENT_STATE.REGS[rs] * CURRENT_STATE.REGS[rt]);
            // TODO:
            NEXT_STATE.HI = (int)((mul_res>>32) & 0xFFFFFFFF);
            NEXT_STATE.LO = (int)(mul_res & 0xFFFFFFFF);
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t MULT HI:%-2d, LO:%-2d, R%-2d\n, R%-2d\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                NEXT_STATE.HI,
                NEXT_STATE.LO,
                rs,
                rt
            );
        break;
        case (DIV): //DIV
            //TODO:
            NEXT_STATE.LO = ((int32_t)CURRENT_STATE.REGS[rs] / (int32_t)CURRENT_STATE.REGS[rt]);
            NEXT_STATE.HI = ((int32_t)CURRENT_STATE.REGS[rs] % (int32_t)CURRENT_STATE.REGS[rt]);
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t DIV HI:%-2d, LO:%-2d, R%-2d\n, R%-2d\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                NEXT_STATE.HI,
                NEXT_STATE.LO,
                rs,
                rt
            );
        break;
        case (BREAK): //BREAK
            if (CURRENT_STATE.REGS[2] == 0xA) {
                RUN_BIT = 0;
            }
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t SYSCALL\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode
            );
        break;
        default:
            printf ("ERROR. Incorrect R-type instruction opcode\n");
    }
}

void decode_r (int instr_opcode) {
    int rs, rt, rd;
    unsigned int shamt, funct;
    rs     = (instr_opcode >> 21)   & 0x1F;
    rt     = (instr_opcode >> 16)   & 0x1F;
    rd     = (instr_opcode >> 11)   & 0x1F;
    shamt  = (instr_opcode >> 6)    & 0x1F;
    funct  = (instr_opcode)         & 0x3F;

    execute_r (rs, rt, rd, shamt, funct);
}

void execute_i (unsigned int opcode, int rs, int rt, int imm) {
    int sign, mem_content;
    int shift_val;
    int address;
    //printf ("I-type instruction\tOpcode is :0x%x\n", opcode);
    switch (opcode) {
        case (BEQ): //BEQ
            if (CURRENT_STATE.REGS[rs] == CURRENT_STATE.REGS[rt]) {
                shift_val = shift_const(14);
                sign = (imm & 0x8000)>>15;
                imm = imm << 2;
                address = (sign) ? (imm | shift_val) : imm;
                NEXT_STATE.PC = CURRENT_STATE.PC + 4 + address;
            }
            else {
                NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            }
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t BEQ R%-2d, R%-2d, 0x%-32x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rt,
                rs,
                imm
            );
        break;
        case (BNE): //BNE
            if (CURRENT_STATE.REGS[rs] != CURRENT_STATE.REGS[rt]) {
                shift_val = shift_const(14);
                sign = (imm & 0x8000)>>15;
                imm = imm << 2;
                address = (sign) ? (imm | shift_val) : imm;
                NEXT_STATE.PC = CURRENT_STATE.PC + 4 + address;
            }
            else {
                NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            }
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t BNE R%-2d, R%-2d, 0x%-32x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rt,
                rs,
                imm
            );
        break;
        case (BLEZ): //BLEZ
            if ((int32_t)CURRENT_STATE.REGS[rs] <= 0) {
                shift_val = shift_const(14);
                sign = (imm & 0x8000)>>15;
                imm = imm << 2;
                address = (sign) ? (imm | shift_val) : imm;
                NEXT_STATE.PC = CURRENT_STATE.PC + 4 + address;
            }
            else {
                NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            }
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t BLEZ R%-2d, 0x%-32x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rs,
                imm
            );
        break;
        case (BGTZ): //BGTZ
            if ((int32_t)CURRENT_STATE.REGS[rs] > 0) {
                shift_val = shift_const(14);
                sign = (imm & 0x8000)>>15;
                imm = imm << 2;
                address = (sign) ? (imm | shift_val) : imm;
                NEXT_STATE.PC = CURRENT_STATE.PC + 4 + address;
            }
            else {
                NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            }
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t BGTZ R%-2d, 0x%-32x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rs,
                imm
            );
        break;
        case (ADDI): //ADDI
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t ADDI R%-2d, R%-2d, 0x%-32x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rt,
                rs,
                imm
            );
            if (rt == 0) {
                NEXT_STATE.PC = CURRENT_STATE.PC + 4;
                return;
            }
            shift_val = shift_const(16);
            sign = (imm & 0x8000)>>15;
            imm = (sign) ? (imm | shift_val) : imm;
            NEXT_STATE.REGS[rt] = CURRENT_STATE.REGS[rs] + imm;
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            
        break;
        case (SLTI): //SLTI
            shift_val = shift_const(16);
            sign = (imm & 0x8000)>>15 ? 1 : 0;
            imm = (sign) ? (imm | shift_val) : imm;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t SLTI R%-2d, R%-2d, 0x%-32x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rt,
                rs,
                imm
            );
            if (rt == 0) {
                NEXT_STATE.PC = CURRENT_STATE.PC + 4;
                return;
            }
            NEXT_STATE.REGS[rt] = ((int32_t)CURRENT_STATE.REGS[rs] < (int32_t)imm) ? 1 : 0;
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
        break;
        case (ANDI): //ANDI
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t ANDI R%-2d, R%-2d, 0x%-32x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rt,
                rs,
                imm
            );
            if (rt == 0) {
                NEXT_STATE.PC = CURRENT_STATE.PC + 4;
                return;
            }
            NEXT_STATE.REGS[rt] = ((unsigned int)CURRENT_STATE.REGS[rs] & (unsigned int)imm);
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
        break;
        case (ORI): //ORI
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t ORI R%-2d, R%-2d, 0x%-32x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rt,
                rs,
                imm
            );
            if (rt == 0) {
                NEXT_STATE.PC = CURRENT_STATE.PC + 4;
                return;
            }
            NEXT_STATE.REGS[rt] = ((unsigned int)CURRENT_STATE.REGS[rs] | (unsigned int)imm);
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
        break;
        case (XORI): //XORI
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t XORI R%-2d, R%-2d, 0x%-32x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rt,
                rs,
                imm
            );
            if (rt == 0) {
                NEXT_STATE.PC = CURRENT_STATE.PC + 4;
                return;
            }
            NEXT_STATE.REGS[rt] = ((unsigned int)CURRENT_STATE.REGS[rs] ^ (unsigned int)imm);
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
        break;
        case (LW): //LW
            shift_val = shift_const(16);
            sign = (imm & 0x8000)>>15;
            imm = (sign) ? (imm | shift_val) : imm;
            address = (CURRENT_STATE.REGS[rs] + imm) & 0xFFFFFFFC;
            mem_content = mem_read_32((unsigned int)address);
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t LW R%-2d, R%-2d, 0x%-32x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rt,
                rs,
                imm
            );
            if (rt == 0) {
                NEXT_STATE.PC = CURRENT_STATE.PC + 4;
                return;
            }
            NEXT_STATE.REGS[rt] = mem_content;
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
        break;
        case (SW): //SW
            shift_val = shift_const(16);
            sign = (imm & 0x8000)>>15;
            imm = (sign) ? (imm | shift_val) : imm;
            // Align the address to a word boundary
            address = (CURRENT_STATE.REGS[rs] + imm) & 0xFFFFFFFC;
            mem_write_32(address, NEXT_STATE.REGS[rt]);
            NEXT_STATE.PC = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t SW R%-2d, R%-2d, 0x%-32x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                rt,
                rs,
                imm
            );
        break;
        default:
            printf ("ERROR. Incorrect I-type instruction opcode %8x\n", instr_opcode);
    }
}

void decode_i (int instr_opcode) {
    int rs, rt;
    unsigned int opcode; 
    int imm;
    opcode = (instr_opcode >> 26)   & 0x3F;
    rs     = (instr_opcode >> 21)   & 0x1F;
    rt     = (instr_opcode >> 16)   & 0x1F;
    imm    = (instr_opcode)         & 0xFFFF;

    execute_i (opcode, rs, rt, imm);
}

void execute_j (unsigned int opcode, int target) {
    int address;
    switch (opcode) { 
        case (J): //J
            address = ((CURRENT_STATE.PC+4) & 0xF0000000) | (target<<2);
            NEXT_STATE.PC = address;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t J %-8x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                NEXT_STATE.PC
            );
        break;
        case (JAL): //JAL
            address = ((CURRENT_STATE.PC+4) & 0xF0000000) | (target<<2);
            NEXT_STATE.PC = address;
            NEXT_STATE.REGS[31] = CURRENT_STATE.PC + 4;
            printf ("[%d] PC:%.8x\tINSTR:%.8x\t JAL %-8x\n", 
                instr_count,
                CURRENT_STATE.PC,
                instr_opcode,
                NEXT_STATE.PC
            );
        break;
        default:
            printf ("ERROR. Incorrect J-type instruction opcode\n");
            
    }
}

void decode_j (int instr_opcode) {
    unsigned int opcode; 
    int address;
    opcode  = (instr_opcode >> 26)   & 0x3F;
    address = (instr_opcode)         & 0x3FFFFFF;

    execute_j (opcode, address);
}

void process_instruction() {
    // TODO:
    instr_opcode = mem_read_32(CURRENT_STATE.PC);
    int type = decode_instr_type (instr_opcode);
    if (type == R_TYPE)
        decode_r (instr_opcode);
    else if (type == J_TYPE)
        decode_j (instr_opcode);
    else 
        decode_i (instr_opcode);
    instr_count++;
}

