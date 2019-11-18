module testbench_gpu();

timeunit 10ns;
timeprecision 1ns;

logic CLK;
logic RESET;
logic init, step, start;

int prj[4][4];
int vec[3] = {30 * (1<< 8), 0 * (1<< 8) , -7 * (1<< 8)};
int out[8][3];

logic test_sig;
logic test_sig_p;
pos_edge_detect test123(CLK, RESET, test_sig, test_sig_p);

//int back_top_left[3];
//int back_bot_left[3];

//gen_prj_mat m1(320 * (1<< 8), 240 * (1<< 8), 5 * (1<< 8), 200 * (1<< 8), prj);

//project_cube cb(.scale(64 * (1<< 8)), .pos(vec), .prj, .out);


//int shift[8][3];
logic draw_ready;
int draw_y, draw_x1, draw_x2;
int draw_y_s, draw_x1_s, draw_x2_s;
int v1[3];
int v2[3];
int v3[3];

rast_triangle test(CLK, RESET, start, v1, v2, v3, draw_ready, draw_y, draw_x1, draw_x2);

assign v1 = '{235 * (1<<8), 155 * (1<<8), 0};
assign v2 = '{243 * (1<<8), 164 * (1<<8), 0};
assign v3 = '{227 * (1<<8), 172 * (1<<8), 0};

assign draw_y_s = draw_y / (1<<8);
assign draw_x1_s = draw_x1 / (1<<8);
assign draw_x2_s = draw_x2 / (1<<8);


//assign shift[0][0] = (out[0][0] / ( 1 << 8));
//assign shift[0][1] = (out[0][1] / ( 1 << 8));
//assign shift[0][2] = (out[0][2]);// / ( 1 << 8));
//assign shift[1][0] = (out[1][0] / ( 1 << 8));
//assign shift[1][1] = (out[1][1] / ( 1 << 8));
//assign shift[1][2] = (out[1][2]);// / ( 1 << 8));
//assign shift[2][0] = (out[2][0] / ( 1 << 8));
//assign shift[2][1] = (out[2][1] / ( 1 << 8));
//assign shift[2][2] = (out[2][2]);// / ( 1 << 8));
//assign shift[3][0] = (out[3][0] / ( 1 << 8));
//assign shift[3][1] = (out[3][1] / ( 1 << 8));
//assign shift[3][2] = (out[3][2]);// / ( 1 << 8));
//assign shift[4][0] = (out[4][0] / ( 1 << 8));
//assign shift[4][1] = (out[4][1] / ( 1 << 8));
//assign shift[4][2] = (out[4][2]);// / ( 1 << 8));
//assign shift[5][0] = (out[5][0] / ( 1 << 8));
//assign shift[5][1] = (out[5][1] / ( 1 << 8));
//assign shift[5][2] = (out[5][2]);// / ( 1 << 8));
//assign shift[6][0] = (out[6][0] / ( 1 << 8));
//assign shift[6][1] = (out[6][1] / ( 1 << 8));
//assign shift[6][2] = (out[6][2]);// / ( 1 << 8));
//assign shift[7][0] = (out[7][0] / ( 1 << 8));
//assign shift[7][1] = (out[7][1] / ( 1 << 8));
//assign shift[7][2] = (out[7][2]);// / ( 1 << 8));



always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin: CLOCK_INITIALIZATION
    CLK = 0;
end 

initial begin: TEST_VECTORS
//start = 0;
test_sig = 0;
RESET = 1;
#1 RESET = 0;
//#1 start = 1;
//#2 start = 0;
#3
test_sig = 0;
#1
test_sig = 1;
end
endmodule
