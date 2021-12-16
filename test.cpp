using namespace std;

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <ctype.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <errno.h>
#include <string>

using namespace std;

void doit();

int main() {
  for (size_t i = 0; i < 2; i++) {
    fork();
  }
  printf("Hello\n" );
  return 0;
}


void doit(){
  if(fork()==0){
    fork();
    printf("Hello\n");
    return;
  }
  return;

}
