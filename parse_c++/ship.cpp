#include <iostream>

using namespace std;

class Ship {
  public:
    string ship_name;
    int    ship_year;

    //Define the appropriate print function
    void print () {
      cout <<"Name of the ship is "<<ship_name<<endl;
      cout <<"Year ship was built in "<<ship_year<<endl<<endl;
    }

    //Define the appropriate mutators
    void setName (string name) {
      ship_name = name;
    }

    //Define the appropriate mutators
    void setYear (int year) {
      ship_year = year;
    }

    //Define the overloaded constructor
    Ship (string name, int year) {
      ship_name = name;
      ship_year = year;
    }

    //Define the default constructor
    Ship () {
    }
};

class CruiseShip : public Ship {
  public:
    int    max_pass;

    //Define the appropriate print function
    void print () {
      cout <<"Name of the ship is "<<ship_name<<endl;
      cout <<"Max passengers: "<<max_pass<<endl<<endl;
    }

    //Define the appropriate mutators
    void setMaxPass (int pass) {
      max_pass = pass;
    }

    //Define the overloaded constructor
    CruiseShip (string name, int pass) {
      ship_name = name;
      max_pass = pass;
    }

    //Define the default constructor
    CruiseShip () {
    }
};

class CargoShip : public Ship {
  public:
    int    cargo_cap;

    //Define the appropriate print function
    void print () {
      cout <<"Name of the ship is "<<ship_name<<endl;
      cout <<"Max Capacity (in tonnage): "<<cargo_cap<<endl<<endl;
    }

    //Define the appropriate mutators
    void setCargoCap (int cap) {
      cargo_cap = cap;
    }

    //Define the overloaded constructor
    CargoShip (string name, int cap) {
      ship_name = name;
      cargo_cap = cap;
    }

    //Define the default constructor
    CargoShip () {
    }
};

int main () {
  string _name;
  int _cap, _year, _pass;
  //Take input from the user
  cout << "Enter Ship's Name" <<endl;
  cin >> _name;
  cout << "Enter Ship's Year" <<endl;
  cin >> _year;
  cout << "Enter Ship's Load Capacity" <<endl;
  cin >> _cap;
  cout << "Enter Ship's Passenger capacity" <<endl;
  cin >> _pass;

  //Create objects of the three classes
  //use the default constructors
  Ship S;
  CruiseShip CrS;
  CargoShip  CaS;
  //Use the accessors and mutators
  //to set the values of different variables
  S.setName (_name);
  S.setYear (_year);
  CrS.setName (_name);
  CrS.setMaxPass (_pass);
  CaS.setName (_name);
  CaS.setCargoCap (_cap);

  //Create objects of the three classes
  //use the overloaded constructors
  Ship S_o (_name, _year);
  CruiseShip CrS_o (_name, _pass);
  CargoShip  CaS_o (_name, _cap);

  //Print the information from all the objects
  S.print ();
  CrS.print ();
  CaS.print ();

  S_o.print ();
  CrS_o.print ();
  CaS_o.print ();

  return 0;
}
