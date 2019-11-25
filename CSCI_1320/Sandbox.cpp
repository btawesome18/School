#include <iostream>
#include <cmath>
#include <string>
#include <cstdlib>

using namespace std;

struct missleSpec {
  int range;
  int mass;
  int speedTop;
  int Altitude;
  int payload;
  bool nuclear;
  int lenght;
  string launcher;
  bool service;
};


int main() {

  missleSpec v2;

  v2.range = 200;
  v2.payload = 2200;
  v2.speedTop = 3580;
  v2.lenght = 45;
  v2.mass = 27600;
  v2.Altitude = 128;
  v2.launcher = "Ground based stand";
  v2.nuclear = 0;
  v2.service = 0;

  std::cout << "Range (Miles): " << v2.range << '\n';

  return 0;
}
