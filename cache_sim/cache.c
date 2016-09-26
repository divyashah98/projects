#include<stdio.h>
#include<math.h>
#include<stdlib.h>
#include<string.h>
#include<inttypes.h>
//Use address space
//as a define
#define ADDRESS_BITS 64

//Declare the global variables
struct cache_bits {
  int tag_bits;
  int index_bits;
  int offset_bits;
} cache_bits_size;
uint64_t address;
int size;
//construct the cache RAMs
//RAMs are modeled as arrays
//Depending on the cache replace-
//-ment policy LRU RAM would be added
struct cache_rams_struct {
  //Ideally, to save space should have used a
  //bool instead of an int
  uint64_t tag_ram[63][2047];
  //Each cache block/line would be B bytes
  //wide. Data RAM is byte addressable
  int data_ram[63][2047][999];
  //Valid bit RAM
  //1-bit for every set in every way
  int valid_ram[63][2047];
  //LRU RAM
  //log(ways) bits for every block
  //in every set
  //Note:LRU RAM is also used when
  //FIFO replacement policy is selected
  int lru_ram[15][2047];
} cache_rams;

//Function to calculate the log to the base 2
//of a given number
int num_bits (int num) {
  int count = 0;
  while (num) {
    num = num>>1;
    count++;
  }
  return count;
}

//Function to initialize RAMs
void init_rams (int A, int S) {
  int i, j;
  for (i = 0; i < A; i++) {
    for (j = 0; j < (S/A); j++) {
      cache_rams.valid_ram[i][j] = 0;
      cache_rams.lru_ram[i][j] = i;
    }
  }
}

//Cache Look up Function
//Will lookup the tag ram and
//will report a hit if the tag bits
//of the address match in the tag ram
int cache_lookup (uint64_t address, int A, int index) {
  int i;
  int lookup = 0;
  address = address >> (cache_bits_size.offset_bits + cache_bits_size.index_bits);
  for (i = 0; i < A; i++) {
    if ((address == cache_rams.tag_ram[i][index]) && (cache_rams.valid_ram[i][index])) {
      lookup = 1;
      return lookup;
    }
  }
  return lookup;
}

//Function to determine if the particular set
//in the cache is  full
int is_cache_full (int A, int index) {
  int i;
  for (i = 0; i < A; i++) {
    if (cache_rams.valid_ram[i][index] != 1) {
      //if the valid bit isn't set for any of the way
      //in that particular set, then that particular
      //set in the cache isn't full
      return 0;
    }
  }
  return 1;
}

//Function to update the LRU bits of 
//every set and way on a cache hit.
//We wouldn't need a FIFO update on a
//cache hit as FIFO doesn't depend on
//the time of access but only depends
//on the time of entry into the cache
void update_LRU (uint64_t address, int A, int index) {
  int i;
  int lru_ram_prev;
  address = address >> cache_bits_size.tag_bits;
  for (i = 0; i < A; i++) {
    if ((address == cache_rams.tag_ram[i][index]) && (cache_rams.valid_ram[i][index] == 1)) {
      lru_ram_prev = cache_rams.lru_ram[i][index];
      cache_rams.lru_ram[i][index] = 0;  //0 -> MRU
      break;
    }
  }
  for (i = 0; i < A; i++) {
    if (cache_rams.lru_ram[i][index] < lru_ram_prev) {
      cache_rams.lru_ram[i][index]++;
    }
  }
}

//Function to update the LRU/FIFO bits
//and update the cache entry on a cache
//miss when the cache isn't full i.e
//there is no eviction
void add_LRU (uint64_t address, int A, int index) {
  int i, rand_way;
  WAY_FULL: rand_way = rand() % A;
  //check if that way contains a valid data
  if (cache_rams.valid_ram[rand_way][index] == 1) {
    goto WAY_FULL;
  }
  else {
    //We are good to go. Set the valid bit 
    //and update lru bits of the valid
    //ways in that set
    cache_rams.valid_ram[rand_way][index] = 1;
    cache_rams.tag_ram[rand_way][index] = address >> cache_bits_size.tag_bits;
    cache_rams.lru_ram[rand_way][index] = 0;
    for (i = 0; i < A; i++) {
      if (cache_rams.valid_ram[i][index] == 1) {
        cache_rams.lru_ram[i][index]++;
      }
    }
  }
}
//Function to update the LRU/FIFO bits
//and update the cache entry on a cache
//miss when the cache is full and we need
//to evict an entry
void remove_LRU (uint64_t address, int A, int index) {
  int i;
  for (i = 0; i < A; i++) {
    if (cache_rams.lru_ram[i][index] == (A - 1)) {
      cache_rams.lru_ram[i][index] = 0;
      //No need to set the valid bit as it is 
      //already set since the cache set has
      //all valid entries 
    }
    else {
      cache_rams.lru_ram[i][index]++;
      cache_rams.tag_ram[i][index] = address >> cache_bits_size.tag_bits;
    }
  }
}
/*Note that the above two functions can effectively be used for
 * FIFO policy as well. The only thing we need to keep in
 * mind when FIFO replacement policy is used that higher
 * lru_ram value represents the earlier entry therefore
 * lru_ram value of A - 1 would represent the first entry. */

