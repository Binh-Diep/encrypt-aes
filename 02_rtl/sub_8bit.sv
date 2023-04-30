module sub_8bit(
    //inputs
    input logic [7:0] M_i,
    input logic [7:0] N_i,
    //outputs
    output logic [8:0] result_o
);
    logic tmp_cin;
    logic tmp_cout;
    logic tmp_cn;
    assign tmp_cin = 1;
    //code
    sub_4bit full_adder_4bit_01 (
    	.M_4bit_i    (M_i[3:0]),
    	.N_4bit_i    (~N_i[3:0]),
    	.Cin_4bit_i  (tmp_cin),
    	.Cout_4bit_o (tmp_cout),
    	.sub_4bit_o  (result_o[3:0])
    );
    sub_4bit full_adder_4bit_02 (
    	.M_4bit_i    (M_i[7:4]),
    	.N_4bit_i    (~N_i[7:4]),
    	.Cin_4bit_i  (tmp_cout),
    	.Cout_4bit_o (tmp_cn),
    	.sub_4bit_o  (result_o[7:4])
    );
    assign result_o[8] = ~tmp_cn & tmp_cin; 
endmodule : sub_8bit
