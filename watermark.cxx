#include <SDL2/SDL.h>
#include <SDL2/SDL_ttf.h>
#include <stdio.h>

int main(int argc, char* argv[]) {
    SDL_Init(SDL_INIT_VIDEO);
    TTF_Init();

    SDL_Window* window = SDL_CreateWindow("SYSTEM CRITICAL", 
        SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, 800, 480, SDL_WINDOW_FULLSCREEN_DESKTOP | SDL_WINDOW_ALWAYS_ON_TOP);
    SDL_Renderer* renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
    SDL_SetRelativeMouseMode(SDL_TRUE);

    // Load standard font for the warning text
    TTF_Font* mainFont = TTF_OpenFont("/system/fonts/Roboto-Regular.ttf", 28);
    SDL_Color white = {255, 255, 255, 255};

    float progress = 0.0f;
    int running = 1;
    SDL_Event event;

    while (running) {
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) running = 0;
        }

        // SLOW PROGRESS
        if (progress < 1.0f) progress += 0.0002f; 

        // Background
        SDL_SetRenderDrawColor(renderer, 150, 0, 0, 255); 
        SDL_RenderClear(renderer);

        // 1. Draw Warning Text
        if (mainFont) {
            SDL_Surface* sText = TTF_RenderUTF8_Blended(mainFont, "NOTICE: Files are queued for encryption Pay Ransom Rs 1000000.", white);
            SDL_Texture* tText = SDL_CreateTextureFromSurface(renderer, sText);
            SDL_Rect rText = { 40, 50, sText->w, sText->h };
            SDL_RenderCopy(renderer, tText, NULL, &rText);
            SDL_FreeSurface(sText);
            SDL_DestroyTexture(tText);
        }

        // 2. Draw Progress Bar
        SDL_Rect barBg = { 100, 350, 600, 30 };
        SDL_SetRenderDrawColor(renderer, 60, 0, 0, 255);
        SDL_RenderFillRect(renderer, &barBg);

        SDL_Rect barFill = { 100, 350, (int)(600 * progress), 30 };
        SDL_SetRenderDrawColor(renderer, 0, 255, 0, 255);
        SDL_RenderFillRect(renderer, &barFill);

        // 3. Draw "File" (White Box)
        SDL_Rect fileBox = { 650, 250, 50, 60 };
        SDL_SetRenderDrawColor(renderer, 255, 255, 255, 255);
        SDL_RenderFillRect(renderer, &fileBox);
        // Small detail for the file
        SDL_Rect fileTab = { 650, 250, 20, 10 };
        SDL_SetRenderDrawColor(renderer, 200, 200, 200, 255);
        SDL_RenderFillRect(renderer, &fileTab);

        // 4. Draw "Bacteria" (Green Square/Circle)
        int bacX = 100 + (int)(540 * progress);
        SDL_Rect bacteria = { bacX, 260, 40, 40 };
        SDL_SetRenderDrawColor(renderer, 0, 255, 50, 255);
        SDL_RenderFillRect(renderer, &bacteria);
        
        // Add "eyes" to the bacteria to make it look alive
        SDL_SetRenderDrawColor(renderer, 0, 0, 0, 255);
        SDL_Rect eye1 = { bacX + 10, 270, 5, 5 };
        SDL_Rect eye2 = { bacX + 25, 270, 5, 5 };
        SDL_RenderFillRect(renderer, &eye1);
        SDL_RenderFillRect(renderer, &eye2);

        SDL_RenderPresent(renderer);
        SDL_Delay(10); 
    }

    if (mainFont) TTF_CloseFont(mainFont);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    TTF_Quit();
    SDL_Quit();
    return 0;
}
