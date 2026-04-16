#ifndef BLOCKS_CONFIG_H
#define BLOCKS_CONFIG_H

#include <stdint.h>
#include <stdlib.h>
#include <time.h>

typedef struct {
    const char *command;
    const unsigned int interval;
    const unsigned int signal;
    const char *format;
} Block;

static const Block blocks[] = {
    {NULL, 5, 0, "bat"},
    {NULL, 5, 0, "mem"},
    {NULL, 5, 0, "cpu"},
    {NULL, 10, 0, "wifi"},
    {NULL, 30, 0, "ip"},
    {NULL, 60, 0, "datetime"},
};

static const unsigned int blocklen = sizeof(blocks) / sizeof(blocks[0]);

#endif