module checkXbyYcenter(startaddr, addr,out); 
input[18:0] addr, startaddr;
output out;

wire[29:0] temp;

genvar i;
generate
	for (i=7;i<23;i=i+1) begin: loop
		assign temp[i] = (addr > (startaddr + i*640+7)) && (addr < (23 + startaddr + i*640)) ? 1'b1 : 1'b0;
	end
endgenerate

or getOut(out,temp[7],temp[8],temp[9],temp[10],
	temp[11],temp[12],temp[13],temp[14],temp[15],temp[16],temp[17],temp[18],temp[19],temp[20],
	temp[21],temp[22]);

endmodule