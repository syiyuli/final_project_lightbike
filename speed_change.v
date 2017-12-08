module speed_change(prevspeed, speed_out, ps2_0, ps2_1, ps2_2, ps2_3, ps2_key_pressed, ps2_key_data);
	input ps2_key_pressed;
	input [31:0] prevspeed;
	input [7:0] ps2_0, ps2_1, ps2_2, ps2_3, ps2_key_data;
	output [31:0] speed_out;
	
	wire [31:0] speed_0, speed_1, speed_2, speed_3;
	assign speed_0 = (ps2_key_pressed && ps2_key_data == ps2_0)? 32'd0:prevspeed;
	assign speed_1 = (ps2_key_pressed && ps2_key_data == ps2_1)? 32'd1:speed_0;
	assign speed_2 = (ps2_key_pressed && ps2_key_data == ps2_2)? 32'd2:speed_1;
	assign speed_out = (ps2_key_pressed && ps2_key_data == ps2_3)? 32'd3:speed_2;

endmodule