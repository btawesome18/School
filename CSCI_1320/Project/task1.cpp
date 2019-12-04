#include <iostream>
#include <string>
#include <ctime>
#include <cmath>
#include <cstdlib>


using namespace std;

string breed(string parent1, string parent2, bool method);

void buildMatingPool(double fitnessPer[], int parents[], int arrySize, int factor);

double sumArryD(double arry[], int arrySize);

char randLetter();

void calculateFitness(string target, string population[], double fitness[], int size, int length);

int compareString(string test, string sample);

void buildPopulation(string poulation[], int size, int targetLenght);

void makePercent(double fitnessPer[], int fitnessInt[], int length, int size);

int main(){
  srand(time(0));
  int populationSize = 200;
  string population[populationSize];
  double fitness[populationSize];
  int parentsIndex[populationSize];
  buildPopulation(population, populationSize, 100);

  for (int i = 0; i < 200; i++) {
    std::cout << population[i] << '\n';
  }

  calculateFitness("Hello DudeHello DudeHello DudeHello DudeHello DudeHello DudeHello DudeHello DudeHello DudeHello Dude", population, fitness, populationSize, 100);

  for (int i = 0; i < 200; i++) {
    std::cout << fitness[i] << '\n';
  }

  buildMatingPool(fitness, parentsIndex, populationSize, 10000);

  for (int i = 0; i < populationSize; i++) {
    std::cout << parentsIndex[i] << '\n';
  }

  return 0;
}

void buildPopulation(string poulation[], int size, int targetLenght){
  string temp = "";
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

void calculateFitness(string target, string population[], double fitness[], int size, int length){
  int fitInt[size];
  for (int i = 0; i < size; i++) {
    fitInt[i] = compareString(target, population[i]);
  }

  makePercent(fitness, fitInt, length, size);
}

int compareString(string test, string sample){
  int total = 0;
  int lenght = test.length();
  for (int i = 0; i < lenght; i++) {
    if (test[i]==sample[i]) {
      total = total + 1;
    }
  }
  return total;
}

void makePercent(double fitnessPer[], int fitnessInt[], int length, int size){
  double mult = 1.0/length;
  for (int i = 0; i < size; i++) {
    fitnessPer[i] = (mult*double(fitnessInt[i]));
  }
}

void buildMatingPool(double fitnessPer[], int parents[], int arrySize, int factor){
  double weight = sumArryD(fitnessPer, arrySize);
  double randValue = 0;
  double testSum = 0;
  int counter = -1;

  for (int i = 0; i < arrySize; i++) {
    randValue = (rand()%int(round(weight*factor)))/factor;
    while (testSum <= randValue) {
      counter++;
      testSum = testSum + fitnessPer[counter];
    }
    parents[i] = counter;
    counter = -1;
    testSum = 0;

  }

}

double sumArryD(double arry[], int arrySize){
  double total = 0;
  for (size_t i = 0; i < arrySize; i++) {
    total = total + arry[i];
  }
  return total;
}

string breed(string parent1, string parent2, bool method){
  int stringLenght = parent1.length();
  string child ="";
  int randomNum =0;

  if(method){
    for (int i = 0; i < stringLenght; i++) {
      randomNum = (rand()%2);
      if (randomNum == 0) {
        child = child + parent1[i];
      } else {
        child = child + parent2[i];
      }
    }
  }else{
    randomNum = rand()%stringLenght;
    for (int i = 0; i < stringLenght; i++) {
      if (i <= randomNum) {
        child = child + parent1[i];
      } else {
        child = child + parent2[i];
      }
    }
  }
}

void causeMutation(string population[], int populationSize, double mutationRate){}
