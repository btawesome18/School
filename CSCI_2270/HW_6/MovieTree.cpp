#include "MovieTree.hpp"
#include <iostream>
#include <string>
#include <fstream>
#include <sstream>

using namespace std;

// MovieNode: node struct that will be stored in the MovieTree BST

MovieTree::MovieTree() {
  //write your code
  root = NULL;
}

void remove(MovieNode *node);

void remove(MovieNode *node){
  if (node == NULL) {
    return;
  }
  if (node->right!=NULL) {
    remove(node->right);
  }
  if (node->left!=NULL) {
    remove(node->left);
  }
  delete node;
}

MovieTree::~MovieTree() {
  //write your code
  remove(root);
}

void printInvHelp(MovieNode *node);

void printInvHelp(MovieNode *node){
  if (node == NULL) {
    return;
  }
  printInvHelp(node->left);
  cout << "Movie: " << node->title << " " << node->rating << endl;
  printInvHelp(node->right);

}

void MovieTree::printMovieInventory() {
   //write your code
   if (root==NULL) {
     cout << "Tree is Empty. Cannot print" << endl;
   } else
   printInvHelp(root);

}

void addMovieHelp(MovieNode *newN, MovieNode *current);

void addMovieHelp(MovieNode *newN, MovieNode *current){
  if (newN->title > current->title) {
    if (current->right == NULL) {
      current->right = newN;
      return;
    }else{
      addMovieHelp(newN, current->right);
    }}else{
    if (current->left == NULL) {
      current->left = newN;
      return;
    }else{
      addMovieHelp(newN, current->left);
    }
  }
}

void MovieTree::addMovieNode(int ranking, string title, int year, float rating) {
  //write your code

  MovieNode *NewNode = new MovieNode(ranking, title, year, rating);
  if (root==NULL) {
    root = NewNode;
  } else {
    addMovieHelp(NewNode, root);
  }

}

void findMovHelp(MovieNode *current, string target);

void findMovHelp(MovieNode *current, string target){
  if (current == NULL) {
    cout << "Movie not found." << endl;
    return;
  }
  if (current->title==target) {
    std::cout << "Movie Info:" << '\n';
    std::cout << "==================" << '\n';
    cout << "Ranking:" << current->ranking << endl;
    cout << "Title  :" << current->title << endl;
    cout << "Year   :" << current->year << endl;
    cout << "rating :" << current->rating << endl;
    return;
  }
  if (current->title > target) {
    findMovHelp(current->left,target);
  } else {
    findMovHelp(current->right,target);
  }
}

void MovieTree::findMovie(string title) {
  //write your code
  findMovHelp(root, title);

}

void quaryHelp(MovieNode *node, float rate, int year);

void quaryHelp(MovieNode *node, float rate, int year){
  if (node == NULL) {
    return;
  }
  if (node->rating>=rate&&node->year>=year) {
    cout << node->title << "(" << node->year << ") " << node->rating << endl;
  }
  quaryHelp(node->left,rate,year);
  quaryHelp(node->right,rate,year);

}

void MovieTree::queryMovies(float rating, int year) {
  //write your code
  if (root == NULL) {
    cout << "Tree is Empty. Cannot query Movies" << endl;
    return;
  }else{
    cout << "Movies that came out after " << year << " with rating at least " << rating << ":" << endl;
    quaryHelp(root, rating, year);
  }

}

float aveHelp(MovieNode *current, int &count);

float aveHelp(MovieNode *current, int &count){
  if (current==NULL) {
    return 0;
  }else{
    count++;
    return aveHelp(current->right, count) + aveHelp(current->left, count) + current->rating;
  }


}

void MovieTree::averageRating() {
  //write your code
  if (root == NULL) {
    cout << "Average rating:0.0" << endl;
    return;
  }
  int count = 0;
  float total = 0;
  total = aveHelp(root, count);
  total = total/count;
  cout << "Average rating:" << total << endl;


}

void printLevHelp(MovieNode *current, int level);

void printLevHelp(MovieNode *current, int level){
  if (current==NULL||level<0) {
    return;
  }
  printLevHelp(current->left,level-1);
  if (level==0) {
    cout << "Movie: " << current->title << " " << current->rating << endl;
  }
  printLevHelp(current->right,level-1);
}

void MovieTree::printLevelNodes(int level) {
  //write your code
  printLevHelp(root,level);
}
