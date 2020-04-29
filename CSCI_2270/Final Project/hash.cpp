#ifndef linklist_H
#define linklist_H
#include <iostream>
#include "hash.hpp"

using namespace std;

node* HashTable::createNode(int key, node* next) {
    node* nnNode = new node;
    nnNode->key = key;
    nnNode->next = next;
    return nnNode;
}

HashTable::HashTable(int bsize) {
    table = new node* [bsize];
    tableSize = bsize;
}

void HashTable::addvals() {

    cout << "Adding 10, 5, 2, 1, 9" << endl;

    //table[1] = createNode(5, NULL);
    table[2] = createNode(2, NULL);
    table[2]->next = createNode(4, NULL);
    table[2]->next->next = createNode(7, NULL);
    table[3] = createNode(1, NULL);
    table[0] = createNode(10, NULL);
    table[0]->next = createNode(8, NULL);
    //table[4] = createNode(9, NULL);

    cout << "added" << endl;

}

void HashTable::linearProbe(int mapVal, int key) {

    while(table[mapVal] != NULL) {
        if(mapVal >= tableSize) {
            mapVal = 0;
        } else {
            mapVal++;
        }
    }

    table[mapVal] = createNode(key, NULL);
}

void HashTable::quadraticProbe(int mapVal, int key) {

    int increment = 0;
    while(table[mapVal] != NULL) {
        cout << "increment: " << increment << endl;

        if(mapVal >= tableSize - 1) {
            mapVal = 0;
        }
        increment++;
        mapVal = mapVal + (increment*increment);
    }

    cout << "spot found" << endl;

    table[mapVal] = createNode(key, NULL);
}

bool HashTable::insertItem(int key) {
    unsigned int mapValue = hashFunction(key);
    if(table[mapValue] != NULL) {
        cout << "commencing probing map value: " << mapValue << " and key: " << key << endl;
        quadraticProbe(mapValue, key);

    } else {
        table[mapValue] = createNode(key, NULL);
    }
}

// hash function to map values to key
unsigned int HashTable::hashFunction(int key) {
    return key % tableSize;
}

void HashTable::printTable() {

    for(int i=0; i<tableSize; i++) {
        if(table[i] != NULL) {
            cout << table[i]->key;
            if(table[i]->next != NULL) {
                node* current = table[i]->next;
                while(current!=NULL) {
                    cout << " -> " << current->key;
                    current = current->next;
                }

            }
        }
        cout << endl;
    }
}

int HashTable::getNumOfCollision() {
    return numOfcolision;
}

node* HashTable::searchItem(int key) {

    for(int i=0; i<tableSize; i++) {

        if(table[i] != NULL) {
            if(table[i]->key != key) {
                node* current = table[i];
                while(current != NULL) {
                    if(current->key == key) {
                        return current;
                    }
                    current = current->next;
                }
            } else {
                return table[i];
            }
        }

    }
}

#endif
