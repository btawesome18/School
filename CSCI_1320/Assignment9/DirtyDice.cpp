#include<iostream>
#include<cstdlib>
#include<ctime>

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

  srand(time(0));// seed the random number generator

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
  int temp = ((rand()%6)+1);
  cout << "Rolled " << temp << endl;
  // random number 1-6
  // will use dummy value of 4
  return temp;
}

int oneTurn( bool turn){
  int turns = 0, thresh = 0,rolls = 0, dice;
  bool hold;
  if(turn){
    do{

      cout << "Roll or hold(1 roll, 0 hold)" <<endl;
      cin >> hold;
      dice = roll();
      turns = turns + dice;
      rolls++;
      if(dice == 3){
        hold = 0;
        turns = -3;
      }

    }while(hold);
    cout << "This round: " << turns << " points and " << rolls << " rolls" << endl;
    return turns;
  }else{
    do{
       if(thresh > 2){
         hold = rand()%2;
         if (hold) {
           cout << "Bot: Roll " <<endl;
         } else {
           cout << "Bot: Hold " <<endl;
         }
       }else{
         hold = 1;
         thresh++;
         cout << "Bot: Roll " <<endl;
       }

      dice = roll();
      rolls++;
      turns = turns + dice;
      if(dice == 3){
        hold = 0;
        turns = -3;
      }
    }while(hold);
    cout << "(Bot)This round: " << turns << " points and " << rolls << " rolls" << endl;
    return turns;
  }
}

bool loopGame( int maxScore){
  int scoreBot=100, scoreHum=100,counter=0, temp = 0;

  do {
    if (counter++%2 == 0) {
      temp = oneTurn(1);
      if (temp == -3) {
        scoreBot = scoreBot + 3;
      }
      scoreHum = scoreHum + temp;
    } else {
      temp = oneTurn(0);
      if (temp == -3) {
        scoreHum = scoreHum + 3;
      }
      scoreBot = scoreBot + temp;
    }
cout << "Bot Score: " << scoreBot << endl;
cout << "Your Score: " << scoreHum << endl;
  } while((scoreBot < maxScore)&&(scoreHum < maxScore));
  cout << "Bot Score: " << scoreBot << endl;
  cout << "Your Score: " << scoreHum << endl;
  // use a dowhile loops
  // alternate between human and computer as the use using i++ % 2 == 0 in an ife statment
  // save scoreHum, and scoreBot from oneTurn()
  // return 0 for human victory, and 1 for robot domination test every loop using if or satemets.
  if (scoreBot > scoreHum) {
    return 1;
  } else {
    return 0;
  }
}
