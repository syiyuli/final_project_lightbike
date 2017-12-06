module background_controls(prevbackground, background_out,ps2_0, ps2_1, ps2_2, ps2_3, ps2_4, ps2_key_pressed, ps2_key_data);
	input ps2_key_pressed;
	input [7:0] ps2_0, ps2_1, ps2_2, ps2_3, ps2_4, ps2_key_data; 
	input [31:0] prevbackground;
	output [31:0] background_out;
	
	wire [31:0] background_0, background_1, background_2, background_3, background5;
	assign background_0 = (ps2_key_pressed && ps2_key_data == ps2_0)? 32'd0:prevbackground;
	assign background_1 = (ps2_key_pressed && ps2_key_data == ps2_1)? 32'd1:background_0;
	assign background_2 = (ps2_key_pressed && ps2_key_data == ps2_2)? 32'd2:background_1;
	assign background_3 = (ps2_key_pressed && ps2_key_data == ps2_3)? 32'd3:background_2;
	assign background_out = (ps2_key_pressed && ps2_key_data == ps2_4)? 32'd4:background_3;

endmodule