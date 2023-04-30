package myfunction;
//-----------------------------------------------------------
// Function: RCON of AES-128-192-256
//-----------------------------------------------------------
    function automatic logic [31:0] Rcon;
        //inputs
        input [7:0] rcon_sel;
        //code
        case (rcon_sel)
            8'd1:    Rcon[31:0] = 32'h01000000;
            8'd2:    Rcon[31:0] = 32'h02000000;
            8'd3:    Rcon[31:0] = 32'h04000000;
            8'd4:    Rcon[31:0] = 32'h08000000;
            8'd5:    Rcon[31:0] = 32'h10000000;
            8'd6:    Rcon[31:0] = 32'h20000000;
            8'd7:    Rcon[31:0] = 32'h40000000;
            8'd8:    Rcon[31:0] = 32'h80000000;
            8'd9:    Rcon[31:0] = 32'h1b000000;
            8'd10:   Rcon[31:0] = 32'h36000000;
            default: Rcon[31:0] = 32'hFFFFFFFF;
        endcase
    endfunction
//-----------------------------------------------------------
// Function: RotWord of AES-128-192-256
//-----------------------------------------------------------
    function automatic logic [31:0] RotWord;
        //inputs
        input logic [31:0] RW_i;
        //code
        begin
            RotWord[31:24] = RW_i[23:16];
            RotWord[23:16] = RW_i[15:8];
            RotWord[15:8]  = RW_i[7:0];
            RotWord[7:0]   = RW_i[31:24];            
        end
    endfunction
//-----------------------------------------------------------
// Function: SubWord of AES-128-192-256
//-----------------------------------------------------------
    function automatic logic [31:0] SubWord;
        //inputs
        input logic [31:0] SW_i;
        //code
        begin
            SubWord[31:24] = S_BOX(SW_i[31:24]);
            SubWord[23:16] = S_BOX(SW_i[23:16]);
            SubWord[15:8]  = S_BOX(SW_i[15:8]);
            SubWord[7:0]   = S_BOX(SW_i[7:0]);
        end
    endfunction