//Main function
int main (int argc, char* argv[]) {
  int S; //number of sets in the cache
  int A; //the associativity (entries in a set)
  int B; //block size in bytes
  int R; //replacement policy 1 -> LRU, 2 -> FIFO
  int W; //Write policy (=1)
  int verbosity = 0; //Set only if -v option is used
  FILE* trace;
  
  int i = 1;
  //Parse argv array and extract all the information
  //argv array is null terminated
  while (argv[i]) {
    if (!(strcmp (argv[i], (char*)"-S"))) {
      S = atoi(argv[i+1]);
    }
    else if (!(strcmp (argv[i], (char*)"-A"))) {
      A = atoi(argv[i+1]);
    }
    else if (!(strcmp (argv[i], (char*)"-B"))) {
      B = atoi(argv[i+1]);
    }
    else if (!(strcmp (argv[i], (char*)"-R"))) {
      R = atoi(argv[i+1]);
    }
    else if (!(strcmp (argv[i], (char*)"-W"))) {
      W = atoi(argv[i+1]);
    }
    else if (!(strcmp (argv[i], (char*)"-v"))) {
      verbosity = 1;
    }
    else if (!(strcmp (argv[i], (char*)"-t"))) {
      trace = fopen (argv[i+1], "r");
    }
    i++;
  }
  //Calculate the cache size in KB
  int cache_size = 0;
  //cache_size = (number_of_sets * block_size)/1024 KB
  cache_size = (S * B);
  cache_size = (cache_size > 1024) ? cache_size / 1024: cache_size;
  printf ("Cache Size:%dKB ", cache_size);
  //check the associativity of the cache
  if (A == 1) { //Direct Mapped Cache
    printf ("Cache Type: Direct Mapped\n");
  }
  else {
    printf ("%d-way Set associative\n",A);
  }
  //Construct the cache size
  //Cache size is the bits required
  //for tag, index and offset fields
  int lru_or_fifo_bits = 0;
  int index_mask = 1;
  int iter;
  int lookup = 0;
  int cache_hit = 0;
  int cache_miss = 0;
  int cache_evict = 0;
  int evict = 0;
  char valid;
  //number of bits in offset is equal
  //to the bits required to map the size 
  //of a cache block/line
  cache_bits_size.offset_bits = num_bits(B);
  //number of bits in index is equal
  //to the bits required to map the number
  //of sets in the cache
  cache_bits_size.index_bits  = num_bits((int)S/A);
  //Finally the number of bits in the tag
  //can be calculated by subtracting the bits used
  //yet from the number of bits in the address
  cache_bits_size.tag_bits = ADDRESS_BITS - (cache_bits_size.offset_bits + cache_bits_size.index_bits);
  //Calculate the LRU/FIFO bits required if the
  //value of R is 1 or 2
  lru_or_fifo_bits = num_bits((A));
  for(iter = 0; iter < cache_bits_size.index_bits; iter++) {
    index_mask = index_mask<<1;
  }
  index_mask = index_mask - 1;
  //now the cache is designed, check if -v (verbosity)
  //option is used. If set then print the cache here
  if (verbosity) {
    int iter;
    for (iter = 0; iter < ADDRESS_BITS+13; iter++) {
      printf("-");
    }
    printf("\n");
    for(iter = 0; iter < cache_bits_size.tag_bits; iter++) {
      if (iter == (int)(cache_bits_size.tag_bits/2 - 1)) {
        printf("Tag");
      }
      else {
        printf("-");
      }
    }
    printf("|");
    for(iter = 0; iter < cache_bits_size.index_bits; iter++) {
      if (iter == (int)(cache_bits_size.index_bits/2 - 1)) {
        printf("Index");
      }
      else {
        printf("-");
      }
    }
    printf("|");
    for(iter = 0; iter < cache_bits_size.offset_bits; iter++) {
      if (iter == (int)(cache_bits_size.offset_bits/2 - 1)) {
        printf("Offset");
      }
      else {
        printf("-");
      }
    }
    printf("\n");
    for (iter = 0; iter < ADDRESS_BITS+13; iter++) {
      printf("-");
    }
    printf("\n");
  }
  int instr_count;
  //parse the trace file (if -t is used)
  //and populate the cache accordingly
  if (trace) {
    //First line would be the instruction load
    //followed by the memory operation of 
    //the instruction performed
    //M - Read modify write
    //L - Rad
    //S - Write
    fscanf(trace,"%c %llx,%d",&valid, &address, &size);
    while (!feof(trace)) {
      if (valid == 'I') {
        instr_count++;
      }
      else if (valid == 'M' || valid == 'L' || valid == 'S') {
        lookup = cache_lookup(address, A, (address>>cache_bits_size.offset_bits)&index_mask);
        if (lookup == 1) {
          cache_hit++;
          if (R == 1 || R == 2) {
            update_LRU(address, A, (address>>cache_bits_size.offset_bits) & index_mask);
          }
        }
        else {
          cache_miss++;
          evict = is_cache_full(A, (address>>cache_bits_size.offset_bits)&index_mask);
          if (evict) {
            cache_evict++;
            if (R == 1 || R == 2) {
              remove_LRU(address, A, (address>>cache_bits_size.offset_bits)&index_mask);
            }
          }
          else {
            if (R == 1 || R == 2) {
              add_LRU(address, A, (address>>cache_bits_size.offset_bits)&index_mask);
            }
          }
        }
      }
      fscanf(trace,"%c %llx,%d",&valid, &address, &size);
    }
    fclose(trace);
  }
  printf("Hits:%d\t\tMisses:%d\tEvictions:%d\n", cache_hit, cache_miss, cache_evict);
}
