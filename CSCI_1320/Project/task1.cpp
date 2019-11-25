#include <iostream>
#include <string>
#include <ctime>
#include <cstdlib>


using namespace std;

char randLetter();

void buildPopulation(string poulation[], int size, int targetLenght);

int main(){
  srand(time(0));
  int populationSize = 200;
  string population[populationSize];

  buildPopulation(population, populationSize, 10);

  for (int i = 0; i < 200; i++) {
    std::cout << population[i] << '\n';
  }

  return 0;
}

void buildPopulation(string poulation[], int size, int targetLenght){
  string temp;-+*-
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < targetLenght; j++) {
      temp = temp + randLetter();
    }
    poulation[i] = temp;
    temp = "";
  }
}

char randLetter(){
  int temp = (rand()%53);
  char alph[] = {" abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"};
  return alph[temp];
}
