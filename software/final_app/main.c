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

//static volatile int rx_done = 0;
///*
//* Callback function that obtains notification that the data
//* is received.*/
//static void done (void* handle, void* data)
//{
//rx_done = 255;
//}


//char transfer(volatile void* from, volatile void* to, alt_u32 size) {
//	rx_done = 0;
//	int rc;
//	alt_dma_txchan txchan;
//	alt_dma_rxchan rxchan;
//	void* tx_data = (void*) from; /* pointer to data to send */
//	void* rx_buffer = (void*) to; /* pointer to rx buffer */
//	/* Create the transmit channel */
//	if ((txchan = alt_dma_txchan_open("/dev/dma_0")) == NULL) {
//		printf("Failed to create transmit channel");
//		return 255;
//	}
//	/* Create the receive channel */
//	if ((rxchan = alt_dma_rxchan_open("/dev/dma_0")) == NULL) {
//		printf("Failed to create receive channel");
//		return 225;
//	}
//	/* Post the transmit request */
//	if ((rc = alt_dma_txchan_send (txchan, tx_data,
//			size, NULL, NULL)) < 0) {
//	printf ("Failed to post transmit request, reason = %i\n", rc);
//		return 225;
//	}
//	/* Post the receive request */
//	if ((rc = alt_dma_rxchan_prepare (rxchan, rx_buffer,
//			size, done, NULL)) < 0) {
//	printf ("Failed to post read request, reason = %i\n", rc);
//		return 225;
//	}
//	/* wait for transfer to complete */
//	while (!rx_done);
//	//printf ("Transfer successful!\n");
//	return 0;
//}

int main()
{
	int i = 0;
	int height = 0;

	volatile struct vga_controller_t* vga_cont = VGA_CONTROLLER_0_BASE;

	union frame_buffer_t* frame1 =  malloc(sizeof(frame_buffer_t));

	vga_cont->frame_pointer = frame1;
	vga_cont->should_draw = 527;
	//clock_t start = clock();
	for(int y = 0; y < SCREEN_HEIGHT; y++) {
		for(int x =0; x < SCREEN_WIDTH; x++) {
			//struct pixel_t p = {{(y*255) / SCREEN_HEIGHT, (x*255) / SCREEN_WIDTH,0, 0}};
			struct pixel_t p = {.r = 0, .g = 255, .b = 0, .a = 0};  //? B G R
			p.r = (y * 255)/480;
			p.g = (x * 255)/640;
			frame1->D2[y][x] = p;
		}
	}
	//for(i = 0; i < 100; i++) {
	//	struct pixel_t p = {.r = 255, .g = 0, .b = 0, .a = 0};  //? B G R
	//	frame1->D1[SCREEN_HEIGHT * SCREEN_WIDTH + i] = p;
	//}
	//clock_t stop = clock();
	//double time_spent = (double)(stop - start) / CLOCKS_PER_SEC;
	//printf("%f\n", time_spent);
	frame1->D2[0][0].r = 0;
	frame1->D2[0][0].b = 0;
	frame1->D2[0][0].g = 255;
	frame1->D2[0][6].r = 0;
	frame1->D2[0][6].b = 255;
	frame1->D2[0][6].g = 0;
	//frame1->D2[0][SCREEN_WIDTH-1].b = 255;
	//frame1->D2[0][9].g = 255;
	//frame1->D2[0][9].r = 0;
	//frame1->D2[0][9].g = 255;
	//frame1->D2[2][10].r = 255;

	for(int x = 0; x < SCREEN_WIDTH; x++) {
		struct pixel_t p = {.r = 0, .g = x, .b = 0, .a = 0};  //? B G R
		if(x%2==0) {
			p.b = 255;
			p.g = 0;
		}
		frame1->D2[2][x] = p;
	}
	frame1->D2[0][6].r = 0;
	frame1->D2[0][6].b = 255;
	frame1->D2[0][6].g = 0;
	frame1->D2[0][1].r = 0;
	frame1->D2[0][1].b = 255;
	frame1->D2[0][1].g = 0;

	frame1->D2[2][0].r = 0;
	frame1->D2[2][0].b = 0;
	frame1->D2[2][0].g = 0;

	frame1->D2[0][SCREEN_WIDTH-5].r = 0;
	frame1->D2[0][SCREEN_WIDTH-5].b = 255;
	frame1->D2[0][SCREEN_WIDTH-5].g = 0;



	height = 0;
	//transfer(frame1->D2[height], vga_cont->line2, sizeof(frame1->D2[0]));
	//transfer(frame1->D2[height], vga_cont->line1, sizeof(frame1->D2[0]));

	int draw_index = 0;
//    while(1) {
//    	if(draw_index >= 480*640*3) {
//    		draw_index = 0;
//    	}
//    	frame1->D2[2][0].r = (draw_index++)/1000;
//    }


    return 1;
}
