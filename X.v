module X(men, ben, exen, aluop, A, B, readA, readB, rd_outDX, rd_outX, renOmem, readOmem, dataOmem, renWB, readWB, dataWB, select, immediate, target, shamt, aluopfin, Oout, Bout, reset, pcin, benfin);
	// Modules Used: ALU, Mult/Div, Branch
	input men, ben, exen, reset, renOmem, renWB;
	input [4:0] aluop, shamt, readA, readB, readOmem, readWB, rd_outDX;
	input [11:0] pcin;
	input [16:0] immediate;
	input [26:0] target;
	input [31:0] A,B,select, dataOmem, dataWB;

	output benfin;
	output [4:0] aluopfin, rd_outX;
	output [31:0] Oout, Bout;

	// Sign extension of the immediate	
	wire [31:0] ext_immed;
	assign ext_immed[16:0] = immediate;
	assign ext_immed[31:17] = immediate[16] ? 15'b111111111111111:15'b000000000000000;
	
	// Bypass if readA matches readAmem, readB matches readBmem
	wire [31:0] Aby1, Bby1, Aby2, Bby2, A31, B31;
	wire Aby1en, Bby1en, Aby2en, Bby2en;
	
	// Wire of the readA and readB
	wire [31:0] readAext, readBext, readOmemext, readWBext, pcinext, thirtytwobitone, targetext;
	wire Anotequalmem, Bnotequalmem, AnotequalWB, BnotequalWB;
	assign readAext [4:0] = readA;
	assign readBext [4:0] = readB;
	assign readOmemext [4:0] = readOmem;
	assign readWBext [4:0] =  readWB;
	assign pcinext[11:0] = pcin;
	assign readAext [31:5] = 27'b000000000000000000000000000;
	assign readBext [31:5] = 27'b000000000000000000000000000;
	assign readOmemext [31:5] = 27'b000000000000000000000000000;
	assign readWBext [31:5] = 27'b000000000000000000000000000;
	assign pcinext [31:12] = 20'b00000000000000000000;
	
	assign thirtytwobitone = 32'b00000000000000000000000000000001;
	assign targetext [26:0] = target;
	assign targetext[31:27] = 5'b00000;
	
	// Writing PC + 1 to register $31, Jump and Link
	wire [4:0] aluop1;
	assign A31 = select[3] ? pcinext:A;
	assign B31 = select[3] ? thirtytwobitone:B;
	assign aluop1 = select[3] ? 5'b00000:aluop;
	
	// Forwarding from Write to Execute
	subtracter subtracterreadAWB(.A(readAext),.B(readWBext),.c0(1'b0),.isNotEqual(AnotequalWB));
	subtracter subtracterreadBWB(.A(readBext),.B(readWBext),.c0(1'b0),.isNotEqual(BnotequalWB));
	and andby1A(Aby1en, ~AnotequalWB, renWB);
	and andby1B(Bby1en, ~BnotequalWB, renWB);
	assign Aby1 = Aby1en ? dataWB:A31;
	assign Bby1 = Bby1en ? dataWB:B31;
	
	// Forwarding from Memory to Execute
	subtracter subtracterreadAMem(.A(readAext),.B(readOmemext),.c0(1'b0),.isNotEqual(Anotequalmem));
	subtracter subtracterreadBMem(.A(readBext),.B(readOmemext),.c0(1'b0),.isNotEqual(Bnotequalmem));
	and andby2A(Aby2en, ~Anotequalmem, renOmem);
	and andby2B(Bby2en, ~Bnotequalmem, renOmem);
	assign Aby2 = Aby2en ? dataOmem:Aby1;
	assign Bby2 = Bby2en ? dataOmem:Bby1;
	
	// Check if Addi, SW, LW to see if there needs to be an extension to the immediate
	wire imm;
	wire [4:0] aluop2;
	wire [31:0] Aalu, Balu;
	or ori(imm, select[5], select[7], select[8]);
	assign Aalu = Aby2;
	assign Balu = imm ? ext_immed:Bby2;
	
	// If imm, configure the aluop
	assign aluop2 = imm ? 5'b00000:aluop1;
	assign aluopfin = ben ? 5'b00001:aluop2;
	
	wire ne, lt, ovfalu;
	wire [31:0] ALUout;
	alu alu1(.data_operandA(Aalu), .data_operandB(Balu), .ctrl_ALUopcode(aluopfin), .ctrl_shiftamt(shamt), .data_result(ALUout), .isNotEqual(ne), .isLessThan(lt), .overflow(ovfalu));
	
	// Branch Final, if less than and blt, or if not equal and bne
	wire blt, bne, bex;
	and andblt(blt, lt, ben, select[6]);
	and andbne(bne, ne, ben, select[2]);
	and andbex(bex, ne, ben, select[22]);
	or orbenfin(benfin, bne, blt, bex);
	
	// Mult here
	
	// Div here
	
	// Overflow Errors
	wire anyovf;
	wire [5:0] ovferrors;
	assign ovferrors[0] = select[21];
	and andovfadd(ovferrors[1], ~aluopfin[0], ~aluopfin[1], ~aluopfin[2], ~aluopfin[3], ~aluopfin[4], select[0], ovfalu);
	and andovfsub(ovferrors[2], aluopfin[0], ~aluopfin[1], ~aluopfin[2], ~aluopfin[3], ~aluopfin[4], select[0],  ovfalu);
	and andovfaddi(ovferrors[3], select[1], ovfalu);
	
	// Only three right now until implement multdiv, also if setx
	or orovf(anyovf, ovferrors[0], ovferrors[1], ovferrors[2], ovferrors[3], select[21]);
	
	// If ovf, write only to status reg, register 30
	assign rd_outX = anyovf ? 5'b11110:rd_outDX;
	
	wire [31:0] Ooutimm0, Ooutimm1, Ooutimm2, Ooutimm3, Ooutimm4, Ooutimm5;
	assign Ooutimm0 = ovferrors[0] ? targetext:ALUout;
	assign Ooutimm1 = ovferrors[1] ? 32'b00000000000000000000000000000001: Ooutimm0;
	assign Ooutimm2 = ovferrors[2] ? 32'b00000000000000000000000000000010: Ooutimm1;
	assign Ooutimm3 = ovferrors[3] ? 32'b00000000000000000000000000000011: Ooutimm2;
	
	assign Oout = Ooutimm3;
	assign Bout = Bby2;
	
endmodule