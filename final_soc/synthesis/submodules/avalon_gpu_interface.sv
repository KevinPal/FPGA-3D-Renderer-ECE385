module avalon_gpu_interface (
    input  logic CLK_clk,
    input  logic RESET_reset,
    // Ava lon slave signals
    input  logic GPU_SLAVE_read,
    output logic [31:0] GPU_SLAVE_readdata,
    input  logic GPU_SLAVE_write,
    input  logic [31:0] GPU_SLAVE_writedata,
    input  logic [31:0] GPU_SLAVE_address,
    input  logic GPU_SLAVE_chipselect,
    // avalon master signals
    output logic [31:0] GPU_MASTER_address,
    //output logic [18:0] GPU_MASTER_burstcount,
    output logic GPU_MASTER_read,
    input  logic [31:0] GPU_MASTER_readdata,
    output logic GPU_MASTER_chipselect,
    input  logic GPU_MASTER_readdatavalid,
    input  logic GPU_MASTER_writeresponsevalid,
    output logic GPU_MASTER_write,
    output logic [31:0] GPU_MASTER_writedata,
    input  logic [1:0] GPU_MASTER_response,
    input  logic GPU_MASTER_waitrequest
);

gpu_core gpu(.*);


endmodule
