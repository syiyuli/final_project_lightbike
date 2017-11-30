module convertAddr(startaddr,orient, addr, memAddr);
input[18:0] addr,startaddr;
input[1:0] orient;
output[18:0] memAddr;

wire[18:0] subres, dividend, remainder;
assign subres = addr - startaddr;
assign dividend = subres / 640;
assign remainder = subres%640;
assign memAddr = 900*orient + dividend*30 + remainder;

endmodule