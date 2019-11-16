#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>

using namespace std;

int menu();

int main(){
  int test = 0;

  test = menu();
  std::cout << test << '\n';

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
