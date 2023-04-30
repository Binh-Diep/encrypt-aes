module csm_1bit(
    //inputs
    input logic x_i,
    input logic y_i,
    input logic b_i,
    input logic os_i,
    //outputs
    output logic b_o,
    output logic d_o
);
    //code
    assign b_o = (~x_i & y_i) | (b_i & ~(x_i ^ y_i));
    assign d_o = (os_i & x_i) | (~os_i & (x_i ^ y_i ^ b_i));
endmodule : csm_1bit
