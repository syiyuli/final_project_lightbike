	module D(A,B,readA,readB,clock,reset,ren_in,rd_in,data_write,bikeblue, bikeblueOrient, masterSwitch,reg27);
	input clock, reset, ren_in;
	input [4:0] rd_in, readA, readB;
	input [31:0] data_write;
	input masterSwitch;
	
	output reg27;
	output [31:0] A,B;
	output [31:0] bikeblue, bikeblueOrient;
	
	// If trying to write to reg0, then stop it`
	wire r0, ren_finin;
	and andregat0(r0,~rd_in[0],~rd_in[1],~rd_in[2],~rd_in[3],~rd_in[4]);	
	assign ren_finin = r0 ? 1'b0:ren_in;
	
	// Instantiate the Regfile
	regfile regfile1(.clock(~clock), .ctrl_writeEnable(ren_finin), .ctrl_reset(reset), .ctrl_writeReg(rd_in), .ctrl_readRegA(readA), .ctrl_readRegB(readB), .data_writeReg(data_write), .data_readRegA(A),.data_readRegB(B) , .bikeblue(bikeblue), .bikeblueOrient(bikeblueOrient),.masterSwitch(masterSwitch),.reg27(reg27));
	
endmodule