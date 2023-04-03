module cipher #(parameter SIZE_RAM  = 60, //128bit: 44 --- 192bit: 52 --- 256bit: 60
                          SIZE_DATA = 128,
                          SIZE_KEY  = 256)(
    //inputs
    input logic clk_i,
    input logic rst_ni,
    input logic ready_i,
    //edit again
    input logic [SIZE_DATA-1:0] plain_text_i,
    input logic [SIZE_KEY-1:0] cipher_key_i,
    //outputs
    output logic done_o,
    output logic [SIZE_DATA-1:0] cipher_text_o
);
    import myfunction::*;
    //variables
    //---module---
    logic [3:0] Nb = 4;  //128bit:  4 --- 192bit: 4  --- 256bit: 4
    logic [3:0] Nk = 8;  //128bit:  4 --- 192bit: 6  --- 256bit: 8
    logic [3:0] Nr = 14; //128bit: 10 --- 192bit: 12 --- 256bit: 14
    logic [7:0] number_RAM;
    logic [7:0] quotient;
    logic [4:0] remainder;
    logic [7:0] quotient_Rcon;
    logic [4:0] remainder_Rcon;
    logic [8:0] cell_RAM;
    logic [7:0] mul_pack;
    logic [7:0] mul_Nr;
    logic [7:0] pack_RAM_01;
    logic [7:0] pack_RAM_02;
    logic [7:0] pack_RAM_03;
    logic [7:0] pack_RAM_04;
    logic [7:0] pack_Nr_01;
    logic [7:0] pack_Nr_02;
    logic [7:0] pack_Nr_03;
    logic [7:0] pack_Nr_04;
    logic [8:0] tmp_add2;
    logic [8:0] tmp_add3;
    logic [8:0] tmp_addNr2;
    logic [8:0] tmp_addNr3;
    logic flag_less_4;
    logic flag_less_6;
    logic flag_less_8;
    logic flag_less_ckey;
    logic flag_less_round;
    logic flag_less_div0;
    logic flag_less_div4;
    logic flag_equal_4;
    logic flag_equal_6;
    logic flag_equal_8;
    logic flag_equal_ckey;
    logic flag_equal_round;
    logic flag_equal_div0;
    logic flag_equal_div4;
    //---module---
    logic [3:0] count_cipher;
    logic [5:0] count_keyexp;
    logic [31:0] COL_1;
    logic [31:0] COL_2;
    logic [31:0] COL_3;
    logic [31:0] COL_4;
    logic [31:0] temp_word;
    logic [31:0] RAM [SIZE_RAM];
    logic [SIZE_DATA-1:0] state;
    logic [SIZE_KEY-1:0] key;
    typedef enum logic [4:0] {
        INIT             = 5'b00000,
        WAIT_AND_PREPARE = 5'b00001,
        KEYEX_S0         = 5'b00010,
        KEYEX_S1         = 5'b00011,
        KEYEX_S2         = 5'b00100,
        KEYEX_S3         = 5'b00101,
        KEYEX_S4         = 5'b00110,
        ARK_INIT         = 5'b00111,
        ROUNDKEY         = 5'b01000,
        SUBBYTES         = 5'b01001,
        SHIFTROW         = 5'b01010,
        MIXCOLUMNS_S0    = 5'b01011,
        MIXCOLUMNS_S1    = 5'b01100,
        ARK_LOOP         = 5'b01101,
        SUBBYTES_OP      = 5'b01110,
        SHIFTROW_OP      = 5'b01111,
        ARK_OP           = 5'b10000,
        SEND             = 5'b10001
    } state_e;
    state_e current_state;
    //module
    mul_4bit MUL_RAM(
        .operand_a_i (Nb),
        .operand_b_i (Nr+1),
        .mul_4_o     (number_RAM)
    );
    mul_4bit MUL_PACK(
        .operand_a_i (count_cipher+1),
        .operand_b_i (4'd4),
        .mul_4_o     (mul_pack)
    );
    mul_4bit MUL_Nr(
        .operand_a_i (Nr),
        .operand_b_i (4'd4),
        .mul_4_o     (mul_Nr)
    );    
    adder_8bit ADD_2(
        .M_i      (mul_pack),
        .N_i      (8'd2),
        .result_o (tmp_add2)
    );
    adder_8bit ADD_3(
        .M_i      (mul_pack),
        .N_i      (8'd3),
        .result_o (tmp_add3)
    );
    adder_8bit ADDNr_2(
        .M_i      (mul_Nr),
        .N_i      (8'd2),
        .result_o (tmp_addNr2)
    );
    adder_8bit ADDNr_3(
        .M_i      (mul_Nr),
        .N_i      (8'd3),
        .result_o (tmp_addNr3)
    );
    brcomp BR1_KEYEXS0(
        .operand_a_i ({4'b0,Nk}),
        .operand_b_i (8'd4),
        .less_o      (flag_less_4),
        .equal_o     (flag_equal_4)
    );
    brcomp BR2_KEYEXS0(
        .operand_a_i ({4'b0,Nk}),
        .operand_b_i (8'd6),
        .less_o      (flag_less_6),
        .equal_o     (flag_equal_6)
    );
    brcomp BR3_KEYEXS0(
        .operand_a_i ({4'b0,Nk}),
        .operand_b_i (8'd8),
        .less_o      (flag_less_8),
        .equal_o     (flag_equal_8)
    );
    brcomp BR4_KEYEXS1(
        .operand_a_i ({2'b0,count_keyexp}),
        .operand_b_i (number_RAM),
        .less_o      (flag_less_ckey),
        .equal_o     (flag_equal_ckey)
    );
    brcomp BR5_ROUNDKEY(
        .operand_a_i ({4'b0,count_cipher}),
        .operand_b_i ({4'b0,(Nr - 1'b1)}),
        .less_o      (flag_less_round),
        .equal_o     (flag_equal_round)
    );
    brcomp BR6_DIV(
        .operand_a_i ({3'b0,remainder}),
        .operand_b_i (8'd0),
        .less_o      (flag_less_div0),
        .equal_o     (flag_equal_div0)
    );
    brcomp BR7_DIV(
        .operand_a_i ({3'b0,remainder}),
        .operand_b_i (8'd4),
        .less_o      (flag_less_div4),
        .equal_o     (flag_equal_div4)
    );
    div_8bit DIV_KEYEXS1(
        .dividend_i  ({2'b0,count_keyexp}),
        .divisor_i   (Nk),
        .quotient_o  (quotient),
        .remainder_o (remainder)
    );
    div_8bit DIV_RCON(
        .dividend_i  ({2'b0,count_keyexp}),
        .divisor_i   (Nk),
        .quotient_o  (quotient_Rcon),
        .remainder_o (remainder_Rcon)        
    );
    sub_8bit SUB_CKEY(
        .M_i      ({2'b0,count_keyexp}),
        .N_i      ({4'b0,Nk}),
        .result_o (cell_RAM)
    );
    //calculate for module
    assign pack_RAM_01 = mul_pack;
    assign pack_RAM_02 = mul_pack + 1;
    assign pack_RAM_03 = tmp_add2[7:0];
    assign pack_RAM_04 = tmp_add3[7:0];
    assign pack_Nr_01  = mul_Nr;
    assign pack_Nr_02  = mul_Nr + 1;
    assign pack_Nr_03  = tmp_addNr2[7:0];
    assign pack_Nr_04  = tmp_addNr3[7:0];
    //code   
    always_ff @(posedge clk_i or negedge rst_ni) begin
        if (!rst_ni) begin
            state         <= 0;
            key           <= 0;
            done_o        <= 0;
            cipher_text_o <= 0;
            current_state <= INIT;
        end
        else begin
            case (current_state)
                INIT: begin
                    count_cipher  <= 0;
                    count_keyexp  <= 0;
                    current_state <= WAIT_AND_PREPARE;
                end
                WAIT_AND_PREPARE: begin
                    if (ready_i) begin
                        state         <= plain_text_i;
                        key           <= cipher_key_i;
                        current_state <= KEYEX_S0;
                    end
                    else begin
                        current_state <= WAIT_AND_PREPARE;
                    end
                end
                KEYEX_S0: begin
                    if (flag_equal_4 & !flag_less_4) begin
                        RAM[0] <= key[255:224];
                        RAM[1] <= key[223:192];
                        RAM[2] <= key[191:160];
                        RAM[3] <= key[159:128];
                    end
                    else if (flag_equal_6 & !flag_less_6) begin
                        RAM[0] <= key[255:224];
                        RAM[1] <= key[223:192];
                        RAM[2] <= key[191:160];
                        RAM[3] <= key[159:128];
                        RAM[4] <= key[127:96];
                        RAM[5] <= key[95:64];
                    end
                    else if (flag_equal_8 & !flag_less_8) begin
                        RAM[0] <= key[255:224];
                        RAM[1] <= key[223:192];
                        RAM[2] <= key[191:160];
                        RAM[3] <= key[159:128];
                        RAM[4] <= key[127:96];
                        RAM[5] <= key[95:64];
                        RAM[6] <= key[63:32];
                        RAM[7] <= key[31:0];
                    end
                    else begin
                        current_state <= KEYEX_S0;
                    end
                    count_keyexp  <= {2'b0,Nk};
                    current_state <= KEYEX_S1;
                end
                KEYEX_S1: begin
                    if (flag_less_ckey & !flag_equal_ckey) begin
                        temp_word <= RAM[count_keyexp - 1];
                        if (flag_equal_div0 & !flag_less_div0) begin
                            current_state <= KEYEX_S2;
                        end
                        else if ((flag_equal_8 & !flag_less_8) & (!flag_less_div4 & flag_equal_div4)) begin
                            current_state <= KEYEX_S3;
                        end
                        else begin
                            current_state <= KEYEX_S4; //thuc hien w[i] = w[i-Nk] ^ temp
                        end
                    end
                    else begin
                        current_state <= ARK_INIT; //Hoan thanh Keyexpasion
                    end
                end
                KEYEX_S2: begin //count_keyexp mod Nk = 0
                    temp_word     <= SubWord(RotWord(temp_word)) ^ Rcon(quotient_Rcon);
                    current_state <= KEYEX_S4;
                end
                KEYEX_S3: begin //Nk > 6 and count_keyexp mod Nk = 4
                    temp_word     <= SubWord(temp_word);
                    current_state <= KEYEX_S4;
                end
                KEYEX_S4: begin //calculate w[i] = w[i-Nk] ^ temp
                    RAM[count_keyexp] <= temp_word ^ RAM[cell_RAM[5:0]];
                    count_keyexp      <= count_keyexp + 1;
                    current_state     <= KEYEX_S1; //Check count_keyexp < (Nb*(Nk+1))
                end
                ARK_INIT: begin
                    state         <= state ^ key[255:128];
                    current_state <= ROUNDKEY;
                end
                ROUNDKEY: begin
                    if (flag_less_round & !flag_equal_round) begin
                        current_state <= SUBBYTES;
                    end
                    else begin
                        current_state <= SUBBYTES_OP; //Hoan thanh Nr vong lap round key
                    end
                end
                SUBBYTES: begin
                    state[127:120] <= S_BOX(state[127:120]);
                    state[119:112] <= S_BOX(state[119:112]);
                    state[111:104] <= S_BOX(state[111:104]);
                    state[103:96]  <= S_BOX(state[103:96]);
                    state[95:88]   <= S_BOX(state[95:88]);
                    state[87:80]   <= S_BOX(state[87:80]);
                    state[79:72]   <= S_BOX(state[79:72]);
                    state[71:64]   <= S_BOX(state[71:64]);
                    state[63:56]   <= S_BOX(state[63:56]);
                    state[55:48]   <= S_BOX(state[55:48]);
                    state[47:40]   <= S_BOX(state[47:40]);
                    state[39:32]   <= S_BOX(state[39:32]);
                    state[31:24]   <= S_BOX(state[31:24]);
                    state[23:16]   <= S_BOX(state[23:16]);
                    state[15:8]    <= S_BOX(state[15:8]);
                    state[7:0]     <= S_BOX(state[7:0]);
                    current_state  <= SHIFTROW;
                end
                SHIFTROW: begin
                    //ROW 1
                    state[119:112] <= state[87:80];
                    state[87:80]   <= state[55:48];
                    state[55:48]   <= state[23:16];
                    state[23:16]   <= state[119:112];
                    //ROW 2
                    state[111:104] <= state[47:40];
                    state[79:72]   <= state[15:8];
                    state[47:40]   <= state[111:104];
                    state[15:8]    <= state[79:72];
                    //ROW 3
                    state[103:96]  <= state[7:0];
                    state[71:64]   <= state[103:96];
                    state[39:32]   <= state[71:64];
                    state[7:0]     <= state[39:32];
                    current_state  <= MIXCOLUMNS_S0;
                end
                MIXCOLUMNS_S0: begin
                    COL_1[31:0]   <= state[127:96];
                    COL_2[31:0]   <= state[95:64];
                    COL_3[31:0]   <= state[63:32];
                    COL_4[31:0]   <= state[31:0];
                    current_state <= MIXCOLUMNS_S1;
                end
                MIXCOLUMNS_S1: begin
                    state[127:120] <= MUL_2(COL_1[31:24]) ^ MUL_3(COL_1[23:16]) ^ COL_1[15:8]        ^ COL_1[7:0];
                    state[119:112] <= COL_1[31:24]        ^ MUL_2(COL_1[23:16]) ^ MUL_3(COL_1[15:8]) ^ COL_1[7:0];
                    state[111:104] <= COL_1[31:24]        ^ COL_1[23:16]        ^ MUL_2(COL_1[15:8]) ^ MUL_3(COL_1[7:0]);
                    state[103:96]  <= MUL_3(COL_1[31:24]) ^ COL_1[23:16]        ^ COL_1[15:8]        ^ MUL_2(COL_1[7:0]);
                    state[95:88]   <= MUL_2(COL_2[31:24]) ^ MUL_3(COL_2[23:16]) ^ COL_2[15:8]        ^ COL_2[7:0];
                    state[87:80]   <= COL_2[31:24]        ^ MUL_2(COL_2[23:16]) ^ MUL_3(COL_2[15:8]) ^ COL_2[7:0];
                    state[79:72]   <= COL_2[31:24]        ^ COL_2[23:16]        ^ MUL_2(COL_2[15:8]) ^ MUL_3(COL_2[7:0]);
                    state[71:64]   <= MUL_3(COL_2[31:24]) ^ COL_2[23:16]        ^ COL_2[15:8]        ^ MUL_2(COL_2[7:0]);
                    state[63:56]   <= MUL_2(COL_3[31:24]) ^ MUL_3(COL_3[23:16]) ^ COL_3[15:8]        ^ COL_3[7:0];
                    state[55:48]   <= COL_3[31:24]        ^ MUL_2(COL_3[23:16]) ^ MUL_3(COL_3[15:8]) ^ COL_3[7:0];
                    state[47:40]   <= COL_3[31:24]        ^ COL_3[23:16]        ^ MUL_2(COL_3[15:8]) ^ MUL_3(COL_3[7:0]);
                    state[39:32]   <= MUL_3(COL_3[31:24]) ^ COL_3[23:16]        ^ COL_3[15:8]        ^ MUL_2(COL_3[7:0]);
                    state[31:24]   <= MUL_2(COL_4[31:24]) ^ MUL_3(COL_4[23:16]) ^ COL_4[15:8]        ^ COL_4[7:0];
                    state[23:16]   <= COL_4[31:24]        ^ MUL_2(COL_4[23:16]) ^ MUL_3(COL_4[15:8]) ^ COL_4[7:0];
                    state[15:8]    <= COL_4[31:24]        ^ COL_4[23:16]        ^ MUL_2(COL_4[15:8]) ^ MUL_3(COL_4[7:0]);
                    state[7:0]     <= MUL_3(COL_4[31:24]) ^ COL_4[23:16]        ^ COL_4[15:8]        ^ MUL_2(COL_4[7:0]);
                    current_state  <= ARK_LOOP;
                end
                ARK_LOOP: begin
                    state         <= state ^ {RAM[pack_RAM_01[5:0]],RAM[pack_RAM_02[5:0]],RAM[pack_RAM_03[5:0]],RAM[pack_RAM_04[5:0]]};
                    count_cipher  <= count_cipher + 1;
                    current_state <= ROUNDKEY;
                end
                SUBBYTES_OP: begin
                    state[127:120] <= S_BOX(state[127:120]);
                    state[119:112] <= S_BOX(state[119:112]);
                    state[111:104] <= S_BOX(state[111:104]);
                    state[103:96]  <= S_BOX(state[103:96]);
                    state[95:88]   <= S_BOX(state[95:88]);
                    state[87:80]   <= S_BOX(state[87:80]);
                    state[79:72]   <= S_BOX(state[79:72]);
                    state[71:64]   <= S_BOX(state[71:64]);
                    state[63:56]   <= S_BOX(state[63:56]);
                    state[55:48]   <= S_BOX(state[55:48]);
                    state[47:40]   <= S_BOX(state[47:40]);
                    state[39:32]   <= S_BOX(state[39:32]);
                    state[31:24]   <= S_BOX(state[31:24]);
                    state[23:16]   <= S_BOX(state[23:16]);
                    state[15:8]    <= S_BOX(state[15:8]);
                    state[7:0]     <= S_BOX(state[7:0]);
                    current_state  <= SHIFTROW_OP;
                end
                SHIFTROW_OP: begin
                    //ROW 1
                    state[119:112] <= state[87:80];
                    state[87:80]   <= state[55:48];
                    state[55:48]   <= state[23:16];
                    state[23:16]   <= state[119:112];
                    //ROW 2
                    state[111:104] <= state[47:40];
                    state[79:72]   <= state[15:8];
                    state[47:40]   <= state[111:104];
                    state[15:8]    <= state[79:72];
                    //ROW 3
                    state[103:96]  <= state[7:0];
                    state[71:64]   <= state[103:96];
                    state[39:32]   <= state[71:64];
                    state[7:0]     <= state[39:32];
                    current_state  <= ARK_OP;
                end
                ARK_OP: begin
                    state <= state ^ {RAM[pack_Nr_01[5:0]],RAM[pack_Nr_02[5:0]],RAM[pack_Nr_03[5:0]],RAM[pack_Nr_04[5:0]]};
                    current_state <= SEND;
                end
                SEND: begin
                    cipher_text_o <= state;
                    done_o        <= 1'b1;
                end
                default: begin
                    done_o <= 0;
                    cipher_text_o <= 128'h0;
                end
            endcase
        end
    end
endmodule : cipher
