module control_mapping_one(left,right,up,down,keyset);
	input [2:0] keyset;
	output [7:0] left, right, up, down;
	
	// Keyset == 0
	wire [7:0] left0, right0, up0, down0;
	assign left0 = 8'h1c;
	assign right0 = 8'h23;
	assign up0 = 8'h1d;
	assign down0 = 8'h1b;
	
	// Keyset == 1
	wire [7:0] left1, right1, up1, down1;
	assign left1 = keyset==1 ?8'h2b:left0;
	assign right1 = keyset==1  ?8'h33:right0;
	assign up1 = keyset==1 ?8'h2c:up0;
	assign down1 = keyset==1 ?8'h34:down0;
	
	// Keyset == 2
	wire [7:0] left2, right2, up2, down2;
	assign left2 = keyset==2 ?8'h3b:left1;
	assign right2 = keyset==2 ?8'h4b:right1;
	assign up2 = keyset==2 ? 8'h43:up1;
	assign down2 = keyset==2 ? 8'h42:down1;
	
	// Keyset == 3
	wire [7:0] left3, right3, up3, down3;
	assign left = keyset==3 ? 8'h6b:left2;
	assign right = keyset==3 ? 8'h74:right2;
	assign up = keyset==3 ? 8'h75:up2;
	assign down = keyset==3 ? 8'h73:down2;
	
endmodule