module rsselector(men, ben, exen, j2en, rs, rt, rd_out, readA2, readB2);
	input men, ben, exen, j2en;
	input [4:0] rs, rt, rd_out;
	output [4:0] readA2, readB2;	

	// Logic to allow for reading in RD as well as RS and RT, need to deal with jump return
	wire [4:0] readA1, readB1, readA0, readB0;
	wire be, boj2;
	or orboj(boj2, ben, j2en);
	and andbe(be,ben,exen);
	
	// Assign rs, rt to readA and readB
	// If Memory, assign rs to readA and rd to readB
	assign readA0 = men ? rs:rs;
	assign readB0 = men ? rd_out:rt;
	
	// If Branch or Jump Return, assign rd to readA and rs to readB
	assign readA1 = boj2 ? rd_out:readA0;
	assign readB1 = boj2 ? rs:readB0;

	// If Branch and Exception, assign rstatus to readA and 0 to readB 
	assign readA2 = be ? 5'b11110:readA1;
	assign readB2 = be ? 5'b00000:readB1;
	
endmodule