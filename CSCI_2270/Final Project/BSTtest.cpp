
#include "tree.hpp"
#include <iostream>
#include <fstream>
#include <ctime>
#include <cmath>
#include <cstdlib>
#include <chrono>

using namespace std;

int main(int argc, char const *argv[]) {
  using namespace std::chrono;

  srand(time(0));//seed the random Numbers with system clock;

  int startTime, endTime, searchTime, insertTime, randN;

  int data[40000];

  double insetArr[400], searchArr[400];

  //for processing documents
  ifstream myfile;
  string input;
  ofstream outFile;


  tree BSTree;


  myfile.open("dataSetB.csv");

  for (size_t i = 0; i < 40000; i++) {
    getline(myfile, input, ',');
    data[i]=stoi(input);
  }

  for (size_t i = 0; i < 400; i++) {

    //test insert

    auto start = steady_clock::now();

    for (size_t j = 0; j < 100; j++) {
      BSTree.insert(data[(i*100)+j]);
    }


    auto end = chrono::steady_clock::now();

    insetArr[i] = (double)(duration_cast<nanoseconds>(end - start).count())/100.0;

    //test search
    startTime = clock();

    auto startS = steady_clock::now();

    for (size_t j = 0; j < 100; j++) {
      randN = (rand() % (((i*100)+j)+1));
      BSTree.search(data[randN]);
    }

    auto endS = steady_clock::now();

    searchArr[i]  = (double)(duration_cast<nanoseconds>(endS - startS).count())/100.0;



  }


  BSTree.clear();

  //Writes results to external File;

  outFile.open("TreeB.csv");
  for (size_t i = 0; i < 400; i++) {
    outFile << (double)(insetArr[i]) << "," << (double)(searchArr[i]) << "\n";
  }



  return 0;
}
