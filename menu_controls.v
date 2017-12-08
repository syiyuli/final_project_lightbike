module menu_controls(prevmenu, menu_out,ps2_0, ps2_1, ps2_2, ps2_3, ps2_key_pressed, ps2_key_data);
	input ps2_key_pressed;
	input [7:0] ps2_0, ps2_1, ps2_2, ps2_3, ps2_key_data; 
	input [2:0] prevmenu;
	output [2:0] menu_out;
	
	wire [2:0] menu_0, menu_1, menu_2, menu_3;
	assign menu_0 = (ps2_key_pressed && ps2_key_data == ps2_0)? 3'd0:prevmenu;
	assign menu_1 = (ps2_key_pressed && ps2_key_data == ps2_1)? 3'd1:menu_0;
	assign menu_2 = (ps2_key_pressed && ps2_key_data == ps2_2)? 3'd2:menu_1;
	assign menu_out = (ps2_key_pressed && ps2_key_data == ps2_3)? 3'd3:menu_2;

endmodule