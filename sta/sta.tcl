# Step 1: Read the timing library (typical corner)
set lib $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
read_liberty $lib

# Step 2: Read the netlist and link the design
read_verilog synth/mult_array_netlist.v
link_design mult_array

# Step 3: Define the clock period (Start with T = 10 ns)
create_clock -name clk -period 10.0 [get_ports clk]

# Step 4: Set input arrival delay (1.0 ns) on all inputs except clk
set_input_delay 1.0 -clock clk [delete_from_list [all_inputs] [get_ports clk]]

# Step 5: Set output required delay (1.0 ns)
set_output_delay 1.0 -clock clk [all_outputs]

# Step 6: Print worst setup slack to terminal
report_worst_slack -max

# Step 7: Save critical path timing report␍
report_checks -path_delay max -digits 3 > sta/mult_array_timing.rpt
