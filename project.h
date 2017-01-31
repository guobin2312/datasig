#ifndef __PROJECT_H
#define __PROJECT_H
/*
 * project related include file
 */

#include <time.h>
#include "global.h"

#define MESSAGE_DESC_SIZE       128

typedef struct common_req
{
    size_t size;
    float  data;
} common_req_t;

typedef struct common_rsp
{
    global_error_t err;
    double  data;
} common_rsp_t;

typedef struct //open_req
{
    common_req_t hdr;
    uint32_t urg:1, mbz:15, opt:16;
    uint8_t  flags;
    uint16_t mac[3];
    global_buf_t buf;
} open_req_t;

typedef struct close_req
{
    common_req_t hdr;
    uint32_t handle;
    uint8_t  flags;
    uint64_t stat[2];
} close_req_t;

typedef struct message_req
{
    global_version_t ver;
    struct {
        uint32_t rid;
        uint32_t xid;
        uint32_t mask;
    };
    struct {
        time_t time;
    } s;

    union
    {
        common_req_t hdr;
        open_req_t open_req;
        close_req_t close_req;
        char desc[MESSAGE_DESC_SIZE];
    } u;
} message_req_t;

typedef struct open_rsp
{
    common_rsp_t hdr;
    uint32_t handle;
} open_rsp_t;

enum failure_type {
    MAX_FAILURE_BIT = 4,
    MAX_FAILURE_LOG = 10,
};

struct failure_log {
    global_error_t err;
    char *end;
    char msg[128];
};

typedef struct close_rsp
{
    common_rsp_t hdr;
    struct failure_log *first, **next;
    struct failure_log fail[MAX_FAILURE_LOG][4];
} close_rsp_t;

typedef struct message_rsp
{
    global_version_t ver;
    uint32_t rid;
    uint32_t xid;
    time_t time;

    union
    {
        struct open_rsp open_rsp;
        close_rsp_t close_rsp;
    } u;

    char desc[MESSAGE_DESC_SIZE];
} message_rsp_t;

/*
 * Local Variables:
 *   c-file-style: "stroustrup"
 *   indent-tabs-mode: nil
 * End:
 *
 * vim: set ai cindent et sta sw=4:
 */
#endif/*__PROJECT_H*/
