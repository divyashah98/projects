#include <iostream>
#include <string>
using namespace std;

char p1, p2;
string check;
int p1Score = 0;
int p2Score = 0;

void displayScore() {
    cout << "Player 1: " <<p1Score << endl;
    cout << "Player 2: " <<p2Score <<endl << endl;
}

int main() {
   
    
    do {
        cout << "Player 1: Please enter either (R)ock, (P)aper, or (S)cissors: " << endl;
        cin >> p1;
        cout << "Player 2: Please enter either (R)ock, (P)aper, or (S)cissors: " << endl;
        cin >> p2;
        
        if(p1 == p2)
            cout << "Draw" << endl;
        if( (p1 == 'P' && p2 == 'p') || (p1 == 'p' && p2 == 'P') )
            cout << "Draw" << endl;
        if( (p1 == 'S' && p2 == 's') || (p1 == 'S' && p2 == 's') )
            cout << "Draw" << endl;
        if( (p1 == 'R' && p2 == 'r') || (p1 == 'R' && p2 == 'r') )
            cout << "Draw" << endl;
        
        if((p1 == 'S' || p1 == 's') && (p2 == 'R' || p2 == 'r')) {
            cout << "Rock breaks scissors, Player 2 win"<<endl; p2Score=p2Score+1;
        }
        if((p1 == 'R' || p1 == 'r') && (p2 == 'P' || p2 == 'p')) {
            cout << "Paper covers rock, Player 2 win"<<endl; p2Score=p2Score+1;
        }
        if((p1 == 'P' || p1 == 'p') && (p2 == 'R' || p2 == 'r')) {
            cout << "Paper covers rock, Player 1 win"<<endl; p1Score=p1Score+1;
        }
        if((p1 == 'P' || p1 == 'p') && (p2 == 'S' || p2 == 's')) {
            cout << "Scissors cut paper, Player 2 win"<<endl; p2Score=p2Score+1;
        }
        if((p1 == 'R' || p1 == 'r') && (p2 == 'S' || p2 == 's')) {
            cout << "Rock breaks scissors, Player 1 win"<<endl; p1Score=p1Score+1;
        }
        if((p1 == 'S' || p1 == 's') && (p2 == 'P' || p2 == 'p')) {
            cout << "Scissors cut paper, Player 1 win"<<endl; p1Score=p1Score+1;
        }
        
        displayScore();
        
        
        cout << "Play again? (Y)es or (N)o" << endl;
        cin >> check;
    } while(check != "n");
    
    return 0;
}
