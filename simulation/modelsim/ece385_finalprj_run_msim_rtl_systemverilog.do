transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlib final_soc
vmap final_soc final_soc
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/final_soc.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/altera_reset_controller.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/altera_reset_synchronizer.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_avalon_st_adapter.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/altera_avalon_sc_fifo.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_timer_0.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_jtag_uart_0.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_SDRAM.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_PLL.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_NIOS2.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_NIOS2_cpu.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_NIOS2_cpu_debug_slave_sysclk.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_NIOS2_cpu_debug_slave_tck.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_NIOS2_cpu_debug_slave_wrapper.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_NIOS2_cpu_test_bench.v}
vlog -sv -work work +incdir+C:/Users/kpalani/Desktop/ece385_finalprj {C:/Users/kpalani/Desktop/ece385_finalprj/HexDriver.sv}
vlog -sv -work work +incdir+C:/Users/kpalani/Desktop/ece385_finalprj {C:/Users/kpalani/Desktop/ece385_finalprj/final_top.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_irq_mapper.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_avalon_st_adapter_error_adapter_0.sv}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/altera_avalon_st_handshake_clock_crosser.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/altera_avalon_st_clock_crosser.v}
vlog -vlog01compat -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/altera_std_synchronizer_nocut.v}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_rsp_mux_001.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/altera_merlin_arbitrator.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_rsp_mux.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_rsp_demux_001.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_rsp_demux.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_cmd_mux_001.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_cmd_mux.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_cmd_demux_001.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_cmd_demux.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_router_004.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_router_003.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_router_001.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/final_soc_mm_interconnect_0_router.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/altera_merlin_slave_agent.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/altera_merlin_burst_uncompressor.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/altera_merlin_master_agent.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/altera_merlin_slave_translator.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/altera_merlin_master_translator.sv}
vlog -sv -work work +incdir+C:/Users/kpalani/Desktop/ece385_finalprj {C:/Users/kpalani/Desktop/ece385_finalprj/VGA_controller.sv}
vlog -sv -work final_soc +incdir+C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules {C:/Users/kpalani/Desktop/ece385_finalprj/final_soc/synthesis/submodules/avalon_vga_interface.sv}

vlog -sv -work work +incdir+C:/Users/kpalani/Desktop/ece385_finalprj {C:/Users/kpalani/Desktop/ece385_finalprj/testbench.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -L final_soc -voptargs="+acc"  testbench

add wave *
view structure
view signals
run 10000 ns
