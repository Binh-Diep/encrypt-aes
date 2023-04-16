//-----------------------Nb--------------Nk------------Nr---------------------------//
//----------------128bit:  4 --- 192bit: 4  --- 256bit: 4---------------------------//
//----------------128bit:  4 --- 192bit: 6  --- 256bit: 8---------------------------//
//----------------128bit: 10 --- 192bit: 12 --- 256bit: 14--------------------------//
module cipher #(parameter SIZE_RAM  = 60,
                          SIZE_DATA = 128,
                          SIZE_KEY  = 256)(
    //inputs
    input logic clk_i,
    input logic rst_ni,
    input logic ready_i,
    input logic [1:0] type_AES,
    input logic [SIZE_DATA-1:0] plain_text_i,
    input logic [SIZE_KEY-1:0] cipher_key_i,
    //outputs
    output logic done_o,
    output logic [SIZE_DATA-1:0] cipher_text_o
);
    import myfunction::*;
    logic round_less_Nr,round_equal_Nr;
    logic index_less_max,index_equal_max;
    logic rem_less_0,rem_less_4,rem_equal_0,rem_equal_4;
    logic Nk_less_4,Nk_less_6,Nk_less_8,Nk_equal_4,Nk_equal_6,Nk_equal_8;
    logic [3:0] round;
    logic [3:0] Nb,Nk,Nr;
    logic [3:0] Nr_add_1,round_add_1;
    logic [4:0] rem_rcon;
    logic [4:0] remainder; 
    logic [5:0] index_ram;
    logic [7:0] quotient;
    logic [7:0] max_index;
    logic [7:0] quo_rcon;
    logic [7:0] index_mul_4,Nr_mul_4;
    logic [7:0] addr01_ram,addr02_ram,addr03_ram,addr04_ram,addr05_ram,addr06_ram,addr07_ram,addr08_ram;
    logic [8:0] index;
    logic [8:0] Nr_add_2,Nr_add_3;
    logic [8:0] index_add_2,index_add_3;
    logic [31:0] COL_1,COL_2,COL_3,COL_4;
    logic [31:0] temp_word;
    logic [31:0] RAM [SIZE_RAM];
    logic [SIZE_DATA-1:0] state;
    logic [SIZE_KEY-1:0] key;
    typedef enum logic [4:0] {
        INIT        = 5'd0,
        WAIT        = 5'd1,
        KEYEX_S0    = 5'd2,
        KEYEX_S1    = 5'd3,
        KEYEX_S2    = 5'd4,
        KEYEX_S3    = 5'd5,
        KEYEX_S4    = 5'd6,
        ARK_INIT    = 5'd7,
        ROUNDKEY    = 5'd8,
        SUBBYTES    = 5'd9,
        SHIFTROW    = 5'd10,
        MIXCOL_S0   = 5'd11,
        MIXCOL_S1   = 5'd12,
        ARK_LOOP    = 5'd13,
        SUBBYTES_OP = 5'd14,
        SHIFTROW_OP = 5'd15,
        ARK_OP      = 5'd16,
        SEND        = 5'd17
    } state_e;
    state_e current_state;
    //module
    typeAES aes(
        .sel_i (type_AES),
        .Nb    (Nb),
        .Nk    (Nk),
        .Nr    (Nr)
    );
    brcomp br_1(
        .operand_a_i ({4'b0,Nk}),
        .operand_b_i (8'h04),
        .less_o      (Nk_less_4),
        .equal_o     (Nk_equal_4)
    );
    brcomp br_2(
        .operand_a_i ({4'b0,Nk}),
        .operand_b_i (8'h06),
        .less_o      (Nk_less_6),
        .equal_o     (Nk_equal_6)
    );
    brcomp br_3(
        .operand_a_i ({4'b0,Nk}),
        .operand_b_i (8'h08),
        .less_o      (Nk_less_8),
        .equal_o     (Nk_equal_8)
    );
    brcomp br_4(
        .operand_a_i ({2'b0,index_ram}),
        .operand_b_i (max_index),
        .less_o      (index_less_max),
        .equal_o     (index_equal_max)
    );
    brcomp br_5(
        .operand_a_i ({4'b0,round}),
        .operand_b_i ({4'b0,(Nr - 1'b1)}),
        .less_o      (round_less_Nr),
        .equal_o     (round_equal_Nr)
    );
    brcomp br_6(
        .operand_a_i ({3'b0,remainder}),
        .operand_b_i (8'h0),
        .less_o      (rem_less_0),
        .equal_o     (rem_equal_0)
    );
    brcomp br_7(
        .operand_a_i ({3'b0,remainder}),
        .operand_b_i (8'h04),
        .less_o      (rem_less_4),
        .equal_o     (rem_equal_4)
    );
    sub_8bit sub(
        .M_i      ({2'b0,index_ram}),
        .N_i      ({4'b0,Nk}),
        .result_o (index)
    );
    mul_4bit mul_1(
        .operand_a_i (Nb),
        .operand_b_i (Nr_add_1),
        .mul_4_o     (max_index)
    );
    mul_4bit mul_2(
        .operand_a_i (round_add_1),
        .operand_b_i (4'h4),
        .mul_4_o     (index_mul_4)
    );
    mul_4bit mul_3(
        .operand_a_i (Nr),
        .operand_b_i (4'h4),
        .mul_4_o     (Nr_mul_4)
    );    
    div_8bit div_1(
        .dividend_i  ({2'b0,index_ram}),
        .divisor_i   (Nk),
        .quotient_o  (quo_rcon),
        .remainder_o (rem_rcon)        
    );
    div_8bit div_2(
        .dividend_i  ({2'b0,index_ram}),
        .divisor_i   (Nk),
        .quotient_o  (quotient),
        .remainder_o (remainder)
    );
    adder_8bit adder_1(
        .M_i      (index_mul_4),
        .N_i      (8'h02),
        .result_o (index_add_2)
    );
    adder_8bit adder_2(
        .M_i      (index_mul_4),
        .N_i      (8'h03),
        .result_o (index_add_3)
    );
    adder_8bit adder_3(
        .M_i      (Nr_mul_4),
        .N_i      (8'h02),
        .result_o (Nr_add_2)
    );
    adder_8bit adder_4(
        .M_i      (Nr_mul_4),
        .N_i      (8'h03),
        .result_o (Nr_add_3)
    );
    //combination
    assign Nr_add_1 = Nr + 1;
    assign round_add_1 = round + 1;
    assign addr01_ram = index_mul_4;
    assign addr02_ram = index_mul_4 + 1;
    assign addr03_ram = index_add_2[7:0];
    assign addr04_ram = index_add_3[7:0];
    assign addr05_ram = Nr_mul_4;
    assign addr06_ram = Nr_mul_4 + 1;
    assign addr07_ram = Nr_add_2[7:0];
    assign addr08_ram = Nr_add_3[7:0];
    //sequence  
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
                    round         <= 0;
                    index_ram     <= 0;
                    current_state <= WAIT;
                end
                WAIT: begin
                    if (ready_i) begin
                        state         <= plain_text_i;
                        key           <= cipher_key_i;
                        current_state <= KEYEX_S0;
                    end
                    else begin
                        current_state <= WAIT;
                    end
                end
                KEYEX_S0: begin
                    RAM[0]        <= key[255:224];
                    RAM[1]        <= key[223:192];
                    RAM[2]        <= key[191:160];
                    RAM[3]        <= key[159:128];
                    RAM[4]        <= key[127:96];
                    RAM[5]        <= key[95:64];
                    RAM[6]        <= key[63:32];
                    RAM[7]        <= key[31:0];
                    index_ram     <= {2'b0,Nk};
                    current_state <= KEYEX_S1;
                end
                KEYEX_S1: begin
                    if (index_less_max & !index_equal_max) begin
                        temp_word <= RAM[index_ram - 1];
                        if (rem_equal_0 & !rem_less_0) begin
                            current_state <= KEYEX_S2;
                        end
                        else if ((Nk_equal_8 & !Nk_less_8) & (!rem_less_4 & rem_equal_4)) begin
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
                KEYEX_S2: begin //index_ram mod Nk = 0
                    temp_word     <= SubWord(RotWord(temp_word)) ^ Rcon(quo_rcon);
                    current_state <= KEYEX_S4;
                end
                KEYEX_S3: begin //Nk > 6 and index_ram mod Nk = 4
                    temp_word     <= SubWord(temp_word);
                    current_state <= KEYEX_S4;
                end
                KEYEX_S4: begin //calculate w[i] = w[i-Nk] ^ temp
                    RAM[index_ram] <= temp_word ^ RAM[index[5:0]];
                    index_ram      <= index_ram + 1;
                    current_state  <= KEYEX_S1; //Check index_ram < (Nb*(Nk+1))
                end
                ARK_INIT: begin
                    state         <= state ^ key[255:128];
                    current_state <= ROUNDKEY;
                end
                ROUNDKEY: begin
                    if (round_less_Nr & !round_equal_Nr) begin
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
                    current_state  <= MIXCOL_S0;
                end
                MIXCOL_S0: begin
                    COL_1[31:0]   <= state[127:96];
                    COL_2[31:0]   <= state[95:64];
                    COL_3[31:0]   <= state[63:32];
                    COL_4[31:0]   <= state[31:0];
                    current_state <= MIXCOL_S1;
                end
                MIXCOL_S1: begin
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
                    state         <= state ^ {RAM[addr01_ram[5:0]],RAM[addr02_ram[5:0]],RAM[addr03_ram[5:0]],RAM[addr04_ram[5:0]]};
                    round         <= round + 1;
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
                    state         <= state ^ {RAM[addr05_ram[5:0]],RAM[addr06_ram[5:0]],RAM[addr07_ram[5:0]],RAM[addr08_ram[5:0]]};
                    current_state <= SEND;
                end
                SEND: begin
                    cipher_text_o <= state;
                    done_o        <= 1'b1;
                end
                default: begin
                    done_o        <= 0;
                    cipher_text_o <= 128'h0;
                end
            endcase
        end
    end
endmodule : cipher
