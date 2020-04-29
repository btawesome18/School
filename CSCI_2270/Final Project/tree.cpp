#include<iostream>
#include "tree.hpp"

using namespace std;

void removeH(NodeT *node);
//Helper to remove all Nodes;
void removeH(NodeT *node){
  if (node == NULL) {
    return;
  }
  if (node->right!=NULL) {
    removeH(node->right);
  }
  if (node->left!=NULL) {
    removeH(node->left);
  }
  delete node;
}

void tree::clear(){ //deletes all nodes;
  removeH(Root);
}


void tree::insert(int key){ //inserts node with new key at end;
  NodeT *Insr, *curr, *prev;
  Insr = new NodeT;
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

NodeT* recusSearch(int key, NodeT *curr);

NodeT* recusSearch(int key, NodeT *curr){
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

NodeT* tree::search(int key){ //Returned pointer to target node;
  return recusSearch(key,Root);
}

void dispHelp(NodeT *curr) {
  if (curr == NULL) {
    return;
  }
  dispHelp(curr->left);
  std::cout << curr->key << '\n';
  dispHelp(curr->right);
}

void tree::display(){ // Prints all keys in order;
  dispHelp(Root);
}
