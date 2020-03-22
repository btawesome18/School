#include "Graph.hpp"
#include <vector>
#include <queue>
#include <iostream>

using namespace std;

// function to add edge between two vertices
void Graph::addEdge(int v1, int v2){

    for(int i = 0; i < vertices.size(); i++){
        if(vertices[i]->key == v1){
            for(int j = 0; j < vertices.size(); j++){
                if(vertices[j]->key == v2 && i != j){
                    adjVertex av;
                    av.v = vertices[j];
                    vertices[i]->adj.push_back(av);
                    //another vertex for edge in other direction
                    adjVertex av2;
                    av2.v = vertices[i];
                    vertices[j]->adj.push_back(av2);
                }
            }
        }
    }
}


// function to add a vertex to the graph
void Graph::addVertex(int n){
    bool found = false;
    for(int i = 0; i < vertices.size(); i++){
        if(vertices[i]->key == n){
            found = true;
        }
    }
    if(found == false){
        vertex * v = new vertex;
        v->key = n;
        vertices.push_back(v);
    }
}



//SILVER TODO
void Graph::printGraph(){
    // TODO
    // loop through all vertices and adjacent vertices
    for (size_t i = 0; i < vertices.size(); i++) {
      std::cout << "Node: "<< vertices[i]->key << " connects to: ";
      for (size_t k = 0; k < vertices[i]->adj.size(); k++) {
        std::cout << vertices[i]->adj[k].v->key << ", ";
      }
      std::cout << '\n';
    }

}
