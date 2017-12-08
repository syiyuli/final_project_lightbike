module bgr_detection(background, background_data, addr, bikeLocation_middle, bike_orient, edge_detected);
	input [4:0] background;
	input [18:0] addr;
	input [2:0] bike_orient;
	input [18:0] bikeLocation_middle;
	input [23:0] background_data;
	output edge_detected;
	
	wire bgr_out;
	assign bgr_out = (background==5'd0 && background_data!=24'h000000) || 
							(background==5'd1 && background_data!=24'h000000) ||
							(background==5'd2 && background_data!=24'h0C1530) ||
							(background==5'd3 && background_data!=24'h3A3A3A) ||
							(background==5'd4 && background_data!=24'h121428);
	
	
	wire edge_detected_left_a, edge_detected_left_b, edge_detected_right_a,edge_detected_right_b, edge_detected_up_a, edge_detected_up_b, edge_detected_down_a, edge_detected_down_b, edge_detected_dead;
	
//	// If bike is oriented up
	assign edge_detected_up_a = (bgr_out!=0 && bike_orient==32'd0 && addr==(bikeLocation_middle-32'd5-(32'd16*32'd640)));
	assign edge_detected_up_b = (bgr_out!=0 && bike_orient==32'd0 && addr==(bikeLocation_middle+32'd5-(32'd16*32'd640)));
	
	// If bike is oriented left
	assign edge_detected_left_a = (bgr_out!=0 && bike_orient==32'd1 && addr==(bikeLocation_middle-32'd16-(32'd5*32'd640)));
	assign edge_detected_left_b = (bgr_out!=0 && bike_orient==32'd1 && addr==(bikeLocation_middle-32'd16+(32'd5*32'd640)));	
	
	// If bike is oriented down
	assign edge_detected_down_a = (bgr_out!=0 && bike_orient==32'd2 && addr==(bikeLocation_middle+32'd5+(32'd16*32'd640)));
	assign edge_detected_down_b = (bgr_out!=0 && bike_orient==32'd2 && addr==(bikeLocation_middle-32'd5+(32'd16*32'd640)));

// If bike is oriented right
	assign edge_detected_right_a = (bgr_out!=0 && bike_orient==32'd3 && addr==(bikeLocation_middle+32'd16-(32'd5*32'd640)));
	assign edge_detected_right_b = (bgr_out!=0 && bike_orient==32'd3 && addr==(bikeLocation_middle+32'd16+(32'd5*32'd640)));
		
	or or_edge(edge_detected, edge_detected_left_a, edge_detected_left_b, edge_detected_up_a, edge_detected_up_b, edge_detected_down_a, edge_detected_down_b, edge_detected_right_a, edge_detected_right_b);
	
	endmodule 