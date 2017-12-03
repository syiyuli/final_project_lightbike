module checkScreenBound(addr,orient, out);
input[18:0] addr;
input[31:0] orient;
output out;

wire screenTop, screenBot, screenLeft;
	assign screenTop = (orient == 32'b11111111111111111111110110000000 && addr >= 0 && addr < 640) ? 1'b1 : 1'b0;
	assign screenBot = (orient == 32'd640 && addr >= 288000 && addr<=288640) ? 1'b1 : screenTop;
	assign screenLeft = (orient == 32'b11111111111111111111111111111111 && addr%640 == 0) ? 1'b1 : screenBot;
	//right
	assign out = (orient == 32'd1 && addr%640 >= 600) ? 1'b1 : screenLeft;
endmodule 