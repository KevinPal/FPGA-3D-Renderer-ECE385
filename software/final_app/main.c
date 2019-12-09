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
static volatile int copy_done = 0;

static void done(void* handle, void* data) {
	copy_done = 255;
}

char transfer(volatile void* from, volatile void* to, alt_u32 size) {
	copy_done = 0;
	int rc;
	alt_dma_txchan txchan;
	alt_dma_rxchan rxchan;
	void* tx_data = (void*) from; /* pointer to data to send */
	void* rx_buffer = (void*) to; /* pointer to rx buffer */
	/* Create the transmit channel */
	if ((txchan = alt_dma_txchan_open("/dev/copy_dma")) == NULL) {
		printf("Failed to create transmit channel");
		return 255;
	}
	/* Create the receive channel */
	if ((rxchan = alt_dma_rxchan_open("/dev/copy_dma")) == NULL) {
		printf("Failed to create receive channel");
		return 225;
	}
	/* Post the transmit request */
	if ((rc = alt_dma_txchan_send(txchan, tx_data, size, NULL, NULL)) < 0) {
		printf("Failed to post transmit request, reason = %i\n", rc);
		return 225;
	}
	/* Post the receive request */
	if ((rc = alt_dma_rxchan_prepare(rxchan, rx_buffer, size, done, NULL))
			< 0) {
		printf("Failed to post read request, reason = %i\n", rc);
		return 225;
	}
	/* wait for transfer to complete */
	while (!copy_done);
	return 0;
}

void draw_cube(volatile gpu_core_t* gpu, int scale, int x, int y, int z,
		int block_id) {
	gpu->mode = GPU_MODE_RENDER;
	gpu->block_id = block_id;
	gpu->scale = scale * (FP_SCALE);
	gpu->x = x * (FP_SCALE);
	gpu->y = y * (FP_SCALE);
	gpu->z = (z - offset) * (FP_SCALE);
	gpu->done = 0;
	gpu->start = 0;
	gpu->start = 1;
	while (gpu->done == 0) {

	}

	gpu->done = 0;
	gpu->mode = GPU_MODE_IDLE;

}

void clear_screen(volatile gpu_core_t* gpu, int should_wait) {
	gpu->mode = GPU_MODE_CLEAR_FRAME;
	gpu->done = 0;
	gpu->start = 0;
	gpu->start = 1;
	if (should_wait == 1) {
		while (gpu->done == 0) {
		}
	}
	gpu->mode = GPU_MODE_IDLE;
}

void clear_depth(volatile gpu_core_t* gpu, int should_wait) {
	gpu->mode = GPU_MODE_CLEAR_DEPTH;
	gpu->done = 0;
	gpu->start = 0;
	gpu->start = 1;
	if (should_wait == 1) {
		while (gpu->done == 0) {
		}
	}
	gpu->mode = GPU_MODE_IDLE;
}

volatile struct gpu_core_t* gpu = GPU_CORE_0_BASE;
volatile struct dma_controller_t* dma = PIXEL_DMA_BASE;
//void swap_buffers() {
//	volatile frame_buffer_t* temp = vga_cont->frame_pointer;
//	vga_cont->frame_pointer = gpu->frame_pointer;
//	gpu->frame_pointer = temp;
//}

