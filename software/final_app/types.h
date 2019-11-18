#include "alt_types.h"

#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480
#define BYTES_PER_PIXEL 4

typedef struct pixel_t {
	char r;
	char g;
	char b;
	char a;
} pixel_t;


//typedef struct vga_controller_t {
//	volatile pixel_t line1[SCREEN_WIDTH];
//	volatile alt_u32 rendering_frame;
//    volatile alt_u32 needs_write;
//    volatile alt_8 padding[1536-8];  //1536 total size in between
//	volatile pixel_t line2[SCREEN_WIDTH];
//} vga_controller_t ;

typedef union z_buffer_t   {
	alt_u32 D2[SCREEN_HEIGHT][SCREEN_WIDTH];
	alt_u32 D1[SCREEN_HEIGHT*SCREEN_WIDTH];
} z_buffer_t ;

typedef union frame_buffer_t   {
	pixel_t D2[SCREEN_HEIGHT][SCREEN_WIDTH];
	pixel_t D1[SCREEN_HEIGHT*SCREEN_WIDTH];
} frame_buffer_t ;

typedef struct vga_controller_t {
	volatile frame_buffer_t* frame_pointer;
	volatile alt_32 should_draw;
} vga_controller_t ;

typedef struct gpu_core_t {
	volatile frame_buffer_t* frame_pointer;
	volatile int start;
	volatile int done;
	volatile z_buffer_t* z_buffer;
	volatile int scale;
	volatile int x;
	volatile int y;
	volatile int z;
} gpu_core_t;



