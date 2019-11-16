#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>

using namespace std;

int gamblingIdx();

int main(){
  const int total = 100;
  int counter = 0, balance[100];
  int test = 0;
  string accountName[total], passWord[total];

  srand(time(0));

  std::cout << gamblingIdx() << '\n';
  std::cout << gamblingIdx() << '\n';
  std::cout << gamblingIdx() << '\n';
  std::cout << gamblingIdx() << '\n';
  std::cout << gamblingIdx() << '\n';
  std::cout << gamblingIdx() << '\n';
  std::cout << gamblingIdx() << '\n';
  std::cout << gamblingIdx() << '\n';
  std::cout << gamblingIdx() << '\n';
  std::cout << gamblingIdx() << '\n';

  return 0;
}

int gamblingIdx(){

  return (rand()%10);
}
