#include <iostream>
#include <cmath>

void swap(int &a, int &b);

int main() {

  int a=4, b=3, c=7, d=2;


}


void swap(int &a, int &b){
  int temp;
  temp = a;
  a = b;
  b = temp;
}
