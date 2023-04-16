`timescale 1ps/1ps
module top ();
    parameter CYC_CLK = 50;
    //create clk
    logic clk_i;
    logic rst_ni;
    logic [1:0] type_AES;
    logic [127:0] plain_text_i;
    logic [255:0] cipher_key_i;
    logic done_o;
    logic [127:0] cipher_text_o; 
    initial begin
        clk_i = 1;
    end
    always #(CYC_CLK/2) clk_i = ~clk_i;
    //driver input:
    initial begin
        type_AES     = 2'b10;
        plain_text_i = 128'h00112233445566778899aabbccddeeff;
        cipher_key_i = 256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
	rst_ni = 1; 
	#20 rst_ni = 0;
	#20 rst_ni = 1;	
    end
    //code
    cipher cipher (
        .clk_i         (clk_i),
        .rst_ni        (rst_ni),
        .ready_i       (1'b1),
        .type_AES      (type_AES),
        .plain_text_i  (plain_text_i),
        .cipher_key_i  (cipher_key_i),
        .done_o        (done_o),
        .cipher_text_o (cipher_text_o)
    );
endmodule : top