#include <iostream>
#include <string>

using namespace std;


bool append(string* &str_arr, string s, int &numEntries, int &arraySize);



int main(int argc, char const *argv[]) {

  string *str = new string[10];
  string s;
  int num = 0, size = 10;

  for (size_t i = 0; i < 22; i++) {
    append(str, "dick", num, size);
    std::cout << num << '\n';
  }

  return 0;
}

bool append(string* &str_arr, string s, int &numEntries, int &arraySize){
  numEntries++;
  bool output = false;
  if (numEntries>=arraySize) {
    string *p = new string[arraySize*2];
    for (int i = 0; i < numEntries; i++) {
      *(p+i) = *(str_arr+i);
    }
    delete[] str_arr;
    str_arr = p;
    arraySize = arraySize * 2;
    output = true;
  }
  *(str_arr+numEntries-1) = s;
  return output;
}
