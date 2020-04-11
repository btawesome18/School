#include <iostream>
#include <string>
#include <fstream>
#include <thread>
#include <ctime>

using namespace std;

void runXfoil(string Naca, int Ren, double Mach, int Iter, double AoAMax, double AoAMin, double AoAIter, bool graph);

void killTimer(int seconds, bool *toLive);

int main(int argc, char const *argv[]) {
  string naca, renMinS, renMaxS, cLMinS;
  if(argc == 1){
    std::cout << "No foil specifyed" << '\n';
    return 1;
  }
  if (argc==2) {
    std::cout << "No min renolds" << '\n';
    return 2;
  }
  if (argc==3) {
    std::cout << "No max renolds" << '\n';
    return 3;
  }
  if (argc==4) {
    std::cout << "No min Cl" << '\n';
    return 4;
  }
  naca = argv[1];
  renMinS = argv[2];
  renMaxS = argv[3];
  cLMinS = argv[4];

  int renMax, renMin;
  double cLMin;
  bool toLive = true, *p;

  p = &toLive;
  renMax = stoi(renMaxS);
  renMin = stoi(renMinS);
  cLMin = stod(cLMinS);

  for(int i = 10000; i < 30000000; i+=1000){
    std::cout << "/* message */" << '\n';
    thread compute(runXfoil,"8320",i,0.12,100,10,-2,.5,true);
    std::cout << "huu" << '\n';

    thread killer(killTimer,120, p);

    compute.join();
    toLive = false;
    killer.join();
    toLive = true;
    std::cout << "Wow" << '\n';
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
  ofs<<"Naca "<<Naca<<"\nOper\nVisc\n"<<Ren<<"\nMach "<<Mach<<"\nIter "<< Iter <<"\nPacc\nNACA"<<Naca<<Ren<<"Pol\n\n"<<"ASeq "<< AoAMin << " "<< AoAMax << " " << AoAIter << "\n \n \n \nQuit\n";
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
