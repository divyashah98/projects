#include<iostream>
#include<iomanip>
#include<cstdlib>
#include<cstring>
using namespace std;

struct No {
  int decimal;
  char *binary;
  char *octal;
  char *hexadecimal;
};

char mapping (int);
void initialize (char *, int);
void constructArray (No *, int);
void processArray (No *, int);
void printArray (No*, int);
void convert (char*, int, int, int);
void garbageCollection (No *, int);

int main () {
  int size = rand () % 10 + 1;
  struct No *num_struct = (struct No*) malloc (size*sizeof(struct No));

  constructArray (num_struct, size);
  printArray (num_struct, size);
  processArray (num_struct, size);
  garbageCollection(num_struct, size);

  return 0;
}

char mapping (int num) {
  switch (num) {
    case  0 :  return '0';
    case  1 :  return '1';
    case  2 :  return '2';
    case  3 :  return '3';
    case  4 :  return '4';
    case  5 :  return '5';
    case  6 :  return '6';
    case  7 :  return '7';
    case  8 :  return '8';
    case  9 :  return '9';
    case  10:  return 'a';
    case  11:  return 'b';
    case  12:  return 'c';
    case  13:  return 'd';
    case  14:  return 'e';
    case  15:  return 'f';
  }
}

void convertBinary(char *num_arr, int num, int bit_size) {
  char *current = num_arr;
  while (*current!= '\0')
    current++;
  current--;
  while (bit_size > 0) {
    int bit = num % 2;
    num = num/2;
    *current = mapping(bit);
    current--;
    bit_size--;
  }
}

void convertOctal(char *num_arr, int num, int bit_size) {
  char *current = num_arr;
  while (*current!= '\0')
    current++;
  current--;
  while (bit_size > 0) {
    int digit = num % 8;
    num = num / 8;
    *current = mapping(digit);
    *current--;
    bit_size--;
  }
}

void convertHexadecimal(char *num_arr, int num, int bit_size) {
  char *current = num_arr;
  while (*current!= '\0')
    current++;
  current--;
  while (bit_size > 0) {
    int digit = num % 16;
    num = num / 16;
    *current = mapping(digit);
    *current--;
    bit_size--;
  }
}

void initialize (char *num_arr, int bit_size) {
  char *current = num_arr;
  while (bit_size > 0) {
    *current++ = '0';
    bit_size--;
  }
  *current = '\0';
}

void constructArray (No *num_struct, int size) {
  struct No *current = num_struct;
  while (size >= 0) {
    current->decimal       = rand () % 0xFFFFFF;
    current->binary = (char *)"0";
    current->octal = (char *)"0";
    current->hexadecimal = (char *)"0";
    size--;
    current++;
  }
}

int noOfBits (int number) {
  int bit_count = 0;
  while (number > 0) {
    bit_count++;
    number = number/2;
  } 
  return bit_count;
}

void processArray (No *num_struct, int size) {
  struct No *current = num_struct;
  char dump_arr[100];
  char *num_arr = dump_arr;
  cout <<"\nDecimal\t\tBinary\t\t\t\t\tOctal\t\t\tHexadecimal\n";
  while (size >= 0) {
    cout <<setfill('0') << setw(8) << current->decimal<<"\t";
    int bit_size = noOfBits(current->decimal);
    convert(num_arr, current->decimal, 0, noOfBits(current->decimal));
    current->binary = num_arr;
    cout<<setfill('0') << setw(24) << current->binary <<"\t\t";
    convert(num_arr, current->decimal, 1, noOfBits(current->decimal));
    current->octal = num_arr;
    cout<<setfill('0') << setw(8) << current->octal<<"\t\t";
    convert(num_arr, current->decimal, 2, noOfBits(current->decimal));
    current->hexadecimal = num_arr;
    cout<<setfill('0') << setw(6) << current->hexadecimal<<"\t\t"<<endl;
    size--;
    current++;
  }
}

void printArray (No *num_struct, int size) {
  struct No *current= num_struct;
  cout <<"Decimal\t\tBinary\t\t\t\t\tOctal\t\t\tHexadecimal\n";
  while (size >= 0) {
    cout <<setfill('0') << setw(8) << current->decimal<<"\t"<<setfill('0') << setw(24) << current->binary <<"\t\t"<< setw(8) << current->octal <<"\t\t"<< setw(6) <<current->hexadecimal<<endl;
    size--;
    current++;
  }
}

void convert (char *num_arr, int num, int base, int bit_size) {
  switch (base) {
    case 0:
                initialize(num_arr, bit_size); 
                convertBinary(num_arr, num, bit_size);
                break;

    case 1:   
                if (bit_size < 3)
                  bit_size = 1;
                else if ((bit_size % 3))
                  bit_size = (bit_size/3) + 1;
                else
                  bit_size = bit_size/3;
                initialize(num_arr, bit_size); 
                convertOctal(num_arr, num, bit_size);
                break;

    case 2:   
                if (bit_size < 4)
                  bit_size = 1;
                else if ((bit_size % 4))
                  bit_size = (bit_size/4) + 1;
                else
                  bit_size = bit_size/4;
                initialize(num_arr, bit_size); 
                convertHexadecimal(num_arr, num, bit_size);
                break;
  }
}

void garbageCollection (No *num_struct, int size) {
  cout<<"\nGarbage Collection"<<endl;
  cout <<"Decimal\t\tBinary\t\tOctal\t\tHexadecimal\n";
  struct No *head = num_struct;
  while (size >= 0) {
    cout <<setfill('0') << setw(8) << num_struct->decimal<<"\t"<<"Deleted\t\tDeleted\t\tDeleted"<<endl;
    head = NULL;
    free(head);
    size--;
    head++;
  }
  num_struct = head;
}
