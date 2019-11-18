module testbench_rast();

timeunit 10ns;
timeprecision 1ns;

logic CLK;
logic RESET;
logic init, step, start;

logic draw_ready;
logic cont;
int draw_y, draw_x1, draw_x2;
int draw_y_s, draw_x1_s, draw_x2_s;
int v1[3];
int v2[3];
int v3[3];
byte rgb[3];
int xyz[3];
int xyz_s[3];
logic done;

rast_triangle test(CLK, RESET, start, cont, v1, v2, v3, draw_ready, rgb, xyz, done);

assign v1 = '{235 * (1<<8), 155 * (1<<8), 0};
assign v2 = '{243 * (1<<8), 164 * (1<<8), 0};
assign v3 = '{227 * (1<<8), 172 * (1<<8), 0};

assign draw_y_s = draw_y / (1<<8);
assign draw_x1_s = draw_x1 / (1<<8);
assign draw_x2_s = draw_x2 / (1<<8);

assign xyz_s[0] = xyz[0] / (1<<8);
assign xyz_s[1] = xyz[1] / (1<<8);
assign xyz_s[2] = xyz[2] / (1<<8);


always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin: CLOCK_INITIALIZATION
    CLK = 0;
end 

initial begin: TEST_VECTORS
cont = 0;
start = 0;
RESET = 0;
#1 RESET = 1;
#2
RESET = 0;
#2
start = 1;
#14
cont = 1;
#2
cont = 0;
#2
cont = 1;
#2
cont = 0;
#2
cont = 1;
#100
cont = 0;
end
endmodule
