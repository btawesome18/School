// Program for calculating freefall distance as a function of time
// d = 1/2 * g * t^2


#include <iostream>
#include <string>

using namespace std;

int main( )
{
	int d;
	const int g = 9.8;
	int t = 10;

	cout << "enter time: " << endl;
	cin >> t;

	d = 1/2.0 * g * t;

	cout << "distance = " << d << endl;


	return 0;
}
