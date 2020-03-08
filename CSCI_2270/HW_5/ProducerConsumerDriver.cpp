/****************************************************************/
/*                Producer Consumer Driver File                 */
/****************************************************************/
/* TODO: Implement menu options as described in the writeup     */
/****************************************************************/

#include "ProducerConsumer.hpp"
#include <iostream>
// you may include more libraries as needed

using namespace std;

/*
 * Purpose: displays a menu with options
 * @param none
 * @return none
 */
void menu()
{
	cout << "*----------------------------------------*" << endl;
	cout << "Choose an option:" << endl;
    cout << "1. Producer (Produce items into the queue)" << endl;
	cout << "2. Consumer (Consume items from the queue)" << endl;
	cout << "3. Return the queue size and exit" << endl;
	cout << "*----------------------------------------*" << endl;
}
// Use getline for reading
int main(int argc, char const *argv[])
{
	menu();
	string input;
	int amount = 0;
	ProducerConsumer *que = new ProducerConsumer();

	getline(cin,input);
	while (input!="3") {
		if (input=="1") {
			std::cout << "Enter the number of items to be produced:" << '\n';
			getline(cin,input);
			amount = stoi(input);
			for (size_t i = 0; i < amount; i++) {
				std::cout << "Item"<< (i+1)<< ":" << '\n';
				getline(cin,input);
				que->enqueue(input);
			}
		} else if (input=="2") {
			std::cout << "Enter the number of items to be consumed:" << '\n';
			getline(cin,input);
			amount = stoi(input);
			for (size_t i = 0; i < amount; i++) {
				if (que->isEmpty()) {
					std::cout << "No more items to consume from queue" << '\n';
					i = amount + 1;
				}else{
				std::cout << "Consumed: "<< que->peek() << '\n';
				que->dequeue();
			}

		}
	}
	menu();
	getline(cin,input);
	}
	std::cout << "Number of items in the queue:" << que->queueSize() << '\n';

	return 0;
}
