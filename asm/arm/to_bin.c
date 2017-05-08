#include <stdio.h> 
extern long int toBin(int); 
int main() { 
    long int b; // Binary Number 
    long int d; // Decimal Number 
    printf("Enter any decimal number:\n"); 
    scanf("%ld",&d); 
    b = toBin(d); 
    printf("Binary value is: %ld", b); 
    return 0; 
}
