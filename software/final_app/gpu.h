/*
 * gpu.h
 *
 *  Created on: Dec 9, 2019
 *      Author: KPalani
 */

#ifndef GPU_H_
#define GPU_H_

#include "types.h"

void clear_screen(volatile gpu_core_t* gpu, int should_wait);

void clear_depth(volatile gpu_core_t* gpu, int should_wait);

void draw_cube(volatile gpu_core_t* gpu, int scale, int x, int y, int z,
		int block_id);

void draw_string(frame_buffer_t* frame, char* s, int num_chars, int x, int y, pixel_t color);

void draw_char(frame_buffer_t* frame, char c, int x, int y, pixel_t color);


#endif /* GPU_H_ */
