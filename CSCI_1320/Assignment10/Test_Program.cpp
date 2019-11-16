#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>

using namespace std;

int menu();

int newAccount(string name[], string pass[], int balance[], int counter, int total);

void deposit(int money[], string pass, int index);

void withdraw(int money[], string pass, int index);

int gamblingIdx();

int swapValues(int money[], int gambler[], int userI);

int main(){
  const int total = 100;
  int counter = 0, balance[100];
  int test = 0;
  string name[total], pass[total];

//  cout << menu();
  counter = newAccount(name, pass, balance, counter, total);

  std::cout << counter << '\n';
  std::cout << balance[0] << '\n';
  std::cout << name[0] << '\n';
  std::cout << pass[0] << '\n';
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

void withdraw(int money[], string pass, int index){
  string temp = "";
  int draw;

  std::cout << "Enter your Password: " << '\n';
  std::cin >> temp;
  if (temp.compare(pass) == 0) {
    std::cout << "Deposit amount: " << '\n';
    std::cin >> draw;
    money[index] = money[index]-draw;
  } else {
    std::cout << "Wrong Password!" << '\n';
  }
}

int gamblingIdx(){
  srand(time(0));
  return (rand()%10);
}

int swapValues(int money[], int gambler[], int userI){
  int gambleIndex = gamblingIdx();
  int temp = 0;
  temp = gambler[gambleIndex];
  gambler[gambleIndex] = money[userI];
  money[userI] = temp;
  return temp;
}
