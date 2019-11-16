module testbench_gpu();

timeunit 10ns;
timeprecision 1ns;

logic CLK;

real prj[4][4];
real vec[3] = {30, 0, -7};
real out[8][3];

gen_prj_mat m1(320.0, 240.0, 5.0, 200.0, prj);

project_cube cb(.scale(64.0), .pos(vec), .prj, .out);

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
