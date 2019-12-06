#include <iostream>
#include <cmath>
#include <ctime>

using namespace std;

void fill_array(int A[], int minVal, int maxVal, int size_A);

int fuse_universe(int ying[], int yang[], int size_y);

int main(){
  srand(time(0));
  int arr_size = 30;
  int minVal, maxVal;
  int temp;

  cout << "Define Minimum Value: " << '\n';
  cin >> minVal;
  cout << "Define Maximum Value: " << '\n';
  cin >> maxVal;

  int Array1[arr_size], Array2[arr_size];


  fill_array(Array1, minVal, maxVal, arr_size);

  fill_array(Array2, minVal, maxVal, arr_size);

  temp = fuse_universe(Array1, Array2, arr_size);

  cout << temp << '\n';

  return 0;
}


void fill_array(int A[], int minVal, int maxVal, int size_A){
  int delta = maxVal-minVal;
  int temp = 0;
  for (int i = 0; i < size_A; i++) {
    temp = ((rand()%delta)+minVal);
    A[i] = temp;
  }
}

int fuse_universe(int ying[], int yang[], int size_y){
  int fusion_success = 0;
  for (int i = 0; i < size_y; i++) {
    fusion_success = fusion_success + (ying[i]*yang[i]);
  }
  return fusion_success;
}
