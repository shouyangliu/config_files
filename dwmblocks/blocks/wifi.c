#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void wifi(char *output) {
    FILE *f = popen("nmcli -t -f SSID,SIGNAL dev wifi | head -1 | cut -d: -f2", "r");
    if (f) {
        char signal[16];
        if (fgets(signal, sizeof(signal), f)) {
            signal[strcspn(signal, "\n")] = 0;
            snprintf(output, 256, "^b#bb9af7^f#1a1b26📶 %s%%^d", signal);
        } else {
            snprintf(output, 256, "^b#bb9af7^f#1a1b26📶 --^d");
        }
        pclose(f);
    } else {
        snprintf(output, 256, "^b#bb9af7^f#1a1b26📶 --^d");
    }
}