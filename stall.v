module stall(stall, lw, rdprev, instruction, j1en, j2en, ren, men, ben, exen, aluop, shamt, rd_out, readA, readB, immediate, target, select, flush);
	input lw, flush;
	input [4:0] rdprev;
	input [31:0] instruction;
	
	output stall, j1en, j2en, ren, men, ben, exen;
	output [4:0] aluop, shamt, rd_out, readA, readB;
	output [16:0] immediate;
	output [26:0] target;
	output [31:0] select;
			
	wire j1enimm, j2enimm, renimm, menimm, benimm, exenimm;
	wire [31:0] selectimm;
	
	opcodeDecoder oD1(.select(selectimm), .op(instruction[31:27]));
	
	// Decode the instruction
	wire [4:0] rs, rt;
	typeSelector typeSelector1(.select(selectimm), .instruction(instruction), .jump1en(j1enimm), .jump2en(j2enimm), .regen(renimm), .memen(menimm), .ben(benimm), .exen(exenimm), .rd(rd_out), .rs(rs), .rt(rt), .aluop(aluop), .shamt(shamt), .immediate(immediate), .target(target));
	
	// Logic to allow for reading in RD as well as RS and RT
	rsselector rsselector1(men, ben, exen, j2en, rs, rt, rd_out, readA, readB);
	
	wire AnotequalPrev, BnotequalPrev, isequal;
	wire [31:0] readAext, readBext, rdprevext;
	assign readAext[31:5] = 27'b000000000000000000000000000;
	assign readBext[31:5] = 27'b000000000000000000000000000;
	assign rdprevext[31:5] = 27'b000000000000000000000000000;
	assign readAext[4:0] = readA;
	assign readBext[4:0] = readB;
	assign rdprevext[4:0] = rdprev;
	
	subtracter subtracterrs1stall(.A(readAext),.B(rdprevext),.c0(1'b0),.isNotEqual(AnotequalPrev));
	subtracter subtracterrs2stall(.A(readBext),.B(rdprevext),.c0(1'b0),.isNotEqual(BnotequalPrev));
	
	wire sf; //stall or flush
	or orisequal(isequal, ~AnotequalPrev, ~BnotequalPrev);
	and andstall(stall, isequal, lw);
	or orstallorflush(sf, stall, flush);
	
	/*assign ren = stall ? 1'b0:renimm;
	assign j1en = stall ? 1'b0:j1enimm;
	assign j2en = stall ? 1'b0:j2enimm;
	assign men = stall ? 1'b0:menimm;
	assign ben = stall ? 1'b0:benimm;
	assign exen = stall ? 1'b0:exenimm;
	assign select = stall ? 32'b00000000000000000000000000000000:selectimm;
	*/
	
	assign ren = sf ? 1'b0:renimm;
	assign j1en = sf ? 1'b0:j1enimm;
	assign j2en = sf ? 1'b0:j2enimm;
	assign men = sf ? 1'b0:menimm;
	assign ben = sf ? 1'b0:benimm;
	assign exen = sf ? 1'b0:exenimm;
	assign select = sf ? 32'b00000000000000000000000000000000:selectimm;
endmodule