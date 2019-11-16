#include <iostream>
#include <string>
#include <cstdlib>
#include <ctime>

using namespace std;

int swapValues(int money[], int gambler[], int userI);

int gamblingIdx();

int main(){
  srand(time(0));
  const int total = 100;
  int counter = 0, balance[100];
  int test = 0;
  int gambler[10] = {0,500,10,1000,20,5000,30,10000,40,50000};
  string accountName[total], passWord[total];
  balance[3] = 250;

  test = swapValues(balance, gambler, 3);

  std::cout << balance[3] << '\n';
  for (int i = 0; i < 10; i++) {
      std::cout << gambler[i] << '\n';
  }

  return 0;
}


int swapValues(int money[], int gambler[], int userI){
  int gambleIndex = gamblingIdx();
  int temp = 0;
  temp = gambler[gambleIndex];
  gambler[gambleIndex] = money[userI];
  money[userI] = temp;
  return temp;
}

int gamblingIdx(){

  return (rand()%10);
}
