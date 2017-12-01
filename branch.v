module branch(ben, lt, ne, pc, pcout, N);
	input lt, ne, ben;
	input [11:0] pc;
	input [31:0] N;
	
	output [11:0] pcout;
	
	wire [11:0] pcoutbranch;
	wire [31:0] sepc;
	
	// Sign extend the PC
	assign sepc[11:0] = pc;
	assign sepc[31:12] = N[11] ? 20'b111111111111111:20'b000000000000000;
	cla clabranch(.S(pcoutbranch),.A(sepc),.B(N),.c0(1'b1));

	wire [11:0] pcoutimm;
	wire bne,blt;
	and andbne(bne,ne, ben);
	and andblt(blt,lt, ben);
	// bne should be the selector bit 2 and blt should be selector bit 6
	// If bne is true, PC = PC + 1 + N
	// assign pcoutimm = bne ? pcoutbranch[11:0]:pc;
	// assign pcout = blt ? pcoutbranch[11:0]:pcoutimm;
	
endmodule