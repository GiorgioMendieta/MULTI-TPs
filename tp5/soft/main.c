#include "config.h"
#include "stdio.h"

#define NPIXEL 256
#define NLINE 256

//////////////////////////////////////////////////////////////////////
//    build function
//////////////////////////////////////////////////////////////////////
unsigned char build(unsigned int x, unsigned int y, unsigned int step)
{
    if (((x >> step & 0x1) && !(y >> step & 0x1)) ||
        (!(x >> step & 0x1) && (y >> step & 0x1)))
    {
        return 0xFF;
    }
    else
    {
        return 0;
    }
} // end build

//////////////////////////////////////////////////////////////////////
//    main function
/////////////////////////////////////////////////////////////////////
__attribute__((constructor)) void main()
{
    unsigned char buf[NPIXEL];
    int n = procid();
    int nprocs = NB_PROCS;
    int line;
    int pixel;

    for (line = n; line < NLINE; line += nprocs)
    {
        for (pixel = 0; pixel < NPIXEL; pixel += 1)
        {
            buf[pixel] = build(pixel, line, 5);
        }
        /*
         * - offset : offset (in bytes) in the frame buffer
         * - buffer : base address of the memory buffer
         * - length : number of bytes to be transfered
         * unsigned int fb_sync_write(unsigned int offset, void *buffer, unsigned int length)
         */
        if (fb_sync_write((line * NPIXEL), buf, NPIXEL) != 0)
        {
            tty_printf(" !!! wrong transfer to frame buffer for line %d\n", line);
        }
        else
        {
            tty_printf(" - building line %d\n", line);
        }
    }

    tty_printf("\ncycles = %d\n", proctime());
    exit();
} // end main
