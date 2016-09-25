#include "parse_info.h"
#include "parse_info.cpp"

int main () {

  cout <<"Enter the file name to get your info: ";
  char file_name[MAX];
  cin >> file_name;
  getchar();
  getMyInfo (ifs, file_name, my_info);
  displayMyInfo (my_info);
  return 0;
}
