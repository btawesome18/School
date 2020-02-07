#include <iostream>
#include <string>
#include <fstream>
#include <thread>
//#include <chrono>
#include <ctime>

using namespace std;

void runXfoil(string Naca, int Ren, double Mach, int Iter, double AoAMax, double AoAMin, double AoAIter, bool graph);

void killTimer(int seconds, bool *toLive);

int main(){

  //const char arg[1000] = command;
  std::cout << "wow" << '\n';
  string Naca;
//  runXfoil(2110,200000,.05,250,10,-2,.5,0);
//  runXfoil(2112,200000,.05,250,10,-2,.5,0);
  int test;
  bool toLive = true, *p;

  p = &toLive;

  for (int i = 0; i < 10; i++) {
    for (int t = 0; t < 10; t++) {
      for (int u = 2; u < 42; u+=2) {
        Naca = to_string(i)+to_string(t);
        if (u>=10) {
          Naca = Naca + to_string(u);
        }else{
          Naca = Naca + "0" + to_string(u);
        }
        //std::cout << Naca << '\n';
        //std::cin >> test;

        thread compute(runXfoil,Naca,200000,.05,100,10,-2,.5,1);

        thread killer(killTimer,120, p);

        compute.join();
        toLive = false;
        killer.join();
        toLive = true;
      }
    }
  }


  return 0;
}

void runXfoil(string Naca, int Ren, double Mach, int Iter, double AoAMax, double AoAMin, double AoAIter, bool graph){
  const char command[1000] = "cd /mnt/c/Users/Brian/Documents/Classes/School/Personal/Wing && ./xfoil.exe < xfoilInput.txt";
  fstream ofs;
  ofs.open("xfoilInput.txt", ios::out | ios::trunc);
  if (graph) {
    ofs<<"Plop \nG\n\n";
  }
  ofs<<"Naca "<<Naca<<"\nOper\nVisc\n"<<Ren<<"\nMach "<<Mach<<"\nIter "<< Iter <<"\nPacc\nNACA"<<Naca<<"Pol\n\n"<<"ASeq "<< AoAMin << " "<< AoAMax << " " << AoAIter << "\n \n \n \nQuit\n";
  ofs.close();
  system(command);

}

void killTimer(int seconds, bool *toLive){
  const char command[1000] = "pkill xfoil";
  bool timeGo = true;
  time_t start_time = time(NULL);
  time_t current_time = time(NULL);

    while ((*toLive)&&(timeGo)) { //(*target).joinable()
      time_t current_time = time(NULL);
      if ((start_time+seconds)>=current_time) {
        system(command);
      }
    }
}
