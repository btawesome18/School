#include <iostream>
#include <string>
#include <fstream>
#include <sstream>



using namespace std;

void runXfoil(int Naca, int Ren, double Mach, int Iter, double AoAMax, double AoAMin, double AoAIter, bool graph);

int main(int argc, char const *argv[]) {
  stringstream str1;
  stringstream str2;
  stringstream str3;
  stringstream str4;
  stringstream str5;
  stringstream str6;
  stringstream str7;
  stringstream str8;

    str1 << argv[1];
    str2 << argv[2];
    str3 << argv[3];
    str4 << argv[4];
    str5 << argv[5];
    str6 << argv[6];
    str7 << argv[7];
    str8 << argv[8];

  int Naca ;
  int Ren ;
  double Mach ;
  int Iter ;
  double AoAM ;
  double AoAm ;
  double AoAi ;
  bool g ;
  str1 >> Naca;
  str2 >> Ren;
  str3 >> Mach;
  str4 >> Iter;
  str5 >> AoAM;
  str6 >> AoAm;
  str7 >> AoAi;
  str8 >> g;



  runXfoil(Naca,Ren,Mach,Iter,AoAM,AoAm,AoAi,g);


  return 0;
}

void runXfoil(int Naca, int Ren, double Mach, int Iter, double AoAMax, double AoAMin, double AoAIter, bool graph){
  const char command[1000] = "cd /mnt/c/Users/Brian/Documents/Classes/School/Personal/Wing && ./xfoil.exe < xfoilInput.txt";
  fstream ofs;
  ofs.open("xfoilInput.txt", ios::out | ios::trunc);
  if (graph) {
    ofs<<"Plop \nG\n\n";
  }
  ofs<<"Naca "<<Naca<<"\nOper\nVisc\n"<<Ren<<"\nMach "<<Mach<<"\nIter "<< Iter <<"\nPacc\nNACA"<<Naca<<"Pol\n\n"<<"ASeq "<< AoAMin << " "<< AoAMax << " " << AoAIter << "\nquit\n";
  ofs.close();
  system(command);
}
