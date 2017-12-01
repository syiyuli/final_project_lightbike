module typeSelector(select, instruction, jump1en, jump2en, regen, memen, ben, exen, rd, rs, rt, aluop, shamt, immediate, target);
	input [31:0] instruction;
	input [31:0] select; // Decoded Instructions
	//input [3:0]  type;
	
	output jump1en, jump2en, regen, memen, ben, exen;
	output [4:0] aluop, rd, rs, rt, shamt;
	output [26:0] target;
	output [16:0] immediate;
	
	// Common Values
	// assign rd = instruction[26:22];
	wire [4:0] rdnorm;
	assign rdnorm = instruction[26:22];
	assign rd = select[3] ? 5'b11111:rdnorm;
	assign rs = instruction[21:17];
	
	// Don't write at 0, note, select 21 is different because it defaults to setx
	wire regat0;
	and andregat0(regat0, ~rd[0], ~rd[1], ~rd[2], ~rd[3], ~rd[4], ~select[21]);
	
	// 0- R Type instruction, registers
	// 1- J Type, Jump to T
	// 2- I Type, Branch Not Equal
	// 3- JI Type, Jump and Link
	// 4- JII Type, Jump Return
	// 5- I Type, Add Immediate
	// 6- I Type, Branch Less Than
	// 7- I Type, Store Word
	// 8- I Type, Load Word
	// 21- JI Type, Setx
	// 22- JI Type, Bex
	
	// Write to Reg- R, Addi, Jump and Link, Load Word, Sext 
	wire regenimm;
	or orreg(regenimm, select[0], select[3], select[5], select[8], select[21]);
	assign regen = regat0 ? 1'b0:regenimm;
	assign rt = instruction[16:12];
	
	assign shamt = instruction[11:7];
	assign aluop = instruction[6:2];
	
	or ormemen(memen, select[7], select[8]);
	assign immediate = instruction[16:0];
	
	// Branch
	or orben(ben, select[2], select[6], select[22]);
	
	// Jump
	or orjump1en(jump1en,select[1],select[3]);
	assign target = instruction[26:0];

	// Exceptions
	or orexen(exen, select[21], select[22]);
	assign jump2en = select[4];

endmodule