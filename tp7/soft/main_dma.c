
#include "stdio.h"

#define NPIXEL 128 //256
#define NLINE 128 //256

///////////////////////////////////////////////////////////////////////////////
//	main function
///////////////////////////////////////////////////////////////////////////////
__attribute__((constructor)) void main()
{
    unsigned char BUF[NPIXEL * NLINE];
    unsigned int line;
    unsigned int pixel;
    unsigned int step;

    for (step = 1; step < 6; step++)
    {
        tty_printf("\n*** damier %d ***\n\n", step);

        for (pixel = 0; pixel < NPIXEL; pixel++)
        {
            for (line = 0; line < NLINE; line++)
            {
                if (((pixel >> step & 0x1) && !(line >> step & 0x1)) ||
                    (!(pixel >> step & 0x1) && (line >> step & 0x1)))
                    BUF[NPIXEL * line + pixel] = 0xFF;
                else
                    BUF[NPIXEL * line + pixel] = 0x0;
            }
        }

        tty_printf(" - build   OK at cycle %d\n", proctime());

        // if (fb_sync_write(0, BUF, NLINE * NPIXEL) != 0)
        // {
        //     tty_printf("\n!!! error in fb_syn_write syscall !!!\n");
        //     exit();
        // }

        if (fb_write(0, BUF, NLINE * NPIXEL) != 0)
        {
            tty_printf("\n!!! error in fb_syn_write syscall !!!\n");
            exit();
        }

        if (fb_completed() != 0)
        {
            tty_printf("\n!!! DMA transfer error !!!\n");
            exit();
        }
        
        // Insertion d'une erreur -> lecture à l'adresse 0X0
        // if(fb_write(0, BUF+0x80000000, 100)!=0){
        //     tty_printf("\n!!! ERREUR ADRESSE !!!\n");
        //     exit();
        // }

        tty_printf(" - display OK at cycle %d\n", proctime());
    }
    tty_printf("\nFin du programme au cycle = %d\n\n", proctime());
    exit();
} // end main
