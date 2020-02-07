#include <iostream>
#include <fstream>
#include <string>

using namespace std;

struct Park{
  string parkname;
  string state;
  int area;
};

void addPark(Park parks[], string parkname, string state, int area, int length);

void printList(const Park parks[], int length);

int main(int argc, char const *argv[]) {
  string inputFile = argv[1], output = argv[2], line, state, areaStr;
  int low = stoi(argv[3]), upper = stoi(argv[4]), area, c =0;
  Park parks[100];

  ifstream myfileIn(inputFile);

  if (!myfileIn.is_open()){
    cout << "Failed to open the file." << std::endl;
  } // error checking

  while (getline(myfileIn, line, ',')){
    getline(myfileIn, state, ',');
    getline(myfileIn, areaStr);
    area = stoi(areaStr);
    addPark(parks, line, state, area, c++);
  }

  myfileIn.close();

  printList(parks, c);

  ofstream fileOut(output);

  for (size_t i = 0; i < c; i++) {
    if ((parks[i].area<upper)&&(parks[i].area>low)) {
      fileOut<< parks[i].parkname << ","<<parks[i].state<<","<<parks[i].area<< "\n";
    }

  }
  fileOut.close();
  return 0;
}

void addPark(Park parks[], string parkname, string state, int area, int length){
  Park temp;
  temp.parkname = parkname;
  temp.state = state;
  temp.area = area;
  parks[length] = temp;
}

void printList(const Park parks[], int length){
  Park temp;
  for (size_t i = 0; i < length; i++) {
    temp = parks[i];
    std::cout  << temp.parkname << " [" << temp.state << "] area: " << temp.area << '\n';
  }
}
