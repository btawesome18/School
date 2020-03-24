#include <iostream>
#include <fstream>
#include "MovieTree.hpp"

using namespace std;

/* ------------------------------------------------------ */
MovieTree::MovieTree()
{
	root = NULL;
}

void deleteTree(TreeNode* node)
{
    if (node != NULL){
      //cout<<"\n Deleting node:"<< node->data;
      deleteTree(node->left);
      deleteTree(node->right);
    }
		deleteList(node->head);
    delete node;
}

void deleteList(LLMovieNode* node){
	if (node !=NULL){
		deleteList(node->next);
	}
	delete node;
}
MovieTree::~MovieTree()
{
		if (root != NULL){
			deleteTree(root);
		}
}

void printListHelper(LLMovieNode* node){
	while (node != NULL){
		cout << " >> " << node->title << " " << node->rating << endl;
		node = node->next;
	}
}

void printTreeHelper(TreeNode* node){
	if (node != NULL){
		printTreeHelper(node->leftChild);
		cout << "Movies starting with letter: " << node->titleChar << endl;
		printListHelper(node->head);
		printTreeHelper(node->rightChild);
	}
}

void MovieTree::printMovieInventory()
{
	if (root !=NULL){
		printTreeHelper(root);
	}

}

void addMovieHelper(TreeNode* insert, TreeNode* cycle){
  if (insert->titleChar < cycle->titleChar && cycle->leftChild == NULL){
    //cout << "push left" << endl;
    cycle->leftChild = insert;
		insert->parent = cycle;
  }
  else if (insert->titleChar > cycle->titleChar && cycle->rightChild ==NULL){
    //cout << "push right" << endl;
    cycle->rightChild = insert;
		insert->parent = cycle;
  }
  else if(insert->titleChar > cycle->titleChar){
    //cout << "bigger" << endl;
    addMovieHelper(insert,cycle->rightChild);
  }
  else if(insert->titleChar < cycle->titleChar){
    //cout << "smaller" << endl;
    addMovieHelper(insert,cycle->leftChild);
  }
  //return cycle;
}

void listAddHelp(LLMovieNode* cycle, LLMovieNode* insert){
	while (cycle != NULL){
		if (cycle->next == NULL || cycle->next->title > insert->title){
			insert->next = cycle->next;
			cycle->next = insert;
			return;
		}
		cycle = cycle->next;
	}
}

void MovieTree::addMovie(int ranking, string title, int year, float rating)
{
		TreeNode* newIns = new TreeNode;
		newIns->titleChar = title[0];
		if (root == NULL){
			newIns->head = new LLMovieNode(ranking, title, year, rating);
			root = newIns;
		}
		else if (searchCharHelper(root, title[0]) == NULL){
			addMovieHelper(newIns,root);
			newIns->head = new LLMovieNode(ranking, title, year, rating);
		}
		else{
			newIns = searchCharHelper(root,title[0]);
			//cout << "successfully made the mf leaf" << endl;
			LLMovieNode* root = newIns->head;
			LLMovieNode* place = new LLMovieNode(ranking, title, year, rating);
			if (title < root->title){
				place->next = root;
				newIns->head = place;
			}
			else{
				listAddHelp(root,place);
			}
		}
}

/**
int listTarget(LLMovieNode* root, string targetTitle){
	if (root == NULL){
		return 0;
	}
	else if (root->next->title == targetTitle || ){

		return 1;
	}
	else{
		listTarget(root->next,targetTitle);
	}
}
*/

TreeNode* getMinValueNode(TreeNode* currNode){
	if(currNode->leftChild == NULL){
		return currNode;
	}
	return getMinValueNode(currNode->leftChild);
}

TreeNode* getMaxValueNode(TreeNode* currNode){
    if(currNode->rightChild == NULL){
        return currNode;
    }
    return getMaxValueNode(currNode->rightChild);
}

TreeNode* deleteNode(TreeNode *currNode, char titleChar)
{

  if(currNode == NULL)
  {
    return NULL;
  }
  else if(titleChar < currNode->titleChar)
  {
    currNode->leftChild = deleteNode(currNode->leftChild, titleChar);
  }
  else if(titleChar > currNode->titleChar)
  {
    currNode->rightChild = deleteNode(currNode->rightChild, titleChar);
  }
  // We found the node with the value
  else
  {
    //TODO Case : No child
    if(currNode->leftChild == NULL && currNode->rightChild == NULL)
    {
      delete currNode;
      currNode = NULL;
    }
    //TODO Case : Only right child
    else if(currNode->leftChild == NULL)
    {
      TreeNode* temp = currNode->rightChild;
			temp->parent = currNode->parent;
      delete currNode;
			return temp;
			//return currNode;
    }
    //TODO Case : Only left child
    else if(currNode->rightChild == NULL)
    {
			TreeNode* temp = currNode->leftChild;
			temp->parent = currNode->parent;
      delete currNode;
			return temp;
			//return currNode;
    }
    //TODO Case: Both left and right child
    else
    {
      ///Replace with Minimum from right subtree
      TreeNode* smol = getMinValueNode(currNode->rightChild);
      char val = smol->titleChar;
      currNode->titleChar = val;
			currNode->head = smol->head;
      currNode->rightChild = deleteNode(currNode->rightChild, val);
    }
  }
//return currNode;
}

void MovieTree::deleteMovie(std::string title)
{
	char search = title[0];
	TreeNode* spot = searchCharHelper(root,search);
	if (spot != NULL){
		LLMovieNode* list = spot->head;
		LLMovieNode* crawly = list;
		bool found = false;
		while (crawly != NULL){
			if (crawly->title == title){
				list->next = crawly->next;
				delete crawly;
				found = true;
			}
			else if (crawly->title == title && crawly == spot->head){
				delete crawly;
				spot->head = NULL;
				//crawly = NULL;
				found = true;
				root = deleteNode(root, search);
			}
			else {
				list = crawly;
				crawly = crawly->next;
			}
		}
		if (found == false){
			cout << "Movie: " << title << " not found, cannot delete." << endl;
		}
	}
	else {
		cout << "Movie: " << title << " not found, cannot delete." << endl;
	}
}

void MovieTree::leftRotation(TreeNode* curr){
	TreeNode* newTop = curr->rightChild;
	TreeNode* grand = curr->parent;
	if (newTop != NULL){
		if (curr == root){
			root = newTop;
			newTop->parent = NULL;
		}
		else{
			newTop->parent = curr->parent;
			curr->parent = newTop;
		}
		curr->rightChild = newTop->leftChild;
		if (curr->titleChar > grand->titleChar){
			grand->rightChild = newTop;
		}
		else{
			grand->leftChild = newTop;
		}
	}
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
