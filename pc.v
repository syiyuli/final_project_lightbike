module pc(next, current, stall, prev, reset, jump1en, jump2en, ben, jumprt, jumpt, N, firstin, firstout, flush);
	input stall, reset, jump1en, jump2en, ben, firstin;
	input [11:0] current, jumprt, jumpt, prev;
	input [16:0] N;
	
	output flush;
	output [11:0] next;
	output [11:0] firstout;
	
	wire redo,pcnotequalzero;
	wire [31:0] signextpc;

	// If pc is equal to 0 and first is 0, repeat one time
	assign signextpc[31:12] = 20'b00000000000000000000;
	assign signextpc[11:0] = current;
	
	subtracter subtracterpc(.A(signextpc),.B(32'b00000000000000000000000000000000),.c0(1'b0),.isNotEqual(pcnotequalzero));
	and andredo(redo,~pcnotequalzero,~firstin);
	
	// firstout becomes one
	assign firstout = redo ? 1'b1:1'b0;
	
	// Sign extensions and computations
	wire [31:0] normnext, securrent, pcbranch, seimmediate;
	wire [11:0] nextimm, nextimm2, nextimm3, nextimm4, nextstall;
	wire pcovf, pc32;
	assign securrent[11:0] = current;
	assign securrent[31:12] = current[11] ? 20'b11111111111111111111:20'b00000000000000000000;
	assign seimmediate [16:0] = N;
	assign seimmediate [31:17] = N[16] ? 15'b111111111111111:15'b000000000000000;
	cla clapcnext(.S(normnext),.Ovf(pcovf),.c32(pc32),.A(securrent),.B(32'b00000000000000000000000000000001),.c0(1'b0));
	cla clapcbranch(.S(pcbranch),.A(securrent),.B(seimmediate),.c0(1'b0));
	
	// Assign next wire
	assign nextimm = jump1en ? jumpt:normnext[11:0]; // Jump to T
	assign nextimm2 = jump2en ? jumprt:nextimm;      // Jump Return
	assign nextimm3 = ben ? pcbranch[11:0]:nextimm2;       // For Branch
	assign nextstall = stall ? prev:nextimm3;        // If need to insert nop
	assign next = redo ? 12'b000000000000:nextstall;
	
	or orj(flush, jump1en, jump2en, ben);
	
endmodule