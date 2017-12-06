module convertTrailAddr(ADDR, trail_ADDR);
	input[18:0] ADDR;
	output [11:0] trail_ADDR;
	
	// wire [18:0] X,Y,Xtemp,temp_trail_ADDR, temp_trail_ADDR_1;
	wire [31:0] X,Y,Xtemp,temp_trail_ADDR, temp_trail_ADDR_1;
//	assign X = ADDR%640;
//	assign Y = ADDR/6400;
//	assign Xtemp = X/10;
//	// NOTE HAVE ERROR WHERE IT READS MULTIPLE TIMES ACROSS THE SCREEN
//	assign temp_trail_ADDR_1 = Y*10;
//	assign temp_trail_ADDR = temp_trail_ADDR_1+Xtemp;
	
//	assign X = ADDR%32'd640;
//	assign Y = ADDR/32'd640;
//	assign Xtemp = X/32'd10;
//	// NOTE HAVE ERROR WHERE IT READS MULTIPLE TIMES ACROSS THE SCREEN
//	assign temp_trail_ADDR = Y+Xtemp;

	// NOTE HAVE ERROR WHERE IT READS MULTIPLE TIMES ACROSS THE SCREEN
	
	// If I do this, it does it many, many more times, can't tell if this operation is too fast or slow
	assign temp_trail_ADDR = (ADDR%640)/10+(ADDR/6400)*64;

	//	assign temp_trail_ADDR = ((ADDR%640)+10*ADDR)<<6;

	
	assign trail_ADDR = temp_trail_ADDR[11:0];
endmodule