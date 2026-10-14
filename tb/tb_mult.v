`timescale 1ns/1ps

module tb_mult_array;

    // Testbench Signals
    reg        clk;
    reg        rst_n;
    reg  [3:0] a;
    reg  [3:0] b;
    wire [7:0] p;

    // Internal Variables for Verification
    integer i, j;
    integer error_count = 0;
    integer total_vectors = 0;

    // Expected value pipeline buffer (for 2-cycle latency tracking)
    reg [7:0] expected_p_stage1;
    reg [7:0] expected_p_stage2;

    // Instantiate Unit Under Test (UUT)
    mult_array uut (
        .a(a),
        .b(b),
        .p(p)
    );

    // 1. Clock Generation (10 ns period -> 5 ns HIGH / 5 ns LOW)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Main Test Stimulus
    initial begin
        // Initialize Waveform File
        $dumpfile("mult.vcd");
        $dumpvars(0, tb_mult_array);

        // Initialize Signals
        a = 0;
        b = 0;
        expected_p_stage1 = 0;
        expected_p_stage2 = 0;

        // 2. Hold rst_n low for the first 2 clock cycles
        rst_n = 0;
        repeat (2) @(posedge clk);
        rst_n = 1;

        // Synchronize stimulus driven at falling edge to provide setup/hold margin
        @(negedge clk);

        // 3. Apply all 256 input combinations (a = 0..15, b = 0..15)
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i;
                b = j;

                // Model 2-cycle latency pipeline for expected value check
                expected_p_stage1 = a * b; // '*' allowed in testbench

                // Wait 2 full clock cycles
                repeat (2) @(posedge clk);
                expected_p_stage2 = expected_p_stage1;

                // Compare p with expected output
                total_vectors = total_vectors + 1;
                if (p !== expected_p_stage2) begin
                    $display("MISMATCH: at time %0t | a = %0d, b = %0d | Expected = %0d, Got = %0d",
                             $time, a, b, expected_p_stage2, p);
                    error_count = error_count + 1;
                end

                @(negedge clk);
            end
        end

        // 4. Print Summary Line
        if (error_count == 0) begin
            $display("PASS: %0d vectors checked, 0 errors", total_vectors);
        end else begin
            $display("FAIL: %0d vectors checked, %0d errors", total_vectors, error_count);
        end

        $finish;
    end
endmodule
