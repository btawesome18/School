#include<iostream>
#include "linklist.hpp"

using namespace std;

void clear(){ //deletes all nodes;
}

void remove(int target){ //deletes node with target key;
}

void insert(int key){ //inserts node with new key at end;
  Node *Insr, *curr, *prev;
  Insr->key = key;
  if (Root==NULL) {
    Root = Insr;
    return;
  }
  curr = Root;
  while (curr!=NULL) {
    prev = curr;
    if (key>curr->key) {
      curr = curr->right;
    }else{
      curr=curr->left;
    }
  }
  if (key>prev->key) {
    prev->right = Insr;
  }else{
    prev->left = Insr;
  }

}

Node* recusSearch(int key, Node *curr);

Node* recusSearch(int key, Node *curr){
  if (curr==NULL) {
    return NULL;
  }
  if (curr->key==key) {
    return curr;
  }
  if (curr->key<key) {
    return recusSearch(key,curr->right);
  }else{
    return recusSearch(key,curr->left);
  }
}

Node* search(int key){ //Returned pointer to target node;
  return recusSearch(key,Root);
}

void display(){ // Prints all keys in order;
}
