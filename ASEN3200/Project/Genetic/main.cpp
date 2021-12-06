#include <iostream>
#include <string>
#include <ctime>
#include <cmath>
#include <cstdlib>
#include <fstream>
#include <vector>


//#include<time.h>


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

float calcAve(float fitness[], int size);

genSummery runGeneration(constillation population[], int populationSize, int mutationRate, float fitness[], city citys[] ,  int length);

void causeMutation(constillation population[], int populationSize, int mutationRate);

constillation breed(constillation parent1, constillation parent2);

void buildMatingPool(float fitnessPer[], int parents[], int arrySize, int factor);

float sumArryD(float arry[], int arrySize);

constillation randCosntilation();

int calculateFitness(constillation population[], float fitness[], int size, city citys[] ,  int length);

float calcFitnessOfConst(constillation element, city citys[],  int length);

int compareString(string test, string sample);

void buildPopulation(constillation poulation[], int size);

float valueAtPoint(float x, float y, float z, city citys[],  int length, float maxAngle);

int main(){
  srand(time(0));
  int populationSize = 10;
  constillation population[populationSize];
  genSummery Current;
  int genCount = 0;
  string fileName = "output1.csv";
  float fitnessPer[populationSize];
  ofstream myfile;

  int startTime, endTime;
  double execTime;
  int genTotal = 0;
  //myfile.open("time.csv");

  //Need to import the citys
  int length =500;
  int count1 =0;
  city citys[length];
  string line;
  std::ifstream myFileIn("city500.csv");
  while (getline(myFileIn, line, ',')) {
    citys[count1].pos[0]=stof(line);
    getline(myFileIn, line, ',');
    citys[count1].pos[1]=stof(line);
    getline(myFileIn, line, ',');
    citys[count1].pos[2]=stof(line);
    getline(myFileIn, line);
    citys[count1].population = stoi(line);
    count1++;
  }

  startTime = clock();


    fileName = "output.csv";

    Current.fitness = 0;
    myfile.open(fileName);
    genCount = 0;

    buildPopulation(population, populationSize);

    while ((genCount < 100)) { //can add a target here so it will stop when it meets a goal
      genCount++;
      Current = runGeneration(population, populationSize, 2, fitnessPer,  citys , length);
      std::cout << "New Gen: " << genCount << '\n';
      /*
      cout << "Gen: " << genCount <<" Fitness Max: " << Current.fitness  <<" Text: " << Current.text << '\n';
      myfile << genCount << "," << Current.fitness <<   ",";
      for (int i = 0; i < populationSize; i++) {
        myfile << fitnessPer[i] << ",";
      }
      myfile << "\n";
      */
    }
    //endTime = clock();
    //execTime = (double)(endTime-startTime)/CLOCKS_PER_SEC;

    genTotal = genTotal + genCount;
  //  myfile << execTime << ",";
    //myfile.close();

  //  myfile.close();
  endTime = clock();
  execTime = (double)(endTime-startTime)/CLOCKS_PER_SEC;
  cout << "Ave execution time: " << execTime/1 << " GenAverage: " << genTotal/1.0 <<endl;

  return 0;
}

void buildPopulation(constillation poulation[], int size){

  for (int i = 0; i < size; i++) {

    poulation[i] = randCosntilation(); //Adds a constilation to array at index i

  }

}

constillation randCosntilation(){
  constillation temp;
  int count = 0;
  launch rocket;
  temp.numLaunches = (rand()%10)+3; //between 3 and 13
  count = temp.numLaunches;
  temp.numSatTotal = 0;
  temp.launches.resize(count);
  for (size_t i = 0; i < count; i++) {
    //r must be between 6728 and 7478, 750km range
    rocket.a = (rand()%750)+6728;
    rocket.e = fmodf(((float)rand() / (RAND_MAX)),(((1-(((float)6728)/rocket.a))-((((float)7478)/rocket.a)-1)))+(1-(((float)6728)/rocket.a)));//(((float)rand() / (RAND_MAX))%(((1-(((float)6728)/rocket.a))-((((float)7478)/rocket.a)-1)))+(1-(((float)6728)/rocket.a));
    rocket.i = fmodf(((float)rand() / (RAND_MAX)),6.28318530717959);//((float)rand() / (RAND_MAX))%6.28318530717959;
    rocket.Om = fmodf(((float)rand() / (RAND_MAX)),6.28318530717959); //((float)rand() / (RAND_MAX))%6.28318530717959;
    rocket.om = fmodf(((float)rand() / (RAND_MAX)),6.28318530717959);//((float)rand() / (RAND_MAX))%6.28318530717959;
    rocket.numSat = rand()%50;
    temp.launches[i] = rocket;
    temp.numSatTotal = temp.numSatTotal + rocket.numSat;
  }
  return temp;
}

