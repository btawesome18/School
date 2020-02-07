#include <iostream>
#include <fstream>
#include <string>

using namespace std;

int insertIntoSortedArray(float myArray[], int numEntries, float newValue);

int main(int argc, char const *argv[]) {



  ifstream myfile (argv[1]);

  if (!myfile.is_open()){
    cout << "Failed to open the file." << std::endl;
  } // error checking

  float testarr[100], newValue;
  string line;
  int numEnt = 0;
  int result =0;

  while (getline(myfile, line)) {
    newValue = stof(line);
    numEnt = insertIntoSortedArray(testarr, numEnt, newValue);
    for (size_t i = 0; i < numEnt; i++) {
      if ((i>0)) {
        std::cout << "," << testarr[i];
      }else
      std::cout << testarr[i];

    }
    std::cout << '\n';
  }
  return 0;
}

int insertIntoSortedArray(float myArray[], int numEntries, float newValue){
  bool sorted = false;
  int count;
  float temp;

  myArray[numEntries] = newValue;
  while (!sorted) {
    count = 0;
    for (int i = 0; i < numEntries; i++) {
      if (myArray[i]<myArray[i+1]) {
        temp = myArray[i];
        myArray[i] = myArray[i+1];
        myArray[i+1] = temp;
      }else{
        count++;
      }
    }
    if (count == numEntries) {
      sorted = true;
    }
  }
  return numEntries+1;
}
