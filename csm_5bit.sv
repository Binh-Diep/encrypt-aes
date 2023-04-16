module csm_5bit(
    //inputs
    input logic [4:0] x5bit_i,
    input logic [4:0] y5bit_i,
    input logic b5bit_i,
    input logic sel_i,
    //outputs
    output logic b5bit_o,
    output logic [4:0] d5bit_o
);
    //VAR
    logic b5bit_1;
    logic b5bit_2;
    logic b5bit_3;
    logic b5bit_4;
    //module
    csm_1bit csm_0(
        .x_i  (x5bit_i[0]),
        .y_i  (y5bit_i[0]),
        .b_i  (b5bit_i),
        .os_i (sel_i),
        .b_o  (b5bit_1),
        .d_o  (d5bit_o[0])
    );
    csm_1bit csm_1(
        .x_i  (x5bit_i[1]),
        .y_i  (y5bit_i[1]),
        .b_i  (b5bit_1),
        .os_i (sel_i),
        .b_o  (b5bit_2),
        .d_o  (d5bit_o[1])
    );
    csm_1bit csm_2(
        .x_i  (x5bit_i[2]),
        .y_i  (y5bit_i[2]),
        .b_i  (b5bit_2),
        .os_i (sel_i),
        .b_o  (b5bit_3),
        .d_o  (d5bit_o[2])
    );
    csm_1bit csm_3(
        .x_i  (x5bit_i[3]),
        .y_i  (y5bit_i[3]),
        .b_i  (b5bit_3),
        .os_i (sel_i),
        .b_o  (b5bit_4),
        .d_o  (d5bit_o[3])
    );
    csm_1bit csm_4(
        .x_i  (x5bit_i[4]),
        .y_i  (y5bit_i[4]),
        .b_i  (b5bit_4),
        .os_i (sel_i),
        .b_o  (b5bit_o),
        .d_o  (d5bit_o[4])
    );
endmodule : csm_5bit
