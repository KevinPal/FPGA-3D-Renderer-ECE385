module testbench_gpu();

timeunit 10ns;
timeprecision 1ns;

logic CLK;

int prj[4][4];
int vec[3] = {30 * (1<< 8), 0 * (1<< 8) , -7 * (1<< 8)};
int out[8][3];

gen_prj_mat m1(320 * (1<< 8), 240 * (1<< 8), 5 * (1<< 8), 200 * (1<< 8), prj);

project_cube cb(.scale(64 * (1<< 8)), .pos(vec), .prj, .out);

int shift[8][3];

assign shift[0][0] = (out[0][0] / ( 1 << 8));
assign shift[0][1] = (out[0][1] / ( 1 << 8));
assign shift[0][2] = (out[0][2] / ( 1 << 8));
assign shift[1][0] = (out[1][0] / ( 1 << 8));
assign shift[1][1] = (out[1][1] / ( 1 << 8));
assign shift[1][2] = (out[1][2] / ( 1 << 8));
assign shift[2][0] = (out[2][0] / ( 1 << 8));
assign shift[2][1] = (out[2][1] / ( 1 << 8));
assign shift[2][2] = (out[2][2] / ( 1 << 8));
assign shift[3][0] = (out[3][0] / ( 1 << 8));
assign shift[3][1] = (out[3][1] / ( 1 << 8));
assign shift[3][2] = (out[3][2] / ( 1 << 8));
assign shift[4][0] = (out[4][0] / ( 1 << 8));
assign shift[4][1] = (out[4][1] / ( 1 << 8));
assign shift[4][2] = (out[4][2] / ( 1 << 8));
assign shift[5][0] = (out[5][0] / ( 1 << 8));
assign shift[5][1] = (out[5][1] / ( 1 << 8));
assign shift[5][2] = (out[5][2] / ( 1 << 8));
assign shift[6][0] = (out[6][0] / ( 1 << 8));
assign shift[6][1] = (out[6][1] / ( 1 << 8));
assign shift[6][2] = (out[6][2] / ( 1 << 8));
assign shift[7][0] = (out[7][0] / ( 1 << 8));
assign shift[7][1] = (out[7][1] / ( 1 << 8));
assign shift[7][2] = (out[7][2] / ( 1 << 8));



always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin: CLOCK_INITIALIZATION
    CLK = 0;
end 

initial begin: TEST_VECTORS


//if (ErrorCnt == 0)
//	$display("Multiplier unit tests passed"); 
//else
//	$display("%d errors on multiplier unit test", ErrorCnt);
end
endmodule
