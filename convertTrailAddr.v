module convertTrailAddr(ADDR, trail_ADDR);
	input[18:0] ADDR;
	output [10:0] trail_ADDR;
	
	wire [10:0] X,Y,Xtemp,temp_trail_ADDR;
	assign X = ADDR%640;
	assign Y = ADDR/6400;
	assign Xtemp = X/10;
	// NOTE HAVE ERROR WHERE IT READS MULTIPLE TIMES ACROSS THE SCREEN
	assign temp_trail_ADDR = Y*10;
	assign trail_ADDR = temp_trail_ADDR+Xtemp;
	
endmodule