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

int main()
{
	int i = 0;
	int height = 0;

	volatile struct vga_controller_t* vga_cont = VGA_CONTROLLER_0_BASE;
	volatile struct gpu_core_t* gpu = GPU_CORE_0_BASE;

	union frame_buffer_t* frame1 =  malloc(sizeof(frame_buffer_t));

	gpu->scale = 64 * (1<<8);
	gpu->x = 0 * (1<<8);
	gpu->y = 0;
	gpu->z = -20 * (1<<8);
	gpu->start = 0;
	printf("%d", gpu->start);

	vga_cont->frame_pointer = frame1;
	gpu->frame_pointer = frame1;
	gpu->done = 0;
	gpu->start = 1;
	//clock_t start = clock();
	for(int y = 0; y < SCREEN_HEIGHT; y++) {
		for(int x =0; x < SCREEN_WIDTH; x++) {
			//struct pixel_t p = {{(y*255) / SCREEN_HEIGHT, (x*255) / SCREEN_WIDTH,0, 0}};
			struct pixel_t p = {.r = 0, .g = 255, .b = 0, .a = 0};  //? B G R
			p.r = (y * 255)/480;
			p.g = (x * 255)/640;
			frame1->D2[y][x] = p;
		}
		if(gpu->done == 1) {
			gpu->done = 0;
			gpu->start = 0;
			gpu->start = 1;
		}
	}

	frame1->D2[0][0].r = 0;
	frame1->D2[0][0].b = 0;
	frame1->D2[0][0].g = 255;
	frame1->D2[0][6].r = 0;
	frame1->D2[0][6].b = 255;
	frame1->D2[0][6].g = 0;

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

    return 1;
}
