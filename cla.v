module cla(S,Ovf,c32,A,B,c0);
	input [31:0] A,B;
	input c0;
	output [31:0]S;
	output Ovf;
	output c32;
	
	wire [3:0] PG;
	wire [3:0] GG;
	
	wire tempc7;
	wire tempc8;
	wire c8;
	eightcla eightcla1(S[7:0],PG[0],GG[0],A[7:0],B[7:0],c0,tempc7);
	and andc8(tempc8,PG[0],c0);
	or  orc8(c8,GG[0],tempc8);
	
	wire tempc15;
	wire tempc16a;
	wire tempc16b;
	wire c16;
	eightcla eightcla2(S[15:8],PG[1],GG[1],A[15:8],B[15:8],c8,tempc15);
	and andc16a(tempc16a,PG[1],PG[0],c0);
	and andc16b(tempc16b,PG[1],GG[0]);
	or  orc16(c16,GG[1],tempc16a,tempc16b);
		
	wire tempc23;	
	wire tempc24a;
	wire tempc24b;
	wire tempc24c;
	wire c24;
	eightcla eightcla3(S[23:16],PG[2],GG[2],A[23:16],B[23:16],c16,tempc23);
	and andc24a(tempc24a,PG[2],PG[1],PG[0],c0);
	and andc24b(tempc24b,PG[2],PG[1],GG[0]);
	and andc24c(tempc24c,PG[2],GG[1]);
	or  orc24(c24,GG[2],tempc24a,tempc24b,tempc24c);

	wire tempc31;
	wire tempc32a;
	wire tempc32b;
	wire tempc32c;
	wire tempc32d;
	eightcla eightcla4(S[31:24],PG[3],GG[3],A[31:24],B[31:24],c24,tempc31);
	and andc32a(tempc32a,PG[3],PG[2],PG[1],PG[0],c0);
	and andc32b(tempc32b,PG[3],PG[2],PG[1],GG[0]);
	and andc32c(tempc32c,PG[3],PG[2],GG[1]);
	and andc32d(tempc32d,PG[3],GG[2]);
	or  orc32(c32,GG[3],tempc32a,tempc32b,tempc32c,tempc32d);
	
	// Overflow detection
	xor xorovf(Ovf,c32,tempc31);
endmodule