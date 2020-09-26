/*
  Authors: Brian Trybus and Rishi Mayekar

Rishi Mayekar: Implemented Hash, and worked on Linked list
Brian Trybus: Made testing program, Implemented BST, and worked on Linked List

*/
#ifndef tree_H
#define tree_H
#include<iostream>

using namespace std;

struct NodeT;
//define Node
struct NodeT{
  int key;
  NodeT* left = NULL;
  NodeT* right = NULL;
};

class tree
{
    public:

        void clear(); //deletes all nodes;
        void remove(int target); //deletes node with target key;
        void insert(int key); //inserts node with new key at end;
        NodeT* search(int key); //Returned pointer to target node;
        void display(); // Prints all keys in order;

    private:
        NodeT* Root = NULL;
};

#endif
