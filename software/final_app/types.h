#define SCREEN_WIDTH 640
#define SCREEN_HEIGHT 480
#define BYTES_PER_PIXEL 3

typedef struct vga_controller_t {
	volatile char line1[1920];
	volatile char rendering_frame;
    volatile char needs_write;
    volatile char padding[126];
	volatile char line2[1920];
} vga_controller_t ;

typedef union frame_buffer_t   {
	char D2[SCREEN_HEIGHT][SCREEN_WIDTH][BYTES_PER_PIXEL];
	char D1[SCREEN_HEIGHT*SCREEN_WIDTH*BYTES_PER_PIXEL];
} frame_buffer_t ;
