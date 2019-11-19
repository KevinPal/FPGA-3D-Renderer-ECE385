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

void draw_cube(volatile gpu_core_t* gpu, int scale, int x, int y, int z) {
	gpu->mode = GPU_MODE_RENDER;
	gpu->scale = scale * (1<<8);
	gpu->x = x * (1<< 8);
	gpu->y = y * (1<< 8);
	gpu->z = z * (1<< 8);
	gpu->done = 0;
	gpu->start = 0;
	gpu->start = 1;
	while(gpu->done == 0) {

	}
	//gpu->done = 0;
	gpu->mode = GPU_MODE_IDLE;

}

void clear_screen(volatile gpu_core_t* gpu) {
	gpu->mode = GPU_MODE_CLEAR;
	gpu->done = 0;
	gpu->start = 0;
	gpu->start = 1;
	//printf("start clear");
	while(gpu->done == 0) {

	}
	//printf("end clear");
	//gpu->done = 0;
	gpu->mode = GPU_MODE_IDLE;
}


volatile struct vga_controller_t* vga_cont = VGA_CONTROLLER_0_BASE;
volatile struct gpu_core_t* gpu = GPU_CORE_0_BASE;

void swap_buffers() {
	volatile frame_buffer_t* temp = vga_cont->frame_pointer;
	vga_cont->frame_pointer = gpu->frame_pointer;
	gpu->frame_pointer = temp;
}


int main()
{

	printf("Starting up");

	union frame_buffer_t* frame1 =  malloc(sizeof(frame_buffer_t));
	union frame_buffer_t* frame2 =  malloc(sizeof(frame_buffer_t));

	gpu->frame_pointer = frame2;
	vga_cont->frame_pointer = frame1;
	int depth = 70;
	int x = 0;
	while(1) {
		clear_screen(gpu);

		draw_cube(gpu, 16, 15+x, 20, -depth);
		draw_cube(gpu, 12, -35+x, 30, -depth);
		draw_cube(gpu, 25, -25+x, -20, -depth);
		//usleep(10);
		//printf("swaping");
		swap_buffers();
		//usleep(100);
		//timer += clock();
		//if(timer > 10) {
		//	x -= 1;
		//}
		x += 1;

	}


//	for(int y = 0; y < SCREEN_HEIGHT; y++) {
//		for(int x =0; x < SCREEN_WIDTH; x++) {
//			struct pixel_t p = {.r = 0x20, .g = 0x20, .b = 0x20, .a = 0};  //? B G R
//			gpu->frame_pointer->D2[y][x] = p;
//		}
//	}
//
//	draw_cube(gpu, 16, 15, 20, -70);
//	draw_cube(gpu, 12, -35, 30, -70);
//	draw_cube(gpu, 25, -25, -20, -100);
//
//	swap_buffers();
//
//	for(int y = 0; y < SCREEN_HEIGHT; y++) {
//		for(int x =0; x < SCREEN_WIDTH; x++) {
//			//struct pixel_t p = {{(y*255) / SCREEN_HEIGHT, (x*255) / SCREEN_WIDTH,0, 0}};
//			struct pixel_t p = {.r = 0x20, .g = 0x20, .b = 0x20, .a = 0};  //? B G R
//			p.r = (y * 255)/480;
//			p.g = (x * 255)/640;
//			gpu->frame_pointer->D2[y][x] = p;
//		}
//		if(gpu->done == 1) {
//			gpu->done = 0;
//			gpu->start = 0;
//			gpu->start = 1;
//		}
//	}
//
//	//while(1) {
//	draw_cube(gpu, 16, 15, 20, -70);
//
//	draw_cube(gpu, 12, -35, 30, -70);
//
//	draw_cube(gpu, 25, -25, -20, -100);
//
//	swap_buffers();
//	//}



    return 1;
}
