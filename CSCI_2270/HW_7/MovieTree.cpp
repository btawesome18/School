#include <iostream>
#include <fstream>
#include "MovieTree.hpp"

using namespace std;

/* ------------------------------------------------------ */
MovieTree::MovieTree()
{
	root = NULL;
}

MovieTree::~MovieTree()
{

}

void printLLHelp(LLMovieNode* head);

void printLLHelp(LLMovieNode* head){
	while (head!=NULL) {
		cout << " >> " << head->title << " " << head->rating << endl;
		head = head->next;
	}
}

void printMoviesHelp(TreeNode *node);

void printMoviesHelp(TreeNode *node){
	if (node==NULL) {
		return;
	}
	printMoviesHelp(node->leftChild);
	cout << "Movies starting with letter: " << node->titleChar << endl;
	printLLHelp(node->head);
	printMoviesHelp(node->rightChild);
}

void MovieTree::printMovieInventory(){
	printMoviesHelp(root);
}

void worthless(TreeNode *tree, LLMovieNode *Movie);

void worthless(TreeNode *tree, LLMovieNode *Movie){
	LLMovieNode *temp, *temp2;
	if (tree->head==NULL) {
		tree->head = Movie;
		return;
	}
	if (tree->head->title >= Movie->title) {
		Movie->next = tree->head;
		tree->head = Movie;
		return;
	}
	temp = tree->head;
	while (temp->next!=NULL){
		temp2 = temp;
		temp = temp->next;
		if (temp->title >= Movie->title){
			Movie->next = temp;
			temp2->next = Movie;
			return;
		}
	}
	temp->next = Movie;
}

void add2Tree(TreeNode *root, TreeNode *Leaf);

void add2Tree(TreeNode *root, TreeNode *Leaf){

	if (root->titleChar > Leaf->titleChar) {
		if (root->leftChild==NULL) {
			Leaf->parent = root;
			root->leftChild = Leaf;
		}else{
			add2Tree(root->leftChild, Leaf);
		}
	}
	if (root->titleChar < Leaf->titleChar) {
		if (root->rightChild==NULL) {
			Leaf->parent = root;
			root->rightChild = Leaf;
		}else{
			add2Tree(root->rightChild, Leaf);
		}
	}
}

void MovieTree::addMovie(int ranking, string title, int year, float rating){
	char key = title[0];

	TreeNode *Treespot = searchCharHelper(root, key);

	LLMovieNode *added = new LLMovieNode;
	added->ranking = ranking;
	added->title = title;
	added->year = year;
	added->rating = rating;
	added->next = NULL;
	if (Treespot==NULL&&root!=NULL) {
		TreeNode *newLeaf = new TreeNode;
		newLeaf->titleChar = key;
		newLeaf->head = added;
		add2Tree(root, newLeaf);
	}else	if(root==NULL){
		TreeNode *newLeaf = new TreeNode;
		newLeaf->titleChar = key;
		newLeaf->head = added;
		root = newLeaf;
	}else
	worthless(Treespot, added);

}



void MovieTree::deleteMovie(std::string title)
{

	TreeNode *temp = MovieTree::searchChar(title[0]);
	if (temp==NULL) {
		cout << "Movie: " << title << " not found, cannot delete." << endl;
		return;
	}
	LLMovieNode *tempM = temp->head;
	LLMovieNode *tempM2;
	if (tempM==NULL) {
		cout << "Movie: " << title << " not found, cannot delete." << endl;
		return;
	}

	if (tempM->title==title) {
		tempM2 = tempM->next;
		temp->head = tempM2;
		delete tempM;
		return;
	}
	while (tempM!=NULL) {
		tempM2 = tempM;
		tempM = tempM->next;
		if (tempM->title==title) {
			tempM2->next = tempM->next;
			delete tempM;
			return;
		}
	}
}

void MovieTree::leftRotation(TreeNode* curr)
{

}
//------ Given Methods--------//
void _grader_inorderTraversal(TreeNode * root)
{
	if (root == NULL) {
		return;
	}

	_grader_inorderTraversal(root->leftChild);
	cout << root->titleChar << " ";
	_grader_inorderTraversal(root->rightChild);
}


void MovieTree::inorderTraversal() {
	_grader_inorderTraversal(root);
	cout << endl;
}



TreeNode* searchCharHelper(TreeNode* curr, char key)
{
    if (curr == NULL)
        return curr;
    else if(curr->titleChar == key)
        return curr;
    else if (curr->titleChar > key)
        return searchCharHelper(curr->leftChild, key);
    else
        return searchCharHelper(curr->rightChild, key);
}

TreeNode* MovieTree::searchChar(char key)
{
    return searchCharHelper(root, key);
}
