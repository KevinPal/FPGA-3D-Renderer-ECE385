module testbench_aes();

timeunit 10ns;
timeprecision 1ns;

    // Avalon Clock Input
logic CLK,
logic        VGA_CLK_clk,      //VGA Clock
logic      CLK_OUT_clk,      // Exported VGA Clock
    
    // Avalon Reset Input
logic RESET,
    
    // Avalon-MM Slave Signals
logic VGA_READ,                    // Avalon-MM Read
logic VGA_WRITE,                    // Avalon-MM Write
logic VGA_CS,                        // Avalon-MM Chip Select
logic [3:0] VGA_BYTE_EN,        // Avalon-MM Byte Enable
logic [1:0] VGA_ADDR,            // Avalon-MM Address
logic [31:0] VGA_WRITEDATA,    // Avalon-MM Write Data
logic [31:0] VGA_READDATA,    // Avalon-MM Read Data

    // Avalon-MM Master Signals
logic [31:0] VGA_MASTER_ADDR,
logic VGA_MASTER_READ,
logic [31:0] VGA_MASTER_READDATA,
logic VGA_MASTER_CS,
logic VGA_MASTER_WAIT_REQUEST,
    
    // Exported Conduits
logic [7:0]  VGA_R,        //VGA Red
             VGA_G,        //VGA Green
             VGA_B,        //VGA Blue
logic [7:0]  DEBUG,
logic        VGA_SYNC_N,   //VGA Sync signal
             VGA_BLANK_N,  //VGA Blank signal
             VGA_VS,       //VGA virtical sync signal
             VGA_HS       //VGA horizontal sync signal

 avalon_vga_interface map(.*);

//always_comb begin: INTERNAL_MONITORING
//    PC = slc3.my_slc.PC;
//    IR = slc3.my_slc.IR;
//    MAR = slc3.my_slc.MAR;
//    MDR = slc3.my_slc.MDR;
//    State = slc3.my_slc.state_controller.State;
//    Bus = slc3.my_slc.databus;
//    //Next_state = slc3.my_slc.state_controller.Next_state;
//end

always begin : CLOCK_GENERATION
#1 
CLK = ~CLK;
#1
CLK = ~CLK;
VGA_CLK_clk = ~VGA_CLK_clk;
end

initial begin: CLOCK_INITIALIZATION
    CLK = 0;
    VGA_CLK_clk = 0;
end 

initial begin: TEST_VECTORS

#1 RESET = 1;
#1 RESET = 0;
#1
VGA_READ = 0;
VGA_WRITE = 1;
VGA_CS = 1;
VGA_BYTE_EN = 4'b1111;
VGA_ADDR = 0;
VGA_WRITEDATA = 0;
#1
VGA_WRITE = 0;
VGA_CS = 0;
#1
#1 VGA_WRITEDATA = 1;
#1 VGA_WRITEDATA = 2;
#1 VGA_WRITEDATA = 3;
#1 VGA_WRITEDATA = 4;
#1 VGA_WRITEDATA = 5;
#1 VGA_WRITEDATA = 6;
#1 VGA_WRITEDATA = 7;
#1 VGA_WRITEDATA = 8;
#1 VGA_WRITEDATA = 9;
#1 VGA_WRITEDATA = 10;
#1 VGA_WRITEDATA = 11;
#1 VGA_WRITEDATA = 12;
#1 VGA_WRITEDATA = 13;
#1 VGA_WRITEDATA = 14;
#1 VGA_WRITEDATA = 15;
#1 VGA_WRITEDATA = 16;
#1 VGA_WRITEDATA = 17;
#1 VGA_WRITEDATA = 18;
#1 VGA_WRITEDATA = 19;
#1 VGA_WRITEDATA = 20;
#1 VGA_WRITEDATA = 21;
#1 VGA_WRITEDATA = 22;
#1 VGA_WRITEDATA = 23;
#1 VGA_WRITEDATA = 24;
#1 VGA_WRITEDATA = 25;
#1 VGA_WRITEDATA = 26;
#1 VGA_WRITEDATA = 27;
#1 VGA_WRITEDATA = 28;
#1 VGA_WRITEDATA = 29;
#1 VGA_WRITEDATA = 30;
#1 VGA_WRITEDATA = 31;
#1 VGA_WRITEDATA = 32;
#1 VGA_WRITEDATA = 33;
#1 VGA_WRITEDATA = 34;
#1 VGA_WRITEDATA = 35;
#1 VGA_WRITEDATA = 36;
#1 VGA_WRITEDATA = 37;
#1 VGA_WRITEDATA = 38;
#1 VGA_WRITEDATA = 39;
#1 VGA_WRITEDATA = 40;
#1 VGA_WRITEDATA = 41;
#1 VGA_WRITEDATA = 42;
#1 VGA_WRITEDATA = 43;
#1 VGA_WRITEDATA = 44;
#1 VGA_WRITEDATA = 45;
#1 VGA_WRITEDATA = 46;
#1 VGA_WRITEDATA = 47;
#1 VGA_WRITEDATA = 48;
#1 VGA_WRITEDATA = 49;
#1 VGA_WRITEDATA = 50;
#1 VGA_WRITEDATA = 51;
#1 VGA_WRITEDATA = 52;
#1 VGA_WRITEDATA = 53;
#1 VGA_WRITEDATA = 54;
#1 VGA_WRITEDATA = 55;
#1 VGA_WRITEDATA = 56;
#1 VGA_WRITEDATA = 57;
#1 VGA_WRITEDATA = 58;
#1 VGA_WRITEDATA = 59;
#1 VGA_WRITEDATA = 60;
#1 VGA_WRITEDATA = 61;
#1 VGA_WRITEDATA = 62;
#1 VGA_WRITEDATA = 63;
#1 VGA_WRITEDATA = 64;
#1 VGA_WRITEDATA = 65;
#1 VGA_WRITEDATA = 66;
#1 VGA_WRITEDATA = 67;
#1 VGA_WRITEDATA = 68;
#1 VGA_WRITEDATA = 69;
#1 VGA_WRITEDATA = 70;
#1 VGA_WRITEDATA = 71;
#1 VGA_WRITEDATA = 72;
#1 VGA_WRITEDATA = 73;
#1 VGA_WRITEDATA = 74;
#1 VGA_WRITEDATA = 75;
#1 VGA_WRITEDATA = 76;
#1 VGA_WRITEDATA = 77;
#1 VGA_WRITEDATA = 78;
#1 VGA_WRITEDATA = 79;
#1 VGA_WRITEDATA = 80;
#1 VGA_WRITEDATA = 81;
#1 VGA_WRITEDATA = 82;


//if (ErrorCnt == 0)
//	$display("Multiplier unit tests passed"); 
//else
//	$display("%d errors on multiplier unit test", ErrorCnt);
end
endmodule
