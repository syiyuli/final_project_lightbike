module convertAddr(startaddr,orient, addr, color, memAddr);	
	input[18:0] addr,startaddr;
	input[2:0] orient;	
	input [2:0] color;
	output[18:0] memAddr;

	wire[18:0] subres, dividend, remainder, orientSX, memAddrBike, memAddrCrash;
	assign orientSX[2:0] = orient;
	assign orientSX[18:3] = 1'b0;
	assign subres = addr - startaddr;
	assign dividend = subres / 640;
	assign remainder = subres%640;
	assign memAddrBike = 900*orientSX + dividend*30 + remainder + 3600*color;
	
	assign memAddrCrash = 19'd14400 + dividend*30 + remainder;
	assign memAddr = orient==32'd5 ? memAddrCrash:memAddrBike;


endmodule