/*
  Authors: Brian Trybus and Rishi Mayekar

Rishi Mayekar: Implemented Hash, and worked on Linked list
Brian Trybus: Made testing program, Implemented BST, and worked on Linked List

*/


#ifndef HASH_HPP
#define HASH_HPP

#include <string>


using namespace std;

struct node
{
    int key;
    struct node* next;
};

class HashTable
{
    int tableSize;  // No. of buckets (linked lists)

    // Pointer to an array containing buckets
    node* *table;
    int numOfcolision =0;
    node* createNode(int key, node* next);
public:
    HashTable(int bsize);  // Constructor

    // inserts a key into hash table
    bool insertItem(int key, int option);
    void addvals();

    void linearProbe(int mapVal, int key);
    void quadraticProbe(int mapVal, int key);
    void LLchain(int mapVal, int key);

    // hash function to map values to key
    unsigned int hashFunction(int key);

    void printTable();
    int getNumOfCollision();

    node* searchItem(int key, int option);
};

#endif
