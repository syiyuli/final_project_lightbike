module convertAddr(startaddr, addr, memAddr);
input[18:0] addr,startaddr;
output[18:0] memAddr;

wire[18:0] subres, dividend, remainder;
assign subres = addr - startaddr;
assign dividend = subres / 640;
assign remainder = subres%640;
assign memAddr = dividend*30 + remainder + dividend;
endmodule