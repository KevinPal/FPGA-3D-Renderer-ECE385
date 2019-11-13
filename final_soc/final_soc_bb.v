
module final_soc (
	clk_clk,
	debug_debug,
	reset_reset_n,
	sdram_clk_clk,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	vga_b_vga_b,
	vga_blank_n_vga_blank_n,
	vga_clk_clk,
	vga_g_vga_g,
	vga_hs_vga_hs,
	vga_r_vga_r,
	vga_sync_n_vga_sync_n,
	vga_vs_vga_vs);	

	input		clk_clk;
	output	[7:0]	debug_debug;
	input		reset_reset_n;
	output		sdram_clk_clk;
	output	[12:0]	sdram_wire_addr;
	output	[1:0]	sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[31:0]	sdram_wire_dq;
	output	[3:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	output	[7:0]	vga_b_vga_b;
	output		vga_blank_n_vga_blank_n;
	output		vga_clk_clk;
	output	[7:0]	vga_g_vga_g;
	output		vga_hs_vga_hs;
	output	[7:0]	vga_r_vga_r;
	output		vga_sync_n_vga_sync_n;
	output		vga_vs_vga_vs;
endmodule
