#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>

using namespace std;

void deposit(int money[], string pass, int index);

int main(){
  const int total = 100;
  int counter = 0, balance[100];
  int test = 0;
  string accountName[total], passWord[total];
  accountName[0] = "Brian";
  passWord[0] = "1234";
  deposit(balance, passWord[0], counter);

  std::cout << balance[0] << '\n';


  return 0;
}

void deposit(int money[], string pass, int index){
  string temp = "";

  std::cout << "Enter your Password: " << '\n';
  std::cin >> temp;
  if (temp.compare(pass) == 0) {
    std::cout << "Deposit amount: " << '\n';
    std::cin >> money[index];
  } else {
    std::cout << "Wrong Password!" << '\n';
  }
}
