module testbench_rast();

timeunit 10ns;
timeprecision 1ns;

logic CLK;
logic RESET;
logic init, start;

logic cont;
logic done;
int prj[4][4];

int scale = (25 * (1<<8));
int pos[3] = '{-25 * (1<<8), 20 * (1<<8), -70 * (1<<8)};
int i = 0;
int f;

// Ava lon slave signals
logic GPU_SLAVE_read;
logic [31:0] GPU_SLAVE_readdata;
logic GPU_SLAVE_write;
logic [31:0] GPU_SLAVE_writedata;
logic [31:0] GPU_SLAVE_address;
logic GPU_SLAVE_chipselect;
// avalon master signal;
logic [31:0] GPU_MASTER_address;
logic GPU_MASTER_read;
logic [31:0] GPU_MASTER_readdata;
logic GPU_MASTER_chipselect;
logic GPU_MASTER_readdatavalid;
logic GPU_MASTER_writeresponsevalid;
logic GPU_MASTER_write;
logic [31:0] GPU_MASTER_writedata;
logic [1:0] GPU_MASTER_response;
logic GPU_MASTER_waitrequest;
int draw_x;
int draw_y;
assign draw_x = (GPU_MASTER_address / 4) % 640;
assign draw_y = (GPU_MASTER_address / 4) / 480;


gpu_core core(
    CLK,
    RESET,
    // Ava lon slave signals
    GPU_SLAVE_read,
    GPU_SLAVE_readdata,
    GPU_SLAVE_write,
    GPU_SLAVE_writedata,
    GPU_SLAVE_address,
    GPU_SLAVE_chipselect,
    // avalon master signals
    GPU_MASTER_address,
    GPU_MASTER_read,
    GPU_MASTER_readdata,
    GPU_MASTER_chipselect,
    GPU_MASTER_readdatavalid,
    GPU_MASTER_writeresponsevalid,
    GPU_MASTER_write,
    GPU_MASTER_writedata,
    GPU_MASTER_response,
    GPU_MASTER_waitrequest
);

gen_prj_mat m1(320 * (1<<8), 240* (1<<8), 5*(1<<8), 200*(1<<8), prj);

//rast_cube cube_renderer(CLK, RESET, start, cont, 
//    scale, '{x, y, z}, prj, rast_ready, rast_rgb, rast_xyz, rast_done);

int v1[3];
int v2[3];
int v3[3];
int xyz[3];
int xyz_f[3];
byte rgb[3];
int verticies[8][3];
assign v1 = verticies[4];
assign v2 = verticies[6];
assign v3 = verticies[7];
logic ready;
byte in_rgb[3] = '{255, 255, 255};
int color_data[480*640];

assign rast_done = core.done;

always_ff @ (posedge CLK) begin
    color_data[GPU_MASTER_address/4] <= GPU_MASTER_writedata;
end

//rast_triangle test(CLK, RESET, start, cont, v3, v2, v1, in_rgb, draw_ready, rgb, xyz, done);

project_cube projector(scale, pos, prj, verticies);

assign error = (  (draw_x < 170) | (draw_x > 350) | (draw_y > 427) | (draw_y  < 260));

int shift[8][3];

assign xyz_f[0] = core.cube_renderer.triangle_renderer.xyz[0] / (1<<8);
assign xyz_f[1] = core.cube_renderer.triangle_renderer.xyz[1] / (1<<8);
assign xyz_f[2] = core.cube_renderer.triangle_renderer.xyz[2] / (1<<8);


