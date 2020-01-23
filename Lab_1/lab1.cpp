#include <iostream>
#include <cmath>
#include <fstream>

#include "func.h"

using namespace std;

int main(int argc, char const *argv[]){
//ios::app look at operation modes
  std::cout << "Number of Args: " << argc << '\n';
  std::cout << "Program Arguments " << '\n';
  for (size_t i = 0; i < argc; i++) {
    std::cout << argv[i] << '\n';
  }


  return 0;
}
