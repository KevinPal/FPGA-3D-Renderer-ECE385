module testbench_gpu();

timeunit 10ns;
timeprecision 1ns;

logic CLK;
logic RESET;
logic init, step, start;

int prj[4][4];
int out[8][3];

//int back_top_left[3];
//int back_bot_left[3];

//gen_prj_mat m1(320 * (1<< 8), 240 * (1<< 8), 5 * (1<< 8), 200 * (1<< 8), prj);

gen_prj_mat m1(320 * (1<< 8), 240 * (1<< 8), 5 * (1<< 8), 100 * (1<< 8), prj);
int test_vec[3] = '{30 * (1<< 8), 0 * (1<< 8) ,  -70* (1<< 8)};
project_cube cb(.scale(32 * (1<< 8)), .pos(test_vec), .prj, .out);

//rast_triangle test(CLK, RESET, start, v1, v2, v3, draw_ready, draw_y, draw_x1, draw_x2);



//0 -> back_top_left
//1 -> back_top_right
//2 -> back_bot_left
//3 -> back_bot_right
//4 -> front_top_left
//5 -> front_top_right
//6 -> front_bot_left
//7 -> front_bot_right
int verticies[8][3];
int shift[8][3];

int test_scale = 64 * (1<<8);

project_cube projector(test_scale, test_vec, prj, verticies);

assign shift[0][0] = (out[0][0] / ( 1 << 8));
assign shift[0][1] = (out[0][1] / ( 1 << 8));
assign shift[0][2] = (out[0][2]);// / ( 1 << 8));
assign shift[1][0] = (out[1][0] / ( 1 << 8));
assign shift[1][1] = (out[1][1] / ( 1 << 8));
assign shift[1][2] = (out[1][2]);// / ( 1 << 8));
assign shift[2][0] = (out[2][0] / ( 1 << 8));
assign shift[2][1] = (out[2][1] / ( 1 << 8));
assign shift[2][2] = (out[2][2]);// / ( 1 << 8));
assign shift[3][0] = (out[3][0] / ( 1 << 8));
assign shift[3][1] = (out[3][1] / ( 1 << 8));
assign shift[3][2] = (out[3][2]);// / ( 1 << 8));
assign shift[4][0] = (out[4][0] / ( 1 << 8));
assign shift[4][1] = (out[4][1] / ( 1 << 8));
assign shift[4][2] = (out[4][2]);// / ( 1 << 8));
assign shift[5][0] = (out[5][0] / ( 1 << 8));
assign shift[5][1] = (out[5][1] / ( 1 << 8));
assign shift[5][2] = (out[5][2]);// / ( 1 << 8));
assign shift[6][0] = (out[6][0] / ( 1 << 8));
assign shift[6][1] = (out[6][1] / ( 1 << 8));
assign shift[6][2] = (out[6][2]);// / ( 1 << 8));
assign shift[7][0] = (out[7][0] / ( 1 << 8));
assign shift[7][1] = (out[7][1] / ( 1 << 8));
assign shift[7][2] = (out[7][2]);// / ( 1 << 8));



always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin: CLOCK_INITIALIZATION
    CLK = 0;
end 

initial begin: TEST_VECTORS
//start = 0;
RESET = 1;
#2 RESET = 0;
#2 start = 1;
#2 start = 0;
end
endmodule
