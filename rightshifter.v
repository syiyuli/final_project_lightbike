module rightshifter(shiftedOutput, A, shiftBits);
	input [31:0] A;
	input [4:0] shiftBits;
	output [31:0] shiftedOutput;
	
	wire [31:0] shift1, shift2, shift4, shift8, shift16, intshift1,intshift2,intshift4,intshift8;

	onebitrightshifter onebitrightshifter1(A,shift1);
	assign intshift1 = shiftBits[0] ? shift1 : A;
	
	twobitrightshifter twobitrightshifter2(intshift1,shift2);
	assign intshift2 = shiftBits[1] ? shift2 : intshift1;
	
	fourbitrightshifter fourbitrightshifter4(intshift2,shift4);
	assign intshift4 = shiftBits[2] ? shift4 : intshift2;
	
	eightbitrightshifter eightbitrightshifter8(intshift4,shift8);
	assign intshift8 = shiftBits[3] ? shift8 : intshift4;
	
	sixteenbitrightshifter sixteenbitrightshifter16(intshift8,shift16);
	assign shiftedOutput = shiftBits[4] ? shift16 : intshift8;

endmodule

module onebitrightshifter(A,shiftedOutput);

	input [31:0] A;
	output [31:0] shiftedOutput;
		
	wire s;
	and andend(s,A[31],1'b1);
	and and31(shiftedOutput[31],s,s);
	genvar i;
	generate
		for(i=1;i<32;i=i+1) begin: loop2
			and and1(shiftedOutput[i-1],A[i],1'b1);
		end
	endgenerate
		
endmodule

module twobitrightshifter(A,shiftedOutput);
	input [31:0] A;
	output [31:0] shiftedOutput;
	
	wire s;
	and andend(s,A[31],1'b1);
	and anda(shiftedOutput[31],s,s);
	and andb(shiftedOutput[30],s,s);
	
	genvar i;
	generate
		for(i=2;i<32;i=i+1) begin: loop2
			and and2(shiftedOutput[i-2],A[i],1'b1);
		end
	endgenerate
	
endmodule

module fourbitrightshifter(A,shiftedOutput);
	input [31:0] A;
	output [31:0] shiftedOutput;

	wire s;
	and andend(s,A[31],1'b1);
	and anda(shiftedOutput[31],s,s);
	and andb(shiftedOutput[30],s,s);
	and andc(shiftedOutput[29],s,s);
	and andd(shiftedOutput[28],s,s);
	
	genvar i;
	generate
		for(i=4;i<32;i=i+1) begin: loop3
			and and4(shiftedOutput[i-4],A[i],1'b1);
		end
	endgenerate
	
endmodule

module eightbitrightshifter(A,shiftedOutput);
	input [31:0] A;
	output [31:0] shiftedOutput;
	
	wire s;
	and andend(s,A[31],1'b1);
	and anda(shiftedOutput[31],s,s);
	and andb(shiftedOutput[30],s,s);
	and andc(shiftedOutput[29],s,s);
	and andd(shiftedOutput[28],s,s);
	and ande(shiftedOutput[27],s,s);
	and andf(shiftedOutput[26],s,s);
	and andg(shiftedOutput[25],s,s);
	and andh(shiftedOutput[24],s,s);
	
	genvar i;
	generate
		for(i=8;i<32;i=i+1) begin: loop4
			and and4(shiftedOutput[i-8],A[i],1'b1);
		end
	endgenerate
	
endmodule

module sixteenbitrightshifter(A,shiftedOutput);
	input [31:0] A;
	output [31:0] shiftedOutput;
	
	wire s;
	and andend(s,A[31],1'b1);
	and anda(shiftedOutput[31],s,s);
	and andb(shiftedOutput[30],s,s);
	and andc(shiftedOutput[29],s,s);
	and andd(shiftedOutput[28],s,s);
	and ande(shiftedOutput[27],s,s);
	and andf(shiftedOutput[26],s,s);
	and andg(shiftedOutput[25],s,s);
	and andh(shiftedOutput[24],s,s);
	and andi(shiftedOutput[23],s,s);
	and andj(shiftedOutput[22],s,s);
	and andk(shiftedOutput[21],s,s);
	and andl(shiftedOutput[20],s,s);
	and andm(shiftedOutput[19],s,s);
	and andn(shiftedOutput[18],s,s);
	and ando(shiftedOutput[17],s,s);
	and andp(shiftedOutput[16],s,s);
	
	genvar i;
	generate
		for(i=16;i<32;i=i+1) begin: loop5
			and and4(shiftedOutput[i-16],A[i],1'b1);
		end
	endgenerate
	
endmodule