#include "config.h"
#include "stdio.h"

#define NPIXEL 128
#define NLINE 128

///////////////////////////////////////////////////////////////////////////////
//	main function
///////////////////////////////////////////////////////////////////////////////
__attribute__((constructor)) void main()
{
    unsigned char BUF1[NPIXEL * NLINE];
    unsigned char BUF2[NPIXEL * NLINE];
    unsigned int line;
    unsigned int pixel;
    unsigned int step; // Square size
    // Processor related variables
    int n = procid();
    int nprocs = NB_PROCS;
    
    tty_printf("\n*** procid : %d ***\n\n", n);
    barrier_init(0, nprocs-1); // 1 barrier for all processors

    // PROLOGUE
    // Build the first image
    step = 1;
    tty_printf("\n*** damier %d ***\n\n", step);

    for (line = n; line < NLINE; line += nprocs)
    {
        for (pixel = 0; pixel < NPIXEL; pixel++)
        {
            if (((pixel >> step & 0x1) && !(line >> step & 0x1)) ||
                (!(pixel >> step & 0x1) && (line >> step & 0x1)))
                BUF1[(NPIXEL * line) + pixel] = 0xFF;
            else
                BUF1[(NPIXEL * line) + pixel] = 0x0;
        }
    }
    barrier_wait(0);
    tty_printf(" - build   OK at cycle %d\n", proctime());
    
    // Pipeline is loaded, we can start the main loop
    // Build image i and show image i-1
    for (step = 2; step < 6; step++)
    {
        tty_printf("\n*** damier %d ***\n\n", step);

        // Even step
        if (step % 2 == 0)
        {
            // Only processor 0 can use DMA
            // Show image i-1
            if(n == 0){
                if ((fb_write(0, BUF1, NLINE * NPIXEL) != 0))
                {
                    tty_printf("\n!!! error in fb_syn_write syscall !!!\n");
                }
            }
            tty_printf(" - display OK at cycle %d\n", proctime());


            // Build image i
            for (line = n; line < NLINE; line += nprocs)
            {
                for (pixel = 0; pixel < NPIXEL; pixel++)
                {
                    if (((pixel >> step & 0x1) && !(line >> step & 0x1)) ||
                        (!(pixel >> step & 0x1) && (line >> step & 0x1)))
                        BUF2[(NPIXEL * line) + pixel] = 0xFF;
                    else
                        BUF2[(NPIXEL * line) + pixel] = 0x0;
                }
            }
            barrier_wait(0);
            tty_printf(" - build   OK at cycle %d\n", proctime());

        }
        // Odd step
        else
        {
            // Only processor 0 can use DMA
            // Show image i-1
            if(n == 0){
                if ((fb_write(0, BUF2, NLINE * NPIXEL) != 0))
                {
                    tty_printf("\n!!! error in fb_syn_write syscall !!!\n");
                }
            }
            tty_printf(" - display OK at cycle %d\n", proctime());


            // Build image i
            for (line = n; line < NLINE; line += nprocs)
            {
                for (pixel = 0; pixel < NPIXEL; pixel++)
                {
                    if (((pixel >> step & 0x1) && !(line >> step & 0x1)) ||
                        (!(pixel >> step & 0x1) && (line >> step & 0x1)))
                        BUF1[(NPIXEL * line) + pixel] = 0xFF;
                    else
                        BUF1[(NPIXEL * line) + pixel] = 0x0;                    
                }
            }
            barrier_wait(0);
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
    // Only processor 0 can use DMA
    if(n == 0){
        if ((fb_write(0, BUF1, NLINE * NPIXEL) != 0))
        {
            tty_printf("\n!!! error in fb_syn_write syscall !!!\n");
        }
    }
    tty_printf(" - display OK at cycle %d\n", proctime());

    // Fin de programme, pas besoin de fb_completed()

    tty_printf("\nFin du programme au cycle = %d\n\n", proctime());
    exit();
} // end main
