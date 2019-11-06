#include<iostream>
#include<string>

//Option 2
using namespace std;

bool CheckList(bool a[],int length);

int main(){
 int list[9],rado,temp;
 bool check[9],done;

 for(int i = 0; i==9;i++){
   list[i] = i;
   check[i] = 1;
 }

 do{


 }while(done);

return 0;
}


bool CheckList(bool a[],int length){
  int temp = 0;

  for(int i =0; i == length; i++){
    temp = temp + int(a[i]);
  }
  if(temp>0){
    return 0;
  }
  return 1;
}
