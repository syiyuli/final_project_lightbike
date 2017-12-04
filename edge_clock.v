module edge_clock(clock, resetn, edge_detected, clock_data);
	input 			clock, resetn, edge_detected;
	output		 	clock_data;

	// Internal Registers
	reg			clock_data;	
	
	always @(posedge clock)
	begin
		if (resetn == 1'b0)
			clock_data <= 1'b0;
		else if (edge_detected == 1'b1)
			clock_data <= 1'b1;
	end
	
endmodule