int calculateFitness(constillation population[], float fitness[], int size, city citys[] ,  int length){
  //returns the index of the best one for that gen, and puts fitness of rest in fitness array.
  //size is population size
  // length is size of citys
  //citys has population and possition of each city.
  float fitInt[size];
  int champInx = 0;
  float champFit = 0;
  for (int i = 0; i < size; i++) {
    fitInt[i] = calcFitnessOfConst(population[i], citys, length);
    if( fitInt[i] > champFit){
      champFit = fitInt[i];
      champInx = i;
    }
  }
  return champInx;
}

float calcFitnessOfConst(constillation element, city citys[],  int length){
  // Needs to propagate the orbits of each const and then calculate the fitness of that constillation.
  //std::cout << "Is running constillation." << '\n';
  int costConst = (element.numLaunches*100) + (element.numSatTotal*5);
  int profit =0;
  float fit =0;
  short timestep = 60;
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
        while (abs(ratio)>(0.0000001)&&(numSats<20)) {
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
        valSum = valSum + valueAtPoint(rx,ry,rz,citys,length,maxAngle);
        //std::cout << " Value: "<< valSum << '\n';
      }
    }
  }
  //std::cout << "Const done" << '\n';
  return ((valSum*timestep)/((float)costConst));
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

void buildMatingPool(float fitnessPer[], int parents[], int arrySize, int factor){
  float squareFit[arrySize];

  for (int i = 0; i < arrySize; i++) {
    squareFit[i] = fitnessPer[i]*fitnessPer[i];
  }

  float weight = sumArryD(squareFit, arrySize);
  float randValue = 0;
  float testSum = 0;
  int counter = -1;

  for (int i = 0; i < arrySize; i++) {
    randValue = (rand()%int(round(weight*factor)))/factor;
    while (testSum <= randValue) {
      counter++;
      testSum = testSum + squareFit[counter];
    }
    parents[i] = counter;
    counter = -1;
    testSum = 0;

  }

}

float sumArryD(float arry[], int arrySize){
  float total = 0;
  for (size_t i = 0; i < arrySize; i++) {
    total = total + arry[i];
  }
  return total;
}

