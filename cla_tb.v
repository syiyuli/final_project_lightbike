`timescale 1 ns / 100 ps
module cla_tb();
	reg signed [31:0] A,B;
	wire [31:0] S;
	cla cla1(.S(S),.A(A),.B(B),.c0(1'b0));
	
	initial
	 
    begin
        $display($time, "<< Starting the Simulation >>");
		  $monitor(S);
		  A=32'b00000000000000000000000000000001;
		  B=32'b00000000000000000000000000000000;
		  #200 
		  $stop;
	 end
	 
	 // Clock generator
    // always
    //     #20     clock = ~clock;
	
endmodule