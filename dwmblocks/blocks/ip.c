#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void ip(char *output) {
    FILE *f = popen("ip route | grep -m1 'src ' | awk '{print $9}'", "r");
    if (f) {
        char ip[32];
        if (fgets(ip, sizeof(ip), f)) {
            ip[strcspn(ip, "\n")] = 0;
            snprintf(output, 256, "^b#9ece4a^f#1a1b26🌐 %s^d", ip);
        } else {
            snprintf(output, 256, "^b#9ece4a^f#1a1b26🌐 --^d");
        }
        pclose(f);
    } else {
        snprintf(output, 256, "^b#9ece4a^f#1a1b26🌐 --^d");
    }
}