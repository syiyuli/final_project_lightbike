module F (clock, pcin, instruction);
	// Modules Used: imem, pc
	input clock;
	input [11:0] pcin;
	output [31:0] instruction;
	
	// Use IMEM to gather the instructions
	imem myimem(.address(pcin),.clken(1'b1),.clock(~clock),.q(instruction));
	
endmodule