module background_detection(background_road_color, current_background_color, addr, bikeLocation_middle, bike_orient, background_detected);
	input [7:0] background_road_color;
	input [7:0] current_background_color;
	input [18:0] addr;
	input [1:0] bike_orient;
	input [18:0] bikeLocation_middle;
	output background_detected;
	
	wire background_detected_left_a, background_detected_left_b, background_detected_right_a,background_detected_right_b, background_detected_up_a, background_detected_up_b, background_detected_down_a, background_detected_down_b;
	
	// If bike is oriented up
	assign background_detected_up_a = (background_road_color!=current_background_color && bike_orient==32'd0 && addr==(bikeLocation_middle-32'd5-(32'd16*32'd640)));
	assign background_detected_up_b = (background_road_color!=current_background_color && bike_orient==32'd0 && addr==(bikeLocation_middle+32'd5-(32'd16*32'd640)));
	
	// If bike is oriented left
	assign background_detected_left_a = (background_road_color!=current_background_color && bike_orient==32'd1 && addr==(bikeLocation_middle-32'd16-(32'd5*32'd640)));
	assign background_detected_left_b = (background_road_color!=current_background_color && bike_orient==32'd1 && addr==(bikeLocation_middle-32'd16+(32'd5*32'd640)));	
	
	// If bike is oriented down
	assign background_detected_down_a = (background_road_color!=current_background_color && bike_orient==32'd2 && addr==(bikeLocation_middle+32'd5+(32'd16*32'd640)));
	assign background_detected_down_b = (background_road_color!=current_background_color && bike_orient==32'd2 && addr==(bikeLocation_middle-32'd5+(32'd16*32'd640)));
	
	// If bike is oriented right
	assign background_detected_right_a = (background_road_color!=current_background_color && bike_orient==32'd3 && addr==(bikeLocation_middle+32'd16-(32'd5*32'd640)));
	assign background_detected_right_b = (background_road_color!=current_background_color && bike_orient==32'd3 && addr==(bikeLocation_middle+32'd16+(32'd5*32'd640)));
	
	or or_edge(background_detected, background_detected_left_a, background_detected_left_b, background_detected_up_a, background_detected_up_b, background_detected_down_a, background_detected_down_b, background_detected_right_a, background_detected_right_b);

endmodule