#include "linklist.hpp"
#include <iostream>
#include <fstream>

using namespace std;

int main(int argc, char const *argv[]) {

  linklist List;
  for (size_t i = 0; i < 10; i++) {
    List.insert(i);
  }
  List.display();
  List.clear();
  List.display();
  return 0;
}
