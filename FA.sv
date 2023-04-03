module FA(
    input logic x_i,
    input logic y_i,
    input logic z_i,
    output logic s_o,
    output logic c_o
);
    logic sum;
    logic carry;
    //code
    always_comb begin
        sum   = ((x_i ^ y_i) ^ z_i);
        carry = (x_i & y_i) | ((x_i ^ y_i) & z_i);
    end
    assign s_o = sum;
    assign c_o = carry;
endmodule : FA
