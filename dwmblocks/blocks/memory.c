#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/sysinfo.h>

void memory(char *output) {
    struct sysinfo si;
    if (sysinfo(&si) == 0) {
        long used_mb = (si.totalram - si.freeram) / (1024 * 1024);
        snprintf(output, 256, "^b#7dcfff^f#1a1b26💾 %ldM^d", used_mb);
    } else {
        snprintf(output, 256, "^b#7dcfff^f#1a1b26💾 n/a^d");
    }
}