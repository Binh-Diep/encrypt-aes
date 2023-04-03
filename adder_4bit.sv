module adder_4bit(
    //inputs
    input logic [3:0] M_4bit_i,
    input logic [3:0] N_4bit_i,
    input logic Cin_4bit_i,
    //outputs
    output logic Cout_4bit_o,
    output logic [3:0] sum_4bit_o
);
    //variables
    logic tmp_carry_0;
    logic tmp_carry_1;
    logic tmp_carry_2;
    logic tmp_carry_3;
    logic tmp_carry_4;
    logic [3:0] tmp_sum;
    assign tmp_carry_0 = Cin_4bit_i;
    //code
    FA full_adder_01 (
    	.x_i (M_4bit_i[0]),
    	.y_i (N_4bit_i[0]),
    	.z_i (tmp_carry_0),
    	.s_o (tmp_sum[0]),
    	.c_o (tmp_carry_1)
    );
    FA full_adder_02 (
    	.x_i (M_4bit_i[1]),
    	.y_i (N_4bit_i[1]),
    	.z_i (tmp_carry_1),
    	.s_o (tmp_sum[1]),
    	.c_o (tmp_carry_2)
    );
    FA full_adder_03 (
    	.x_i (M_4bit_i[2]),
    	.y_i (N_4bit_i[2]),
    	.z_i (tmp_carry_2),
    	.s_o (tmp_sum[2]),
    	.c_o (tmp_carry_3)
    );
    FA full_adder_04 (
    	.x_i (M_4bit_i[3]),
    	.y_i (N_4bit_i[3]),
    	.z_i (tmp_carry_3),
    	.s_o (tmp_sum[3]),
    	.c_o (tmp_carry_4)
    );
    assign sum_4bit_o = tmp_sum;
    assign Cout_4bit_o = tmp_carry_4;
endmodule : adder_4bit
