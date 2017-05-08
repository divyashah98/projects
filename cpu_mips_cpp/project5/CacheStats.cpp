#include <iostream>
#include <cstdlib>
#include <iomanip>
#include "CacheStats.h"
using namespace std;

CacheStats::CacheStats() {
  cout << "Cache Config: ";
  if(!CACHE_EN) {
    cout << "cache disabled" << endl;
  } else {
    cout << (SETS * WAYS * BLOCKSIZE) << " B (";
    cout << BLOCKSIZE << " bytes/block, " << SETS << " sets, " << WAYS << " ways)" << endl;
    cout << "  Latencies: Lookup = " << LOOKUP_LATENCY << " cycles, ";
    cout << "Read = " << READ_LATENCY << " cycles, ";
    cout << "Write = " << WRITE_LATENCY << " cycles" << endl;
  }

  loads = 0;
  stores = 0;
  load_misses = 0;
  store_misses = 0;
  writebacks = 0;

  /* TODO: your code here */
  // Initialise the RAMs to the
  // default value
  for(int i = 0; i < SETS; i++) {
    for (int j = 0; j < WAYS; j++) {
       cacheArray[i][j].valid = false;
       cacheArray[i][j].dirty = false;   
       cacheArray[i][j].tag = 0;
    }
  }
  // Initialise the roundRobin RAM
  // to its default value
  for(int k = 0; k < SETS; k++) {
     roundRobin[k] = 0;
  }
}

int CacheStats::access(uint32_t addr, ACCESS_TYPE type) {
  if(!CACHE_EN) { // no cache
    return (type == LOAD) ? READ_LATENCY : WRITE_LATENCY;
  }

  /* TODO: your code here */
  // Define all the variables here
  int latency = 0;
  int addrTag = (addr) / (BLOCKSIZE * SETS);
  int index   = ((addr) / BLOCKSIZE) % (SETS);
  int rrIndex = roundRobin[index];
  
  // Start with the read transaction
  // i.e a memory load transaction
  if (type == LOAD) {
     loads++;
     latency += LOOKUP_LATENCY;
     // See if we had a hit
     for (int i = 0; i < WAYS; ++i)
     {
       if ((cacheArray[index][i].valid == true) && 
           (cacheArray[index][i].tag == addrTag)) {
        return latency;
       }
     }
     // The load didn't hit in the cache
     // MISS Latency
     latency += READ_LATENCY;
     load_misses++;

     // Writeback the dirty data from the Cache
     if(cacheArray[index][rrIndex].dirty == true) 
     {
       latency += WRITE_LATENCY;
       writebacks++;
     }

    // Update all the RAMs here
    cacheArray[index][rrIndex].tag   = addrTag;
    cacheArray[index][rrIndex].dirty = false;
    cacheArray[index][rrIndex].valid = true;
    roundRobin[index] = (roundRobin[index] + 1) % WAYS;

    return latency;
  }

  // Start with the write transaction
  // i.e a memory store transaction
  if(type == STORE) {
    // Lookup
    stores++;
    
    // See if we had a hit
    latency += LOOKUP_LATENCY;
    for (int i = 0; i < WAYS; ++i)
    {
      if(cacheArray[index][i].valid == true && cacheArray[index][i].tag == addrTag)
        {
          cacheArray[index][i].dirty = true; // set dirty bit
          return latency;
        }
    }

    // The store didn't hit in the cache
    // MISS Latency
    store_misses++;
    latency += READ_LATENCY;

    // Writeback the dirty data from the Cache
    if(cacheArray[index][rrIndex].dirty == true)
    {
      latency += WRITE_LATENCY;
      writebacks++;
    }
    
    // Update all the RAMs here
    cacheArray[index][rrIndex].tag   = addrTag;  
    cacheArray[index][rrIndex].dirty = true; 
    cacheArray[index][rrIndex].valid = true;
    roundRobin[index] = (roundRobin[index] + 1) % WAYS; 

    return latency;
   }
}

void CacheStats::printFinalStats() {
  /* TODO: your code here (don't forget to drain the cache of writebacks) */

  int accesses = loads + stores;
  int misses = load_misses + store_misses;

  for (int i = 0; i < SETS; i++) {
    for(int j = 0; j < WAYS; j++) {
      // Calculate the writebacks here
      if(cacheArray[i][j].dirty == true) {
        writebacks++;
		  } 
    }
  }
   
  cout << "Accesses: " << accesses << endl;
  cout << "  Loads: " << loads << endl;
  cout << "  Stores: " << stores << endl;
  cout << "Misses: " << misses << endl;
  cout << "  Load misses: " << load_misses << endl;
  cout << "  Store misses: " << store_misses << endl;
  cout << "Writebacks: " << writebacks << endl;
  cout << "Hit Ratio: " << fixed << setprecision(1) << 100.0 * (accesses - misses) / accesses;
  cout << "%" << endl;
}
