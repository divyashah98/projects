#include <iostream>
#include <fstream>
#include <cstring>
#include <math.h>

using namespace std;

const int MAX = 80;
const int MAXNO = 5;

enum Title {Miss, Mrs, Mr, Dr, Unknown};

struct Date
{
  int day;
  int month;
  int year;
};

struct MyInfo
{
  char name [MAX];
  Title title;
  char national [MAX];
  Date dob;
  int noOfHobbies;
  char hobby [MAXNO][MAX];
  int noOfWishes;
  char wish [MAXNO][MAX];
};

char month_name[12][12] = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}; 

void getMyInfo (ifstream&, char[], MyInfo&);
void displayMyInfo (MyInfo);

void getName ();
void getTitleNational();
void getDate();
void getNoHobbies();
void getHobby();
void getNoWishes();
void getWish();

int convertNumString2Int(char [], int);
void convertEnum2String(Title, char[]);

MyInfo my_info;
Date date;
ifstream ifs;
