#include<iostream>
#include "linklist.hpp"

using namespace std;


void linklist::clear(){ //deletes all nodes;
  Node *curr = Root, *next;
  while (curr!=NULL) {
    next = curr->next;
    delete curr;
    curr = next;
  }
  Root=NULL;
}

void linklist::remove(int target){ //deletes node with target key;
  Node *curr = Root, *prev=NULL;
  while (curr!=NULL) {
    if (curr->key==target) {
      if (prev==NULL) { //Checks if it is deleting Root;
        Root = curr->next;
        delete curr;
        return;
      }else{ //If not root no other edge cases;
        prev->next=curr->next;
        delete curr;
        return;
      }
    }
    prev = curr;
    curr = curr->next;
  }
}

void linklist::insert(int key){ //inserts node with new key at end;
  Node *Add = new Node;
  Add->key = key;

  if (Root==NULL) {
    Root = Add;
    return;
  }
  Node *curr = Root->next;

  Root = Add;
  Add->next = curr;
}

Node* linklist::search(int key){ //Returned pointer to target node;
  Node *curr = Root;
  while (curr!=NULL) {
    if (curr->key==key) {
      return curr;//returns target node;
    }
    curr = curr->next;
  }
  return NULL; //if not found returns NULL
}

void linklist::display(){ // Prints all keys in order;
  Node *curr = Root;
  while (curr!=NULL) {
    std::cout << curr->key << '\n';
    curr = curr->next;
  }
}
