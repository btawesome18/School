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
    for (size_t i = 0; i < bsize; i++) {
      *(table+i)=NULL;
    }
}

void HashTable::addvals() {

    //cout << "Adding 10, 5, 2, 1, 9" << endl;

    //table[1] = createNode(5, NULL);
    table[2] = createNode(2, NULL);
    table[2]->next = createNode(4, NULL);
    table[2]->next->next = createNode(7, NULL);
    table[3] = createNode(1, NULL);
    table[0] = createNode(10, NULL);
    table[0]->next = createNode(8, NULL);
    //table[4] = createNode(9, NULL);

    //cout << "added" << endl;

}

void HashTable::linearProbe(int mapVal, int key) {

    while(table[mapVal] != NULL) {
        if(mapVal >= tableSize-1) {
            mapVal = 0;
        } else {
            mapVal++;
        }
        numOfcolision++;
    }

    //cout << "spot found at " << mapVal << endl;
    table[mapVal] = createNode(key, NULL);
}

void HashTable::quadraticProbe(int mapVal, int key) {

    int increment = 0;
    while(table[mapVal] != NULL) {

        increment++;
        mapVal = (mapVal + (increment*increment))%tableSize;


    }

    numOfcolision += increment;

    //cout << "spot found at " << mapVal << endl;

    table[mapVal] = createNode(key, NULL);
}

void HashTable::LLchain(int mapVal, int key) {
    node* current = table[mapVal];
    while(current->next != NULL) {
        current = current->next;
    }
    current->next = createNode(key, NULL);
}

bool HashTable::insertItem(int key, int option) {

    unsigned int mapValue = hashFunction(key);

    if(table[mapValue] != NULL) {
        //cout << "commencing probing map value: " << mapValue << " and key: " << key << endl;

        if(option == 1) {
            linearProbe(mapValue, key);
        } else if(option == 2) {
            quadraticProbe(mapValue, key);
        } else if(option == 3) {
            LLchain(mapValue, key);
        }

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

node* HashTable::searchItem(int key, int option) {

    int index = hashFunction(key);

    if(option == 1) {
        while(true) {
            if(index >= tableSize) {
                index = 0;
            }
            if(table[index]->key == key) {
                return table[index];
            }

            index++;
        }

    } else if(option == 2) {

        int increment = 0;

        while(true) {

            increment++;
            index = index + increment^2;
            //cout<<"Increment: "<<increment<<endl;

            while(index >= tableSize) {
                index = index-tableSize;
            }

            if(table[index]!=NULL) {
                if(table[index]->key == key) {
                    return table[index];
                }

            }
        }

    } else if(option == 3) {


        node* current = table[index];

        while(current != NULL) {
            if(current->key == key) {
                return current;
            }
            current = current->next;
        }

        return NULL;
    }


}

#endif
