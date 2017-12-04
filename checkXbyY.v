module checkXbyY(X, Y, startaddr, addr,out); 
input[9:0] X,Y;
input[18:0] addr, startaddr;
output out;

wire[29:0] temp;

genvar i;
generate
	for (i=0;i<30;i=i+1) begin: loop
		assign temp[i] = (addr > (startaddr + i*640)) && (addr < (X + startaddr + i*640)) ? 1'b1 : 1'b0;
	end
endgenerate

or getOut(out,temp[1],temp[2],temp[3],temp[4],temp[5],temp[6],temp[7],temp[8],temp[9],temp[10],
	temp[11],temp[12],temp[13],temp[14],temp[15],temp[16],temp[17],temp[18],temp[19],temp[20],
	temp[21],temp[22],temp[23],temp[24],temp[25],temp[26],temp[27],temp[28],temp[29]);

endmodule