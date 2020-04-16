#ifndef GRAPH_H
#define GRAPH_H
#include<vector>
#include<iostream>
#include "Graph.hpp"

using namespace std;

void Graph::addEdge(string v1, string v2, int num){
  vertex *loc1=NULL, *loc2=NULL;

  for (size_t i = 0; i < vertices.size(); i++) {
    if (vertices[i]->name==v1) {
      loc1=vertices[i];
    }
  }

  for (size_t i = 0; i < vertices.size(); i++) {
    if (vertices[i]->name==v2) {
      loc2=vertices[i];
    }
  }

  adjVertex temp1, temp2;
  temp1.v = loc1;
  temp1.weight = num;
  temp2.v = loc2;
  temp2.weight = num;

  loc1->adj.push_back(temp2);
  loc2->adj.push_back(temp1);

}

void Graph::addVertex(string name){
  bool ifExist=false;
  for (size_t i = 0; i < vertices.size(); i++) {
    if (vertices[i]->name==name) {
      ifExist = true;
    }
  }

  if(ifExist){
    return;
  }
  vertex* temp = new vertex;
  temp->name = name;

  vertices.push_back(temp);
}

void Graph::displayEdges(){
  for (size_t i = 0; i < vertices.size(); i++) {
    std::cout << vertices[i]->name << " --> ";
    for (size_t j = 0; j < vertices[i]->adj.size(); j++) {
      std::cout << vertices[i]->adj[j].v->name <<" ";
    }
    std::cout << '\n';
  }
}

void Graph::breadthFirstTraverse(string sourceVertex){
  vertex *n=NULL;
  for (size_t i = 0; i < vertices.size(); i++) {
    if (vertices[i]->name==sourceVertex) {
      n=vertices[i];
    }
  }

  if (n==NULL) {
    return;
  }
  cout<< "Starting vertex (root): " << n->name << "-> ";

  queue<vertex*> q;

  q.push(n);
  n->visited=true;

  while (!q.empty()) {

    n = q.front();
    q.pop();

    for (size_t i = 0; i < n->adj.size(); i++) {
      if (!(n->adj[i].v->visited)) {
        q.push(n->adj[i].v);
        n->adj[i].v->visited=true;
        n->adj[i].v->distance = n->distance + 1;
        std::cout << n->adj[i].v->name << "(" << n->adj[i].v->distance << ") ";
      }
    }

  }

  for (size_t i = 0; i < vertices.size(); i++) {
    vertices[i]->visited=false;
    vertices[i]->distance=0;
  }

}

void removeHelp(vector<vertex*> &list, vertex *n);

void removeHelp(vector<vertex*> &list, vertex *n){
  for (int i = 0; i < list.size(); i++) {
    if (list[i]==n) {
      list.erase(list.begin()+i);
      return;
    }
  }
}


int Graph::getConnectedComponents(){
  vector<vertex*> remain;
  for (int i = 0; i<vertices.size(); i++){
    remain.push_back(vertices[i]);
  }

  int count = 0;

  while (!remain.empty()) {

    vertex *n=remain[0];
    removeHelp(remain,n);

    queue<vertex*> q;

    q.push(n);
    n->visited=true;

    while (!q.empty()) {



      n = q.front();
      q.pop();

      for (size_t i = 0; i < n->adj.size(); i++) {
        if (!(n->adj[i].v->visited)) {
          q.push(n->adj[i].v);
          n->adj[i].v->visited=true;
        }
      }
      removeHelp(remain,n);
    }

    count++;

  }

  for (size_t i = 0; i < vertices.size(); i++) {
    vertices[i]->visited=false;
    vertices[i]->distance=0;
  }
  return count;
}

void dftHelp(vertex *start);

void dftHelp(vertex *start){

  if (start->visited) {
    return;
  }
  start->visited = true;
  cout << start->name << " -> ";
  for (size_t i = 0; i < start->adj.size(); i++) {
    dftHelp(start->adj[i].v);
  }

}

void Graph::depthFirstTraversal(string sourceVertex)
{
    // Your code here
    vertex *n=NULL;
    for (size_t i = 0; i < vertices.size(); i++) {
      if (vertices[i]->name==sourceVertex) {
        n=vertices[i];
      }
    }

    dftHelp(n);
    cout << "DONE";
}

void Graph::dijkstraTraverse(string source)
{
  vector<vertex*> solved;

  vertex* sv;

  for (size_t i = 0; i < vertices.size(); i++) {
    if (vertices[i]->name==source) {
      sv=vertices[i];
      sv->visited = true;
      solved.push_back(sv);
    }
  }

  vertex* n = NULL;

  while (solved.size()!=vertices.size()) {
    int minDist = 9999999;
    n = NULL;
    for (size_t i = 0; i < solved.size(); i++) {
      for (size_t j = 0; j < solved[i]->adj.size(); j++) {
        if (!solved[i]->adj[j].v->visited) {
          int dist = solved[i]->distance + solved[i]->adj[j].weight;
          if (dist <= minDist) {
            n = solved[i]->adj[j].v;
            minDist = dist;
            solved[i]->adj[j].v->pred = solved[i];
            n->pred = solved[i];
          }
        }
      }
    }
    n->distance = minDist;
    n->visited = true;
    solved.push_back(n);
  }

}

#include <stack>
void Graph::shortestPath(string start, string end)
{

  vertex* sv;

  for (size_t i = 0; i < vertices.size(); i++) {
    if (vertices[i]->name==end) {
      sv=vertices[i];
    }
  }

  dijkstraTraverse(start);

  //vector<vertex*> path;
  stack<string> path;

  int min = sv->distance;
  int total = sv->distance;
  vertex* minV;


  while (sv != NULL){
    vertex* pushIt = sv;
    sv = sv->pred;
    path.push(pushIt->name);
  }

/*  while (sv->name != end) {
    for (size_t i = 0; i < sv->adj.size(); i++) {
      if (sv->adj[i].v->distance < min) {
        min = sv->adj[i].v->distance;
        minV = sv->adj[i].v;
      }
    }
    path.push(minV->name);
    sv = minV;
  } */


  while(!path.empty()) {
    cout << path.top() << " -> ";
    path.pop();
  }

  cout << "DONE " << "[" << total << "]" << endl;

}
