module opcodeDecoder(select, op);
	input [4:0] op;
	
	output [31:0] select; 
	
	and and0(select[0], ~op[4], ~op[3], ~op[2], ~op[1], ~op[0]); // R Type instruction, registers
	and and1(select[1], ~op[4], ~op[3], ~op[2], ~op[1], op[0]);  // Jump to T, JI Type
	and and2(select[2], ~op[4], ~op[3], ~op[2], op[1], ~op[0]);  // Branch Not Equal, I type
	and and3(select[3], ~op[4], ~op[3], ~op[2], op[1], op[0]);   // Jump and Link, JI Type
	and and4(select[4], ~op[4], ~op[3], op[2], ~op[1], ~op[0]);  // Jump Return, JII Type
	and and5(select[5], ~op[4], ~op[3], op[2], ~op[1], op[0]);   // Add immediate, I type
	and and6(select[6], ~op[4], ~op[3], op[2], op[1], ~op[0]);   // Branch Less Than, I type
	and and7(select[7], ~op[4], ~op[3], op[2], op[1], op[0]);    // Store Word, I type
	and and8(select[8], ~op[4], op[3], ~op[2], ~op[1], ~op[0]);  // Load word, I type
	
	and and21(select[21], op[4], ~op[3], op[2], ~op[1], op[0]);  // setx, JI Type
	and and22(select[22], op[4], ~op[3], op[2], op[1], ~op[0]);  // Bex, JI Type
	
endmodule