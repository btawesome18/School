#include <iostream>
#include <string>

using namespace std;

int menu();

int newAccount(string name[], string pass[], int balance[], int counter, int total);

int main(){
  int counter = 0, total = 100, balance[100];
  int test = 0;
  string name[total], pass[total];

//  cout << menu();
//  test = newAccount()
//s1.compare(s2) == 0 to compare strings
  return 0;
}

int menu(){
  int choice = 6;//defult to just finish if invalid input

  cout << "1. Make an account" << endl;
  cout << "2. Deposit" << endl;
  cout << "3. Withdraw" << endl;
  cout << "4. Balance" << endl;
  cout << "5. Gambling" << endl;
  cout << "6. Finish" << endl;
  cin >> choice;

  return choice;
}

int newAccount(string name[], string pass[], int balance[], int counter, int total){
  int i = counter;

  if (i<total) {
    cout << "Enter your name: " << '\n';
    cin >> name[i];
    cout << "Make a passphrase: " << '\n';
    cin >> pass[i];

    balance[i] = 0;

    return i+1;
  } else {
    cout << "The bank account database is full" << '\n';
    return i;
  }



}
