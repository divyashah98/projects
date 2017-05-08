/******************************
 * Your Name Goes Here
 * CS 3339 - Semester Goes Here
 ******************************/
#include "Stats.h"

Stats::Stats() {
  cycles = PIPESTAGES - 1; // pipeline startup cost
  flushes = 0;
  bubbles = 0;
  stalls = 0;

  memops = 0;
  branches = 0;
  taken = 0;

  for(int i = IF1; i < PIPESTAGES; i++) {
    resultReg[i] = -1;
    ready[i] = -1;
  }
}

void Stats::clock(PIPESTAGE stage) {
  cycles++;

  // run all pipeline flops
  for(int i = WB; i > stage; i--) {
    resultReg[i] = resultReg[i-1];
    ready[i] = ready[i-1];
  }
  // inject no-op into IF1
  resultReg[stage] = -1;
}

void Stats::registerSrc(int rs, PIPESTAGE needed) {
  if (rs == 0)
  return;
  // Variable to maintain the count of
  // bubbles to insert in the pipe
  for(int i = EXE1; i < WB; i++) {
    // Check if any of the current reg
    // matches dest reg of the instr in flight
    if (((resultReg[i] == rs))
    ) {
      // Needed by default is set to EXE1
      int neededAt = needed - ID;
      // Forwarded data should be ready by MEM1
      int readyAt = ready[i] - i;
      // the number of bubbles would be equal
      // to the value of neededAt - readyAt for
      // the current pipe stage
      int bubbles_to_insert = readyAt - neededAt;
      countHazard (i-3);
      while (bubbles_to_insert>0) {
        bubble();
        bubbles_to_insert--;
      }
      break;
    }
  }
}

void Stats::registerDest(int r, PIPESTAGE avail) {
  resultReg[ID] = r;
  ready[ID] = avail;
}

void Stats::stall(int latency) {
   for(int i = 0; i < latency; ++i) {
     // clock till the WB stage
     clock(WB);
     // Increment the stall counts
     stalls++;
   }
}

void Stats::flush(int count) { // count == how many ops to flush
  for (int i = 0; i < count; i++) {
    flushes++;
    // Need to clock till IF1 stage
    clock(IF1);
  }
}

void Stats::bubble() {
  bubbles++;
  // Clock from EXE1 stage
  // since the bubbles are resolved
  // in the ID stage only
  clock (EXE1);
}

int Stats::getTotHazards () {
  rawHz.count = 0;
  for (int i =0; i < 4; i++) {
    rawHz.count += rawHz.stage[i];
  }
  return rawHz.count;
}
