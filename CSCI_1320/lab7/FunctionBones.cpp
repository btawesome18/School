#include<iostream>
#include<cstdlib>
#include<cmathe

using namespace std;

int roll();
//give random value 1-6 to simulate d6.

int oneTurn( bool turn);
//controls bot, or take player input
//input deturments wether it is bot or human
//ask to roll or hold then sum hte points erned and return that value

bool loopGame( int maxScore);
//takes in the maxScore ad loops tell that score is reached
//every loop calls oneTurn

int main(){
  int Max;
  bool winner;

  cout << "Set max score: " << endl;
  cin >> Max;

  winner = loopGame(Max);

  if (winner) {
    cout << "You lose"<<endl;
  } else {
    cout << "You win"<<endl;
  }

  return 0;
}

int roll(){
  // random number 1-6
  // will use dummy value of 4
  return 4;
}

int oneTurn( bool turn){
  int sum = 0, dice;
  if (turn) {
    //do while
    /* ask user to roll or hold */
    //call dice
    dice = roll();
    // loop tell they hold or roll a 3
    if (dice == 3) {
      /* return 3; */
    } else {
      /* sum = sum + dice; */
    }
    //sum points to sum
  } else {
    // do while
    /* have the computer randomnly roll or hold */
    //save points to sum
  }
  sum = 4; // dummy value
  return sum;
}

bool loopGame( int maxScore){
  // use a dowhile loops
  // alternate between human and computer as the use using i++ % 2 == 0 in an ife statment
  // save scoreHum, and scoreBot from oneTurn()
  // return 0 for human victory, and 1 for robot domination test every loop using if or satemets.
  return 1;
}
