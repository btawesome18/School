#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>

using namespace std;

int newAccount(string name[], string pass[], int balance[], int counter, int total);

int main(){
  const int total = 100;
  int counter = 0, balance[100];
  int test = 0;
  string accountName[total], passWord[total];

  counter = newAccount(accountName, passWord, balance, counter, total);

  std::cout << counter << '\n';
  std::cout << accountName[0] << '\n';
  std::cout << passWord[0] << '\n';

  return 0;
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