assign shift[0][0] = verticies[0][0]  / (1<<8);
assign shift[0][1] = verticies[0][1]  / (1<<8);
assign shift[0][2] = verticies[0][2]  / (1<<8);
assign shift[1][0] = verticies[1][0]  / (1<<8);
assign shift[1][1] = verticies[1][1]  / (1<<8);
assign shift[1][2] = verticies[1][2]  / (1<<8);
assign shift[2][0] = verticies[2][0]  / (1<<8);
assign shift[2][1] = verticies[2][1]  / (1<<8);
assign shift[2][2] = verticies[2][2]  / (1<<8);
assign shift[3][0] = verticies[3][0]  / (1<<8);
assign shift[3][1] = verticies[3][1]  / (1<<8);
assign shift[3][2] = verticies[3][2]  / (1<<8);
assign shift[4][0] = verticies[4][0]  / (1<<8);
assign shift[4][1] = verticies[4][1]  / (1<<8);
assign shift[4][2] = verticies[4][2]  / (1<<8);
assign shift[5][0] = verticies[5][0]  / (1<<8);
assign shift[5][1] = verticies[5][1]  / (1<<8);
assign shift[5][2] = verticies[5][2]  / (1<<8);
assign shift[6][0] = verticies[6][0]  / (1<<8);
assign shift[6][1] = verticies[6][1]  / (1<<8);
assign shift[6][2] = verticies[6][2]  / (1<<8);
assign shift[7][0] = verticies[7][0]  / (1<<8);
assign shift[7][1] = verticies[7][1]  / (1<<8);
assign shift[7][2] = verticies[7][2]  / (1<<8);


always begin : CLOCK_GENERATION
#1 CLK = ~CLK;
end

initial begin: CLOCK_INITIALIZATION
    CLK = 0;
end 


initial begin: TEST_VECTORS
//    GPU_SLAVE_read,
//    [31:0] GPU_SLAVE_readdata,
//    GPU_SLAVE_write,
//    [31:0] GPU_SLAVE_writedata,
//    [31:0] GPU_SLAVE_address,
//    GPU_SLAVE_chipselect,
//    // avalon master signals
//    [31:0] GPU_MASTER_address,
//    GPU_MASTER_read,
//    [31:0] GPU_MASTER_readdata,
//    GPU_MASTER_chipselect,
//    GPU_MASTER_readdatavalid,
//    GPU_MASTER_writeresponsevalid,
//    GPU_MASTER_write,
//    [31:0] GPU_MASTER_writedata,
//    [1:0] GPU_MASTER_response,
//    GPU_MASTER_waitrequest
//

ready = 1;
cont = 0;
start = 0;
RESET = 0;
#1 RESET = 1;
#2
RESET = 0;
#2
GPU_SLAVE_chipselect = 1;
GPU_SLAVE_write = 1;
GPU_SLAVE_address = 8;
GPU_SLAVE_writedata= 1;
#4
GPU_SLAVE_chipselect = 1;
GPU_SLAVE_write = 1;
GPU_SLAVE_address = 4;
GPU_SLAVE_writedata= scale;
#4
GPU_SLAVE_chipselect = 1;
GPU_SLAVE_write = 1;
GPU_SLAVE_address = 5;
GPU_SLAVE_writedata = 25 * (1<<8);
#4
GPU_SLAVE_chipselect = 1;
GPU_SLAVE_write = 1;
GPU_SLAVE_address = 6;
GPU_SLAVE_writedata = (-20) * (1<<8);
#4
GPU_SLAVE_chipselect = 1;
GPU_SLAVE_write = 1;
GPU_SLAVE_address = 7;
GPU_SLAVE_writedata = (-70) * (1<<8);
#4
GPU_SLAVE_chipselect = 1;
GPU_SLAVE_write = 1;
GPU_SLAVE_address = 1;
GPU_SLAVE_writedata= 1;
#4
GPU_SLAVE_chipselect = 0;
GPU_SLAVE_write = 0;
#4
GPU_MASTER_waitrequest = 0;
GPU_MASTER_writeresponsevalid = 1;

@(posedge rast_done)
f = $fopen("output.txt","wb+");
for (i = 0; i<(480*640); i=i+1)
    $fwrite(f,"%h\n",color_data[i]);

$fclose(f);
end
endmodule
