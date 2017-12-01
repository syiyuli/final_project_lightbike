`timescale 1 ns / 100 ps

module D_tb();
		reg signed [4:0] rd_in;
		reg signed [31:0] data_write;
		reg signed [11:0] pc;
		reg signed [31:0] instruction;
		reg signed [31:0] valuein;
		reg clock, ren_in, reset;
		wire j1en, j2en, ren_out, men, ben, exen;
		wire signed[31:0] A,B;
		wire [4:0] aluop, shamt, rd_out;
		wire [16:0] immediate;
		wire [26:0] target;
		wire [31:0] select;
		D myD (A, B, select, j1en, j2en, ren_out, men, ben, exen, ren_in, rd_in, clock, instruction, data_write, reset, aluop, shamt, rd_out, immediate, target);
	 integer errors;
	 integer index;
	 
	 initial

    begin
        $display($time, "<< Starting the Simulation >>");
		  $monitor(A,B, select);
		  clock = 1'b0;    // at time 0
        errors = 0;
		  instruction = 32'b00000000000000000000000000000000;
		  
		  reset = 1'b1;    // assert reset
        @(negedge clock);    // wait until next negative edge of clock
        @(negedge clock);    // wait until next negative edge of clock

        reset = 1'b0;    // de-assert reset
        @(negedge clock);    // wait until next negative edge of clock

		  @(negedge clock);
		  writeRegister(1,00000000000000000000000000000001);
		  checkRegister(1,00000000000000000000000000000001);
		  
		  @(negedge clock);
		  writeRegister(1,00000000000000000000000000000010);
		  instruction = 32'b00100000010000100000000000000001;
		  
		  @(negedge clock);
		  instruction = 32'b00100000010000100000000000000001;
		  // Check if Registers write properly
		  // valuein= 32'b00000000000000000000000000000000;
		  // Begin testing...(loop over registers)
        // for(index = 0; index <= 31; index = index + 1) begin
		      // valuein=valuein+32'b00000000000000000000000000000001;
            // writeRegister(index, 32'h0000DEAD);
            // checkRegister(index, 32'h0000DEAD);
				// writeRegister(index, valuein);
            // checkRegister(index, valuein);
        // end
		  $stop;
	 end
	 
	 // Clock generator
    always
         #10     clock = ~clock;
	 
	 
	 // Task for writing
    task writeRegister;

        input [4:0] writeReg;
        input [31:0] value;

        begin
            @(negedge clock);    // wait for next negedge of clock
            $display($time, " << Writing register %d with %h >>", writeReg, value);

            ren_in = 1'b1;
            rd_in = writeReg;
            data_write = value;

            @(negedge clock); // wait for next negedge, write should be done
            ren_in = 1'b0;
        end
    endtask	
			  
	 // Task for reading
    task checkRegister;

        input [4:0] checkReg;
        input [31:0] exp;

        begin
            @(negedge clock);    // wait for next negedge of clock

            instruction[21:17] = checkReg;    // test port A
            instruction[16:12] = checkReg;    // test port B

            @(negedge clock); // wait for next negedge, read should be done
				$display(A);
				$display(B);
				
            if(A !== exp) begin
                $display("**Error on port A: read %h but expected %h.", A, exp);
                errors = errors + 1;
            end

            if(B !== exp) begin
                $display("**Error on port B: read %h but expected %h.", B, exp);
                errors = errors + 1;
            end
        end
    endtask
			
endmodule