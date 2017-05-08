#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//
// Very simple microcode assembler for 159233
// Martin Johnson - August 2003
//

// table of possible outputs
typedef struct _symbol {
    const char *name;
    int v;
} symbol;

// names for bits in a microinstruction
symbol symbol_table[]={
    {"oepc",0<<9},{"oemem",1<<9},{"oeacc",2<<9},{"oeconst",3<<9},
    {"irnext",1<<8},{"eqz",1<<7},{"incpc",1<<6},{"ldmar",1<<3},
    {"ldacc",3<<3},{"ldabr",5<<3},{"ldpc",6<<3},{"ldir",7<<3},
    {"write",1<<2},{"carry",1<<1},{"sub",1}
};

int main(int argc, char *argv[]) {
    FILE *f=NULL,*lgf_in,*lgf_out;
    char word[256];
    int code[32];
    int i,n=-1,w=0,next;
    int error=0;

    // number of symbols
    int nsymb=sizeof(symbol_table)/sizeof(symbol);

    if(argc==2)
        f=fopen(argv[1],"r");
    if(argc==1) // default file to open
        f=fopen("picoucode","r");
    if(!f) {
        puts("input file not found");
        exit(1);
    }
    for(i=0;i<32;i++) // clear microcode memory
        code[i]=0;
    while(!feof(f)) {
        fscanf(f," %s",word); // read in next word
        if(word[0]=='/') { // comment
            while(!feof(f) && fgetc(f)!='\n'); // skip rest of line
        } else {
            if(word[strlen(word)-1]==':') { // start of instruction
                sscanf(word,"%d:",&n); // get instruction number
                if(n>31 || n<0) {
                    printf("Bad instruction number: %d\n",n);
                    error=1;
                }
                w=0; // initialise instruction to zero
            } else {
                if(word[0]==':') { // next instruction to execute
                    sscanf(word,":%d ",&next);
                    if(next>31 || next<0) {
                        printf("Bad instruction number: %d\n",next);		
                        error=1;
                    }						
                    w=w|(next<<11);
                } else {
                    for(i=0;i<nsymb; i++) { // is it a symbol?
                        if(!strcmp(symbol_table[i].name,word)) {
                            w=w|symbol_table[i].v;
                            break;
                        }
                    }
                    if(i==nsymb) {// if not, then error
                        printf("syntax error: %s\n",word);
                        error=1;
                    }
                }
            }
        }
        code[n]=w; // put the instruction in memory
    }
     
    lgf_in=fopen("superpico2016.lgf","r");
    if(!lgf_in) {
        puts("superpico lgf file not found");
        exit(1);
    }
    lgf_out=fopen("superpico_run.lgf","wb"); // for writing
    if(!lgf_in) {
        puts("can't open output file");
        exit(1);
    }
    char line[512];
    do {
        fgets(line,512,lgf_in);     // go through lgf file
        fputs(line,lgf_out);
    } while (strncmp(line,"I31",3)); // find start of first microcode ROM
    for(i=0;i<32;i++) 
        fprintf(lgf_out,"%d\n",(code[i]&0xff)); // replace it
    do {
        fgets(line,512,lgf_in);
    } while(line[0]>31);
    fprintf(lgf_out,"\n");
    do {
        fgets(line,512,lgf_in);
        fputs(line,lgf_out);
    } while (strncmp(line,"I31",3)); // find start of second microcode ROM
    for(i=0;i<32;i++) 
        fprintf(lgf_out,"%d\n", (code[i]&0xff00)>>8); // replace it
    do {
        fgets(line,512,lgf_in);
    } while(line[0]>31);
    fprintf(lgf_out,"\n");
    while (!feof(lgf_in)) {     // write out the rest og the lgf file
        fgets(line,512,lgf_in);
        if(!feof(lgf_in))
            fputs(line,lgf_out);
    }
    fclose(lgf_out);
    puts("Microcode assembly completed");
    if(error) 
        puts("Error found");
    else
        system("log.exe superpico_run.lgf"); // run log using new lgf file
}
