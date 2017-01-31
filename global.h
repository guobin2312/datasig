#ifndef __GLOBAL_H
#define __GLOBAL_H

/*
 * global related include file
 */

#include "system.h"

typedef enum global_error
{
    ERROR_OK = 0,
    ERROR_UNKNOWN = -1,
} global_error_t;

#define GLOBAL_BUFSIZE  256
typedef uint8_t global_buf_t[GLOBAL_BUFSIZE];

typedef struct global_version
{
    uint16_t major;
    uint16_t minor;
} global_version_t;

/*
 * Local Variables:
 *   c-file-style: "stroustrup"
 *   indent-tabs-mode: nil
 * End:
 *
 * vim: set ai cindent et sta sw=4:
 */
#endif/*__GLOBAL_H*/
