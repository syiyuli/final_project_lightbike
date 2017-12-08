module control_mapping_four(left,right,up,down,keyset);
	input [2:0] keyset;
	output [7:0] left, right, up, down;
	
	// Keyset == 0
	wire [7:0] left0, right0, up0, down0;
	assign left0 = keyset==0?8'h1c:left3;
	assign right0 = keyset==0?8'h23:right3;
	assign up0 = keyset==0?8'h1d:up3;
	assign down0 = keyset==0?8'h1b:down3;
	
	// Keyset == 1
	wire [7:0] left1, right1, up1, down1;
	assign left1 = keyset==1 ?8'h2b:left0;
	assign right1 = keyset==1  ?8'h33:right0;
	assign up1 = keyset==1 ?8'h2c:up0;
	assign down1 = keyset==1 ?8'h34:down0;
	
	// Keyset == 2
	wire [7:0] left2, right2, up2, down2;
	assign left = keyset==2 ?8'h3b:left1;
	assign right = keyset==2 ?8'h4b:right1;
	assign up = keyset==2 ? 8'h43:up1;
	assign down = keyset==2 ? 8'h42:down1;
	
	// Keyset == 3
	wire [7:0] left3, right3, up3, down3;
	assign left3 = 8'h6b;
	assign right3 = 8'h74;
	assign up3 = 8'h75;
	assign down3 = 8'h73;
	
endmodule