module convertBackground(ADDR, background, background_ADDR);
	input[18:0] ADDR;
	input [4:0] background;
	output [13:0] background_ADDR;
	
	wire [4:0] background_sub;
	wire [31:0] temp_background_ADDR, temp_background_ADDR_1;
	// Background of 0 should be for black
	assign background_sub = background;
	assign temp_background_ADDR = (ADDR%640)/10+(ADDR/6400)*64+3072*background_sub;
	assign background_ADDR = temp_background_ADDR[13:0];
endmodule