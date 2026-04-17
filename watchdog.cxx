#include <windows.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char* argv[]) {
    printf("Watchdog active. Monitoring watermark.exe...\n");

    while(1) {
        // This will launch watermark and the watchdog will stay 
        // on this line until watermark is closed.
        system("watermark.exe");
        
        printf("Watermark closed! Restarting in 1 second...\n");
        sleep(1);
    }
    return 0;
}