#include <iostream>
#include <string>
#include <ctime>
#include <cmath>
#include <cstdlib>
#include <fstream>


using namespace std;

struct genSummery{
  double fitness;
  string text;
  double aveFit;
};

double calcAve(double fitness[], int size);

genSummery runGeneration(string population[], int populationSize, string target, int mutationRate, double fitness[]);

void causeMutation(string population[], int populationSize, double mutationRate);

string breed(string parent1, string parent2, bool method);

void buildMatingPool(double fitnessPer[], int parents[], int arrySize, int factor);

double sumArryD(double arry[], int arrySize);

char randLetter();

int calculateFitness(string target, string population[], double fitness[], int size, int length);

int compareString(string test, string sample);

void buildPopulation(string poulation[], int size, int targetLenght);

void makePercent(double fitnessPer[], int fitnessInt[], int length, int size);

int main(){
  srand(time(0));
  int populationSize = 200;
  string population[populationSize];
  string Target = "May your mountains rise";
  genSummery Current;
  int genCount = 0;
  string fileName = "output.csv";
  double fitnessPer[populationSize];
  ofstream myfile;

  myfile.open(fileName);

  buildPopulation(population, populationSize, Target.length());

  while ((Current.fitness < 1)&&(genCount < 50000)) {
    genCount++;
    Current = runGeneration(population, populationSize, Target, 4, fitnessPer);

    cout << "Gen: " << genCount <<" Fitness Max: " << Current.fitness  <<" Text: " << Current.text << '\n';
    myfile << genCount << "," << Current.fitness <<   ",";
    for (int i = 0; i < populationSize; i++) {
      myfile << fitnessPer[i] << ",";
    }
    myfile << "\n";
  }


  myfile.close();
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

int calculateFitness(string target, string population[], double fitness[], int size, int length){
  int fitInt[size];
  int champInx = 0;
  int champFit = 0;
  for (int i = 0; i < size; i++) {
    fitInt[i] = compareString(target, population[i]);
    if( fitInt[i] > champFit){
      champFit = fitInt[i];
      champInx = i;
    }
  }

  makePercent(fitness, fitInt, length, size);
  return champInx;
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
  string child = parent1;
  int randomNum = 0;

  if(method == 0){
    for (int i = 0; i < stringLenght; i++) {
      randomNum = (rand()%2);
      if (randomNum == 0) {
        child[i] =  parent2[i];
      }
    }
  }else{
    randomNum = (rand()%stringLenght);
    child = "";
    for (int i = 0; i < stringLenght; i++) {
      if(i <= randomNum){
        child = child + parent1[i];
      }else{
        child = child + parent2[i];
      }
    }
  }
  return child;
}

void causeMutation(string population[], int populationSize, double mutationRate){
  string temp = "";
  for (int i = 0; i < populationSize; i++) {
    temp = population[i];
    for (int j = 0; j < temp.length(); j++) {
      if(round(mutationRate*10) >= (rand()%1000)){
        temp[j] = randLetter();
      }
      population[i] = temp;
    }
  }
}

genSummery runGeneration(string population[], int populationSize, string target, int mutationRate, double fitness[]){
  int parentsIndex1[populationSize], parentsIndex2[populationSize];

  genSummery Champ;
  int champIndex;
  string children[populationSize];

  champIndex = calculateFitness(target, population, fitness, populationSize, target.length());

  Champ.fitness = fitness[champIndex];
  Champ.text = population[champIndex];
  //Champ.aveFit = calcAve(fitness,populationSize);  They want this done in matlab.
  buildMatingPool(fitness, parentsIndex1, populationSize, 10000);
  buildMatingPool(fitness, parentsIndex2, populationSize, 10000);

  int parentTempA, parentTempB;
  for (int i = 0; i < populationSize; i++) {
    parentTempA = parentsIndex1[i];
    parentTempB = parentsIndex2[i];
    while(parentTempB == parentTempA){
      parentTempB = rand()%populationSize;
      parentTempA = rand()%populationSize;
    }
    children[i] = breed(population[parentTempA], population[parentTempB], 0);

  }


  causeMutation(children, populationSize, 4);

  children[0] = Champ.text;

  for (int i = 0; i < populationSize; i++) {
    population[i] = children[i];
  }

  return Champ;
}

double calcAve(double fitness[], int size){
  double total = 0;
  for (int i = 0; i < size; i++) {
    total = total + fitness[i];
  }
  return (total/size);
}
