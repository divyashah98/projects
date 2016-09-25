void getMyInfo (ifstream &ifs, char file_name[], MyInfo &my_info) {
  ifs.open(file_name, std::ifstream::in);
  if (!ifs.is_open() || !ifs.good()) {
    cout << file_name<<" opened for reading failed"<<endl;
    cout << "Press enter to return to Quincy..."<<endl;
    if(cin.get() == '\n') {
      return;
    }
  }
  MyInfo info;
  int count = 0;
  while (ifs.good()) {
    getName();
    getTitleNational();
    getDate();
    getNoHobbies();
    getHobby();
    getNoWishes();
    getWish();
  }
}

void getName () {
  char name = ifs.get();
  for (int i = 0; name != '\n'; i++) {
    my_info.name[i] = name;
    name = ifs.get();
  }
}

void getTitleNational () {
  char parse_title[MAX] = {'\n'};
  char title_read = ifs.get();
  for (int i = 0; title_read != ' '; i++) {
    parse_title[i] = title_read;
    title_read = ifs.get();
  }
  if (strcmp(parse_title, "Miss") == 0)
    my_info.title = Miss;
  else if (strcmp(parse_title, "Mrs") == 0)
    my_info.title = Mrs;
  else if (strcmp(parse_title, "Mr") == 0)
    my_info.title = Mr;
  else if (strcmp(parse_title, "Dr") == 0)
    my_info.title = Dr;
  else
    my_info.title = Unknown;
  char national;
  national = ifs.get();
  for (int i = 0; national!= '\n'; i++) {
    my_info.national[i] = national;
    national = ifs.get();
  }
}

void getDate () {
  char parse_date[MAX] = {'\n'};
  char date = ifs.get();
  int j;
  for (int i = 0; i < 3; i++) {
    for (j = 0; (date != ' ') && (date != '\n'); j++) {
      parse_date[j] = date;
      date = ifs.get();
    }
    if (date != '\n') {
      date = ifs.get();
      date = ifs.get();
      date = ifs.get();
    }
    if (i == 0) 
      my_info.dob.day = convertNumString2Int (parse_date, j);
    else if (i == 1)
      my_info.dob.month = convertNumString2Int (parse_date, j);
    else if (i == 2)
      my_info.dob.year = convertNumString2Int (parse_date, j);
  }
}

void getNoHobbies () {
  char noHobby;
  noHobby = ifs.get();
  my_info.noOfHobbies = (noHobby - 48);
  for (int i = 0; ifs.get() != '\n'; i++);
}

void getHobby () {
  char hobby = ifs.get();
  for (int i = 0; i < my_info.noOfHobbies; i++) {
    for (int j = 0; hobby!= '\n'; j++) {
      my_info.hobby[i][j] = hobby;
      hobby = ifs.get();
    }
    if (i < my_info.noOfHobbies - 1)
      hobby = ifs.get();
  }
}

void getNoWishes() {
  char noWishes;
  noWishes = ifs.get();
  my_info.noOfWishes = (noWishes - 48);
  for (int i = 0; ifs.get() != '\n'; i++);
}

void getWish () {
  char wish = ifs.get();
  for (int i = 0; i < my_info.noOfWishes; i++) {
    for (int j = 0; wish!= '\n'; j++) {
      my_info.wish[i][j] = wish;
      wish = ifs.get();
    }
    wish = ifs.get();
  }
}

int convertNumString2Int (char str_arr[], int index) {
  int num = 0;
  int pow_index = 0;
  for (int i = (index-1); i >= 0; i--) {
    num = num + (str_arr[i] - 48) * pow(10, pow_index);
    pow_index++;
  }
  return num;
}

void displayMyInfo (MyInfo my_info) {
  cout <<"My Information"<<endl;
  char name[10];
  convertEnum2String(my_info.title, name);
  cout <<"Name: "<<name<<" "<<my_info.name<<endl;
  cout <<"National:  "<<my_info.national<<endl;
  cout <<"Date of birth: "<<my_info.dob.day<<" "<<month_name[my_info.dob.month-1]<<", "<<my_info.dob.year<<endl;
  cout <<"I have "<<my_info.noOfHobbies<<" hobbies"<<endl;
  for (int i = 0; i <my_info.noOfHobbies; i++) {
    cout <<"\t"<<i+1<<": "<<my_info.hobby[i]<<endl;
  }
  cout <<"I have "<<my_info.noOfWishes<<" wishes"<<endl;
  for (int i = 0; i <my_info.noOfWishes; i++) {
    cout <<"\t"<<i+1<<": "<<my_info.wish[i]<<endl;
  }
}

void convertEnum2String (Title title, char name[]) {
  if (title == Miss) {
    strcpy(name,"Miss");
  }
  else if (title == Mrs){
    strcpy(name,"Mrs");
  }
  else if (title == Mr) {
    strcpy(name,"Mr");
  }
  else if (title == Dr) {
    strcpy(name,"Dr");
  }
}
