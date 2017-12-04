module bike_controls(bikeleft, bikeright, bikeup, bikedown, ps2_left, ps2_right, ps2_up, ps2_down, ps2_key_pressed, ps2_key_data);
	input ps2_key_pressed;
	input [7:0] ps2_left, ps2_right, ps2_up, ps2_down, ps2_key_data; 
	output bikeleft, bikeright, bikeup, bikedown;
	
	assign bikeleft = (ps2_key_pressed && ps2_key_data == ps2_left)? 1'b1:1'b0;
	assign bikeright = (ps2_key_pressed && ps2_key_data == ps2_right)? 1'b1:1'b0;
	assign bikeup = (ps2_key_pressed && ps2_key_data == ps2_up)? 1'b1:1'b0;
	assign bikedown = (ps2_key_pressed && ps2_key_data == ps2_down)? 1'b1:1'b0;
endmodule