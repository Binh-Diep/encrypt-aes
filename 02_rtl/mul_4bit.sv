module mul_4bit(
    //inputs
    input logic [3:0] operand_a_i,
    input logic [3:0] operand_b_i,
    //outputs
    output logic [7:0] mul_4_o
);
    //VAR
    logic [3:0] addend_01;
    logic [3:0] augend_01;
    logic [3:0] addend_02;
    logic [3:0] augend_02;
    logic [3:0] addend_03;
    logic [3:0] augend_03;
    logic [3:0] sum_add01;
    logic [3:0] sum_add02;
    //module adder 4bit
    adder_4bit AD1(
        .M_4bit_i    (addend_01),
        .N_4bit_i    (augend_01),
        .Cin_4bit_i  (1'b0),
        .Cout_4bit_o (augend_02[3]),
        .sum_4bit_o  (sum_add01)
    );
    adder_4bit AD2(
        .M_4bit_i    (addend_02),
        .N_4bit_i    (augend_02),
        .Cin_4bit_i  (1'b0),
        .Cout_4bit_o (augend_03[3]),
        .sum_4bit_o  (sum_add02) 
    );
    adder_4bit AD3(
        .M_4bit_i    (addend_03),
        .N_4bit_i    (augend_03),
        .Cin_4bit_i  (1'b0),
        .Cout_4bit_o (mul_4_o[7]),
        .sum_4bit_o  (mul_4_o[6:3]) 
    );
    //partial product 1
    assign addend_01      = {operand_a_i[1] & operand_b_i[3],operand_a_i[1] & operand_b_i[2],operand_a_i[1] & operand_b_i[1],operand_a_i[1] & operand_b_i[0]};
    assign augend_01[3:0] = {1'b0,operand_a_i[0] & operand_b_i[3],operand_a_i[0] & operand_b_i[2],operand_a_i[0] & operand_b_i[1]};
    //partial product 2
    assign addend_02      = {operand_a_i[2] & operand_b_i[3],operand_a_i[2] & operand_b_i[2],operand_a_i[2] & operand_b_i[1],operand_a_i[2] & operand_b_i[0]};
    assign augend_02[2:0] = sum_add01[3:1];
    //partial product 3
    assign addend_03      = {operand_a_i[3] & operand_b_i[3],operand_a_i[3] & operand_b_i[2],operand_a_i[3] & operand_b_i[1],operand_a_i[3] & operand_b_i[0]};
    assign augend_03[2:0] = sum_add02[3:1];
    //final product
    assign mul_4_o[0]     = operand_a_i[0] & operand_b_i[0];
    assign mul_4_o[1]     = sum_add01[0];
    assign mul_4_o[2]     = sum_add02[0];
endmodule : mul_4bit
