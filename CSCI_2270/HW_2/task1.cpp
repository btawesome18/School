#include <fstream>
#include <iostream>
#include <string>
#include <iomanip>

using  namespace std;

struct wordItem{
  string word;
  int count = 0;
};


void getStopWords(const char *ignoreWordFileName, string ignoreWords[]);

bool isStopWord(string word, string ignoreWords[]);

int getTotalNumberNonStopWords(wordItem uniqueWords[], int length);

void arraySort(wordItem uniqueWords[], int length);

void printNext10(wordItem uniqueWords[], int N, int totalNumWords);

wordItem* doubleArry(wordItem starter[], int size);


int main(int argc, char const *argv[]) {

  if(!(argc == 4)){
    std::cout << "Usage: Assignment2Solution <number of words><inputfilename.txt> <ignoreWordsfilename.txt>" << std::endl;
    return -1;
  }

  int numberWords = stoi(argv[1]);
  string targetTextName = argv[2];
  string ignoreListName = argv[3];

  string ignoreWords[50];

  getStopWords(argv[3], ignoreWords);

  wordItem *arry = new wordItem[100], *temp;
  int arryMax = 100, uniqueWordC = 0, uniqueness = 0, timesDoubled = 0, total;
  string word;

  ifstream target;
  target.open(targetTextName);

  while (target >> word) {
    uniqueness = 0;

    if (!(isStopWord(word, ignoreWords)))
    {
      if (uniqueWordC==0) {
        arry[0].count = 1;
        arry[0].word = word;
        uniqueWordC++;
        //std::cout << arry[0].word << '\n';
      }
      for (size_t i = 0; i < uniqueWordC; i++) {
        if (word == arry[i].word) {
          arry[i].count++;
        } else {
          uniqueness++;
        }

      }
      if (uniqueness == uniqueWordC) {
        if ((arryMax-1) == uniqueWordC) {
          temp = new wordItem[arryMax*2];
          for (size_t i = 0; i < arryMax; i++) {
            *(temp+i) = arry[i];
          }
          delete[] arry;
          arry = temp;
          arryMax = arryMax*2;
          timesDoubled++;
          //std::cout << "arrydoubled" << '\n';
        }
        arry[uniqueWordC].word = word;
        arry[uniqueWordC].count = 1;
        uniqueWordC++;
        //std::cout << word << '\n';
      }
    }
    //std::cout << "uniqueWordC: " << uniqueWordC << '\n';
  }
  //std::cout << "uniqueWordC: " << uniqueWordC << '\n';

  arraySort(arry, uniqueWordC);

  total = getTotalNumberNonStopWords(arry, uniqueWordC);

  std::cout << "Array doubled: " << timesDoubled << '\n';
  std::cout << "#" << '\n';
  std::cout << "Unique non-common words: " << uniqueWordC << '\n';
  std::cout << "#" << '\n';
  std::cout << "Total non-common words: " << total-1 << '\n';
  std::cout << "#" << '\n';
  std::cout << "Probability of next 10 words from rank " << numberWords << '\n';
  std::cout << "---------------------------------------" << '\n';

  printNext10(arry, numberWords, total);


  target.close();
  return 0;
}


void getStopWords(const char *ignoreWordFileName, string ignoreWords[]){

  string wordTemp, fileName = ignoreWordFileName;
  int c =0;

  ifstream inStream;
  inStream.open(fileName);

  while (getline(inStream,wordTemp)) {
    ignoreWords[c++] = wordTemp;
  }
  inStream.close();
}

bool isStopWord(string word, string ignoreWords[]){
  for (size_t i = 0; i < 50; i++) {
    if (word == ignoreWords[i]) {
      return true;
    }
  }
  return false;
}

int getTotalNumberNonStopWords(wordItem uniqueWords[], int length){
  int total =0;
  for (size_t i = 0; i < length; i++) {
    total += uniqueWords[i].count;
  }
  return total;
}

void arraySort(wordItem uniqueWords[], int length){

  int c;
  wordItem temp;

  for(c = length; c > 0; c--){

    for (size_t i = 0; i < c; i++) {
      if ((uniqueWords[i].count) < (uniqueWords[i+1].count)) {
        temp = uniqueWords[i];
        uniqueWords[i] = uniqueWords[i+1];
        uniqueWords[i+1] = temp;
      }
    }
  }
}

void printNext10(wordItem uniqueWords[], int N, int totalNumWords){

  float pOfO;

  for (size_t i = N; i < N +10; i++) {
    pOfO = ((float)uniqueWords[i].count/totalNumWords);

    std::cout << setprecision(4) << std::fixed << pOfO << " - " << uniqueWords[i].word << '\n';
  }
}

wordItem* doubleArry(wordItem starter[], int size){
  wordItem *p = new wordItem[size*2];
  for (size_t i = 0; i < size; i++) {
    *(p+i) = starter[i];
  }
  delete[] starter;

}
