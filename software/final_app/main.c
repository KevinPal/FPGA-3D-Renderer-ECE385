#include "system.h"
#include <math.h>
#include <time.h>
#include "types.h"
#include <stdlib.h>
#include "altera_avalon_dma.h"
#include <stdio.h>
#include <stddef.h>
#include <stdlib.h>
#include "sys/alt_dma.h"
#include "alt_types.h"

static volatile int rx_done = 0;
/*
* Callback function that obtains notification that the data
* is received.*/
static void done (void* handle, void* data)
{
rx_done = 255;
}


char transfer(void* from, void* to, alt_u32 size) {

	int rc;
	alt_dma_txchan txchan;
	alt_dma_rxchan rxchan;
	void* tx_data = (void*) from; /* pointer to data to send */
	void* rx_buffer = (void*) to; /* pointer to rx buffer */
	/* Create the transmit channel */
	if ((txchan = alt_dma_txchan_open("/dev/dma_0")) == NULL) {
		printf("Failed to create transmit channel");
		return 255;
	}
	/* Create the receive channel */
	if ((rxchan = alt_dma_rxchan_open("/dev/dma_0")) == NULL) {
		printf("Failed to create receive channel");
		return 225;
	}
	/* Post the transmit request */
	if ((rc = alt_dma_txchan_send (txchan, tx_data,
			size, NULL, NULL)) < 0) {
	printf ("Failed to post transmit request, reason = %i\n", rc);
		return 225;
	}
	/* Post the receive request */
	if ((rc = alt_dma_rxchan_prepare (rxchan, rx_buffer,
			size, done, NULL)) < 0) {
	printf ("Failed to post read request, reason = %i\n", rc);
		return 225;
	}
	/* wait for transfer to complete */
	while (!rx_done);
	//printf ("Transfer successful!\n");
	return 0;
}

int main()
{
	int i = 0;
	int height = 0;

	volatile struct vga_controller_t* vga_cont = VGA_CONTROLLER_0_BASE;

	union frame_buffer_t* frame1 =  malloc(sizeof(frame_buffer_t));

//	for(i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++) {
//		frame1->D1[i*3+0] = 0;
//		frame1->D1[i*3+1] = 255;
//		frame1->D1[i*3+2] = 0;
//	}

	clock_t start = clock();
	for(int y = 0; y < SCREEN_HEIGHT; y++) {
		for(int x =0; x < SCREEN_WIDTH; x++) {
			frame1->D1[(y*SCREEN_WIDTH + x)*3 + 0] = (y*255) / SCREEN_HEIGHT;
			frame1->D1[(y*SCREEN_WIDTH + x)*3 + 1] = (x*255) / SCREEN_WIDTH;
			frame1->D1[(y*SCREEN_WIDTH + x)*3 + 2] = 0;

		}
	}
	clock_t stop = clock();
	double time_spent = (double)(stop - start) / CLOCKS_PER_SEC;
	printf("%f\n", time_spent);

	height = 0;
	transfer(frame1->D2[height], vga_cont->line2, 1920);
	transfer(frame1->D2[height], vga_cont->line1, 1920);


	int flag = 0;
	int draw_index = 0;
    while(1) {
    	if(draw_index >= 480*640*3) {
    		draw_index = 0;
    	}
        if(vga_cont->needs_write >= 1) {
            if(vga_cont->rendering_frame == 0) { // Write to line 0

            	//if(height % 200 == 0) {
            		//clock_t start = clock();
            		transfer(frame1->D2[height], vga_cont->line1, 1920);
            		//clock_t stop = clock();
            		//double time_spent = (double)(stop - start) / CLOCKS_PER_SEC;
            		//printf("%f\n", time_spent);


//                for(i = 0; i < SCREEN_WIDTH; i++) {
//                    vga_cont->line2[i*3+0] = frame1->D1[draw_index++];
//                    vga_cont->line2[i*3+1] = frame1->D1[draw_index++];
//                    vga_cont->line2[i*3+2] = frame1->D1[draw_index++];
//
//                }
//                clock_t stop = clock();
//        		double time_spent = (double)(stop - start) / CLOCKS_PER_SEC;
//        		if(flag < 50)
//        			printf("%f\n", time_spent);
//        		flag++;
                //temp = 1;
            } else { // Write to line 1
            	transfer(frame1->D2[height], vga_cont->line2, 1920);

            	//transfer(frame1+height*1920, vga_cont->line2, 1920);
//                for(i = 0; i < SCREEN_WIDTH; i++) {
//                    vga_cont->line1[i*3+0] = frame1->D1[draw_index++];
//                    vga_cont->line1[i*3+1] = frame1->D1[draw_index++];
//                    vga_cont->line1[i*3+2] = frame1->D1[draw_index++];
//                }
                //temp = 0;
            }
            if(flag < 10 & vga_cont->needs_write > 1) {
            	printf("Missed frame");
            	printf("%d\n", vga_cont->needs_write);
            	flag++;
            }
            height = (height + vga_cont->needs_write) % SCREEN_HEIGHT;
            vga_cont->needs_write = 0;

        }
    }


    return 1;
}
