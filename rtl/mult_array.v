module mult_array (
    input  wire [3:0] a,
    input  wire [3:0] b,
    output wire [7:0] p
);

    // 16 Partial Products: pp_i[j] = a[j] & b[i]
    wire [3:0] pp0, pp1, pp2, pp3;
    
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : gen_pp
            assign pp0[i] = a[i] & b[0];
            assign pp1[i] = a[i] & b[1];
            assign pp2[i] = a[i] & b[2];
            assign pp3[i] = a[i] & b[3];
        end
    endgenerate

    // Row 0: No adders
    assign p[0] = pp0[0];
    wire [3:0] r0 = {1'b0, pp0[3], pp0[2], pp0[1]};

    // Row 1: 4 Full Adders
    wire [3:0] s1;
    wire [4:0] c1;
    assign c1[0] = 1'b0;

    generate
        for (i = 0; i < 4; i = i + 1) begin : row1_fa
            full_adder fa (
                .a(pp1[i]),
                .b(r0[i]),
                .cin(c1[i]),
                .sum(s1[i]),
                .cout(c1[i+1])
            );
        end
    endgenerate

    assign p[1] = s1[0];
    wire [3:0] r1 = {c1[4], s1[3], s1[2], s1[1]};

    // Row 2: 4 Full Adders
    wire [3:0] s2;
    wire [4:0] c2;
    assign c2[0] = 1'b0;

    generate
        for (i = 0; i < 4; i = i + 1) begin : row2_fa
            full_adder fa (
                .a(pp2[i]),
                .b(r1[i]),
                .cin(c2[i]),
                .sum(s2[i]),
                .cout(c2[i+1])
            );
        end
    endgenerate

    assign p[2] = s2[0];
    wire [3:0] r2 = {c2[4], s2[3], s2[2], s2[1]};

    // Row 3: 4 Full Adders
    wire [3:0] s3;
    wire [4:0] c3;
    assign c3[0] = 1'b0;

    generate
        for (i = 0; i < 4; i = i + 1) begin : row3_fa
            full_adder fa (
                .a(pp3[i]),
                .b(r2[i]),
                .cin(c3[i]),
                .sum(s3[i]),
                .cout(c3[i+1])
            );
        end
    endgenerate

    assign p[3]   = s3[0];
    assign p[7:4] = {c3[4], s3[3], s3[2], s3[1]};

endmodule
