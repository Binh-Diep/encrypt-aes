module testtop;

reg [3:0] X,Y;
wire [3:0] S;
wire Cout;

adder_4bit adder_inst(X,Y,S,Cout);
//adder_4bit adder_inst( .X(X), .Y(Y), .S(S), .Cout(Cout));

initial begin
	X=4'b0000; Y=4'b0000; #10
	X=4'b0110; Y=4'b1100; #10
	X=4'b1100; Y=4'b0101; #10
	X=4'b1010; Y=4'b0010; #10
	#100;
	$finish;	
end

always @(X or Y) begin
	#1;
	$display("%t Nhi phan: X = %b, Y = %b, Cout = %b, S = %b",$time,X,Y,Cout,S);
	$display("%t Thap phan: X = %d, Y = %d, {Cout,S} = %d",$time,X,Y,{Cout,S});
end

endmodule
