module div_8bit(
    //inputs
    input logic [7:0] dividend_i,
    input logic [3:0] divisor_i,
    //outputs
    output logic [7:0] quotient_o,
    output logic [4:0] remainder_o
);
    logic tmp_sel_0,tmp_sel_1,tmp_sel_2,tmp_sel_3,tmp_sel_4,tmp_sel_5,tmp_sel_6,tmp_sel_7;
    logic [4:0] tmp_d0,tmp_d1,tmp_d2,tmp_d3,tmp_d4,tmp_d5,tmp_d6,tmp_d7;
    //module
    csm_5bit row_01(
        .x5bit_i  ({4'b0,dividend_i[7]}),
        .y5bit_i  ({1'b0,divisor_i[3:0]}),
        .b5bit_i  (1'b0),
        .sel_i    (tmp_sel_0),
        .b5bit_o  (tmp_sel_0),
        .d5bit_o  (tmp_d0)
    );
    csm_5bit row_02(
        .x5bit_i  ({tmp_d0[3:0],dividend_i[6]}),
        .y5bit_i  ({1'b0,divisor_i[3:0]}),
        .b5bit_i  (1'b0),
        .sel_i    (tmp_sel_1),
        .b5bit_o  (tmp_sel_1),
        .d5bit_o  (tmp_d1)
    );
    csm_5bit row_03(
        .x5bit_i  ({tmp_d1[3:0],dividend_i[5]}),
        .y5bit_i  ({1'b0,divisor_i[3:0]}),
        .b5bit_i  (1'b0),
        .sel_i    (tmp_sel_2),
        .b5bit_o  (tmp_sel_2),
        .d5bit_o  (tmp_d2)
    );
    csm_5bit row_04(
        .x5bit_i  ({tmp_d2[3:0],dividend_i[4]}),
        .y5bit_i  ({1'b0,divisor_i[3:0]}),
        .b5bit_i  (1'b0),
        .sel_i    (tmp_sel_3),
        .b5bit_o  (tmp_sel_3),
        .d5bit_o  (tmp_d3)
    );
    csm_5bit row_05(
        .x5bit_i  ({tmp_d3[3:0],dividend_i[3]}),
        .y5bit_i  ({1'b0,divisor_i[3:0]}),
        .b5bit_i  (1'b0),
        .sel_i    (tmp_sel_4),
        .b5bit_o  (tmp_sel_4),
        .d5bit_o  (tmp_d4)
    );
    csm_5bit row_06(
        .x5bit_i  ({tmp_d4[3:0],dividend_i[2]}),
        .y5bit_i  ({1'b0,divisor_i[3:0]}),
        .b5bit_i  (1'b0),
        .sel_i    (tmp_sel_5),
        .b5bit_o  (tmp_sel_5),
        .d5bit_o  (tmp_d5)
    );
    csm_5bit row_07(
        .x5bit_i  ({tmp_d5[3:0],dividend_i[1]}),
        .y5bit_i  ({1'b0,divisor_i[3:0]}),
        .b5bit_i  (1'b0),
        .sel_i    (tmp_sel_6),
        .b5bit_o  (tmp_sel_6),
        .d5bit_o  (tmp_d6)
    );
    csm_5bit row_08(
        .x5bit_i  ({tmp_d6[3:0],dividend_i[0]}),
        .y5bit_i  ({1'b0,divisor_i[3:0]}),
        .b5bit_i  (1'b0),
        .sel_i    (tmp_sel_7),
        .b5bit_o  (tmp_sel_7),
        .d5bit_o  (tmp_d7)
    );
    //code
    assign quotient_o  = {~tmp_sel_0,~tmp_sel_1,~tmp_sel_2,~tmp_sel_3,~tmp_sel_4,~tmp_sel_5,~tmp_sel_6,~tmp_sel_7};
    assign remainder_o = tmp_d7;
endmodule : div_8bit
