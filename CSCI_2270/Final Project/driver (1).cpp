#include "hash.hpp"
#include <iostream>

int main() {

    HashTable newHash(5);

    newHash.printTable();

    cout << "looking for 4" << endl;
    cout << newHash.searchItem(4)->key << endl;

    newHash.insertItem(25, 1);
    newHash.insertItem(85, 1);
    newHash.insertItem(45, 1);
    newHash.insertItem(75, 3);
    newHash.insertItem(15, 3);

    newHash.printTable();
    cout << "No. of collisions: " << newHash.getNumOfCollision() << endl;

}