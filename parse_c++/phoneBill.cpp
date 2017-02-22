#include <iostream>

using namespace std;

class Customer {
  public:
    string cust_name;
    int num_of_calls;
    int monthly_fee;
    float percall_fee;
    float permin_fee;
    int num_mins;

    void init_rate () {
      monthly_fee = 10;
      percall_fee = 0.5;
    }

    // Define the overloaded constructor
    Customer (string name, int calls) {
      cust_name = name;
      num_of_calls = calls;
      init_rate ();
    }

    // Define the appropriate print function
    string getName () {
      return (cust_name);
    }

    // Define the virtual function to generate bill
    virtual float ComputeBill () {
        float bill;
        bill = (float)monthly_fee + (float)(percall_fee * (float) num_of_calls);
        return bill;
    }

    Customer () {
    }

};

class PremiumCustomer : public Customer {
  public:

    void init_rate () {
      monthly_fee = 20;
      percall_fee = 0.05;
      permin_fee = 0.10;
    }

    // Define the virtual function to generate bill
    virtual float ComputeBill () {
        float bill;
        bill = (float)monthly_fee + (float)(percall_fee * (float) num_of_calls) + (float)(permin_fee * (float)num_mins);
        return bill;
    }
    
    // Define the overloaded constructor
    PremiumCustomer (string name, int calls, int mins) {
      cust_name = name;
      num_of_calls = calls;
      num_mins = mins;
      init_rate();
    }

};

int main () {

  Customer* C;
  C = new Customer ("John Cena", 30);
  cout << "Customer using Basic Plan: "<<C->getName()<<" owes "<<C->ComputeBill()<<" dollars."<<endl;
  
  C = new PremiumCustomer ("John Cena", 30, 90);
  cout << "Customer using Premium Plan: "<<C->getName()<<" owes "<<C->ComputeBill()<<" dollars."<<endl;
  return 0;
}
