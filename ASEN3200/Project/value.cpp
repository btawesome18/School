#include <iostream>
#include <string>
#include <ctime>
#include <cmath>
#include <cstdlib>
#include <fstream>
#include <vector>

using namespace std;


struct launch{
  float a=0;
  float e=0;
  float i=0;
  float Om=0;
  float om=0;
  char numSat=0;
};

struct constillation{
  int numSatTotal=0;
  int numLaunches=0;
  vector<launch> launches;
};

struct genSummery{
  float fitness;
  float aveFit;
  constillation val;
};

struct city{
  int population =0;
  float pos[3];
};

float calcFitnessOfConst(constillation element, city citys[],  int length);

float valueAtPoint(float x, float y, float z, city citys[],  int length, float maxAngle);

int main(int argc, char const *argv[]) {


  int length =41001;
  int count1 =0;
  city citys[length];
  string line;
  std::ifstream myFileIn("AllCities.csv");
  while (getline(myFileIn, line, ',')) {
    citys[count1].pos[0]=stof(line);
    getline(myFileIn, line, ',');
    citys[count1].pos[1]=stof(line);
    getline(myFileIn, line, ',');
    citys[count1].pos[2]=stof(line);
    getline(myFileIn, line);
    citys[count1].population = (int)stof(line);
    count1++;
  }
  length = count1;
  constillation constillation;
  launch rocket;

  constillation.numSatTotal = 360;
  constillation.numLaunches = 11;
  constillation.launches.resize(11);
  rocket.numSat = 32;
  rocket.a = 7432;
  rocket.e = 0.076693500000000;
  rocket.i = 0.605355000000000;
  rocket.Om = 0.700906000000000;
  rocket.om = 0;
  constillation.launches[0] = rocket;
  rocket.numSat = 31;
  rocket.a = 7036;
  rocket.e = 0.012048300000000;
  rocket.i = 0.906087000000000;
  rocket.Om = 0.076276500000000;
  rocket.om = 0.785398000000000;
  constillation.launches[1] = rocket;
  rocket.numSat = 38;
  rocket.a = 6950;
  rocket.e = 4.554090000000000e-04;
  rocket.i = 0.043312600000000;
  rocket.Om = 0.643086000000000;
  rocket.om = 1.570800000000000;
  constillation.launches[2] = rocket;
  rocket.numSat = 43;
  rocket.a = 7372;
  rocket.e =0.042986800000000;
  rocket.i = 0.360027000000000;
  rocket.Om = 0.981944000000000;
  rocket.om = 2.356190000000000;
  constillation.launches[3] = rocket;
  rocket.numSat = 48;
  rocket.a = 7470;
  rocket.e =0.096113900000000;
  rocket.i = 0.024683400000000;
  rocket.Om = 0.416047000000000;
  rocket.om = 3.141590000000000;
  constillation.launches[4] = rocket;
  rocket.numSat = 38;
  rocket.a = 7335;
  rocket.e =0.042047800000000;
  rocket.i = 0.727659000000000;
  rocket.Om = 0.300849000000000;
  rocket.om = 3.926990000000000;
  constillation.launches[5] = rocket;
  rocket.numSat = 30;
  rocket.a = 7169;
  rocket.e =0.076897100000000;
  rocket.i = 0.940060000000000;
  rocket.Om = 0.377291000000000;
  rocket.om = 4.712390000000000;
  constillation.launches[6] = rocket;
  rocket.numSat = 42;
  rocket.a = 7340;
  rocket.e =00.006411490000000;
  rocket.i = 00.361489000000000;
  rocket.Om = 00.485900000000000;
  rocket.om = 5.497790000000000;
  constillation.launches[7] = rocket;
  rocket.numSat = 28;
  rocket.a = 7069;
  rocket.e =0.017110900000000;
  rocket.i = 0.6647210000000000;
  rocket.Om = 4.12861500000000000;
  rocket.om = 0.3223080000000000;
  constillation.launches[8] = rocket;
  rocket.numSat = 14;
  rocket.a = 6802;
  rocket.e = 0.063752400000000;
  rocket.i = 0.8322300000000000;
  rocket.Om = 4.281285000000000;
  rocket.om = 0.126673000000000;
  constillation.launches[9] = rocket;
  rocket.numSat = 16;
  rocket.a = 6783;
  rocket.e = 0.046591200000000;
  rocket.i = 0.802851000000000;
  rocket.Om = 4.425544000000000;
  rocket.om = 0.479107000000000;
  constillation.launches[10] = rocket;
  //constillation is defined
  std::cout << "Value: "<< calcFitnessOfConst(constillation, citys, length) << '\n';


  return 0;
}

