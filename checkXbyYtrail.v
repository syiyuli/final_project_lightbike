module checkXbyYtrail(X, Y, startaddr, addr,out); 
input[9:0] X,Y;
input[18:0] addr, startaddr;
output out;

wire[14:0] temp;

genvar i;
generate
	for (i=1;i<15;i=i+1) begin: loop
		assign temp[i] = (addr > (startaddr + i*640)) & (addr < (X + startaddr + i*640)) ? 1'b1 : 1'b0;
	end
endgenerate

or getOut(out,temp[0],temp[1],temp[2],temp[3],temp[4],temp[5],temp[6],temp[7],temp[8],temp[9],temp[10],
	temp[11],temp[12],temp[13],temp[14]);

endmodule