//-----------------------------------------------------------
// Function: S-Box of AES-128-192-256
//-----------------------------------------------------------
    function automatic logic [7:0] S_BOX;
        //inputs
        input [7:0] sbox_in;
        //code
        case (sbox_in[7:0])
              8'h00:	S_BOX[7:0] = 8'h63;
              8'h01:	S_BOX[7:0] = 8'h7c;
              8'h02:	S_BOX[7:0] = 8'h77;
              8'h03:	S_BOX[7:0] = 8'h7b;
              8'h04:	S_BOX[7:0] = 8'hf2;
              8'h05:	S_BOX[7:0] = 8'h6b;
              8'h06:	S_BOX[7:0] = 8'h6f;
              8'h07:	S_BOX[7:0] = 8'hc5;
              8'h08:	S_BOX[7:0] = 8'h30;
              8'h09:	S_BOX[7:0] = 8'h01;
              8'h0a:	S_BOX[7:0] = 8'h67;
              8'h0b:	S_BOX[7:0] = 8'h2b;
              8'h0c:	S_BOX[7:0] = 8'hfe;
              8'h0d:	S_BOX[7:0] = 8'hd7;
              8'h0e:	S_BOX[7:0] = 8'hab;
              8'h0f:	S_BOX[7:0] = 8'h76;
              //----------------------------
              8'h10:	S_BOX[7:0] = 8'hca;
              8'h11:	S_BOX[7:0] = 8'h82;
              8'h12:	S_BOX[7:0] = 8'hc9;
              8'h13:	S_BOX[7:0] = 8'h7d;
              8'h14:	S_BOX[7:0] = 8'hfa;
              8'h15:	S_BOX[7:0] = 8'h59;
              8'h16:	S_BOX[7:0] = 8'h47;
              8'h17:	S_BOX[7:0] = 8'hf0;
              8'h18:	S_BOX[7:0] = 8'had;
              8'h19:	S_BOX[7:0] = 8'hd4;
              8'h1a:	S_BOX[7:0] = 8'ha2;
              8'h1b:	S_BOX[7:0] = 8'haf;
              8'h1c:	S_BOX[7:0] = 8'h9c;
              8'h1d:	S_BOX[7:0] = 8'ha4;
              8'h1e:	S_BOX[7:0] = 8'h72;
              8'h1f:	S_BOX[7:0] = 8'hc0;
              //----------------------------
              8'h20:	S_BOX[7:0] = 8'hb7;
              8'h21:	S_BOX[7:0] = 8'hfd;
              8'h22:	S_BOX[7:0] = 8'h93;
              8'h23:	S_BOX[7:0] = 8'h26;
              8'h24:	S_BOX[7:0] = 8'h36;
              8'h25:	S_BOX[7:0] = 8'h3f;
              8'h26:	S_BOX[7:0] = 8'hf7;
              8'h27:	S_BOX[7:0] = 8'hcc;
              8'h28:	S_BOX[7:0] = 8'h34;
              8'h29:	S_BOX[7:0] = 8'ha5;
              8'h2a:	S_BOX[7:0] = 8'he5;
              8'h2b:	S_BOX[7:0] = 8'hf1;
              8'h2c:	S_BOX[7:0] = 8'h71;
              8'h2d:	S_BOX[7:0] = 8'hd8;
              8'h2e:	S_BOX[7:0] = 8'h31;
              8'h2f:	S_BOX[7:0] = 8'h15;
              //----------------------------
              8'h30:	S_BOX[7:0] = 8'h04;
              8'h31:	S_BOX[7:0] = 8'hc7;
              8'h32:	S_BOX[7:0] = 8'h23;
              8'h33:	S_BOX[7:0] = 8'hc3;
              8'h34:	S_BOX[7:0] = 8'h18;
              8'h35:	S_BOX[7:0] = 8'h96;
              8'h36:	S_BOX[7:0] = 8'h05;
              8'h37:	S_BOX[7:0] = 8'h9a;
              8'h38:	S_BOX[7:0] = 8'h07;
              8'h39:	S_BOX[7:0] = 8'h12;
              8'h3a:	S_BOX[7:0] = 8'h80;
              8'h3b:	S_BOX[7:0] = 8'he2;
              8'h3c:	S_BOX[7:0] = 8'heb;
              8'h3d:	S_BOX[7:0] = 8'h27;
              8'h3e:	S_BOX[7:0] = 8'hb2;
              8'h3f:	S_BOX[7:0] = 8'h75;
              //----------------------------
              8'h40:	S_BOX[7:0] = 8'h09;
              8'h41:	S_BOX[7:0] = 8'h83;
              8'h42:	S_BOX[7:0] = 8'h2c;
              8'h43:	S_BOX[7:0] = 8'h1a;
              8'h44:	S_BOX[7:0] = 8'h1b;
              8'h45:	S_BOX[7:0] = 8'h6e;
              8'h46:	S_BOX[7:0] = 8'h5a;
              8'h47:	S_BOX[7:0] = 8'ha0;
              8'h48:	S_BOX[7:0] = 8'h52;
              8'h49:	S_BOX[7:0] = 8'h3b;
              8'h4a:	S_BOX[7:0] = 8'hd6;
              8'h4b:	S_BOX[7:0] = 8'hb3;
              8'h4c:	S_BOX[7:0] = 8'h29;
              8'h4d:	S_BOX[7:0] = 8'he3;
              8'h4e:	S_BOX[7:0] = 8'h2f;
              8'h4f:	S_BOX[7:0] = 8'h84;
              //----------------------------
              8'h50:	S_BOX[7:0] = 8'h53;
              8'h51:	S_BOX[7:0] = 8'hd1;
              8'h52:	S_BOX[7:0] = 8'h00;
              8'h53:	S_BOX[7:0] = 8'hed;
              8'h54:	S_BOX[7:0] = 8'h20;
              8'h55:	S_BOX[7:0] = 8'hfc;
              8'h56:	S_BOX[7:0] = 8'hb1;
              8'h57:	S_BOX[7:0] = 8'h5b;
              8'h58:	S_BOX[7:0] = 8'h6a;
              8'h59:	S_BOX[7:0] = 8'hcb;
              8'h5a:	S_BOX[7:0] = 8'hbe;
              8'h5b:	S_BOX[7:0] = 8'h39;
              8'h5c:	S_BOX[7:0] = 8'h4a;
              8'h5d:	S_BOX[7:0] = 8'h4c;
              8'h5e:	S_BOX[7:0] = 8'h58;
              8'h5f:	S_BOX[7:0] = 8'hcf;
              //----------------------------
              8'h60:	S_BOX[7:0] = 8'hd0;
              8'h61:	S_BOX[7:0] = 8'hef;
              8'h62:	S_BOX[7:0] = 8'haa;
              8'h63:	S_BOX[7:0] = 8'hfb;
              8'h64:	S_BOX[7:0] = 8'h43;
              8'h65:	S_BOX[7:0] = 8'h4d;
              8'h66:	S_BOX[7:0] = 8'h33;
              8'h67:	S_BOX[7:0] = 8'h85;
              8'h68:	S_BOX[7:0] = 8'h45;
              8'h69:	S_BOX[7:0] = 8'hf9;
              8'h6a:	S_BOX[7:0] = 8'h02;
              8'h6b:	S_BOX[7:0] = 8'h7f;
              8'h6c:	S_BOX[7:0] = 8'h50;
              8'h6d:	S_BOX[7:0] = 8'h3c;
              8'h6e:	S_BOX[7:0] = 8'h9f;
              8'h6f:	S_BOX[7:0] = 8'ha8;
              //----------------------------
              8'h70:	S_BOX[7:0] = 8'h51;
              8'h71:	S_BOX[7:0] = 8'ha3;
              8'h72:	S_BOX[7:0] = 8'h40;
              8'h73:	S_BOX[7:0] = 8'h8f;
              8'h74:	S_BOX[7:0] = 8'h92;
              8'h75:	S_BOX[7:0] = 8'h9d;
              8'h76:	S_BOX[7:0] = 8'h38;
              8'h77:	S_BOX[7:0] = 8'hf5;
              8'h78:	S_BOX[7:0] = 8'hbc;
              8'h79:	S_BOX[7:0] = 8'hb6;
              8'h7a:	S_BOX[7:0] = 8'hda;
              8'h7b:	S_BOX[7:0] = 8'h21;
              8'h7c:	S_BOX[7:0] = 8'h10;
              8'h7d:	S_BOX[7:0] = 8'hff;
              8'h7e:	S_BOX[7:0] = 8'hf3;
              8'h7f:	S_BOX[7:0] = 8'hd2;
              //----------------------------
              8'h80:	S_BOX[7:0] = 8'hcd;
              8'h81:	S_BOX[7:0] = 8'h0c;
              8'h82:	S_BOX[7:0] = 8'h13;
              8'h83:	S_BOX[7:0] = 8'hec;
              8'h84:	S_BOX[7:0] = 8'h5f;
              8'h85:	S_BOX[7:0] = 8'h97;
              8'h86:	S_BOX[7:0] = 8'h44;
              8'h87:	S_BOX[7:0] = 8'h17;
              8'h88:	S_BOX[7:0] = 8'hc4;
              8'h89:	S_BOX[7:0] = 8'ha7;
              8'h8a:	S_BOX[7:0] = 8'h7e;
              8'h8b:	S_BOX[7:0] = 8'h3d;
              8'h8c:	S_BOX[7:0] = 8'h64;
              8'h8d:	S_BOX[7:0] = 8'h5d;
              8'h8e:	S_BOX[7:0] = 8'h19;
              8'h8f:	S_BOX[7:0] = 8'h73;
              //----------------------------
              8'h90:	S_BOX[7:0] = 8'h60;
              8'h91:	S_BOX[7:0] = 8'h81;
              8'h92:	S_BOX[7:0] = 8'h4f;
              8'h93:	S_BOX[7:0] = 8'hdc;
              8'h94:	S_BOX[7:0] = 8'h22;
              8'h95:	S_BOX[7:0] = 8'h2a;
              8'h96:	S_BOX[7:0] = 8'h90;
              8'h97:	S_BOX[7:0] = 8'h88;
              8'h98:	S_BOX[7:0] = 8'h46;
              8'h99:	S_BOX[7:0] = 8'hee;
              8'h9a:	S_BOX[7:0] = 8'hb8;
              8'h9b:	S_BOX[7:0] = 8'h14;
              8'h9c:	S_BOX[7:0] = 8'hde;
              8'h9d:	S_BOX[7:0] = 8'h5e;
              8'h9e:	S_BOX[7:0] = 8'h0b;
              8'h9f:	S_BOX[7:0] = 8'hdb;
              //----------------------------
              8'ha0:	S_BOX[7:0] = 8'he0;
              8'ha1:	S_BOX[7:0] = 8'h32;
              8'ha2:	S_BOX[7:0] = 8'h3a;
              8'ha3:	S_BOX[7:0] = 8'h0a;
              8'ha4:	S_BOX[7:0] = 8'h49;
              8'ha5:	S_BOX[7:0] = 8'h06;
              8'ha6:	S_BOX[7:0] = 8'h24;
              8'ha7:	S_BOX[7:0] = 8'h5c;
              8'ha8:	S_BOX[7:0] = 8'hc2;
              8'ha9:	S_BOX[7:0] = 8'hd3;
              8'haa:	S_BOX[7:0] = 8'hac;
              8'hab:	S_BOX[7:0] = 8'h62;
              8'hac:	S_BOX[7:0] = 8'h91;
              8'had:	S_BOX[7:0] = 8'h95;
              8'hae:	S_BOX[7:0] = 8'he4;
              8'haf:	S_BOX[7:0] = 8'h79;
              //----------------------------
              8'hb0:	S_BOX[7:0] = 8'he7;
              8'hb1:	S_BOX[7:0] = 8'hc8;
              8'hb2:	S_BOX[7:0] = 8'h37;
              8'hb3:	S_BOX[7:0] = 8'h6d;
              8'hb4:	S_BOX[7:0] = 8'h8d;
              8'hb5:	S_BOX[7:0] = 8'hd5;
              8'hb6:	S_BOX[7:0] = 8'h4e;
              8'hb7:	S_BOX[7:0] = 8'ha9;
              8'hb8:	S_BOX[7:0] = 8'h6c;
              8'hb9:	S_BOX[7:0] = 8'h56;
              8'hba:	S_BOX[7:0] = 8'hf4;
              8'hbb:	S_BOX[7:0] = 8'hea;
              8'hbc:	S_BOX[7:0] = 8'h65;
              8'hbd:	S_BOX[7:0] = 8'h7a;
              8'hbe:	S_BOX[7:0] = 8'hae;
              8'hbf:	S_BOX[7:0] = 8'h08;
              //----------------------------
              8'hc0:	S_BOX[7:0] = 8'hba;
              8'hc1:	S_BOX[7:0] = 8'h78;
              8'hc2:	S_BOX[7:0] = 8'h25;
              8'hc3:	S_BOX[7:0] = 8'h2e;
              8'hc4:	S_BOX[7:0] = 8'h1c;
              8'hc5:	S_BOX[7:0] = 8'ha6;
              8'hc6:	S_BOX[7:0] = 8'hb4;
              8'hc7:	S_BOX[7:0] = 8'hc6;
              8'hc8:	S_BOX[7:0] = 8'he8;
              8'hc9:	S_BOX[7:0] = 8'hdd;
              8'hca:	S_BOX[7:0] = 8'h74;
              8'hcb:	S_BOX[7:0] = 8'h1f;
              8'hcc:	S_BOX[7:0] = 8'h4b;
              8'hcd:	S_BOX[7:0] = 8'hbd;
              8'hce:	S_BOX[7:0] = 8'h8b;
              8'hcf:	S_BOX[7:0] = 8'h8a;
              //----------------------------
              8'hd0:	S_BOX[7:0] = 8'h70;
              8'hd1:	S_BOX[7:0] = 8'h3e;
              8'hd2:	S_BOX[7:0] = 8'hb5;
              8'hd3:	S_BOX[7:0] = 8'h66;
              8'hd4:	S_BOX[7:0] = 8'h48;
              8'hd5:	S_BOX[7:0] = 8'h03;
              8'hd6:	S_BOX[7:0] = 8'hf6;
              8'hd7:	S_BOX[7:0] = 8'h0e;
              8'hd8:	S_BOX[7:0] = 8'h61;
              8'hd9:	S_BOX[7:0] = 8'h35;
              8'hda:	S_BOX[7:0] = 8'h57;
              8'hdb:	S_BOX[7:0] = 8'hb9;
              8'hdc:	S_BOX[7:0] = 8'h86;
              8'hdd:	S_BOX[7:0] = 8'hc1;
              8'hde:	S_BOX[7:0] = 8'h1d;
              8'hdf:	S_BOX[7:0] = 8'h9e;
              //----------------------------
              8'he0:	S_BOX[7:0] = 8'he1;
              8'he1:	S_BOX[7:0] = 8'hf8;
              8'he2:	S_BOX[7:0] = 8'h98;
              8'he3:	S_BOX[7:0] = 8'h11;
              8'he4:	S_BOX[7:0] = 8'h69;
              8'he5:	S_BOX[7:0] = 8'hd9;
              8'he6:	S_BOX[7:0] = 8'h8e;
              8'he7:	S_BOX[7:0] = 8'h94;
              8'he8:	S_BOX[7:0] = 8'h9b;
              8'he9:	S_BOX[7:0] = 8'h1e;
              8'hea:	S_BOX[7:0] = 8'h87;
              8'heb:	S_BOX[7:0] = 8'he9;
              8'hec:	S_BOX[7:0] = 8'hce;
              8'hed:	S_BOX[7:0] = 8'h55;
              8'hee:	S_BOX[7:0] = 8'h28;
              8'hef:	S_BOX[7:0] = 8'hdf;
              //----------------------------
              8'hf0:	S_BOX[7:0] = 8'h8c;
              8'hf1:	S_BOX[7:0] = 8'ha1;
              8'hf2:	S_BOX[7:0] = 8'h89;
              8'hf3:	S_BOX[7:0] = 8'h0d;
              8'hf4:	S_BOX[7:0] = 8'hbf;
              8'hf5:	S_BOX[7:0] = 8'he6;
              8'hf6:	S_BOX[7:0] = 8'h42;
              8'hf7:	S_BOX[7:0] = 8'h68;
              8'hf8:	S_BOX[7:0] = 8'h41;
              8'hf9:	S_BOX[7:0] = 8'h99;
              8'hfa:	S_BOX[7:0] = 8'h2d;
              8'hfb:	S_BOX[7:0] = 8'h0f;
              8'hfc:	S_BOX[7:0] = 8'hb0;
              8'hfd:	S_BOX[7:0] = 8'h54;
              8'hfe:	S_BOX[7:0] = 8'hbb;
              default:	S_BOX[7:0] = 8'h16;
        endcase
    endfunction 
//-----------------------------------------------------------
// Function: MUL-2 and MUL-3 of AES-128-192-256
//-----------------------------------------------------------
    function automatic logic [7:0] MUL_2;
        //inputs
        input logic [7:0] MUL2_in;
        //code
        begin
            MUL_2 = (MUL2_in[7] == 1'b1)?({MUL2_in[6:0],1'b0} ^ 8'b00011011):{MUL2_in[6:0],1'b0};
        end
    endfunction
    function automatic logic [7:0] MUL_3;
        //inputs
        input logic [7:0] MUL3_in;
        //code
        begin
            MUL_3 = MUL_2(MUL3_in[7:0]) ^ MUL3_in[7:0];
        end
    endfunction
endpackage : myfunction
