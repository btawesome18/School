#include <iostream>
#include <cmath>
#include <ctime>

using namespace std;

void practicum(int a[], int size, int &min_ele); // finds the index of the lowest value

main(){
  int Array1[] = {11,19,12,3,4,51}, min_ele = 10000;

  practicum(Array1, 6, min_ele);

  std::cout << "min_ele is " << min_ele <<'\n';

  return 0;
}

void practicum(int a[], int size, int &min_ele){
  int temp = a[0];
  for (int i = 0; i < size; i++) {
    if (a[i]<temp) {
      min_ele = i;
      temp = a[i];
    }
  }

}
