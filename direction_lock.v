module direction_lock(clock, resetn, crash, current_direction, direction_lock);
	input 			clock, resetn, crash;
	input [2:0]		current_direction;
	output[2:0]	 	direction_lock;

	// Internal Registers
	reg [2:0]			direction_lock;	
	
	always @(posedge clock)
	begin
		if (resetn == 1'b0)
			direction_lock <= 3'd0;
		else if (crash == 1'b1)
			direction_lock <= 3'd5;
	end
	
endmodule