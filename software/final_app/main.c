#include "system.h"
#include <math.h>
#include <time.h>
#include "types.h"
#include <stdlib.h>



int main()
{
	int i = 0;
	int height = 0;

	volatile struct vga_controller_t* vga_cont = VGA_CONTROLLER_0_BASE;

	union frame_buffer_t* frame1 =  malloc(sizeof(frame_buffer_t));

	for(i = 0; i < SCREEN_WIDTH * SCREEN_HEIGHT; i++) {
		frame1->D1[i*3+0] = i % SCREEN_WIDTH;
		frame1->D1[i*3+1] = i % SCREEN_HEIGHT;
		frame1->D1[i*3+2] = 0;
	}
	int draw_index = 0;
    while(1) {
    	if(draw_index >= 480*640*3) {
    		draw_index = 0;
    	}
        if(vga_cont->needs_write == 1) {
            if(vga_cont->rendering_frame == 0) {
            	//clock_t start = clock();
                for(i = 0; i < SCREEN_WIDTH; i++) {
                    vga_cont->line2[i*3+0] = frame1->D1[draw_index++];
                    vga_cont->line2[i*3+1] = frame1->D1[draw_index++];
                    vga_cont->line2[i*3+2] = frame1->D1[draw_index++];

                }
                //clock_t stop = clock();
        		//double time_spent = (double)(stop - start) / CLOCKS_PER_SEC;
        		//printf("%f\n", time_spent);
                //temp = 1;
            } else {
                for(i = 0; i < SCREEN_WIDTH; i++) {
                    vga_cont->line1[i*3+0] = frame1->D1[draw_index++];
                    vga_cont->line1[i*3+1] = frame1->D1[draw_index++];
                    vga_cont->line1[i*3+2] = frame1->D1[draw_index++];
                }
                //temp = 0;
            }
            height = (height + 1) % SCREEN_HEIGHT;
            vga_cont->needs_write = 0;

        }
    }


    return 1;
}
