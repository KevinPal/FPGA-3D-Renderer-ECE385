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
    output logic        VGA_VS            //      vga_vs.vga_vs
);

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
    .vga_b_vga_b(VGA_B),             //       vga_b.vga_b
    .vga_blank_n_vga_blank_n(VGA_BLANK_N), // vga_blank_n.vga_blank_n
    .vga_clk_clk(VGA_CLK_CLK),             //     vga_clk.clk
    .vga_g_vga_g(VGA_G),             //       vga_g.vga_g
    .vga_hs_vga_hs(VGA_HS),           //      vga_hs.vga_hs
    .vga_r_vga_r(VGA_R),             //       vga_r.vga_r
    .vga_sync_n_vga_sync_n(VGA_SYNC_N),   //  vga_sync_n.vga_sync_n
    .vga_vs_vga_vs(VGA_VS),            //      vga_vs.vga_vs
    .debug_debug(debug)
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

