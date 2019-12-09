module testbench_triangle();

timeunit 10ns;
timeprecision 1ns;

logic CLK;
logic RESET;
logic init, start;
logic cont;
logic done;
logic draw_ready;
int xyz[3];
byte rgb[3];
int f;
int i;

int v1[4] = '{100 * (1<<8), 100 * (1<<8), -50 * (1<<8), {16'd00 + 0, 16'd00}};
int v2[4] = '{250 * (1<<8), 50 * (1<<8), -50 * (1<<8), {16'd15 + 0, 16'd00}};
int v3[4] = '{50 * (1<<8), 250 * (1<<8), -50 * (1<<8), {16'd15 + 0, 16'd15}};

//gen_prj_mat m1(320 * (1<<8), 240* (1<<8), 5*(1<<8), 200*(1<<8), prj);

int color_data[240*320*2];


always_ff @ (posedge CLK) begin
    if(draw_ready)
        color_data[((( ((xyz[1]/(1<<8))*320) + (xyz[0]/(1<<8)))*4))/4] <= {8'h00, rgb[0], rgb[1], rgb[2]};
end

// always_comb begin
//     if(GPU_MASTER_read)
//         GPU_MASTER_readdata = color_data[GPU_MASTER_address/4];
//     else
//         GPU_MASTER_readdata = 32'hxxxx;
// end

rast_triangle test(CLK, RESET, start, cont, v3, v2, v1, draw_ready, rgb, xyz, done);

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
#2
start = 0;
#2
cont = 1;

@(posedge done)

f = $fopen("output.txt","wb+");
for (i = 0; i<(240*320*2); i=i+1)
    $fwrite(f,"%h\n",color_data[i]);

$fclose(f);
$display("done");

$system("python \\u\Desktop\385_FinalPrj\sim_files\convert.py");
$display("done converting");

end
endmodule
