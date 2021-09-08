#define SDL_MAIN_HANDLED
#include <iostream>
#include <SDL2/SDL.h>


using namespace std;

//Screen dimension constants
const int SCREEN_WIDTH = 640;
const int SCREEN_HEIGHT = 480;


int main(int argc, char const *argv[]) {
    //The window we'll be rendering to
  SDL_Window* window = NULL;

  SDL_Surface* screenSurface = NULL;

  window = SDL_CreateWindow( "SDL Tutorial", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, SCREEN_WIDTH, SCREEN_HEIGHT, SDL_WINDOW_SHOWN );



  return 0;
}
