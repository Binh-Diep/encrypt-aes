module adder_8bit(
    //inputs
    input logic [7:0] M_i,
    input logic [7:0] N_i,
    //outputs
    output logic [8:0] result_o
);
    logic tmp_cout;
    //code
    adder_4bit full_adder_4bit_01 (
    	.M_4bit_i    (M_i[3:0]),
    	.N_4bit_i    (N_i[3:0]),
    	.Cin_4bit_i  (1'b0),
    	.Cout_4bit_o (tmp_cout),
    	.sum_4bit_o  (result_o[3:0])
    );
    adder_4bit full_adder_4bit_02 (
    	.M_4bit_i    (M_i[7:4]),
    	.N_4bit_i    (N_i[7:4]),
    	.Cin_4bit_i  (tmp_cout),
    	.Cout_4bit_o (result_o[8]),
    	.sum_4bit_o  (result_o[7:4])
    );
endmodule : adder_8bit
