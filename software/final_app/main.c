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
extern int x_off;
extern int y_off;
extern int z_off;
static volatile int copy_done = 0;

char transfer(volatile void* from, volatile void* to, alt_u32 size);

volatile struct gpu_core_t* gpu = GPU_CORE_0_BASE;
volatile struct dma_controller_t* dma = PIXEL_DMA_BASE;

#define WORLD_Z 10
#define WORLD_Y 15
#define WORLD_X 15

void draw_tree(int world_data[WORLD_Z][WORLD_Y][WORLD_X], int base_x,
		int base_y, int base_z, int height, int log_id, int leaf_id) {

	for (int y = 0; y < height; y++) {
		world_data[base_z][base_y + y][base_x] = log_id;
	}

	world_data[base_z][base_y + 1 * height][base_x] = leaf_id;
	world_data[base_z][base_y + 1 * height - 1][base_x - 1] = leaf_id;
	world_data[base_z][base_y + 1 * height - 1][base_x + 1] = leaf_id;
	world_data[base_z + 1][base_y + 1 * height - 1][base_x] = leaf_id;
	world_data[base_z - 1][base_y + 1 * height - 1][base_x] = leaf_id;

	world_data[base_z][base_y + 1 * height - 2][base_x - 1] = leaf_id;
	world_data[base_z][base_y + 1 * height - 2][base_x + 1] = leaf_id;
	world_data[base_z + 1][base_y + 1 * height - 2][base_x] = leaf_id;
	world_data[base_z - 1][base_y + 1 * height - 2][base_x] = leaf_id;

	world_data[base_z - 1][base_y + 1 * height - 2][base_x - 1] = leaf_id;
	world_data[base_z - 1][base_y + 1 * height - 2][base_x + 1] = leaf_id;
	world_data[base_z + 1][base_y + 1 * height - 2][base_x - 1] = leaf_id;
	world_data[base_z + 1][base_y + 1 * height - 2][base_x + 1] = leaf_id;

}

void gen_world(int world_data[WORLD_Z][WORLD_Y][WORLD_X]) {
	for (int z = 0; z < WORLD_Z; z++) {
		for (int y = 0; y < WORLD_Y; y++) {
			for (int x = 0; x < WORLD_X; x++) {
				world_data[z][y][x] = -1;
			}
		}
	}

	const int grass_depth = 5;
	const int wall_height = 4;
	const int sold_wall_width = 7;

	for (int z = WORLD_Z - grass_depth; z < WORLD_Z; z++) {
		for (int x = 0; x < WORLD_X; x++) {
			world_data[z][0][x] = BLOCK_GRASS;
		}
	}

	for (int x = 0; x < 4; x++) {
		for (int y = 1; y < wall_height; y++) {
			world_data[WORLD_Z - grass_depth][y][x] = BLOCK_STONE;
		}
	}

	for (int x = 4; x < 7; x++) {
		for (int y = 1; y < wall_height; y++) {
			world_data[WORLD_Z - grass_depth - (y)][y][x] = BLOCK_PLANK;
		}
	}

	for (int x = 7; x < WORLD_X; x++) {
		for (int y = 1; y < wall_height; y++) {
			world_data[WORLD_Z - grass_depth][y][x] = BLOCK_STONE;
		}
	}

	for (int z = WORLD_Z - grass_depth; z < WORLD_Z; z++) {
		for (int x = 4; x < 7; x++) {
			world_data[z][0][x] = BLOCK_COBBLE;
		}
	}

	for (int z = WORLD_Z - grass_depth; z < WORLD_Z; z++) {
		world_data[z][0][3] = BLOCK_DIRT;
	}

	for (int z = WORLD_Z - grass_depth; z < WORLD_Z; z++) {
		world_data[z][0][7] = BLOCK_DIRT;
	}


	world_data[grass_depth+1][1][3] = BLOCK_LEAF_SOLID;
	world_data[grass_depth+1][1][2] = BLOCK_LEAF_SOLID;
	world_data[grass_depth+1][1][1] = BLOCK_LEAF_SOLID;
	world_data[grass_depth+1][1][0] = BLOCK_LEAF_SOLID;

	world_data[grass_depth+3][1][1] = BLOCK_PUMPKIN;


	draw_tree(world_data, 12, 1, grass_depth + 3, 7, BLOCK_LOG,
			BLOCK_LEAF_SOLID);

	draw_tree(world_data, 8, 1, grass_depth + 1, 6, BLOCK_LOG_DARK,
			BLOCK_LEAF_TRANS);

	world_data[grass_depth+3][2][10] = BLOCK_FURNACE;
	world_data[grass_depth+3][1][10] = BLOCK_GLASS;





}

