# Read the standard cell timing library (typical corner)
set lib $::env(PDK_ROOT)/sky130A/libs.ref/sky130_fd_sc_hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# Step 1: Read the Verilog source files
read_verilog rtl/full_adder.v rtl/mult_array.v

# Step 2: Generic synthesis and flatten full adders into one module
synth -top mult_array -flatten

# Step 3: Map flip-flops to SKY130 flip-flop cells
dfflibmap -liberty $lib

# Step 4: Map combinational logic to SKY130 gate cells
abc -liberty $lib

# Step 5: Remove unused wires
opt_clean -purge


# Step 6: Write the cell count and area report
tee -o synth/mult_array_stat.rpt stat -liberty $lib


# Step 7: Write out the synthesized gate-level netlist
write_verilog -noattr synth/mult_array_netlist.v
