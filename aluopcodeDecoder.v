module aluopcodeDecoder(final_out,final_overflow,final_notequal,final_lessthan,int_add, int_sub, int_and, int_or, int_sll, int_sra, int_addovf, int_subovf, int_notequal, int_lessthan, aluop);
	input [31:0] int_add, int_sub, int_and, int_or, int_sll, int_sra;
	input [4:0] aluop;
	input int_addovf, int_subovf, int_notequal, int_lessthan;

	output [31:0] final_out;
	output final_overflow, final_notequal,final_lessthan;
	
	wire [31:0] select;
	
	and and0(select[0], ~aluop[4], ~aluop[3], ~aluop[2], ~aluop[1], ~aluop[0]); // add
	and and1(select[1], ~aluop[4], ~aluop[3], ~aluop[2], ~aluop[1], aluop[0]);  // select
	and and2(select[2], ~aluop[4], ~aluop[3], ~aluop[2], aluop[1], ~aluop[0]);  // and
	and and3(select[3], ~aluop[4], ~aluop[3], ~aluop[2], aluop[1], aluop[0]);   // or
	and and4(select[4], ~aluop[4], ~aluop[3], aluop[2], ~aluop[1], ~aluop[0]);  // sll
	and and5(select[5], ~aluop[4], ~aluop[3], aluop[2], ~aluop[1], aluop[0]);   // sra
	
	assign final_out = select[0] ? int_add:32'bz;
	assign final_out = select[1] ? int_sub:32'bz;
	assign final_out = select[2] ? int_and:32'bz;
	assign final_out = select[3] ? int_or:32'bz;
	assign final_out = select[4] ? int_sll:32'bz;
	assign final_out = select[5] ? int_sra:32'bz;
	
	assign final_overflow = select[0] ? int_addovf:1'bz;
	assign final_overflow = select[1] ? int_subovf:1'bz;
	
	assign final_notequal = select[1] ? int_notequal:1'bz;
	assign final_lessthan = select[1] ? int_lessthan:1'bz;
	
endmodule