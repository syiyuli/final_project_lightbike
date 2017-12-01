module eightcla(S,PG,GG,A,B,Cin,Cmsb);
	input [7:0] A,B;
	input Cin;
	
	output [7:0] S;
	output Cmsb;
	output PG,GG;
	wire [7:0] P,G,C;
	
	// generate and propagate
	and andg0(G[0],A[0],B[0]);
	and andg1(G[1],A[1],B[1]);
	and andg2(G[2],A[2],B[2]);
	and andg3(G[3],A[3],B[3]);
	and andg4(G[4],A[4],B[4]);
	and andg5(G[5],A[5],B[5]);
	and andg6(G[6],A[6],B[6]);
	and andg7(G[7],A[7],B[7]);
	
	xor xorp0(P[0],A[0],B[0]);
	xor xorp1(P[1],A[1],B[1]);
	xor xorp2(P[2],A[2],B[2]);
	xor xorp3(P[3],A[3],B[3]);
	xor xorp4(P[4],A[4],B[4]);
	xor xorp5(P[5],A[5],B[5]);
	xor xorp6(P[6],A[6],B[6]);
	xor xorp7(P[7],A[7],B[7]);
	
	// carry bits
	and andc(C[0],Cin,1'b1);
	
	// carry 1
	wire intc1;
	and andc1(intc1,P[0],C[0]);
	or  orc1(C[1],G[0],intc1);
	
	// carry 2
	wire intc2a;
	wire intc2b;
	
	and andc2a(intc2a,P[1],P[0],C[0]);
	and andc2b(intc2b,P[1],G[0]);
	or  orc2(C[2],G[1],intc2a,intc2b);
	
	// carry 3
	wire intc3a;
	wire intc3b;
	wire intc3c;
	
	and andc3a(intc3a,P[2],P[1],P[0],C[0]);
	and andc3b(intc3b,P[2],P[1],G[0]);
	and andc3c(intc3c,P[2],G[1]);
	or  orc3(C[3],G[2],intc3a,intc3b,intc3c);
	
	// carry 4
	wire intc4a;
	wire intc4b;
   wire intc4c;
	wire intc4d;
	
	and andc4a(intc4a,P[3],P[2],P[1],P[0],C[0]);
	and andc4b(intc4b,P[3],P[2],P[1],G[0]);
	and andc4c(intc4c,P[3],P[2],G[1]);
	and andc4d(intc4d,P[3],G[2]);
	or  orc4(C[4],G[3],intc4a,intc4b,intc4c,intc4d);
	
	// carry 5
	wire intc5a;
	wire intc5b;
   wire intc5c;
	wire intc5d;
	wire intc5e;
	
	and andc5a(intc5a,P[4],P[3],P[2],P[1],P[0],C[0]);
	and andc5b(intc5b,P[4],P[3],P[2],P[1],G[0]);
	and andc5c(intc5c,P[4],P[3],P[2],G[1]);
	and andc5d(intc5d,P[4],P[3],G[2]);
	and andc5e(intc5e,P[4],G[3]);
	or  orc5(C[5],G[4],intc5a,intc5b,intc5c,intc5d,intc5e);
	
	// carry 6
	wire intc6a;
	wire intc6b;
   wire intc6c;
	wire intc6d;
	wire intc6e;
	wire intc6f;
	
	and andc6a(intc6a,P[5],P[4],P[3],P[2],P[1],P[0],C[0]);
	and andc6b(intc6b,P[5],P[4],P[3],P[2],P[1],G[0]);
	and andc6c(intc6c,P[5],P[4],P[3],P[2],G[1]);
	and andc6d(intc6d,P[5],P[4],P[3],G[2]);
	and andc6e(intc6e,P[5],P[4],G[3]);
	and andc6f(intc6f,P[5],G[4]);
	or  orc6(C[6],G[5],intc6a,intc6b,intc6c,intc6d,intc6e,intc6f);

	// carry 7
	wire intc7a;
	wire intc7b;
   wire intc7c;
	wire intc7d;
	wire intc7e;
	wire intc7f;
	wire intc7g;
	
	and andc7a(intc7a,P[6],P[5],P[4],P[3],P[2],P[1],P[0],C[0]);
	and andc7b(intc7b,P[6],P[5],P[4],P[3],P[2],P[1],G[0]);
	and andc7c(intc7c,P[6],P[5],P[4],P[3],P[2],G[1]);
	and andc7d(intc7d,P[6],P[5],P[4],P[3],G[2]);
	and andc7e(intc7e,P[6],P[5],P[4],G[3]);
	and andc7f(intc7f,P[6],P[5],G[4]);
	and andc7g(intc7g,P[6],G[5]);
	or  orc7(C[7],G[6],intc7a,intc7b,intc7c,intc7d,intc7e,intc7f,intc7g);
	
	// carry 8
	//wire intc8a;
	//wire intc8b;
   //wire intc8c;
	//wire intc8d;
	//wire intc8e;
	//wire intc8f;
	//wire intc8g;
	//wire intc8h;
	
	//and andc8a(intc8a,P[7],P[6],P[5],P[4],P[3],P[2],P[1],P[0],Cin);
	//and andc8b(intc8b,P[7],P[6],P[5],P[4],P[3],P[2],P[1],G[0]);
	//and andc8c(intc8c,P[7],P[6],P[5],P[4],P[3],P[2],G[1]);
	//and andc8d(intc8d,P[7],P[6],P[5],P[4],P[3],G[2]);
	//and andc8e(intc8e,P[7],P[6],P[5],P[4],G[3]);
	//and andc8f(intc8f,P[7],P[6],P[5],G[4]);
	//and andc8g(intc8g,P[7],P[6],G[5]);
	//and andc8h(intc8h,P[7],G[6]);
	//or  orc8(Cout,G[7],intc8a,intc8b,intc8c,intc8d,intc8e,intc8f,intc8g,intc8h);
	
	and andPG(PG,P[7],P[6],P[5],P[4],P[3],P[2],P[1],P[0]);
	
	wire intGGa;
	wire intGGb;
	wire intGGc;
	wire intGGd;
	wire intGGe;
	wire intGGf;
	wire intGGg;
	and andGGa(intGGa,P[7],P[6],P[5],P[4],P[3],P[2],P[1],G[0]);
	and andGGb(intGGb,P[7],P[6],P[5],P[4],P[3],P[2],G[1]);
	and andGGc(intGGc,P[7],P[6],P[5],P[4],P[3],G[2]);
	and andGGd(intGGd,P[7],P[6],P[5],P[4],G[3]);
	and andGGe(intGGe,P[7],P[6],P[5],G[4]);
	and andGGf(intGGf,P[7],P[6],G[5]);
	and andGGg(intGGg,P[7],G[6]);
	or  orGG(GG,G[7],intGGa,intGGb,intGGc,intGGd,intGGe,intGGf,intGGg);
	
	xor xors0(S[0],P[0],C[0]);
	xor xors1(S[1],P[1],C[1]);
	xor xors2(S[2],P[2],C[2]);
	xor xors3(S[3],P[3],C[3]);
	xor xors4(S[4],P[4],C[4]);
	xor xors5(S[5],P[5],C[5]);
	xor xors6(S[6],P[6],C[6]);
	xor xors7(S[7],P[7],C[7]);
	
	and andMSB(Cmsb,C[7],1'b1);

endmodule