module typeAES(
    //inputs
    input logic [1:0] sel_i,
    //outputs
    output logic [3:0] Nb,
    output logic [3:0] Nk,
    output logic [3:0] Nr
);
    parameter AES_128 = 2'b00;
    parameter AES_192 = 2'b01;
    parameter AES_256 = 2'b10;
    //code
    always_comb begin
        case (sel_i)
            AES_128: begin
                Nb = 4;
                Nk = 4;
                Nr = 10;
            end
            AES_192: begin
                Nb = 4;
                Nk = 6;
                Nr = 12;
            end
            AES_256: begin
                Nb = 4;
                Nk = 8;
                Nr = 14;
            end
            default: begin
                Nb = 0;
                Nk = 0;
                Nr = 0;                
            end
        endcase
    end
endmodule : typeAES
