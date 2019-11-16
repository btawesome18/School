#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>

using namespace std;

void withdraw(int money[], string pass, int index);

int main(){
  const int total = 100;
  int counter = 0, balance[100];
  int test = 0;
  string accountName[total], passWord[total];
  accountName[0] = "Brian";
  passWord[0] = "1234";
  balance[0] = 500;
  withdraw(balance, passWord[0], counter);

  std::cout << balance[0] << '\n';

  return 0;
}

void withdraw(int money[], string pass, int index){
  string temp = "";
  int draw;

  std::cout << "Enter your Password: " << '\n';
  std::cin >> temp;
  if (temp.compare(pass) == 0) {
    std::cout << "Withdraw amount: " << '\n';
    std::cin >> draw;
    money[index] = money[index]-draw;
  } else {
    std::cout << "Wrong Password!" << '\n';
  }
}