float calcFitnessOfConst(constillation element, city citys[],  int length){
  // Needs to propagate the orbits of each const and then calculate the fitness of that constillation.
  //std::cout << "Is running constillation." << '\n';
  int costConst = (element.numLaunches*100) + (element.numSatTotal*5);
  int profit =0;
  float fit =0;
  short timestep = 30;
  int timespan = 86400;
  float a=0;
  float e=0;
  float i=0;
  float Om=0;
  float om=0;
  short numSat=0;
  short Re = 6378;
  launch rocket;
  int MU = 398600;
  float J2 = 1.087*(10^-3);
  float maxAngle = 0.261799387799149;
  float n=0;
  float p=0;
  float rotRate = -7.29211505392569*(10^-05);
  float OmegaDot = 0;
  float wDot = 0;
  float w = 0;
  float Omega = 0;
  float P = 0;
  float E = 0;
  float f = 0;
  float R = 0;
  float ratio = 1;
  int tOff =0;
  char numSats = 0;
  float rx = 0;
  float ry = 0;
  float rz = 0;
  float j = 0;
  float valSum = 0;
  for (size_t inc = 0; inc < element.numLaunches; inc++) {
    //std::cout << "Launch: "<< inc << '\n';
    rocket = element.launches[inc];
    a = rocket.a;
    e = rocket.e;
    i = rocket.i;
    Om = rocket.Om;
    om = rocket.om;
    numSats = rocket.numSat;
    n = sqrt(MU/(a*a*a));
    p = a*(1-(e*e));
    OmegaDot = -1.5*J2*sqrt(MU/(a*a*a))*(Re/p)*cos(i);
    wDot = 0.75*n*J2*((Re/(p))*(Re/(p)))*(2-(2.5*(sin(i)*sin(i))));
    P = 6.28318530717959/n;
    // Find
    for (size_t t = 0; t < timespan; t+=timestep) {
      //true anomaly will be based off of period and number of sats to give even spacing
      //std::cout << "Time: "<< t << '\n';
      w = om + (wDot*t);
      Omega = Om+(OmegaDot*t);
      for (size_t satCur = 0; satCur < numSats; satCur++) {
        //std::cout << "Sat: "<< satCur;
        tOff = t + ((P/numSats)*satCur); //This gives the time offset for each sat.

        numSats = 0;
        if ((n*tOff)<3.14159265358979) {
          E = (n*tOff)+(e/2);
        } else {
          E = (n*tOff)-(e/2);
        }
        ratio = 1;
        while (abs(ratio)>(0.00000001)&&(numSats<20)) {
          ratio = (E - e*sin(E) - (n*tOff))/(1 - e*cos(E));
          E = E-ratio;
          numSats++;
        }

        f = 2*atan((sqrt((1+e)/(1-e)))*tan(E/2));
        R = a*(1-(e*cos(E)));
        j = (rotRate*t);//Not sure if this should be t or tOff
        rx = (R*cos(j)*cos(f)*cos(w)*cos(Omega))-(cos(i)*R*cos(j)*cos(f)*sin(w)*sin(Omega))+(R*cos(j)*sin(f)*cos(w)*sin(Omega))+(cos(i)*R*cos(j)*sin(f)*sin(w)*cos(Omega))-(R*sin(j)*cos(f)*sin(w)*cos(Omega))-(cos(i)*R*sin(j)*cos(f)*cos(w)*sin(Omega))+(cos(i)*R*sin(j)*sin(f)*cos(w)*cos(Omega))-(R*sin(j)*sin(f)*sin(w)*sin(Omega));
        ry = (-R*cos(j)*cos(f)*sin(w)*cos(Omega))-(cos(i)*R*cos(j)*cos(w)*sin(Omega))+(cos(i)*R*cos(j)*sin(f)*cos(w)*cos(Omega))-(R*cos(j)*sin(f)*sin(w)*sin(Omega))-(R*sin(j)*cos(f)*cos(w)*cos(Omega))+(cos(i)*R*sin(j)*cos(f)*sin(w)*sin(Omega))-(R*sin(j)*sin(f)*cos(w)*sin(Omega))-(cos(i)*R*sin(j)*sin(f)*sin(w)*cos(Omega));
        rz = (sin(i)*R*cos(j)*sin(Omega))-(sin(i)*R*sin(j)*cos(Omega));
        valSum = valSum + (valueAtPoint(rx,ry,rz,citys,length,maxAngle)*timestep);
        //std::cout << " Value: "<< valSum << '\n';
      }
    }
  }
  //std::cout << "Const done" << '\n';
  return (valSum/timespan);
}

float valueAtPoint(float x, float y, float z, city citys[],  int length, float maxAngle){
  float cx = 0;
  float cy = 0;
  float cz = 0;
  float vecx = 0;
  float vecy = 0;
  float vecz = 0;
  float norm = 0;
  float dot = 0;
  float sum = 0;
  for (size_t i = 0; i < length; i++) {
    //Get current city
    cx = citys[i].pos[0];
    cy = citys[i].pos[1];
    cz = citys[i].pos[2];

    //line from city to sat
    vecx = x - cx;
    vecy = y - cy;
    vecz = z - cz;
    //City hat
    norm = sqrt((cx*cx)+(cy*cy)+(cz*cz));
    cx = cx/norm;
    cy = cy/norm;
    cz = cz/norm;
    //find vechat
    norm = sqrt((vecx*vecx)+(vecy*vecy)+(vecz*vecz));
    vecx = vecx/norm;
    vecy = vecy/norm;
    vecz = vecz/norm;
    //do the dot product
    dot = (cx*vecx)+(cy*vecy)+(cz*vecz);

    if (asin(dot)>maxAngle) {
      //std::cout << "Wow: " << sum << '\n';
      sum = sum +(citys[i].population);
    }
  }
  return sum;
}
