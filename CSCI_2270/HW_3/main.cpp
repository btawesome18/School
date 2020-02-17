/****************************************************************/
/*                   Assignment 3 Driver File                   */
/****************************************************************/
/* TODO: Implement menu options as described in the writeup     */
/****************************************************************/

#include "CountryNetwork.hpp"
#include <iostream>
#include <fstream>

void displayMenu();  // declaration for main's helper-function

int main(int argc, char* argv[])
{
    // Object representing our network of cities.
    // (Linked list representation is in CountryNetwork)
    CountryNetwork CountryNet;

    // TODO
    int choice = 0;
    bool flag = true, populated = false;
    string message, target, temp;
    while (flag) {
      displayMenu();
      getline(cin,temp,'\n');
      choice = stoi(temp);
      switch (choice) {
        case 1:{
          CountryNet.loadDefaultSetup();
          CountryNet.printPath();
          populated = true;
          break;
        }
        case 2:{
          CountryNet.printPath();
          break;
        }
        case 3:{
          std::cout << "Enter name of the country to receive the message:" << '\n';
          getline(cin,target, '\n');
          std::cout << "Enter the message to send:" << '\n'<<'\n';
          getline(cin,message,'\n');
          if (!populated&&(CountryNet.searchNetwork(target) == NULL)) {
            std::cout << "Empty list" << '\n';
          }else if (populated&&(CountryNet.searchNetwork(target) == NULL)){
            std::cout << "Country not found" << '\n';
          }else
          CountryNet.transmitMsg(target, message);
          break;
        }
        case 4:{
          std::cout << "Enter a new country name:" << '\n';
          getline(cin,message,'\n');
          std::cout << "Enter the previous country name (or First):" << '\n';
          getline(cin,target,'\n');
          if (target == "First") {
            CountryNet.insertCountry(NULL,message);
            CountryNet.printPath();
          }else{
            Country *temp = CountryNet.searchNetwork(target);
            while ((temp == NULL)) {
              std::cout << "INVALID(previous country name)...Please enter a VALID previous country name!" << '\n';
              getline(cin,target,'\n');
              temp = CountryNet.searchNetwork(target);
            }
            CountryNet.insertCountry(temp, message);
            CountryNet.printPath();
          }
          populated = true;
          break;
        }
        case 5:{
          std::cout << "Quitting...\nGoodbye!" << '\n';
          flag = false;
          break;
        }
      }
    }


    return 0;
}


/*
 * Purpose; displays a menu with options
 */
void displayMenu()
{
    cout << "Select a numerical option:" << endl;
    cout << "+=====Main Menu=========+" << endl;
    cout << " 1. Build Network " << endl;
    cout << " 2. Print Network Path " << endl;
    cout << " 3. Transmit Message " << endl;
    cout << " 4. Add Country " << endl;
    cout << " 5. Quit " << endl;
    cout << "+-----------------------+" << endl;
    cout << "#> ";
}