constillation breed(constillation parent1, constillation parent2){
  constillation child = parent1;
  int randomNum = 0;
  launch rocket;
  child.numLaunches = (parent1.numLaunches+parent2.numLaunches)/2;
  child.launches.resize(child.numLaunches);
  for (size_t i = 0; i < child.numLaunches; i++) {
    if ((parent1.numLaunches<=i)&&(parent2.numLaunches<=i)) {
      child.launches[i].a = (parent1.launches[i].a+parent2.launches[i].a)/2;
      child.launches[i].e = fmodf(((parent1.launches[i].e+parent2.launches[i].e)/2),(((1-(((float)6728)/child.launches[i].a))-((((float)7478)/child.launches[i].a)-1)))+(1-(((float)6728)/child.launches[i].a)));//((parent1.launches[i].e+parent2.launches[i].e)/2)%(((1-(((float)6728)/child.launches[i].a))-((((float)7478)/child.launches[i].a)-1)))+(1-(((float)6728)/child.launches[i].a));//Confine e to keep within peramiters
      child.launches[i].i = (parent1.launches[i].i+parent2.launches[i].i)/2;
      child.launches[i].Om = (parent1.launches[i].Om+parent2.launches[i].Om)/2;
      child.launches[i].om = (parent1.launches[i].om+parent2.launches[i].om)/2;
      child.launches[i].numSat = (parent1.launches[i].numSat+parent2.launches[i].numSat)/2;
    }else if((parent2.numLaunches>=i)){
      //make a random launch set
      rocket.a = (rand()%750)+6728;
      rocket.e = fmodf(((float)rand() / (RAND_MAX)),(((1-(((float)6728)/rocket.a))-((((float)7478)/rocket.a)-1)))+(1-(((float)6728)/rocket.a)));//(((float)rand() / (RAND_MAX))%(((1-(((float)6728)/rocket.a))-((((float)7478)/rocket.a)-1)))+(1-(((float)6728)/rocket.a));
      rocket.i = fmodf(((float)rand() / (RAND_MAX)),6.28318530717959);//((float)rand() / (RAND_MAX))%6.28318530717959;
      rocket.Om = fmodf(((float)rand() / (RAND_MAX)),6.28318530717959); //((float)rand() / (RAND_MAX))%6.28318530717959;
      rocket.om = fmodf(((float)rand() / (RAND_MAX)),6.28318530717959);//((float)rand() / (RAND_MAX))%6.28318530717959;
      rocket.numSat = rand()%50;
      //breed with the valid parent: parent 2
      child.launches[i].a = (rocket.a+parent2.launches[i].a)/2;
      child.launches[i].e = fmodf(((rocket.e+parent2.launches[i].e)/2),(((1-(((float)6728)/child.launches[i].a))-((((float)7478)/child.launches[i].a)-1)))+(1-(((float)6728)/child.launches[i].a)));//((rocket.e+parent2.launches[i].e)/2)%(((1-(((float)6728)/child.launches[i].e))-((((float)7478)/child.launches[i].e)-1)))+(1-(((float)6728)/child.launches[i].e));//Confine e to keep within peramiters
      child.launches[i].i = (rocket.i+parent2.launches[i].i)/2;
      child.launches[i].Om = (rocket.Om+parent2.launches[i].Om)/2;
      child.launches[i].om = (rocket.om+parent2.launches[i].om)/2;
      child.launches[i].numSat = (rocket.numSat+parent2.launches[i].numSat)/2;
    }else{
      //make a random launch set
      rocket.a = (rand()%750)+6728;
      rocket.e = fmodf(((float)rand() / (RAND_MAX)),(((1-(((float)6728)/rocket.a))-((((float)7478)/rocket.a)-1)))+(1-(((float)6728)/rocket.a)));//(((float)rand() / (RAND_MAX))%(((1-(((float)6728)/rocket.a))-((((float)7478)/rocket.a)-1)))+(1-(((float)6728)/rocket.a));
      rocket.i = fmodf(((float)rand() / (RAND_MAX)),6.28318530717959);//((float)rand() / (RAND_MAX))%6.28318530717959;
      rocket.Om = fmodf(((float)rand() / (RAND_MAX)),6.28318530717959); //((float)rand() / (RAND_MAX))%6.28318530717959;
      rocket.om = fmodf(((float)rand() / (RAND_MAX)),6.28318530717959);//((float)rand() / (RAND_MAX))%6.28318530717959;
      rocket.numSat = rand()%50;
      //breed with the valid parent: parent 1
      child.launches[i].a = (rocket.a+parent1.launches[i].a)/2;
      child.launches[i].e = fmodf(((rocket.e+parent1.launches[i].e)/2),(((1-(((float)6728)/child.launches[i].e))-((((float)7478)/child.launches[i].e)-1)))+(1-(((float)6728)/child.launches[i].e)));//((rocket.e+parent1.launches[i].e)/2)%(((1-(((float)6728)/child.launches[i].e))-((((float)7478)/child.launches[i].e)-1)))+(1-(((float)6728)/child.launches[i].e));//Confine e to keep within peramiters
      child.launches[i].i = (rocket.i+parent1.launches[i].i)/2;
      child.launches[i].Om = (rocket.Om+parent1.launches[i].Om)/2;
      child.launches[i].om = (rocket.om+parent1.launches[i].om)/2;
      child.launches[i].numSat = (rocket.numSat+parent1.launches[i].numSat)/2;
    }

  }

  return child;
}

void causeMutation(constillation population[], int populationSize, int mutationRate){
  constillation temp;
  for (int i = 0; i < populationSize; i++) {

    temp = population[i];


    if(round(mutationRate*10) >= (rand()%1000)){
      breed(temp, randCosntilation());
    }

    population[i] = temp;

  }
}

genSummery runGeneration(constillation population[], int populationSize, int mutationRate, float fitness[], city citys[] ,  int length){
  int parentsIndex1[populationSize], parentsIndex2[populationSize];

  genSummery Champ;
  int champIndex;
  constillation children[populationSize];

  champIndex = calculateFitness(population, fitness, populationSize, citys, length);

  Champ.fitness = fitness[champIndex];
  Champ.val = population[champIndex];
  Champ.aveFit = calcAve(fitness,populationSize); // They want this done in matlab.
  buildMatingPool(fitness, parentsIndex1, populationSize, 10000);
  buildMatingPool(fitness, parentsIndex2, populationSize, 10000);

  int parentTempA, parentTempB;
  for (int i = 0; i < populationSize; i++) {
    parentTempA = parentsIndex1[i];
    parentTempB = parentsIndex2[i];
    while(parentTempB == parentTempA){
      parentTempB = rand()%populationSize;
      parentTempA = rand()%populationSize;
    }
    children[i] = breed(population[parentTempA], population[parentTempB]);

  }


  causeMutation(children, populationSize, mutationRate);

  children[0] = Champ.val;

  for (int i = 0; i < populationSize; i++) {
    population[i] = children[i];
  }

  return Champ;
}

float calcAve(float fitness[], int size){
  float total = 0;
  for (int i = 0; i < size; i++) {
    total = total + fitness[i];
  }
  return (total/size);
}
