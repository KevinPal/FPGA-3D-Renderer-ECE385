/************************************************************************
Lab 9 Quartus Project Top Level

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

module final_top (
    input int test1, test2, test3,
    output int yeet,
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
logic [7:0] debug1;
logic [7:0] debug2;
logic [7:0] debug3;
// Instantiation of Qsys design
//final_soc final_subsystem (
//	.clk_clk(CLOCK_50),								// Clock input
//	.reset_reset_n(KEY[0]),							// Reset key
//	.sdram_wire_addr(DRAM_ADDR),					// sdram_wire.addr
//	.sdram_wire_ba(DRAM_BA),						// sdram_wire.ba
//	.sdram_wire_cas_n(DRAM_CAS_N),				// sdram_wire.cas_n
//	.sdram_wire_cke(DRAM_CKE),						// sdram_wire.cke
//	.sdram_wire_cs_n(DRAM_CS_N),					// sdram.cs_n
//	.sdram_wire_dq(DRAM_DQ),						// sdram.dq
//	.sdram_wire_dqm(DRAM_DQM),						// sdram.dqm
//	.sdram_wire_ras_n(DRAM_RAS_N),				// sdram.ras_n
//	.sdram_wire_we_n(DRAM_WE_N),					// sdram.we_n
//	.sdram_clk_clk(DRAM_CLK),						// Clock out to SDRAM
//    .vga_b_vga_b(VGA_B),             //       vga_b.vga_b
//    .vga_blank_n_vga_blank_n(VGA_BLANK_N), // vga_blank_n.vga_blank_n
//    .vga_clk_clk(VGA_CLK_CLK),             //     vga_clk.clk
//    .vga_g_vga_g(VGA_G),             //       vga_g.vga_g
//    .vga_hs_vga_hs(VGA_HS),           //      vga_hs.vga_hs
//    .vga_r_vga_r(VGA_R),             //       vga_r.vga_r
//    .vga_sync_n_vga_sync_n(VGA_SYNC_N),   //  vga_sync_n.vga_sync_n
//    .vga_vs_vga_vs(VGA_VS),            //      vga_vs.vga_vs
//    .debug_debug(debug)
//);
//
//

int out[8][3];
int prj[4][4];
int vec[3] = '{30 * (1<< 8), 0 * (1<< 8) , -7 * (1<< 8)};

project_cube cb(.scale(64 * (1<< 8)), .pos(vec), .prj, .out(out));
gen_prj_mat m1(320 * (1<< 8), 240 * (1<< 8), 5 * (1<< 8), 200 * (1<< 8), prj);

assign vec[2] = test1;
assign vec[1] = test2;
assign vec[0] = test3;

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

assign {debug, debug1, debug2, debug3} = (shift[0][0] + shift[0][1] + shift[0][2] + shift[1][0] + shift[1][1] + shift[1][2] + shift[2][0] + shift[2][1] + shift[2][2] + shift[3][0] + shift[3][1] + shift[3][2] + shift[4][0] + shift[4][1] + shift[4][2] + shift[5][0] + shift[5][1] + shift[5][2] + shift[6][0] + shift[6][1] + shift[6][2] + shift[7][0] + shift[7][1] + shift[7][2]);

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

