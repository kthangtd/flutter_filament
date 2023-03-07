#ifndef UNLIT_OPAQUE_H_
#define UNLIT_OPAQUE_H_

#include <stdint.h>

extern "C" {
    extern const uint8_t UNLIT_OPAQUE_PACKAGE[];
    extern int UNLIT_OPAQUE_UNLIT_OFFSET;
    extern int UNLIT_OPAQUE_UNLIT_SIZE;
}
#define UNLIT_OPAQUE_UNLIT_DATA (UNLIT_OPAQUE_PACKAGE + UNLIT_OPAQUE_UNLIT_OFFSET)

#endif