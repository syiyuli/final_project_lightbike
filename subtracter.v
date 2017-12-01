module subtracter(S,Ovf,c32,A,B,c0,isNotEqual,isLessThan);
	input [31:0] A, B;
	input c0;
	
	output [31:0] S;
	output Ovf,c32,isNotEqual,isLessThan;
	
	// Invert the bits for B and set the carry in to one
	cla clasub(S,Ovf,c32,A,~B,1'b1);
	
	// If A-B=0, then Ovf, c32 and S should be zero
	or orzero(isNotEqual,S[31],S[30],S[29],S[28],S[27],S[26],S[25],S[24],S[23],S[22],S[21],S[20],S[19],S[18],S[17],S[16],S[15],S[14],S[13],S[12],S[11],S[10],S[9],S[8],S[7],S[6],S[5],S[4],S[3],S[2],S[1],S[0]);
	
	// Is Less Than
	or orlessthan(isLessThan,S[31],Ovf);
	
endmodule