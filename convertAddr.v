module convertAddr(startaddr,orient, addr, color, memAddr);
input[18:0] addr,startaddr;
input[1:0] orient;
input [1:0] color;
output[18:0] memAddr;

wire[18:0] subres, dividend, remainder, orientSX;
	assign orientSX[1:0] = orient;
	assign orientSX[18:2] = 1'b0;
	assign subres = addr - startaddr;
	assign dividend = subres / 640;
	assign remainder = subres%640;
	assign memAddr = 900*orientSX + dividend*30 + remainder + 3600*color;

endmodule