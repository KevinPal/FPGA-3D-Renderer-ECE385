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
#include "gpu.h"

int offset = 0;
static volatile int copy_done = 0;

char transfer(volatile void* from, volatile void* to, alt_u32 size);

volatile struct gpu_core_t* gpu = GPU_CORE_0_BASE;
volatile struct dma_controller_t* dma = PIXEL_DMA_BASE;

void draw_tree(volatile gpu_core_t* gpu, int base_x, int base_y, int base_z, int height, int log_id, int leaf_id) {
	for (int y = 0; y < height; y++) {
		draw_cube(gpu, 8, base_x, base_y + 8 * y, base_z, log_id);
	}
	draw_cube(gpu, 8, base_x, base_y + 8 * height, base_z, leaf_id);
	draw_cube(gpu, 8, base_x-8, base_y + 8 * height - 8, base_z, leaf_id);
	draw_cube(gpu, 8, base_x+8, base_y + 8 * height - 8, base_z, leaf_id);
	draw_cube(gpu, 8, base_x, base_y + 8 * height - 8, base_z + 8, leaf_id);
	draw_cube(gpu, 8, base_x, base_y + 8 * height - 8, base_z - 8, leaf_id);

	draw_cube(gpu, 8, base_x-8, base_y + 8 * height - 16, base_z, leaf_id);
	draw_cube(gpu, 8, base_x+8, base_y + 8 * height - 16, base_z, leaf_id);
	draw_cube(gpu, 8, base_x, base_y + 8 * height - 16, base_z + 8, leaf_id);
	draw_cube(gpu, 8, base_x, base_y + 8 * height - 16, base_z - 8, leaf_id);

	draw_cube(gpu, 8, base_x-8, base_y + 8 * height - 16, base_z-8, leaf_id);
	draw_cube(gpu, 8, base_x+8, base_y + 8 * height - 16, base_z-8, leaf_id);
	draw_cube(gpu, 8, base_x-8, base_y + 8 * height - 16, base_z + 8, leaf_id);
	draw_cube(gpu, 8, base_x+8, base_y + 8 * height - 16, base_z + 8, leaf_id);

}

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
	float last_fps = 0;
	char fps_str[4];
	while (1) {
		time_t start_time = clock();
		time_t frame_time = clock();

		//transfer(frame_clean, frame2, sizeof(frame2->D1));
		//transfer(z_buffer_clean, z_buffer, sizeof(z_buffer->D2));

		clear_screen(gpu, 1);
		clear_depth(gpu, 1);


		printf("Clear ticks %d\n", clock() - start_time);

		start_time = clock();

		for (int z = 4; z > 0; z--) {
			for (int x = 10; x > -5; x--) {
				draw_cube(gpu, 8, -16 + 8 * x, -16, -64 + 8 * z, BLOCK_GRASS);
			}
		}

		//		draw_cube(gpu, 8, -16 + 16, -16 + 8 * y, -64 + 16 - 16, BLOCK_LOG_DARK);
		draw_tree(gpu, 0, -16, -64, 5, BLOCK_LOG_DARK, BLOCK_LEAF_TRANS);


		draw_tree(gpu, -16, -16, -48, 6,  BLOCK_LOG, BLOCK_LEAF_TRANS);



		draw_cube(gpu, 8, 16, -8, -40, BLOCK_COBBLE);
		draw_cube(gpu, 8, 8, -8, -40, BLOCK_COBBLE);
		draw_cube(gpu, 8, 24, -8, -40, BLOCK_COBBLE);
		draw_cube(gpu, 8, 16, -8, -40 - 8, BLOCK_COBBLE);
		draw_cube(gpu, 8, 16, -8, -40 + 8, BLOCK_GLASS);
		draw_cube(gpu, 8, 16, 0, -40, BLOCK_FURNACE);



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


		gcvt (last_fps, 4, fps_str);
		draw_string(frame2, "FPS:", 4, 10, 10);
		draw_string(frame2, fps_str, 4, 40, 10);
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

		//        Matrix([[cos(phi), 			0,			 sin(phi), 0],
		//                [sin(phi)*sin(theta), cos(theta), -sin(theta)*cos(phi), 0],
		//                [-sin(phi)*cos(theta), sin(theta), cos(phi)*cos(theta), 0], [0, 0, 0, 1]]

		gpu->cam_x_axis.x = c_p;
		gpu->cam_x_axis.y = s_p * s_t / FP_SCALE;
		gpu->cam_x_axis.z = -s_p * c_t / FP_SCALE;

		gpu->cam_y_axis.x = 0;
		gpu->cam_y_axis.y = c_t;
		gpu->cam_y_axis.z = s_t;

		gpu->cam_z_axis.x = s_p;
		gpu->cam_z_axis.y = -s_t * c_p / FP_SCALE;
		gpu->cam_z_axis.z = c_p * c_t / FP_SCALE;

		last_fps = 1000.0/(clock() - frame_time);
		//printf("Frame ticks %.2f\n", );
	}

	return 1;
}

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
