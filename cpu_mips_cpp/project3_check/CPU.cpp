#include "CPU.h"

const string CPU::regNames[] = {"$zero","$at","$v0","$v1","$a0","$a1","$a2","$a3",
                                "$t0","$t1","$t2","$t3","$t4","$t5","$t6","$t7",
                                "$s0","$s1","$s2","$s3","$s4","$s5","$s6","$s7",
                                "$t8","$t9","$k0","$k1","$gp","$sp","$fp","$ra"};

CPU::CPU(uint32_t pc, Memory &iMem, Memory &dMem) : pc(pc), iMem(iMem), dMem(dMem) {
  for(int i = 0; i < NREGS; i++) {
    regFile[i] = 0;
  }
  hi = 0;
  lo = 0;
  regFile[28] = 0x10008000; // gp
  regFile[29] = 0x10000000 + dMem.getSize(); // sp

  instructions = 0;
  stop = false;
}

void CPU::run() {
  while(!stop) {
    instructions++;

    stats.clock(IF1);
    fetch();
    decode();
    execute();
    mem();
    writeback();

    D(printRegFile());
  }
}

void CPU::fetch() {
  instr = iMem.loadWord(pc);
  pc = pc + 4;
}

/////////////////////////////////////////
// ALL YOUR CHANGES GO IN THIS FUNCTION
/////////////////////////////////////////
void CPU::decode() {
  uint32_t opcode;      // opcode field
  uint32_t rs, rt, rd;  // register specifiers
  uint32_t shamt;       // shift amount (R-type)
  uint32_t funct;       // funct field (R-type)
  uint32_t uimm;        // unsigned version of immediate (I-type)
  int32_t simm;         // signed version of immediate (I-type)
  uint32_t addr;        // jump address offset field (J-type)

  opcode = instr >> 26;	// for the opcode we need bits 26 to 31, it's the top of the 32 bit instruction,
                  // we can get those 6 bits by shifting the instruction value to the right 26 times
                  // so bit 26 will now be bit 0, bit 25 will be bit 1, and so on. Since the shift inserts
                  // zeros at the left, we will end up with only the 6 bits of the opcode in the opcode
                  // variable
  rs = (instr >> 21) & 0x1F; // for the Rs field we need bits 25 to 21, we can get those 5 bits by shifting the
                   // instruction value to the right 21 times. After that we will have 21 zeros to the left,
                   // 6 bits of the opcode and at the rightmost, the 5 bits we need, in order to clear all the bits
                   // we don't need, we use a "mask", we can mask 5 bits using the 32 bit pattern in binary:
                   // 00000000 00000000 00000000 00011111, and making an AND operation using this value,
                   // after that we will get zeros in the right and only the 5 rightmost bits (Rs) will be preserved
                   // we can translate the value in binary to hexadecimal and obtain the mask as: 0x0000001F
                   // we can simply use the 0x1F since zeros to the left are implied
  rt = (instr >> 16) & 0x1F; // for the Rt field we need bits 20 to 16, we can get those 5 bits by shifting the
                   // instruction value to the right 16 times. After that we will have 16 zeros to the left,
                   // 6 bits of the opcode,5 bits of Rs and the 5 bits we need, in order to clear all the bits
                   // we don't need, we use a "mask", we can mask 5 bits using the 32 bit pattern in binary:
                   // 00000000 00000000 00000000 00011111, and making an AND operation using this value,
                   // after that we will get zeros in the right and only the 5 rightmost bits (Rt) will be preserved
                   // we can translate the value in binary to hexadecimal and obtain the mask as: 0x0000001F
                   // we can simply use the 0x1F since zeros to the left are implied
  rd = (instr >> 11) & 0x1F; // for the Rd field we need bits 15 to 11, we can get those 5 bits by shifting the
                   // instruction value to the right 11 times. After that we will have 11 zeros to the left,
                   // 6 bits of opcode, 5 bits of Rs, 5 bits of Rt and at the rightmost the 5 bits we need,
                   // we clear all the bits using the 32 bit pattern in binary:
                   // 00000000 00000000 00000000 00011111, and making an AND operation using this value,
                   // after that we will get zeros in the right and only the 5 rightmost bits (Rd) will be preserved
                   // we can translate the value in binary to hexadecimal and obtain the mask as: 0x0000001F
                   // we can simply use the 0x1F since zeros to the left are implied
  shamt = (instr >> 6) & 0x1F; // for the shamt field we need bits 10 to 6, we can get those 5 bits by shifting the
                   // instruction value to the right 6 times. After that we will have 6 zeros to the left,
                   // 6 opcode bits, 5 for Rs, 5 for Rt, 5 for Rd and the 5 bits we need, in order to clear all the bits
                   // we don't need, we use a "mask", we can mask 5 bits using the 32 bit pattern in binary:
                   // 00000000 00000000 00000000 00011111, and making an AND operation using this value,
                   // after that we will get zeros in the right and only the 5 rightmost bits (shamt) will be preserved
                   // we can translate the value in binary to hexadecimal and obtain the mask as: 0x0000001F
                   // we can simply use the 0x1F since zeros to the left are implied
  funct = instr & 0x3F;      // for the funct field we need bits 5 to 0, they are at the rightmost position in the instruction
                   // in order to clear all the bits we don't need, we use a "mask", we can mask 6 bits using the 32 bit
                   // pattern in binary:
                   // 00000000 00000000 00000000 00111111, and making an AND operation using this value,
                   // after that we will get zeros in the right and only the 6 rightmost bits (funct) will be preserved
                   // we can translate the value in binary to hexadecimal and obtain the mask as: 0x0000003F
                   // we can simply use the 0x3F since zeros to the left are implied
  uimm = instr & 0xFFFF;     // for the uimm field we need bits 15 to 0, they are at the rightmost position in the instruction
                   // in order to clear all the bits we don't need, we use a "mask", we can mask 6 bits using the 32 bit
                   // pattern in binary:
                   // 00000000 00000000 11111111 11111111, and making an AND operation using this value,
                   // after that we will get zeros in the right and only the 16 rightmost bits (uimm) will be preserved
                   // we can translate the value in binary to hexadecimal and obtain the mask as: 0x0000FFFF
                   // we can simply use the 0xFFFF since zeros to the left are implied
  simm = ((instr & 0x8000)? 0xFFFF0000 : 0x0) | (instr & 0xFFFF); // for the simm field we need bits 15 to 0, they are at the rightmost position in the instruction
                   // in order to clear all the bits we don't need, we use a "mask", we can mask 6 bits using the 32 bit
                   // pattern in binary:
                   // 00000000 00000000 11111111 11111111, and making an AND operation using this value,
                   // after that we will get zeros in the right and only the 16 rightmost bits (uimm) will be preserved
                   // we can translate the value in binary to hexadecimal and obtain the mask as: 0x0000FFFF
                   // we can simply use the 0xFFFF since zeros to the left are implied
                   // Since we want a signed value based on bit 15, we need to add either zeros or ones depending on bit 15.
                   // We can get bit 15 by using the mask:  00000000 00000000 10000000 00000000 = 0x8000 in hexadecimal
                   // if the bit is different than zero, we need to add ones (extend the sign) to the bits 16 to 31
                   // we can do that by OR'ing (|) the value: FFFFFFFF FFFFFFFF 00000000 00000000 = 0xFFFF0000 in hexadecimal
                   // if the value of bit 15 is zero we OR with 0 since we have cleared the left bits with the first mask
  addr = instr &  0x3FFFFFF; // for the addr field we need bits 25 to 0, they are at the rightmost position in the instruction.
                   // In order to clear all the bits we don't need, we use a "mask", we can mask 26 bits using the 32 bit
                   // pattern in binary:
                   // 00000011 11111111 11111111 11111111, and making an AND operation using this value,
                   // after that we will get zeros in the right and only the 26 rightmost bits (addr) will be preserved
                   // we can translate the value in binary to hexadecimal and obtain the mask as: 0x03FFFFFF
                   // we can simply use the 0x3FFFFFF since zeros to the left are implied


  // Safe values for all the control signals
  opIsLoad=false;   // no load instruction
  opIsStore=false;  // no store instruction
  opIsMultDiv=false;    // no mul/div instruction
  aluOp=ADD;            // use ADD by default
  writeDest=false;      // do not write the alu result to a register
  destReg=regFile[REG_ZERO];    // use zero register as destination
  aluSrc1=regFile[REG_ZERO];    // use zero register as first alu source
  aluSrc2=regFile[REG_ZERO];    // use zero register as second alu source
  storeData=0;          // set value to save to memory to zero

  D(cout << "  " << hex << setw(8) << pc - 4 << ": ");
  switch(opcode) {
    case 0x00:
      switch(funct) {
        case 0x00: D(cout << "sll " << regNames[rd] << ", " << regNames[rs] << ", " << dec << shamt);
                   writeDest=true; // indicates that the alu result must be saved
                   aluOp = SHF_L; // set the shift left operation on the ALU
                   destReg=rd;  // set destination register as rd
                   stats.registerDest (destReg);
                   stats.registerSrc (rs);
                   aluSrc1=regFile[rs];  // set first operand on the alu to rs
                   aluSrc2=shamt;  // set second operand on the alu to shift value
                   break;
        case 0x03: D(cout << "sra " << regNames[rd] << ", " << regNames[rs] << ", " << dec << shamt);
                   writeDest=true; // indicates that the alu result must be saved
                   aluOp = SHF_R; // set the shift right operation on the ALU
                   destReg=rd;  // set destination register as rd
                   stats.registerDest (destReg);
                   stats.registerSrc (rs);
                   aluSrc1=regFile[rs];  // set first operand on the alu to rs
                   aluSrc2=shamt;  // set second operand on the alu to shift value
                   break;
        case 0x08: D(cout << "jr " << regNames[rs]);
                   writeDest = false;   // do not write alu result to a register
                   stats.registerDest (REG_ZERO);
                   stats.registerSrc (rs);
                   pc = regFile[rs];    // set the next pc location to the address in rs
                   stats.flush(2);
                   break;
        case 0x10: D(cout << "mfhi " << regNames[rd]);
                   writeDest=true; // indicates that the alu result must be saved in a register
                   aluOp = ADD; // set the ADD operation on the ALU
                   destReg=rd;  // set destination register as rd
                   stats.registerDest (destReg);
                   stats.registerSrc (REG_HILO);
                   aluSrc1=hi;  // set first operand on the alu to hi
                   aluSrc2=regFile[REG_ZERO]; // set second operand on the alu to zero
                   break;
        case 0x12: D(cout << "mflo " << regNames[rd]);
                   writeDest=true; // indicates that the alu result must be saved in a register
                   aluOp = ADD; // set the ADD operation on the ALU
                   destReg=rd;  // set destination register as rd
                   stats.registerDest (destReg);
                   stats.registerSrc (REG_HILO);
                   aluSrc1=lo;  // set first operand on the alu to lo
                   aluSrc2=regFile[REG_ZERO]; // set second operand on the alu to zero
                   break;
        case 0x18: D(cout << "mult " << regNames[rs] << ", " << regNames[rt]);
                   writeDest=false; // indicates that the alu result should not be saved (it will be saved in lo,hi)
                   opIsMultDiv=true;    // set the flag to indicate that the operation will be a multiplication
                   aluOp = MUL; // set the ADD operation on the ALU
                   stats.registerDest (REG_HILO);
                   stats.registerSrc (rs);
                   stats.registerSrc (rt);
                   aluSrc1=regFile[rs];  // set first operand on the alu to rs
                   aluSrc2=regFile[rt];  // set second operand on the alu to rt
                   break;
        case 0x1a: D(cout << "div " << regNames[rs] << ", " << regNames[rt]);
                   writeDest=false; // indicates that the alu result should not be saved (it will be saved in lo,hi)
                   opIsMultDiv=true;    // set the flag to indicate that the operation will be a multiplication
                   aluOp = DIV; // set the ADD operation on the ALU
                   stats.registerDest (REG_HILO);
                   stats.registerSrc (rs);
                   stats.registerSrc (rt);
                   aluSrc1=regFile[rs];  // set first operand on the alu to rs
                   aluSrc2=regFile[rt];  // set second operand on the alu to rt
                   break;
        case 0x21: D(cout << "addu " << regNames[rd] << ", " << regNames[rs] << ", " << regNames[rt]);
                   writeDest=true; // indicates that the alu result must be saved in a register
                   aluOp = ADD; // set the ADD operation on the ALU
                   destReg=rd;  // set destination register as rd
                   stats.registerDest (destReg);
                   stats.registerSrc (rs);
                   stats.registerSrc (rt);
                   aluSrc1=regFile[rs];  // set first operand on the alu to rs
                   aluSrc2=regFile[rt];  // set second operand on the alu to rt
                   break;
        case 0x23: D(cout << "subu " << regNames[rd] << ", " << regNames[rs] << ", " << regNames[rt]);
                   writeDest=true; // indicates that the alu result must be saved
                   aluOp = ADD; // use the ADD operation on the ALU since there is no sub
                   destReg=rd;  // set destination register as rd
                   stats.registerDest (destReg);
                   stats.registerSrc (rs);
                   stats.registerSrc (rt);
                   aluSrc1=regFile[rs];  // set first operand on the alu to rs
                   aluSrc2=-regFile[rt];  // set second operand on the alu to -rt to make a substraction
                   break;
        case 0x2a: D(cout << "slt " << regNames[rd] << ", " << regNames[rs] << ", " << regNames[rt]);
                   writeDest=true; // indicates that the alu result must be saved in a register
                   aluOp = CMP_LT; // set the comparison operation on the ALU, the result is either 0 or 1
                   destReg=rd;  // set destination register as rd so the comparison result is saved in it
                   stats.registerDest (destReg);
                   stats.registerSrc (rs);
                   stats.registerSrc (rt);
                   aluSrc1=regFile[rs];  // set first operand on the alu to rd
                   aluSrc2=regFile[rt];  // set second operand on the alu to rt
                   break;
        default: cerr << "unimplemented instruction: pc = 0x" << hex << pc - 4 << endl;
      }
      break;
    case 0x02: D(cout << "j " << hex << ((pc & 0xf0000000) | addr << 2)); // P1: pc + 4
               writeDest = false;   // do not write registers
               pc = (pc & 0xf0000000) | addr << 2; // save address field in pc to jump to the location
               stats.flush(2);
               break;
    case 0x03: D(cout << "jal " << hex << ((pc & 0xf0000000) | addr << 2)); // P1: pc + 4
               writeDest = true; destReg = REG_RA; // writes PC+4 to $ra
               aluOp = ADD; // ALU should pass pc thru unchanged
               aluSrc1 = pc;
               stats.registerDest (destReg);
               aluSrc2 = regFile[REG_ZERO]; // always reads zero
               pc = (pc & 0xf0000000) | addr << 2;
               stats.flush(2);
               break;
    case 0x04: D(cout << "beq " << regNames[rs] << ", " << regNames[rt] << ", " << pc + (simm << 2));
               stats.registerSrc (rs);
               stats.registerSrc (rt);
               if(regFile[rs]==regFile[rt]) {// compare both register values for equality
                 pc=pc + (simm << 2);   // if the register contents are equal, jump to the immediate offset address
                                        // relative to the current value of pc
                 stats.flush(2);
                 stats.countTaken();
               }
               stats.countBranch();
               break;
    case 0x05: D(cout << "bne " << regNames[rs] << ", " << regNames[rt] << ", " << pc + (simm << 2));
               stats.registerSrc (rs);
               stats.registerSrc (rt);
               if(regFile[rs]!=regFile[rt]) {// compare both register values for inequality
                 pc=pc + (simm << 2);   // if the register contents are different, jump to the immediate offset address
                                        // relative to the current value of pc
                 stats.flush(2);
                 stats.countTaken();
               }
               stats.countBranch();
               break;
    case 0x08: D(cout << "addi " << regNames[rt] << ", " << regNames[rs] << ", " << dec << simm);
               writeDest=true; // indicates that the alu result must be saved
               aluOp = ADD; // set the ADD operation on the ALU
               destReg=rt;  // set destination register as rt
               stats.registerDest (destReg);
               stats.registerSrc (rs);
               aluSrc1=regFile[rs];  // set first operand on the alu to rs
               aluSrc2=simm;  // set second operand on the alu to zero extended immediate
               break;
    case 0x09: D(cout << "addiu " << regNames[rt] << ", " << regNames[rs] << ", " << dec << simm);
               writeDest=true; // indicates that the alu result must be saved
               aluOp = ADD; // set the ADD operation on the ALU
               destReg=rt;  // set destination register as rt
               stats.registerDest (destReg);
               stats.registerSrc (rs);
               aluSrc1=regFile[rs];  // set first operand on the alu to rs
               aluSrc2=simm;  // set second operand on the alu to zero extended immediate
               break;
    case 0x0c: D(cout << "andi " << regNames[rt] << ", " << regNames[rs] << ", " << dec << uimm);
               writeDest=true; // indicates that the alu result must be saved
               aluOp = AND; // set the AND operation on the ALU
               destReg=rt;  // set destination register as rd
               stats.registerDest (destReg);
               stats.registerSrc (rs);
               aluSrc1=regFile[rs];  // set first operand on the alu to rs
               aluSrc2=uimm;  // set second operand on the alu to zero extended immediate
               break;
    case 0x0f: D(cout << "lui " << regNames[rt] << ", " << dec << simm);
               writeDest=true; // indicates that the alu result must be saved
               aluOp = SHF_L; // set the shift left operation on the ALU
               destReg=rt;  // set destination register as rd
               stats.registerDest (destReg);
               aluSrc1=simm;  // set first operand on the alu to simm
               aluSrc2=16;  // set second operand to 16 in order to shift the immediate value 16 times left
               break;
    case 0x1a: D(cout << "trap " << hex << addr);
               switch(addr & 0xf) {
                 case 0x0: 
                           cout << endl; 
                           break;
                 case 0x1: 
                           cout << " " << (signed)regFile[rs];
                           stats.registerSrc (rs);
                           break;
                 case 0x5: cout << endl << "? "; cin >> regFile[rt];
                           stats.registerDest(rt);
                           break;
                 case 0xa: stop = true; break;
                 default: cerr << "unimplemented trap: pc = 0x" << hex << pc - 4 << endl;
                          stop = true;
               }
               break;
    case 0x23: D(cout << "lw " << regNames[rt] << ", " << dec << simm << "(" << regNames[rs] << ")");
               writeDest=true; // indicates that the alu result must be saved
               opIsLoad=true; // it's a load instruction so we set the flag to true
               aluOp = ADD; // set the ADD operation on the ALU to calculate the address
               destReg=rt;  // set destination register as rt
               stats.registerDest (destReg);
               stats.registerSrc (rs);
               aluSrc1=regFile[rs];  // set first operand on the alu to rs
               aluSrc2=simm;  // set second operand on the alu to sign extended immediate
               stats.countMemOp();
               break;
    case 0x2b: D(cout << "sw " << regNames[rt] << ", " << dec << simm << "(" << regNames[rs] << ")");
               writeDest=false; // indicates that the alu result should not be saved
               opIsStore=true; // it's a store instruction so we set the flag to true
               aluOp = ADD; // set the ADD operation on the ALU to calculate the address
               aluSrc1=regFile[rs];  // set first operand on the alu to rs
               aluSrc2=simm;  // set second operand on the alu to sign extended immediate
               stats.registerSrc (rs);
               stats.registerSrc (rt);
               storeData = regFile[rt]; // data to store on memory will be the value in the register rt
               stats.countMemOp();
               break;
    default: cerr << "unimplemented instruction: pc = 0x" << hex << pc - 4 << endl;
               destReg=rt;  // set destination register as rd
               break;
  }
  D(cout << endl);
}

