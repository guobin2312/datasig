#include "project.h"

#define DATASIG_TABLE             \
    /* entry1(type) */            \
    /* entry2(type, field) */     \
    DATASIG_ENTRY1(message_req_t) \
    DATASIG_ENTRY1(message_rsp_t) \

#define DATASIG_ENTRY1(_type)   DATASIG_ENTRY2(_type, f_ ## _type)

typedef struct datasig_all
{
#define DATASIG_ENTRY2(_type, _field) \
    _type _field;                     \

#if 0
    size_t s_ ## _type;               \

#endif

    DATASIG_TABLE

#undef DATASIG_ENTRY2
} datasig_all_t;

datasig_all_t datasig_var =
{
#define DATASIG_ENTRY2(_type, _field) \
    ._field = {},                     \

#if 0
    .s_ ## _type = sizeof(_type),     \

#endif

    DATASIG_TABLE

#undef DATASIG_ENTRY2
};

int main(int argc, char *argv[])
{
    return 0;
}

/*
 * Local Variables:
 *   c-file-style: "stroustrup"
 *   indent-tabs-mode: nil
 * End:
 *
 * vim: set ai cindent et sta sw=4:
 */
