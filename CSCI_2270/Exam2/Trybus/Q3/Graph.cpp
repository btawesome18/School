#include "Graph.hpp"
#include <vector>
#include <queue>
#include <iostream>
#include <queue>


using namespace std;

void Graph::addEdge(string source, string target){
    for(unsigned int i = 0; i < vertices.size(); i++){
        if(vertices[i]->name == source){
            for(unsigned int j = 0; j < vertices.size(); j++){
                if(vertices[j]->name == target && i != j){
                    adjVertex av;
                    av.v = vertices[j];
                    vertices[i]->adj.push_back(av);
                }
            }
        }
    }
}

void Graph::addVertex(string vName){
    bool found = false;
    for(unsigned int i = 0; i < vertices.size(); i++){
        if(vertices[i]->name == vName){
            found = true;
            cout<<vertices[i]->name<<" found."<<endl;
        }
    }
    if(found == false){
        vertex * v = new vertex;
        v->name = vName;
        vertices.push_back(v);
    }
}

void Graph::display(){
    cout<<"vertex"<<":"<<"color"<<endl;
    for(unsigned int i = 0; i < vertices.size(); i++){
        cout<<vertices[i]->name<<":"<<vertices[i]->color<<endl;

    }
}



void Graph::color(string source){
  //TODO
  vertex *node = NULL, *current;//node is the node to be worked on, and current is just used for searching
  for (size_t i = 0; i < vertices.size(); i++) {
    current = vertices[i];
    if (source == current->name) {
      node = current;//finds the node to start
    }
    current->visited= false;
    current->color = "white"; //any islands will be painted white here
  }
  current = NULL;
  if (node==NULL) {
    return; //check if the search worked stop if it didn't;
  }

  //sets up first node and ensure the first loop of the while is true
  queue<vertex*> q;
  node->visited=true;
  node->color="black";
  q.push(node);


  while (!q.empty()) { // Breath first traversal throught the starting island

    //update the queue
    node = q.front();
    q.pop();

    for (size_t i = 0; i < node->adj.size(); i++) {
      if (!(node->adj[i].v->visited)) {
        q.push(node->adj[i].v); // adds to queue for next loop
        node->adj[i].v->visited=true; //prevents infiante loop
        if (node->color=="black") { // lookes at next node and colors it based off of the current node;
          node->adj[i].v->color="red";
        }else{
          node->adj[i].v->color="black";
        }
      }
    }
  }
 // once the queue is empty the code is done and the starting island has been painted.
}
