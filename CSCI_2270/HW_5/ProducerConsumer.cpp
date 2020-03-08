#include "ProducerConsumer.hpp"
#include <iostream>

using namespace std;



ProducerConsumer::ProducerConsumer(){
  queueFront = 0;
  queueEnd = 0;
}
bool ProducerConsumer::isEmpty(){
  if (counter == 0) {
    return true;
  }else return false;
}
bool ProducerConsumer::isFull(){
  if (counter == SIZE) {
    return true;
  }else return false;
}
void ProducerConsumer::enqueue(std::string item){
  if (isFull()) {
    std::cout << "Queue full, cannot add new item" << '\n';
    return;
  } else {
    queue[queueEnd++]= item;
    queueEnd = queueEnd%SIZE;
    counter++;
  }
}
void ProducerConsumer::dequeue(){
  if (isEmpty()) {
    std::cout << "Queue empty, cannot dequeue an item" << '\n';
    return;
  }else{
    queueFront++;
    queueFront = queueFront%SIZE;
    counter--;
  }
}
string ProducerConsumer::peek(){
  if (isEmpty()) {
    std::cout << "Queue empty, cannot peek" << '\n';
    return "";
  }else{
    return queue[queueFront];
  }
}
int ProducerConsumer::queueSize(){
  return counter;
}   //changed
