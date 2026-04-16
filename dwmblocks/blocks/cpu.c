#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static long long prev_total = 0;
static long long prev_idle = 0;

void cpu(char *output) {
    FILE *f = fopen("/proc/stat", "r");
    if (f) {
        long long total, idle, usage;
        char line[256];
        
        if (fgets(line, sizeof(line), f)) {
            long long user, nice, system, idle, iowait, irq, softirq;
            sscanf(line, "cpu %lld %lld %lld %lld %lld %lld %lld",
                   &user, &nice, &system, &idle, &iowait, &irq, &softirq);
            
            total = user + nice + system + idle + iowait + irq + softirq;
            usage = total - prev_total - (idle - prev_idle);
            
            if (prev_total > 0) {
                int perc = (int)((usage * 100) / (total - prev_total));
                snprintf(output, 256, "^b#9ece6a^f#1a1b26📡 %d%%^d", perc);
            } else {
                snprintf(output, 256, "^b#9ece6a^f#1a1b26📡 0%%^d");
            }
            
            prev_total = total;
            prev_idle = idle;
        }
        fclose(f);
    } else {
        snprintf(output, 256, "^b#9ece6a^f#1a1b26📡 n/a^d");
    }
}