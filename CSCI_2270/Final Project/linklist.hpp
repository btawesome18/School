/*
  Authors: Brian Trybus and Rishi Mayekar

Rishi Mayekar: Implemented Hash, and worked on Linked list
Brian Trybus: Made testing program, Implemented BST, and worked on Linked List

*/
#ifndef linklist_H
#define linklist_H
#include<iostream>
using namespace std;

struct Node;
//define Node
struct Node{
  int key;
  Node* next = NULL;
};

class linklist
{
    public:
        void clear(); //deletes all nodes;
        void remove(int target); //deletes node with target key;
        void insert(int key); //inserts node with new key at end;
        Node* search(int key); //Returned pointer to target node;
        void display(); // Prints all keys in order;

    private:
        Node* Root=NULL;
};

#endif
