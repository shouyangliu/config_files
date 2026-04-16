#include <errno.h>
#include <fcntl.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <sys/types.h>
#include "blocks/config.h"

extern void battery(char *output);
extern void memory(char *output);
extern void cpu(char *output);
extern void wifi(char *output);
extern void ip(char *output);
extern void datetime(char *output);

static unsigned int tick;
static char status[16384];
static char block_output[32][512];

void kill_sig(int sig) {
    exit(0);
}

void setroot(void) {
    char cmd[16384 + 32];
    snprintf(cmd, sizeof(cmd), "xsetroot -name \"%s\"", status);
    system(cmd);
}

void update(void) {
    for (unsigned int i = 0; i < blocklen; i++) {
        char output[512] = "";
        
        if (blocks[i].signal > 0 && blocks[i].signal != tick) {
            continue;
        }
        
        if (blocks[i].interval > 0 && tick > 0 && tick % blocks[i].interval != 0) {
            continue;
        }
        
        if (strcmp(blocks[i].format, "bat") == 0) {
            battery(output);
        } else if (strcmp(blocks[i].format, "mem") == 0) {
            memory(output);
        } else if (strcmp(blocks[i].format, "cpu") == 0) {
            cpu(output);
        } else if (strcmp(blocks[i].format, "datetime") == 0) {
            datetime(output);
        } else if (strcmp(blocks[i].format, "wifi") == 0) {
            wifi(output);
        } else if (strcmp(blocks[i].format, "ip") == 0) {
            ip(output);
        } else if (blocks[i].command != NULL) {
            FILE *p = popen(blocks[i].command, "r");
            if (p) {
                if (fgets(output, sizeof(output), p)) {
                    output[strcspn(output, "\n")] = 0;
                }
                pclose(p);
            }
        }
        
        strncpy(block_output[i], output, sizeof(block_output[i]) - 1);
    }
    
    status[0] = '\0';
    for (unsigned int i = 0; i < blocklen; i++) {
        if (strlen(block_output[i]) > 0) {
            if (strlen(status) > 0) {
                strcat(status, " | ");
            }
            strcat(status, block_output[i]);
        }
    }
    
    printf("%s\n", status);
    fflush(stdout);
}

int main(void) {
    signal(SIGINT, kill_sig);
    signal(SIGTERM, kill_sig);
    
    tick = 0;
    while (1) {
        int needs_update = 0;
        for (unsigned int i = 0; i < blocklen; i++) {
            if (blocks[i].signal > 0 && (tick == 0 || blocks[i].signal == tick)) {
                needs_update = 1;
                break;
            }
            if (blocks[i].interval > 0 && (tick == 0 || tick % blocks[i].interval == 0)) {
                needs_update = 1;
                break;
            }
        }
        
        if (needs_update) {
            update();
            setroot();
        }
        
        sleep(1);
        tick++;
        
        if (tick % 3600 == 0) {
            tick = 0;
        }
    }
    
    return 0;
}