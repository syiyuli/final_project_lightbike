module convertNumbers(ADDR, startaddr, numbers_location, number);
	input[18:0] ADDR, startaddr;
	input [2:0] number;
	output[18:0] numbers_location;

	wire[18:0] subres, dividend, remainder;
	assign subres = ADDR - startaddr;
	assign dividend = subres/640;
	assign remainder = subres%640;
	assign numbers_location = 2000*number + dividend*40 + remainder;

endmodule