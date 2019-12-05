/************************************************************************
Lab 9 Quartus Project Top Level

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module final_top (
	input  logic        CLOCK_50,
	input  logic [1:0]  KEY,
	output logic [7:0]  LEDG,
	output logic [17:0] LEDR,
	output logic [6:0]  HEX0,
	output logic [6:0]  HEX1,
	output logic [6:0]  HEX2,
	output logic [6:0]  HEX3,
	output logic [6:0]  HEX4,
	output logic [6:0]  HEX5,
	output logic [6:0]  HEX6,
	output logic [6:0]  HEX7,
	output logic [12:0] DRAM_ADDR,
	output logic [1:0]  DRAM_BA,
	output logic        DRAM_CAS_N,
	output logic        DRAM_CKE,
	output logic        DRAM_CS_N,
	inout  logic [31:0] DRAM_DQ,
	output logic [3:0]  DRAM_DQM,
	output logic        DRAM_RAS_N,
	output logic        DRAM_WE_N,
	output logic        DRAM_CLK,
    output logic [7:0]  VGA_B,             //       vga_b.vga_b
    output logic        VGA_BLANK_N, // vga_blank_n.vga_blank_n
    output logic        VGA_CLK_CLK,             //     vga_clk.clk
    output logic [7:0]  VGA_G,             //       vga_g.vga_g
    output logic        VGA_HS,           //      vga_hs.vga_hs
    output logic [7:0]  VGA_R,             //       vga_r.vga_r
    output logic        VGA_SYNC_N,   //  vga_sync_n.vga_sync_n
    output logic        VGA_VS,            //      vga_vs.vga_vs
    // CY7C67200 Interface
    inout  wire  [15:0] OTG_DATA,     //CY7C67200 Data bus 16 Bits
    output logic [1:0]  OTG_ADDR,     //CY7C67200 Address 2 Bits
    output logic        OTG_CS_N,     //CY7C67200 Chip Select
                        OTG_RD_N,     //CY7C67200 Write
                        OTG_WR_N,     //CY7C67200 Read
                        OTG_RST_N,    //CY7C67200 Reset
    input               OTG_INT      //CY7C67200 Interrupt
);

logic Reset_h, Clk;
logic [7:0] keycode;

assign Clk = CLOCK_50;
always_ff @ (posedge Clk) begin
    Reset_h <= ~(KEY[0]);        // The push buttons are active low
end

logic [1:0] hpi_addr;
logic [15:0] hpi_data_in, hpi_data_out;
logic hpi_r, hpi_w, hpi_cs, hpi_reset;

logic [7:0] debug;
// Instantiation of Qsys design
final_soc final_subsystem (
	.clk_clk(CLOCK_50),								// Clock input
	.reset_reset_n(KEY[0]),							// Reset key
	.sdram_wire_addr(DRAM_ADDR),					// sdram_wire.addr
	.sdram_wire_ba(DRAM_BA),						// sdram_wire.ba
	.sdram_wire_cas_n(DRAM_CAS_N),				// sdram_wire.cas_n
	.sdram_wire_cke(DRAM_CKE),						// sdram_wire.cke
	.sdram_wire_cs_n(DRAM_CS_N),					// sdram.cs_n
	.sdram_wire_dq(DRAM_DQ),						// sdram.dq
	.sdram_wire_dqm(DRAM_DQM),						// sdram.dqm
	.sdram_wire_ras_n(DRAM_RAS_N),				// sdram.ras_n
	.sdram_wire_we_n(DRAM_WE_N),					// sdram.we_n
	.sdram_clk_clk(DRAM_CLK),						// Clock out to SDRAM
    .vga_B(VGA_B),             //       vga_b.vga_b
    .vga_BLANK(VGA_BLANK_N), // vga_blank_n.vga_blank_n
    .vga_CLK(VGA_CLK_CLK),             //     vga_clk.clk
    .vga_G(VGA_G),             //       vga_g.vga_g
    .vga_HS(VGA_HS),           //      vga_hs.vga_hs
    .vga_R(VGA_R),             //       vga_r.vga_r
    .vga_SYNC(VGA_SYNC_N),   //  vga_sync_n.vga_sync_n
    .vga_VS(VGA_VS),            //      vga_vs.vga_vs
    .keycode_export(keycode),  
    .otg_hpi_address_export(hpi_addr),
    .otg_hpi_data_in_port(hpi_data_in),
    .otg_hpi_data_out_port(hpi_data_out),
    .otg_hpi_cs_export(hpi_cs),
    .otg_hpi_r_export(hpi_r),
    .otg_hpi_w_export(hpi_w),
    .otg_hpi_reset_export(hpi_reset)
);



    // Interface between NIOS II and EZ-OTG chip
    hpi_io_intf hpi_io_inst(
        .Clk(Clk),
        .Reset(Reset_h),
        // signals connected to NIOS II
        .from_sw_address(hpi_addr),
        .from_sw_data_in(hpi_data_in),
        .from_sw_data_out(hpi_data_out),
        .from_sw_r(hpi_r),
        .from_sw_w(hpi_w),
        .from_sw_cs(hpi_cs),
        .from_sw_reset(hpi_reset),
        // signals connected to EZ-OTG chip
        .OTG_DATA(OTG_DATA),    
        .OTG_ADDR(OTG_ADDR),    
        .OTG_RD_N(OTG_RD_N),    
        .OTG_WR_N(OTG_WR_N),    
        .OTG_CS_N(OTG_CS_N),
        .OTG_RST_N(OTG_RST_N)
    );




// Display the first 4 and the last 4 hex values of the received message
HexDriver hexdrv0 (
	.In0(debug[3:0]),
    .Out0(HEX0)
);
HexDriver hexdrv1 (
 	.In0(debug[7:4]),
    .Out0(HEX1)
);
// hexdriver hexdrv2 (
// 	.In(AES_EXPORT_DATA[11:8]),
//    .Out(HEX2)
// );
// hexdriver hexdrv3 (
// 	.In(AES_EXPORT_DATA[15:12]),
//    .Out(HEX3)
// );
// hexdriver hexdrv4 (
// 	.In(AES_EXPORT_DATA[19:16]),
//    .Out(HEX4)
// );
// hexdriver hexdrv5 (
// 	.In(AES_EXPORT_DATA[23:20]),
//    .Out(HEX5)
// );
// hexdriver hexdrv6 (
// 	.In(AES_EXPORT_DATA[27:24]),
//    .Out(HEX6)
// );
// hexdriver hexdrv7 (
// 	.In(AES_EXPORT_DATA[31:28]),
//    .Out(HEX7)
// );

endmodule



// Interface between NIOS II and EZ-OTG chip
module hpi_io_intf( input        Clk, Reset,
                    input [1:0]  from_sw_address,
                    output[15:0] from_sw_data_in,
                    input [15:0] from_sw_data_out,
                    input        from_sw_r, from_sw_w, from_sw_cs, from_sw_reset, // Active low
                    inout [15:0] OTG_DATA,
                    output[1:0]  OTG_ADDR,
                    output       OTG_RD_N, OTG_WR_N, OTG_CS_N, OTG_RST_N // Active low
                   );

// Buffer (register) for from_sw_data_out because inout bus should be driven 
//   by a register, not combinational logic.
logic [15:0] from_sw_data_out_buffer;

// TODO: Fill in the blanks below. 
always_ff @ (posedge Clk)
begin
    if(Reset)
    begin
        from_sw_data_out_buffer <= 16'h0000;
        OTG_ADDR                <= 2'b00;
        OTG_RD_N                <= 1'b1;
        OTG_WR_N                <= 1'b1;
        OTG_CS_N                <= 1'b1;
        OTG_RST_N               <= 1'b1;
        from_sw_data_in         <= 16'h0000;
    end
    else 
    begin
        from_sw_data_out_buffer <=  from_sw_data_out;
        OTG_ADDR                <=  from_sw_address;
        OTG_RD_N                <=  from_sw_r;
        OTG_WR_N                <=  from_sw_w;
        OTG_CS_N                <=  from_sw_cs;
        OTG_RST_N               <=  from_sw_reset;
        from_sw_data_in         <=  OTG_DATA;
    end
end

// OTG_DATA should be high Z (tristated) when NIOS is not writing to OTG_DATA inout bus.
// Look at tristate.sv in lab 6 for an example.
assign OTG_DATA = ~from_sw_w ? from_sw_data_out_buffer : {16{1'bZ}};

endmodule 
