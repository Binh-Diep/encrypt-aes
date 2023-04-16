module brcomp(
    //inputs
    input logic [7:0] operand_a_i,
    input logic [7:0] operand_b_i,
    //outputs
    output logic less_o,
    output logic equal_o
);
    logic [8:0] tmp_value;
    //module substractor
    sub_8bit substractor(
        .M_i      (operand_a_i),
        .N_i      (operand_b_i),
        .result_o (tmp_value)
    );
    //code
    always_comb begin
        if (tmp_value[8]) begin
            less_o = 1'b1;
            equal_o = 1'b0;
        end 
        else begin
            if (!(|tmp_value[7:0])) begin
                less_o = 1'b0;
                equal_o = 1'b1;
            end
            else begin
                less_o = 1'b0;
                equal_o = 1'b0;                
            end
        end
    end
endmodule : brcomp
