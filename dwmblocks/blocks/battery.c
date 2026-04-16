#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void battery(char *output) {
    FILE *f = fopen("/sys/class/power_supply/BAT1/capacity", "r");
    if (f) {
        int pct;
        if (fscanf(f, "%d", &pct) == 1) {
            snprintf(output, 256, "^b#f7768e^f#1a1b26🔋 %d%%^d", pct);
        } else {
snprintf(output, 256, "^b#f7768e^f#1a1b26🔋 n/a^d");
        }
        fclose(f);
    } else {
        snprintf(output, 256, "🔋 n/a");
    }
}