int main() {

	printf("Starting up");

	union frame_buffer_t* frame1 =
			(frame_buffer_t*) COPY_DMA_WRITE_MASTER_FRAME_BUFFER_BASE;
	union frame_buffer_t* frame2 = malloc(sizeof(frame_buffer_t));
	union z_buffer_t* z_buffer = malloc(sizeof(z_buffer_t));

	dma->back_buffer = frame1;
	dma->front_buffer = 0; //swap

	gpu->frame_pointer = frame2;
	gpu->z_buffer = z_buffer;

	pixel_t black = {0, 0, 0, 0};
	pixel_t red = {0, 0, 255, 0};

	clear_screen(gpu, 1);
	draw_string(frame2, "INITING KEYBOARD", 16, SCREEN_WIDTH / 4,
			SCREEN_HEIGHT / 2, black);
	transfer(frame2, frame1, sizeof(frame1->D1));

	gpu->z_clip = -16 * (FP_SCALE) * FP_SCALE;

	//gpu->cam_trans.z = (FP_SCALE)<<100;

	printf("Allocation Done. Frame 1: %h, Frame2: %h, Z Buffer: %h\n", frame1,
			frame2, z_buffer);

	printf("Done initial clear, Initing keyboard\n");
	init_keyboard();

	clear_screen(gpu, 1);
	draw_string(frame2, "GENERATING WORLD", 16, SCREEN_WIDTH / 4,
			SCREEN_HEIGHT / 2, black);
	transfer(frame2, frame1, sizeof(frame1->D1));

	double theta = 0;
	double phi = 0;

	gpu->cam_pos.x = 0;
	gpu->cam_pos.z = 0;
	gpu->cam_pos.y = 0;

	gpu->cam_trans.x = 0;
	gpu->cam_trans.y = 0;
	gpu->cam_trans.z = 0;

	int poll_keycode = 0;
	int keycode = 0;
	int selected_block = 0;
	int break_flag = 0;
	int place_flag = 0;
	float last_fps = 0;
	char fps_str[4];
	char blk_str[2];

	int world_data[WORLD_Z][WORLD_Y][WORLD_X];
	gen_world(world_data);




	printf("Starting game loop");
	while (1) {
		time_t frame_time = clock();

		//transfer(frame_clean, frame2, sizeof(frame2->D1));
		//transfer(z_buffer_clean, z_buffer, sizeof(z_buffer->D2));

		keycode = 0;
		clear_screen(gpu, 1);

		loop_keyboard(&poll_keycode);
		keycode = (poll_keycode == 0 ? keycode : poll_keycode);

		clear_depth(gpu, 1);

		for (int z = WORLD_Z - 1; z >= 0; z--) {
			for (int y = 0; y < WORLD_Y; y++) {
				for (int x = 0; x < WORLD_X; x++) {
					if (world_data[z][y][x] != -1) {
						draw_cube(gpu, 8, x * 8 - 64, y * 8 - 16, z * 8 - 96,
								world_data[z][y][x]);
					}
				}
			}
			loop_keyboard(&poll_keycode);
			keycode = (poll_keycode == 0 ? keycode : poll_keycode);
		}

		int cursor_y = 2 - ((y_off) / 8);
		int cursor_x = 8 - ((x_off + 4) / 8);
//        world_data[WORLD_Z - 1][2 - ((y_off) / 8)][8 - ((x_off+4) / 8)] = BLOCK_FURNACE;
		if (z_buffer->D2[SCREEN_HEIGHT / 2][SCREEN_WIDTH / 2] < 268435455) {
			int depth_check = WORLD_Z - 1;
			if (place_flag == 1 || break_flag == 1) {
				while (world_data[depth_check][cursor_y][cursor_x] == -1
						&& depth_check >= 0) {
					depth_check--;
				}
				if (depth_check >= 0 && depth_check < WORLD_Z) {
					if (place_flag) {
						world_data[depth_check + 1][cursor_y][cursor_x] =
								selected_block;
					} else if (break_flag) {
						world_data[depth_check][cursor_y][cursor_x] = -1;
					}
				}
				break_flag = 0;
				place_flag = 0;
			}
		}

		int c_w = 3;
		int c_h = 3;
		pixel_t pixel = { 200, 200, 200, 0 };
		for (int c = SCREEN_HEIGHT / 2 - c_w; c < SCREEN_HEIGHT / 2 + c_w + 1;
				c++) {
			frame2->D2[c][SCREEN_WIDTH / 2] = pixel;
		}
		for (int c = SCREEN_WIDTH / 2 - c_h; c < SCREEN_WIDTH / 2 + c_h + 1;
				c++) {
			frame2->D2[SCREEN_HEIGHT / 2][c] = pixel;
		}

		gcvt(last_fps, 4, fps_str);
		gcvt(selected_block+1, 2, blk_str);




		draw_string(frame2, "FPS:", 4, 10, 10, black);
		draw_string(frame2, fps_str, 5, 40, 10, black);
		if(selected_block+1<10) {
			draw_string(frame2, blk_str, 1, 300, 10, red);
		} else {
			draw_string(frame2, blk_str, 2, 300, 10, red);
		}
		transfer(frame2, frame1, sizeof(frame1->D1));
		loop_keyboard(&poll_keycode);
		keycode = (poll_keycode == 0 ? keycode : poll_keycode);

//
//		if(keycode == KEY_S) {
//			gpu->cam_trans.z += FP_SCALE;
//		} else if (keycode == KEY_W) {
//			gpu->cam_trans.z -= FP_SCALE;
//			printf("%d", gpu->cam_trans.z);
//		}

		if (keycode == KEY_S) {
			//gpu->cam_pos.z += 1;
			z_off -= 4;
		} else if (keycode == KEY_W) {
			//gpu->cam_pos.z -= 1;
			z_off += 4;
		} else if (keycode == KEY_A) {
			x_off += 4;
		} else if (keycode == KEY_D) {
			x_off -= 4;
		} else if (keycode == KEY_SPACE) {
			y_off -= 4;
		} else if (keycode == KEY_C) {
			y_off += 4;
		} else if (keycode == KEY_UP) {
			theta += 0.005;
		} else if (keycode == KEY_DOWN) {
			theta -= 0.005;
		} else if (keycode == KEY_LEFT) {
			phi += 0.005;
		} else if (keycode == KEY_RIGHT) {
			phi -= 0.005;
		} else if (keycode >= KEY_1 && keycode <= KEY_0) {
			selected_block = keycode - KEY_1;
		} else if(keycode == KEY_I) {
			selected_block = BLOCK_FURNACE;
		} else if(keycode == KEY_O) {
			selected_block = BLOCK_GLASS;
		} else if(keycode == KEY_P) {
			selected_block = BLOCK_BEEHIVE;
		} else if (keycode == KEY_Q) {
			if(theta == 0 && phi == 0) {
				break_flag = 1;
			}
		} else if (keycode == KEY_E) {
			if(theta == 0 && phi == 0) {
				place_flag = 1;
			}
		} else if(keycode == KEY_R) {
			clear_screen(gpu, 1);
			draw_string(frame2, "RESETING WORLD", 14, SCREEN_WIDTH / 4,
					SCREEN_HEIGHT / 2, black);
			x_off = 0;
			y_off = 0;
			z_off = 0;
			theta = 0;
			phi = 0;
			transfer(frame2, frame1, sizeof(frame1->D1));
			gen_world(world_data);
		}
		if (phi >= 0.02) {
			phi = 0.02;
		}
		if (phi <= -0.02) {
			phi = -0.02;
		}
		if (x_off >= 60) {
			x_off = 60;
		}
		if (x_off <= -60) {
			x_off = -60;
		}
		if (theta >= 0.02) {
			theta = 0.02;
		}
		if (theta <= -0.02) {
			theta = -0.02;
		}
		if (z_off >= 32) {
			z_off = 32;
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

//				gpu->cam_x_axis.x = c_p;
//				gpu->cam_y_axis.x = s_p * s_t / FP_SCALE;
//				gpu->cam_z_axis.x = -s_p * c_t / FP_SCALE;
//
//				gpu->cam_x_axis.y = 0;
//				gpu->cam_y_axis.y = c_t;
//				gpu->cam_z_axis.y = s_t;
//
//				gpu->cam_x_axis.z = s_p;
//				gpu->cam_y_axis.z = -s_t * c_p / FP_SCALE;
//				gpu->cam_z_axis.z = c_p * c_t / FP_SCALE;

		last_fps = 1000.0 / (clock() - frame_time);
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
	while (!copy_done)
		;
	return 0;
}
