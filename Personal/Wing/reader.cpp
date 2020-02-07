#include <fstream>
#include <iostream>
#include <string>

using namespace std;

struct wingSum{
  double liftToDrag =0;
  double alpha =0;
  double lift =0;
  double drag =0;
  bool fail;
};

wingSum readPolar(string file, int maxarry);

int main(int argc, char const *argv[]) {

  //string Naca;
  wingSum current;
  wingSum Max;
  string NacaMax;
//  int test;

  for (int i = 1; i < 10; i++) {
    for (int t = 1; t < 10; t++) {
      for (int u = 2; u < 42; u+=2) {
        string Naca = "";
        Naca = to_string(i)+to_string(t);
        if (u>=10) {
          Naca = Naca + to_string(u);
        }else{
          Naca = Naca + "0" + to_string(u);
        }
        Naca = "NACA" + Naca + "Pol";
        cout << Naca << '\n';
      //  cin >> test;
        current = readPolar(Naca,100);
        if (!current.fail&&(current.liftToDrag > Max.liftToDrag)) {
          NacaMax = Naca;
          Max = current;
        }
      }
    }
  }
  std::cout << "Best Wing: "<< NacaMax << " Lift/Drag: " << Max.liftToDrag << " Lift: " << Max.lift << " Drag: " << Max.drag <<'\n';

  //wingSum test1;

  //test1 =  readPolar("NACA9836Pol", 100);
  //std::cout << "Max CL/CD: " << test1.liftToDrag << '\n';
}

wingSum readPolar(string file, int maxarry){
  //std::cout << "file: " << file << '\n';
  string const fileName = file;
  wingSum wing;
  string temp;
  double alpha[maxarry];
  double cofL[maxarry];
  double cofD[maxarry];
  double liftODrag[maxarry];
  double maxLiftToDrag = 0;
  int max =0;
  int pos =0;
  //std::cout << "FileName: " << fileName << '\n';
  ifstream polar;
  polar.open(fileName);

  if (!polar) { // error checking
    cerr << "Unable to open file " << fileName << '\n';
    wing.fail = true;
    return wing;
  }

  while (polar >> temp) {
    if (temp == "--------") {
      pos = 1;
    }

    if ((pos > 0)&&(temp != "--------" && temp != "---------")) {
      //cout << temp << " " << pos << '\n';
      if (pos%7 ==1 ) { // grabs angle
        //cout << "Alpha: "<< temp << '\n';
        alpha[pos/7] = stod(temp);
      }
      if (pos%7 ==2 ) { // grabs CL
        //cout << "CL: "<< temp << '\n';
        cofL[pos/7] = stod(temp);
      }
      if (pos%7 ==3 ) { // grabs CD
        //cout << "CD: "<< temp << '\n';
        cofD[pos/7] = stod(temp);
      }
      pos++;
    }

  }

  for (int i = 0; i < pos/7; i++) {
    liftODrag[i] = cofL[i]/cofD[i];
    if (liftODrag[i] > maxLiftToDrag) {
      max = i;
      maxLiftToDrag = liftODrag[i];
    }
    //std::cout << "CL/CD: " << liftODrag[i] << '\n';
  }

  wing.liftToDrag = maxLiftToDrag;
  wing.alpha = alpha[max];
  wing.lift = cofL[max];
  wing.drag = cofD[max];
  wing.fail = false;

  return wing;
}
