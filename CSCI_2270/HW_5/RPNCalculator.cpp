#include "RPNCalculator.hpp"

using namespace std;

RPNCalculator::RPNCalculator(){
  stackHead = NULL;
}

RPNCalculator::~RPNCalculator(){
  while (!(stackHead==NULL)) {
    pop();
  }
}

bool RPNCalculator::isEmpty(){
  if (stackHead==NULL) {
    return true;
  }else return false;
}

void RPNCalculator::push(float num){
  Operand *temp = new Operand;
  temp->number = num;
  temp->next = stackHead;
  stackHead = temp;
}

void RPNCalculator::pop(){
  if (isEmpty()) {
    std::cout << "Stack empty, cannot pop an item." << '\n';
    return;
  } else{
    Operand *temp = stackHead;
    stackHead = temp->next;
    delete temp;
  }
}

Operand* RPNCalculator::peek(){
  if (isEmpty()) {
    std::cout << "Stack empty, cannot peek." << '\n';
    return NULL;
  } else return stackHead;
}

bool RPNCalculator::compute(std::string symbol){
  if (!((symbol=="+")||(symbol=="*"))) {

    std::cout << "err: invalid operation" << '\n';
    return false;

  }
  if (isEmpty()) {
    std::cout << "err: not enough operands" << '\n';
    return false;
  }
  if ((symbol=="+")) {
    float temp1, temp2;
    temp1 = peek()->number;
    pop();
    if (isEmpty()) {
      std::cout << "err: not enough operands" << '\n';
      push(temp1);
      return false;
    }
    temp2 = peek()->number;
    pop();
    push(temp1+temp2);
    return true;
  }
  if ((symbol=="*")) {
    float temp1, temp2;
    temp1 = peek()->number;
    pop();
    if (isEmpty()) {
      std::cout << "err: not enough operands" << '\n';
      push(temp1);
      return false;
    }
    temp2 = peek()->number;
    pop();
    push(temp1*temp2);
    return true;
  }



}
