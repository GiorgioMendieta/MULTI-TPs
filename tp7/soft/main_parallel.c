#include "config.h"
#include "stdio.h"

#define NPIXEL 128
#define NLINE 128

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

///////////////////////////////////////////////////////////////////////////////
//	main function
///////////////////////////////////////////////////////////////////////////////
__attribute__((constructor)) void main()
{
    unsigned char BUF1[NPIXEL * NLINE];
    unsigned char BUF2[NPIXEL * NLINE];
    unsigned int line;
    unsigned int pixel;
    unsigned int step;
    // Processor related variables
    int n = procid();
    int nprocs = NB_PROCS;

    // PROLOGUE
    // Build the first image
    step = 1;
    tty_printf("\n*** damier %d ***\n\n", step);

    for (line = 0; line < NLINE; line += nprocs)
    {
        for (pixel = 0; pixel < NPIXEL; pixel++)
        {
            BUF1[pixel] = build(pixel, line, step);
        }
    }
    tty_printf(" - build   OK at cycle %d\n", proctime());

    // Pipeline is loaded, we can start the main loop
    // Build image i and show image i-1
    for (step = 2; step < 6; step++)
    {
        tty_printf("\n*** damier %d ***\n\n", step);

        // Even step
        if (step % 2 == 0)
        {
            if (fb_write(0, BUF1, NLINE * NPIXEL) != 0)
            {
                tty_printf("\n!!! error in fb_syn_write syscall !!!\n");
            }

            tty_printf(" - display OK at cycle %d\n", proctime());

            for (line = 0; line < NLINE; line += nprocs)
            {
                for (pixel = 0; pixel < NPIXEL; pixel++)
                {
                    BUF2[pixel] = build(pixel, line, step);
                }
            }
            tty_printf(" - build   OK at cycle %d\n", proctime());
        }
        // Odd step
        else
        {
            if (fb_write(0, BUF2, NLINE * NPIXEL) != 0)
            {
                tty_printf("\n!!! error in fb_syn_write syscall !!!\n");
            }
            tty_printf(" - display OK at cycle %d\n", proctime());

            for (line = 0; line < NLINE; line += nprocs)
            {
                for (pixel = 0; pixel < NPIXEL; pixel++)
                {
                    BUF1[pixel] = build(pixel, line, step);
                }
            }
            tty_printf(" - build   OK at cycle %d\n", proctime());
        }

        if (fb_completed() != 0)
        {
            tty_printf("\n!!! DMA transfer error !!!\n");
            exit();
        }
    }

    // EPILOGUE
    // Display the last image
    if (fb_write(0, BUF1, NLINE * NPIXEL) != 0)
    {
        tty_printf("\n!!! error in fb_syn_write syscall !!!\n");
    }
    tty_printf(" - display OK at cycle %d\n", proctime());

    // Fin de programme, pas besoin de fb_completed()

    tty_printf("\nFin du programme au cycle = %d\n\n", proctime());
    exit();
} // end main
