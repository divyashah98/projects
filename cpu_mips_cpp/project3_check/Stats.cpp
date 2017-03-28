/******************************
 * Your Name Goes Here
 * CS 3339 - Semester Goes Here
 ******************************/
#include "Stats.h"

Stats::Stats() {
  cycles = PIPESTAGES - 1; // pipeline startup cost
  flushes = 0;
  bubbles = 0;

  memops = 0;
  branches = 0;
  taken = 0;

  for(int i = IF1; i < PIPESTAGES; i++) {
    resultReg[i] = -1;
  }
}

void Stats::clock(PIPESTAGE stage) {
  cycles++;

  // run all pipeline flops
  for(int i = WB; i > stage; i--) {
    resultReg[i] = resultReg[i-1];
  }
  // inject no-op into IF1
  resultReg[stage] = -1;
}

void Stats::registerSrc(int rs) {
  // Variable to maintain the count of
  // bubbles to insert in the pipe
  int bubbles_to_insert;
  for(int i = EXE1; i < WB; i++) {
    // Check if any of the current reg
    // matches dest reg of the instr in flight
    if (((resultReg[i] == rs) && (rs != 0))
    ) {
      // the number of bubbles would be equal
      // to the value of WB - i where i gives
      // us the current pipe stage
      bubbles_to_insert = WB - i;
      while (bubbles_to_insert>0) {
        bubble();
        bubbles_to_insert--;
      }
      break;
    }
  }
}

void Stats::registerDest(int r) {
  resultReg[ID] = r;
}

void Stats::flush(int count) { // count == how many ops to flush
  for (int i = 0; i < count; i++) {
    flushes++;
    // Need to clock till IF1 stage
    clock(IF1);
  }
}

void Stats::bubble() {
  ++bubbles;
  // Clock from EXE1 stage
  // since the bubbles are resolved
  // in the ID stage only
  clock (EXE1);
}
