module full_adder (
    input  wire a,
    input  wire b,
    input  wire cin,
    output wire sum,
    output wire cout
);

    wire xor1_out, and1_out, and2_out;

    xor g1 (xor1_out, a, b);
    xor g2 (sum, xor1_out, cin);

    and g3 (and1_out, a, b);
    and g4 (and2_out, xor1_out, cin);

    or  g5 (cout, and1_out, and2_out);
endmodule
