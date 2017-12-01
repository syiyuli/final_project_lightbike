`timescale 1 ns / 100 ps

module processor_tb();
	reg clock, reset;
	wire [11:0] dmem_address;
	wire [31:0] dmem_data_in;
	
	processor processora(clock, reset, dmem_data_in, dmem_address);
	
	initial
	 
    begin
        $display($time, "<< Starting the Simulation >>");
			clock = 1'b0;
			// reset = 1'b1;
			@(negedge clock);
			@(negedge clock);
			@(negedge clock);
			@(negedge clock);
			reset = 1'b1;
			@(negedge clock);
			reset =1'b0;
			@(negedge clock);
			@(negedge clock);
			@(negedge clock);
			@(negedge clock);

			$stop;
	 end
	 
	 // Clock generator
    always
         #20     clock = ~clock;


    
	
endmodule