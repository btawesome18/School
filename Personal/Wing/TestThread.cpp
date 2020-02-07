#include <iostream>
#include <string>
#include <fstream>
#include <thread>
#include <ctime>

using namespace std;

void runXfoil(string Naca, int Ren, double Mach, int Iter, double AoAMax, double AoAMin, double AoAIter, bool graph);

void killTimer(int seconds, bool *toLive );

int main(int argc, char const *argv[]) {
  string Naca = "9802";
  bool toLive = true, *p;
  p = &toLive;


  thread compute(runXfoil,Naca,200000,.05,100,10,-2,.5,1);

  thread killer(killTimer,120, p);

  compute.join();
  toLive = false;
  killer.join();


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
