	module D(A,B,readA,readB,clock,reset,ren_in,rd_in,data_write,bikeone, bikeoneOrient, biketwo, biketwoOrient, bikethree, bikethreeOrient, bikefour, bikefourOrient, masterSwitch, reg27, bikeoneOrient_IN, biketwoOrient_IN, bikethreeOrient_IN, bikefourOrient_IN,
	background_in, bikeonepowerup_in, biketwopowerup_in, bikethreepowerup_in, bikefourpowerup_in, background_out, bikeonepowerup_out, biketwopowerup_out, bikethreepowerup_out, bikefourpowerup_out	
	);
	input clock, reset, ren_in;

	input [4:0] rd_in, readA, readB;
	input [31:0] data_write, bikeoneOrient_IN, biketwoOrient_IN, bikethreeOrient_IN, bikefourOrient_IN;
	input masterSwitch;
	input [31:0] background_in, bikeonepowerup_in, biketwopowerup_in, bikethreepowerup_in, bikefourpowerup_in;
	output [31:0] background_out, bikeonepowerup_out, biketwopowerup_out, bikethreepowerup_out, bikefourpowerup_out;
	
	output reg27;
	output [31:0] A,B;
	output [31:0] bikeone, bikeoneOrient, biketwo, biketwoOrient, bikethree, bikethreeOrient, bikefour, bikefourOrient;
	
	// If trying to write to reg0, then stop it`
	wire r0, ren_finin;
	and andregat0(r0,~rd_in[0],~rd_in[1],~rd_in[2],~rd_in[3],~rd_in[4]);	
	assign ren_finin = r0 ? 1'b0:ren_in;
	
	// Instantiate the Regfile
// 	regfile regfile1(.clock(~clock), .ctrl_writeEnable(ren_finin), .ctrl_reset(reset), .ctrl_writeReg(rd_in), .ctrl_readRegA(readA), .ctrl_readRegB(readB), .data_writeReg(data_write), .data_readRegA(A),.data_readRegB(B) , .bikeone(bikeone), .bikeoneOrient(bikeoneOrient), .biketwo(biketwo),.biketwoOrient(biketwoOrient),.bikethree(bikethree),.bikethreeOrient(bikethreeOrient),.bikefour(bikefour),.bikefourOrient(bikefourOrient),.masterSwitch(masterSwitch),.reg27(reg27), .bikeoneOrient_IN(bikeoneOrient_IN), .biketwoOrient_IN(biketwoOrient_IN), .bikethreeOrient_IN(bikethreeOrient_IN), .bikefourOrient_IN(bikefourOrient_IN));
	regfile regfile1(.clock(~clock),
							.ctrl_writeEnable(ren_finin), 
							.ctrl_reset(reset), 
							.ctrl_writeReg(rd_in), 
							.ctrl_readRegA(readA), 
							.ctrl_readRegB(readB), 
							.data_writeReg(data_write), 
							.data_readRegA(A),
							.data_readRegB(B),
							.bikeone(bikeone),
							.bikeoneOrient(bikeoneOrient), 
							.biketwo(biketwo),
							.biketwoOrient(biketwoOrient),
							.bikethree(bikethree),
							.bikethreeOrient(bikethreeOrient),
							.bikefour(bikefour),
							.bikefourOrient(bikefourOrient),
							.masterSwitch(masterSwitch),
							.reg27(reg27), 
							.bikeoneOrient_IN(bikeoneOrient_IN), 
							.biketwoOrient_IN(biketwoOrient_IN), 
							.bikethreeOrient_IN(bikethreeOrient_IN), 
							.bikefourOrient_IN(bikefourOrient_IN),
							.background_in(background_in),
							.bikeonepowerup_in(bikeonepowerup_in),
							.biketwopowerup_in(biketwopowerup_in),
							.bikethreepowerup_in(bikethreepowerup_in),
							.bikefourpowerup_in(bikefourpowerup_in),
							.background_out(background_out),
							.bikeonepowerup_out(bikeonepowerup_out),
							.biketwopowerup_out(biketwopowerup_out),
							.bikethreepowerup_out(bikethreepowerup_out),
							.bikefourpowerup_out(bikefourpowerup_out)
							);

endmodule 