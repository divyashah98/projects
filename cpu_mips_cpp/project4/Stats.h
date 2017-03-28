#ifndef __STATS_H
#define __STATS_H
#include <iostream>
#include "Debug.h"
using namespace std;

enum PIPESTAGE { IF1 = 0, IF2 = 1, ID = 2, EXE1 = 3, EXE2 = 4, MEM1 = 5, 
                 MEM2 = 6, WB = 7, PIPESTAGES = 8 };

enum HAZARDS { EX1 = 0, EX2, M1, M2 };

struct Hazard {
  int stage[4] = {0};
  int count = 0;
};

class Stats {
  private:
    long long cycles;
    int flushes;
    int bubbles;

    int memops;
    int branches;
    int taken;

    int resultReg[PIPESTAGES];
    // Structure to maintain register readiness
    int ready[PIPESTAGES];
    Hazard rawHz;

  public:
    Stats();

    void clock(PIPESTAGE stage);

    void flush(int count);

    // Added new parameters to function
    // needed - This is for source registers. Indicates the stage
    //          by which the source reg is needed. Should be EXE1
    void registerSrc(int rs, PIPESTAGE needed = EXE1);
    // Added new parameters to function
    // avail - This is used for destination registers. This gives
    //         the stage at which data can be forwarded by.
    void registerDest(int r, PIPESTAGE avail = MEM1);

    void countMemOp() { memops++; }
    void countBranch() { branches++; }
    void countTaken() { taken++; }
    void countHazard (int stage) { rawHz.stage[stage]++; }

    // getters
    long long getCycles() { return cycles; }
    int getFlushes() { return flushes; }
    int getBubbles() { return bubbles; }
    int getMemOps() { return memops; }
    int getBranches() { return branches; }
    int getTaken() { return taken; }
    int getHazard (int stage) { return rawHz.stage[stage]; }
    int getTotHazards ();

  private:
    void bubble();
};

#endif
