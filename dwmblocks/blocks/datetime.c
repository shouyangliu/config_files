#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

void datetime(char *output) {
    time_t t = time(NULL);
    struct tm *tm = localtime(&t);
    char time_str[64];
    strftime(time_str, sizeof(time_str), "%H:%M %Y-%m-%d", tm);
    snprintf(output, 256, "^b#bb9af7^f#1a1b26🕒 %s^d", time_str);
}