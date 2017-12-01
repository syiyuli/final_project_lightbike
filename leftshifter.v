module leftshifter(shiftedOutput,A,shiftBits);
	input [31:0] A;
	input [4:0] shiftBits;
	
	output [31:0] shiftedOutput;
	
	wire [31:0] shift1, shift2, shift4, shift8, shift16, intshift1,intshift2,intshift4,intshift8;

	onebitleftshifter onebitleftshift1(A,shift1);
	assign intshift1 = shiftBits[0] ? shift1 : A;
	
	twobitleftshifter onebitleftshift2(intshift1,shift2);
	assign intshift2 = shiftBits[1] ? shift2 : intshift1;
	
	fourbitleftshifter onebitleftshift4(intshift2,shift4);
	assign intshift4 = shiftBits[2] ? shift4 : intshift2;
	
	eightbitleftshifter onebitleftshift8(intshift4,shift8);
	assign intshift8 = shiftBits[3] ? shift8 : intshift4;
	
	sixteenbitleftshifter onebitleftshift16(intshift8,shift16);
	assign shiftedOutput = shiftBits[4] ? shift16 : intshift8;
	
endmodule

module onebitleftshifter(A,shiftedOutput);

	input [31:0] A;
	output [31:0] shiftedOutput;
		
	and and0(shiftedOutput[0],1'b0,1'b0);
	genvar i;
	generate
		for(i=1;i<32;i=i+1) begin: loop2
			and and1(shiftedOutput[i],A[i-1],1'b1);
		end
	endgenerate
		
endmodule

module twobitleftshifter(A,shiftedOutput);
	input [31:0] A;
	output [31:0] shiftedOutput;
	
	and anda(shiftedOutput[0],1'b0,1'b0);
	and andb(shiftedOutput[1],1'b0,1'b0);
	
	genvar i;
	generate
		for(i=2;i<32;i=i+1) begin: loop2
			and and2(shiftedOutput[i],A[i-2],1'b1);
		end
	endgenerate
	
endmodule

module fourbitleftshifter(A,shiftedOutput);
	input [31:0] A;
	output [31:0] shiftedOutput;

	and anda(shiftedOutput[0],1'b0,1'b0);
	and andb(shiftedOutput[1],1'b0,1'b0);
	and andc(shiftedOutput[2],1'b0,1'b0);
	and andd(shiftedOutput[3],1'b0,1'b0);
	
	genvar i;
	generate
		for(i=4;i<32;i=i+1) begin: loop3
			and and4(shiftedOutput[i],A[i-4],1'b1);
		end
	endgenerate
	
endmodule

module eightbitleftshifter(A,shiftedOutput);
	input [31:0] A;
	output [31:0] shiftedOutput;
	
	and anda(shiftedOutput[0],1'b0,1'b0);
	and andb(shiftedOutput[1],1'b0,1'b0);
	and andc(shiftedOutput[2],1'b0,1'b0);
	and andd(shiftedOutput[3],1'b0,1'b0);
	and ande(shiftedOutput[4],1'b0,1'b0);
	and andf(shiftedOutput[5],1'b0,1'b0);
	and andg(shiftedOutput[6],1'b0,1'b0);
	and andh(shiftedOutput[7],1'b0,1'b0);
	
	genvar i;
	generate
		for(i=8;i<32;i=i+1) begin: loop4
			and and4(shiftedOutput[i],A[i-8],1'b1);
		end
	endgenerate
	
endmodule

module sixteenbitleftshifter(A,shiftedOutput);
	input [31:0] A;
	output [31:0] shiftedOutput;
	
	and anda(shiftedOutput[0],1'b0,1'b0);
	and andb(shiftedOutput[1],1'b0,1'b0);
	and andc(shiftedOutput[2],1'b0,1'b0);
	and andd(shiftedOutput[3],1'b0,1'b0);
	and ande(shiftedOutput[4],1'b0,1'b0);
	and andf(shiftedOutput[5],1'b0,1'b0);
	and andg(shiftedOutput[6],1'b0,1'b0);
	and andh(shiftedOutput[7],1'b0,1'b0);
	and andi(shiftedOutput[8],1'b0,1'b0);
	and andj(shiftedOutput[9],1'b0,1'b0);
	and andk(shiftedOutput[10],1'b0,1'b0);
	and andl(shiftedOutput[11],1'b0,1'b0);
	and andm(shiftedOutput[12],1'b0,1'b0);
	and andn(shiftedOutput[13],1'b0,1'b0);
	and ando(shiftedOutput[14],1'b0,1'b0);
	and andp(shiftedOutput[15],1'b0,1'b0);
	
	genvar i;
	generate
		for(i=16;i<32;i=i+1) begin: loop5
			and and4(shiftedOutput[i],A[i-16],1'b1);
		end
	endgenerate
	
endmodule