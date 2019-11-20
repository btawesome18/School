#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>

using namespace std;

void deposit(int money[], string pass, int index);

void withdraw(int money[], string pass, int index);

int menu();

int newAccount(string name[], string pass[], int balance[], int counter, int total);

int gamblingIdx();

int swapValues(int money[], int gambler[], int userI);

int searchString(string name, string accounts[], int max);

int main(){
  const int total = 100;
  int counter = 0, balance[100];
  int test = 0, menuIndex = 0, currentUser = 0, dispNum = 0;
  string accountName[total], passWord[total], currentName, passTemp;
  int gamblPool[10] = {0,500,10,1000,20,5000,30,10000,40,50000};
  srand(time(0)); // seed rand for gamblingIdx

  do {
    menuIndex = menu();
    switch (menuIndex) {
      case 1:
        counter = newAccount(accountName, passWord, balance, counter, total);
      break;
      case 2:
        std::cout << "Enter a name: " << '\n';
        std::cin >> currentName;
        currentUser = searchString(currentName, accountName, total);
        if (currentUser == 200) {
          std::cout << "No Account!" << '\n';
        }else{
          deposit(balance, passWord[currentUser], currentUser);
        }
      break;
      case 3:
        std::cout << "Enter a name: " << '\n';
        std::cin >> currentName;
        currentUser = searchString(currentName, accountName, total);
        if (currentUser == 200) {
          std::cout << "No Account!" << '\n';
        }else{
          withdraw(balance, passWord[currentUser], currentUser);
        }
      break;
      case 4:
        std::cout << "Enter a name: " << '\n';
        std::cin >> currentName;
        currentUser = searchString(currentName, accountName, total);
        if (currentUser == 200) {
          std::cout << "No Account!" << '\n';
        }else{
          std::cout << "Enter your Password: " << '\n';
          std::cin >> passTemp;
          if (passTemp==passWord[currentUser]) {
            std::cout << "Your balance is : " << balance[currentUser] << '\n';
          }else{
            std::cout << "Wronge Password" << '\n';
          }
        }
      break;
      case 5:
      std::cout << "Enter a name: " << '\n';
      std::cin >> currentName;
      currentUser = searchString(currentName, accountName, total);
      std::cout << "Enter your Password: " << '\n';
      std::cin >> passTemp;
      if (passTemp==passWord[currentUser]) {
        dispNum = swapValues(balance, gamblPool, currentUser);
        std::cout << "Your balance is now: " << dispNum << '\n';
      }else{
        std::cout << "Wronge Password" << '\n';
      }
      break;
    }
  } while(menuIndex != 6);



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

int gamblingIdx(){

  return (rand()%10);
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

  if (counter<total) {
    cout << "Enter your name: " << '\n';
    cin >> name[counter];
    cout << "Make a passphrase: " << '\n';
    cin >> pass[counter];

    balance[counter] = 0;

    return ++counter;
  } else {
    cout << "The bank account database is full" << '\n';
    return counter;
  }



}

int swapValues(int money[], int gambler[], int userI){
  int gambleIndex = gamblingIdx();
  int temp = 0;
  temp = gambler[gambleIndex];
  gambler[gambleIndex] = money[userI];
  money[userI] = temp;
  return temp;
}

int searchString(string name, string accounts[], int max){

  for (int i = 0; i < max; i++) {
    if (name == accounts[i]) {
      return i;
    }else{
      return 200;
    }
  }

}
