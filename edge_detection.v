module edge_detection(trail_output, addr, bikeLocation_middle, bike_orient, edge_detected);
	input [3:0] trail_output;
	input [18:0] addr;
	input [2:0] bike_orient;
	input [18:0] bikeLocation_middle;
	output edge_detected;
	
	wire edge_detected_left_a, edge_detected_left_b, edge_detected_right_a,edge_detected_right_b, edge_detected_up_a, edge_detected_up_b, edge_detected_down_a, edge_detected_down_b;
	
	// If bike is oriented up
	assign edge_detected_up_a = (trail_output!=32'd0 && bike_orient==32'd0 && addr==(bikeLocation_middle-32'd5-(32'd16*32'd640)));
	assign edge_detected_up_b = (trail_output!=32'd0 && bike_orient==32'd0 && addr==(bikeLocation_middle+32'd5-(32'd16*32'd640)));
	
	// If bike is oriented left
	assign edge_detected_left_a = (trail_output!=32'd0 && bike_orient==32'd1 && addr==(bikeLocation_middle-32'd16-(32'd5*32'd640)));
	assign edge_detected_left_b = (trail_output!=32'd0 && bike_orient==32'd1 && addr==(bikeLocation_middle-32'd16+(32'd5*32'd640)));	
	
	// If bike is oriented down
	assign edge_detected_down_a = (trail_output!=32'd0 && bike_orient==32'd2 && addr==(bikeLocation_middle+32'd5+(32'd16*32'd640)));
	assign edge_detected_down_b = (trail_output!=32'd0 && bike_orient==32'd2 && addr==(bikeLocation_middle-32'd5+(32'd16*32'd640)));
	
	// If bike is oriented right
	assign edge_detected_right_a = (trail_output!=32'd0 && bike_orient==32'd3 && addr==(bikeLocation_middle+32'd16-(32'd5*32'd640)));
	assign edge_detected_right_b = (trail_output!=32'd0 && bike_orient==32'd3 && addr==(bikeLocation_middle+32'd16+(32'd5*32'd640)));
	
	or or_edge(edge_detected, edge_detected_left_a, edge_detected_left_b, edge_detected_up_a, edge_detected_up_b, edge_detected_down_a, edge_detected_down_b, edge_detected_right_a, edge_detected_right_b);

endmodule