#include <iostream>
#include <fstream>
#include "MovieTree.hpp"

using namespace std;

/* ------------------------------------------------------ */
MovieTree::MovieTree()
{
	root = NULL;
}

TreeNode* ChainSaw(TreeNode *root);

void delinker(LLMovieNode *head);

void delinker(LLMovieNode *head){
	LLMovieNode *temp = head;
	while (head!=NULL) {
		temp = head;
		head = head->next;
		delete temp;
	}
}

TreeNode* ChainSaw(TreeNode *root){
	if (root==NULL) {
		return NULL;
	}

	root->rightChild = ChainSaw(root->rightChild);
	root->leftChild = ChainSaw(root->leftChild);
	if (root->leftChild == NULL&& root->rightChild == NULL) {
		delinker(root->head);
		delete root;
		return NULL;
	}
}

MovieTree::~MovieTree(){
	root = ChainSaw(root);
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

	TreeNode *Treespot = MovieTree::searchChar(key);

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

TreeNode* deleteHelper(TreeNode *root, char key);

TreeNode* minValueNode(TreeNode *root);

TreeNode* minValueNode(TreeNode *root){
	while (root->leftChild!=NULL) {
		root = root->leftChild;
	}
	return root;
}

TreeNode* deleteHelper(TreeNode *root, char key){
	if (root == NULL) {
		return root;
	}
	if (key < root->titleChar) {
		root->leftChild = deleteHelper(root->leftChild, key);
	} else if (key > root->titleChar) {
		root->rightChild = deleteHelper(root->rightChild, key);
	} else {
		if (root->leftChild==NULL&&root->rightChild==NULL) {
			delete root;
			return NULL;
		}
		if (root->leftChild==NULL) {
			TreeNode *temp = root->rightChild;
			temp->parent = root->parent;
			delete root;
			return temp;
		} else if (root->rightChild==NULL) {
			TreeNode *temp = root->leftChild;
			temp->parent = root->parent;
			delete root;
			return temp;
		}

		TreeNode *temp = minValueNode(root->rightChild);
		root->titleChar = temp->titleChar;
		root->head = temp->head;

		root->rightChild = deleteHelper(root->rightChild, temp->titleChar);

	}
}

void MovieTree::deleteMovie(std::string title)
{

	TreeNode *temp = MovieTree::searchChar(title[0]);
	if (temp==NULL) {
		cout << "Movie: " << title << " not found, cannot delete." << endl;
		return;
	}
	LLMovieNode *tempM = temp->head;
	LLMovieNode *tempM2 = NULL;
	if (tempM==NULL) {
		cout << "Movie: " << title << " not found, cannot delete." << endl;
		return;
	}

	if (tempM->title==title) {
		tempM2 = tempM->next;
		temp->head = tempM2;
		delete tempM;
		if (temp->head==NULL) {
			root = deleteHelper(root, title[0]);
		}
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
	TreeNode *temp = curr->rightChild;
	temp->parent= curr->parent;
	if (temp->leftChild!=NULL) {
		temp->leftChild->parent = curr;
	}
	curr->rightChild = temp->leftChild; //humm
	temp->leftChild = curr;
	if (curr == root) {
		root = temp;
		curr->parent = temp;
		return;
	}
	if (temp->parent->rightChild == curr) {
		temp->parent->rightChild = temp;
	}else if (temp->parent->leftChild == curr) {
			temp->parent->leftChild = temp;
	}
	curr->parent = temp;
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
