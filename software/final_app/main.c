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
#include "keyboard.h"
#include "math.h"

int offset = 0;

void draw_cube(volatile gpu_core_t* gpu, int scale, int x, int y, int z,
		int block_id) {
	gpu->mode = GPU_MODE_RENDER;
	gpu->block_id = block_id;
	gpu->scale = scale * (FP_SCALE);
	gpu->x = x * (FP_SCALE);
	gpu->y = y * (FP_SCALE);
	gpu->z = (z-offset) * (FP_SCALE);
	gpu->done = 0;
	gpu->start = 0;
	gpu->start = 1;
	time_t start = clock();
	while (gpu->done == 0) {

	}
//	time_t delta = clock() - start;
//	if (delta > 100) {
//		printf("Render ticks %d\n", delta);
//	}
	gpu->done = 0;
	gpu->mode = GPU_MODE_IDLE;

}

void clear_screen(volatile gpu_core_t* gpu, int should_wait) {
	gpu->mode = GPU_MODE_CLEAR_FRAME;
	gpu->done = 0;
	gpu->start = 0;
	gpu->start = 1;
	//printf("start clear");
	if (should_wait == 1) {
		while (gpu->done == 0) {
		}
	}
	//printf("end clear");
	//gpu->done = 0;
	gpu->mode = GPU_MODE_IDLE;
}

void clear_depth(volatile gpu_core_t* gpu, int should_wait) {
	gpu->mode = GPU_MODE_CLEAR_DEPTH;
	gpu->done = 0;
	gpu->start = 0;
	gpu->start = 1;
	//printf("start clear");
	if (should_wait == 1) {
		while (gpu->done == 0) {
		}
	}
	//printf("end clear");
	//gpu->done = 0;
	gpu->mode = GPU_MODE_IDLE;
}

//volatile struct vga_controller_t* vga_cont = VGA_CONTROLLER_0_BASE;
volatile struct gpu_core_t* gpu = GPU_CORE_0_BASE;
volatile struct dma_controller_t* dma = PIXEL_DMA_BASE;
//void swap_buffers() {
//	volatile frame_buffer_t* temp = vga_cont->frame_pointer;
//	vga_cont->frame_pointer = gpu->frame_pointer;
//	gpu->frame_pointer = temp;
//}

int main() {

	printf("Starting up");

	union frame_buffer_t* frame1 = (frame_buffer_t*) FRAME_BUFFER_BASE;
	union frame_buffer_t* frame2 = malloc(sizeof(frame_buffer_t));
	union z_buffer_t* z_buffer = malloc(sizeof(z_buffer_t));

	dma->back_buffer = frame1;
	dma->front_buffer = 0; //swap

	gpu->frame_pointer = frame2;
	gpu->z_buffer = z_buffer;
	//vga_cont->frame_pointer = frame1;

	printf("Allocation Done. Frame 1: %h, Frame2: %h, Z Buffer: %h\n", frame1,
			frame2, z_buffer);

	printf("Done initial clear, Initing keyboard\n");
	init_keyboard();

	double theta = 0;




	int keycode = 0;
	while (1) {
		time_t start_time = clock();
		clear_depth(gpu, 1);
		clear_screen(gpu, 1);
		printf("Clear ticks %d\n", clock() - start_time);
		start_time = clock();

		for(int z = 5; z > 0; z--) {
		for(int x = 10; x > -30; x--) {
					draw_cube(gpu, 8, -16 + 8*x, -16, -64 + 8*z, 0);
			}
		}

		for(int y = 1; y < 6; y++) {
			draw_cube(gpu, 8, -16, -16+8*y, -64 + 16, 2);
		}

		for(int y = 1; y < 6; y++) {
			draw_cube(gpu, 8, -16+16, -16+8*y, -64 + 16-16, 2);
		}

		draw_cube(gpu, 8, 16, -8, -40, 3);
		draw_cube(gpu, 8, 8, -8, -40, 3);
		draw_cube(gpu, 8, 24, -8, -40, 3);
		draw_cube(gpu, 8, 16, -8, -40-8, 3);
		draw_cube(gpu, 8, 16, -8, -40+8, 3);
		draw_cube(gpu, 8, 16, 0, -40, 6);


		memcpy(frame1, frame2, sizeof(frame1->D1));


		printf("Render ticks %d\n", clock() - start_time);
		start_time = clock();
		//usleep(500000);
		//printf("swaping");
		//swap_buffers();

		loop_keyboard(&keycode);
		if(keycode == KEY_S) {
			gpu->cam_pos.z += 1;
		} else if (keycode == KEY_W) {
			gpu->cam_pos.z -= 1;
		}
		if(keycode == KEY_A) {
			//gpu->cam_pos.y += 1;
			theta += 0.01;
		} else if(keycode == KEY_D) {
			theta -= 0.01;
			//gpu->cam_pos.y -= 1;
			//printf("moving %d", gpu->cam_pos.y);
		}

		int s = (int)(sin(theta) * (1<<8));
		int c = (int)(cos(theta) * (1<<8));

		gpu->cam_x_axis.x = c;
		gpu->cam_x_axis.y = 0;
		gpu->cam_x_axis.z = -s;

		gpu->cam_y_axis.x = 0;
		gpu->cam_y_axis.y = 1<<8;
		gpu->cam_y_axis.z = 0;

		gpu->cam_z_axis.x = s;
		gpu->cam_z_axis.y = 0;
		gpu->cam_z_axis.z = c;

	}

	return 1;
}
