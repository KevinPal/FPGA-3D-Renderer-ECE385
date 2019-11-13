	component final_soc is
		port (
			clk_clk                 : in    std_logic                     := 'X';             -- clk
			debug_debug             : out   std_logic_vector(7 downto 0);                     -- debug
			reset_reset_n           : in    std_logic                     := 'X';             -- reset_n
			sdram_clk_clk           : out   std_logic;                                        -- clk
			sdram_wire_addr         : out   std_logic_vector(12 downto 0);                    -- addr
			sdram_wire_ba           : out   std_logic_vector(1 downto 0);                     -- ba
			sdram_wire_cas_n        : out   std_logic;                                        -- cas_n
			sdram_wire_cke          : out   std_logic;                                        -- cke
			sdram_wire_cs_n         : out   std_logic;                                        -- cs_n
			sdram_wire_dq           : inout std_logic_vector(31 downto 0) := (others => 'X'); -- dq
			sdram_wire_dqm          : out   std_logic_vector(3 downto 0);                     -- dqm
			sdram_wire_ras_n        : out   std_logic;                                        -- ras_n
			sdram_wire_we_n         : out   std_logic;                                        -- we_n
			vga_b_vga_b             : out   std_logic_vector(7 downto 0);                     -- vga_b
			vga_blank_n_vga_blank_n : out   std_logic;                                        -- vga_blank_n
			vga_clk_clk             : out   std_logic;                                        -- clk
			vga_g_vga_g             : out   std_logic_vector(7 downto 0);                     -- vga_g
			vga_hs_vga_hs           : out   std_logic;                                        -- vga_hs
			vga_r_vga_r             : out   std_logic_vector(7 downto 0);                     -- vga_r
			vga_sync_n_vga_sync_n   : out   std_logic;                                        -- vga_sync_n
			vga_vs_vga_vs           : out   std_logic                                         -- vga_vs
		);
	end component final_soc;

	u0 : component final_soc
		port map (
			clk_clk                 => CONNECTED_TO_clk_clk,                 --         clk.clk
			debug_debug             => CONNECTED_TO_debug_debug,             --       debug.debug
			reset_reset_n           => CONNECTED_TO_reset_reset_n,           --       reset.reset_n
			sdram_clk_clk           => CONNECTED_TO_sdram_clk_clk,           --   sdram_clk.clk
			sdram_wire_addr         => CONNECTED_TO_sdram_wire_addr,         --  sdram_wire.addr
			sdram_wire_ba           => CONNECTED_TO_sdram_wire_ba,           --            .ba
			sdram_wire_cas_n        => CONNECTED_TO_sdram_wire_cas_n,        --            .cas_n
			sdram_wire_cke          => CONNECTED_TO_sdram_wire_cke,          --            .cke
			sdram_wire_cs_n         => CONNECTED_TO_sdram_wire_cs_n,         --            .cs_n
			sdram_wire_dq           => CONNECTED_TO_sdram_wire_dq,           --            .dq
			sdram_wire_dqm          => CONNECTED_TO_sdram_wire_dqm,          --            .dqm
			sdram_wire_ras_n        => CONNECTED_TO_sdram_wire_ras_n,        --            .ras_n
			sdram_wire_we_n         => CONNECTED_TO_sdram_wire_we_n,         --            .we_n
			vga_b_vga_b             => CONNECTED_TO_vga_b_vga_b,             --       vga_b.vga_b
			vga_blank_n_vga_blank_n => CONNECTED_TO_vga_blank_n_vga_blank_n, -- vga_blank_n.vga_blank_n
			vga_clk_clk             => CONNECTED_TO_vga_clk_clk,             --     vga_clk.clk
			vga_g_vga_g             => CONNECTED_TO_vga_g_vga_g,             --       vga_g.vga_g
			vga_hs_vga_hs           => CONNECTED_TO_vga_hs_vga_hs,           --      vga_hs.vga_hs
			vga_r_vga_r             => CONNECTED_TO_vga_r_vga_r,             --       vga_r.vga_r
			vga_sync_n_vga_sync_n   => CONNECTED_TO_vga_sync_n_vga_sync_n,   --  vga_sync_n.vga_sync_n
			vga_vs_vga_vs           => CONNECTED_TO_vga_vs_vga_vs            --      vga_vs.vga_vs
		);

