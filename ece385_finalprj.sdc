
create_clock -name {Clk} -period 15.000  [get_ports {CLOCK_50}]
# Automatically apply a generate clock on the output of phase-locked loops (PLLs)
# This command can be safely left in the SDC even if no PLLs exist in the design

derive_pll_clocks

# Constrain the input I/O path

set_input_delay -clock {Clk} -max 3 [all_inputs]
set_input_delay -clock {Clk} -min 2 [all_inputs]

# Constrain the output I/O path

set_output_delay -clock {Clk} -max 3 [all_outputs]
set_output_delay -clock {Clk} -min 2 [all_outputs]

#set_multicycle_path 50 -setup -from  -to <EndPoint>