void CPU::execute() {
  aluOut = alu.op(aluOp, aluSrc1, aluSrc2);
}

void CPU::mem() {
  if(opIsLoad)
    writeData = dMem.loadWord(aluOut);
  else
    writeData = aluOut;

  if(opIsStore)
    dMem.storeWord(storeData, aluOut);
}

void CPU::writeback() {
  if(writeDest && destReg > 0) // never write to reg 0
    regFile[destReg] = writeData;

  if(opIsMultDiv) {
    hi = alu.getUpper();
    lo = alu.getLower();
  }
}

void CPU::printRegFile() {
  cout << hex;
  for(int i = 0; i < NREGS; i++) {
    cout << "    " << regNames[i];
    if(i > 0) cout << "  ";
    cout << ": " << setfill('0') << setw(8) << regFile[i];
    if( i == (NREGS - 1) || (i + 1) % 4 == 0 )
      cout << endl;
  }
  cout << "    hi   : " << setfill('0') << setw(8) << hi;
  cout << "    lo   : " << setfill('0') << setw(8) << lo;
  cout << dec << endl;
}

void CPU::printFinalStats() {
  cout << "Program finished at pc = 0x" << hex << pc << "  ("
       << dec << instructions << " instructions executed)" << endl;
  cout << endl;
  cout << "Cycles: "<< stats.getCycles()<<endl;
  cout << "CPI: " << fixed << setprecision(2) << (stats.getCycles()/static_cast<double>(instructions)) << endl;
  cout << endl;
  cout << "Bubbles: " << stats.getBubbles() << endl;
  cout << "Flushes: " << stats.getFlushes() << endl;
  cout << endl;
  cout << "Mem ops: "<< fixed << setprecision(1) << 
           100.0 *  stats.getMemOps()/instructions << "%" << " of instructions"<< endl;
  cout << "Branches: "<< fixed << setprecision(1) << 
           100.0 *  stats.getBranches()/instructions << "%" << " of instructions"<< endl;
  cout << " %" << " Taken: " << fixed << setprecision(1) << 
           100.0 *  stats.getTaken()/stats.getBranches() << endl;
}
