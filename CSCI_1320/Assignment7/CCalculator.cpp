#include<iostream>
using namespace std;

int main(){

  float num1, num2, add, sub, mult, div;

  cout << "Give 2 numbers" << endl;
  cin >> num1 >> num2;

  add = num1+num2;
  sub = num1-num2;
  mult = num1*num2;
  div = num1/num2;

  cout << "Sum: " << add << " Difference: " << sub << " Product: " << mult << " Quoint: " << div << endl;

  return 0;
}
