module clocktest(clock, dout, dout2);
	input clock;
	
	wire [31:0] din, din2;
	output [31:0] dout, dout2;
	
	genvar i;
	generate
		for(i=0;i<32;i=i+1) begin: loop1
	      dffe a_dffe(din[i], clock, 1'b1, 1'b1, 1'b1, dout[i]);
		   dffe b_dffe(din2[i], clock, 1'b1, 1'b1, 1'b1, dout2[i]);
		end
	endgenerate	
	
	secondmod secondmod(dout, din);
	assign din2 = dout;
	
endmodule

module secondmod(din, dout);
	input din;
	output dout;
	
	assign dout = din + 32'b00000000000000000000000000000001;
	
endmodule