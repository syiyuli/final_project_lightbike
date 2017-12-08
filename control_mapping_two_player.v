module control_mapping_two_player(left,right,up,down,keyset);
	input [2:0] keyset;
	output [7:0] left, right, up, down;
	
	// Keyset == 1
	wire [7:0] left0, right0, up0, down0;
	assign left0 = keyset==1?8'h1c:left1;
	assign right0 = keyset==1?8'h23:right1;
	assign up0 = keyset==1?8'h1d:up1;
	assign down0 = keyset==1?8'h1b:down1;
	
	// Keyset == 2
	wire [7:0] left1, right1, up1, down1;
	assign left1 = 8'h2b;
	assign right1 = 8'h33;
	assign up1 = 8'h2c;
	assign down1 = 8'h34;
	
	// Keyset == 3
	wire [7:0] left2, right2, up2, down2;
	assign left2 = keyset==3 ?8'h3b:left0;
	assign right2 = keyset==3 ?8'h4b:right0;
	assign up2 = keyset==3 ? 8'h43:up0;
	assign down2 = keyset==4 ? 8'h42:down0;
	
	// Keyset == 4
	wire [7:0] left3, right3, up3, down3;
	assign left = keyset==4 ? 8'h6b:left2;
	assign right = keyset==4 ? 8'h74:right2;
	assign up = keyset==4 ? 8'h75:up2;
	assign down = keyset==4 ? 8'h73:down2;
	
endmodule