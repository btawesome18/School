#include <iostream>
#include <cmath>
#include <string>
#include <fstream>

using namespace std;


struct Park{
  string name;
  string state;
  int area;
};


void addPark(Park parks[], string parkname, string state, int area, int length);

void printList(const Park parks[], int length);

int main(){
  int length = 55;
  ifstream myFile;
  myFile.open("park.csv");

  Park arry[length];
  int i =0,index = 0;
  string areaS, name, state;
  while(getline(myFile, name, ',')){
    getline(myFile, state, ',');
    getline(myFile, areaS);
    if(stoi(areaS) >200000)
    addPark(arry, name, state,stoi(areaS),index++);

    i++;

  };

  printList(arry, index);

  myFile.close();

  return 0;
}

void addPark(Park parks[], string parkname, string state, int area, int length){

  Park temp;
  temp.name = parkname;
  temp.state = state;
  temp.area = area;
  parks[length] = temp;
}

void printList(const Park parks[], int length){
  for (int i = 0; i < length; i++) {
    cout << parks[i].name << " [" << parks[i].state << "] area: " << parks[i].area << '\n';
  }
}