int main() {

	printf("Starting up");

	union frame_buffer_t* frame1 = (frame_buffer_t*) COPY_DMA_WRITE_MASTER_FRAME_BUFFER_BASE;
	union frame_buffer_t* frame2 = malloc(sizeof(frame_buffer_t));
	union z_buffer_t* z_buffer = malloc(sizeof(z_buffer_t));

	dma->back_buffer = frame1;
	dma->front_buffer = 0; //swap

	gpu->frame_pointer = frame2;
	gpu->z_buffer = z_buffer;


	printf("Allocation Done. Frame 1: %h, Frame2: %h, Z Buffer: %h\n", frame1,
			frame2, z_buffer);

	printf("Done initial clear, Initing keyboard\n");
	init_keyboard();

	double theta = 0;
	double phi = 0;

	gpu->cam_pos.z = 0;
	gpu->cam_pos.y = 0;

	int keycode = 0;
	while (1) {
		time_t start_time = clock();
		clear_depth(gpu, 1);
		clear_screen(gpu, 1);
		printf("Clear ticks %d\n", clock() - start_time);
		start_time = clock();

		for (int z = 4; z > 0; z--) {
			for (int x = 10; x > -5; x--) {
				draw_cube(gpu, 8, -16 + 8 * x, -16, -64 + 8 * z, 0);
			}
		}

		for (int y = 1; y < 6; y++) {
			draw_cube(gpu, 8, -16, -16 + 8 * y, -64 + 16, 2);
		}

		for (int y = 1; y < 6; y++) {
			draw_cube(gpu, 8, -16 + 16, -16 + 8 * y, -64 + 16 - 16, 2);
		}

		draw_cube(gpu, 8, 16, -8, -40, 3);
		draw_cube(gpu, 8, 8, -8, -40, 3);
		draw_cube(gpu, 8, 24, -8, -40, 3);
		draw_cube(gpu, 8, 16, -8, -40 - 8, 3);
		draw_cube(gpu, 8, 16, -8, -40 + 8, 3);
		draw_cube(gpu, 8, 16, 0, -40, 6);

		int c_w = 3;
		int c_h = 3;
		pixel_t pixel = {200, 200, 200, 0};
		for(int c = SCREEN_HEIGHT/2 - c_w; c < SCREEN_HEIGHT/2 + c_w + 1;c++) {
			frame2->D2[c][SCREEN_WIDTH/2] = pixel;

		}
		for(int c = SCREEN_WIDTH/2 - c_h; c < SCREEN_WIDTH/2 + c_h + 1;c++) {
			frame2->D2[SCREEN_HEIGHT/2][c] = pixel;
		}

		printf("Render ticks %d\n", clock() - start_time);
		start_time = clock();

		//memcpy(frame1, frame2, sizeof(frame1->D1));
		//printf("%d", );
		transfer(frame2, frame1,sizeof(frame1->D1));

		printf("Copy ticks %d\n", clock() - start_time);
		start_time = clock();


		loop_keyboard(&keycode);
		if(keycode == KEY_S) {
			gpu->cam_pos.z += 1;
		} else if (keycode == KEY_W) {
			gpu->cam_pos.z -= 1;
		}

		if(keycode == KEY_A) {
			gpu->cam_pos.x += 1;
		} else if (keycode == KEY_D) {
			gpu->cam_pos.x -= 1;
		}

		if(keycode == KEY_UP) {
			theta += 0.01;
		} else if(keycode == KEY_DOWN) {
			theta -= 0.01;
		}

		if(keycode == KEY_LEFT) {
			phi += 0.01;
		} else if(keycode == KEY_RIGHT) {
			phi -= 0.01;
		}

		int s_t = (int) (sin(theta) * (1 << 8));
		int c_t = (int) (cos(theta) * (1 << 8));

		int s_p = (int) (sin(phi) * (1 << 8));
		int c_p = (int) (cos(phi) * (1 << 8));

//		gpu->cam_x_axis.x = c;
//		gpu->cam_x_axis.y = 0;
//		gpu->cam_x_axis.z = -s;
//
//		gpu->cam_y_axis.x = 0;
//		gpu->cam_y_axis.y = 1<<8;
//		gpu->cam_y_axis.z = 0;
//
//		gpu->cam_z_axis.x = s;
//		gpu->cam_z_axis.y = 0;
//		gpu->cam_z_axis.z = c;

		//        Matrix([[cos(phi), 			0,			 sin(phi), 0],
		//                [sin(phi)*sin(theta), cos(theta), -sin(theta)*cos(phi), 0],
		//                [-sin(phi)*cos(theta), sin(theta), cos(phi)*cos(theta), 0], [0, 0, 0, 1]]

		gpu->cam_x_axis.x = c_p;
		gpu->cam_x_axis.y = s_p * s_t / (1 << 8);
		gpu->cam_x_axis.z = -s_p * c_t / (1 << 8);

		gpu->cam_y_axis.x = 0;
		gpu->cam_y_axis.y = c_t;
		gpu->cam_y_axis.z = s_t;

		gpu->cam_z_axis.x = s_p;
		gpu->cam_z_axis.y = -s_t * c_p / (1 << 8);
		gpu->cam_z_axis.z = c_p * c_t / (1 << 8);
	}

	return 1;
}
