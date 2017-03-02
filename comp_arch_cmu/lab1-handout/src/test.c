#include <stdio.h>
#include<inttypes.h>

int main () {
    uint32_t opcode = 0xFFFFFFF1;
    int temp = 1;
    if ((int32_t)opcode > temp)
    printf ("opcode: %u\n", opcode);
    int imm, sign_imm;
    imm = opcode & 0xFFFF;
    sign_imm = (((imm & 0x8000)>>15) == 1) ? imm | 0xFFFF0000: imm;
    printf ("opcode is %x\n", opcode);
    printf ("imm is %x\n", (imm&0x8000)>>15);
    printf ("signimm is %x\n", sign_imm);
}
