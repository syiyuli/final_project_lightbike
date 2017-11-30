module checkXbyY(X, Y, startaddr, addr,out); 
input[9:0] X,Y;
input[18:0] addr, startaddr;
output out;

wire[59:0] temp;

genvar i;
generate
	for (i=1;i<30;i=i+1) begin: loop
		assign temp[i] = (addr > (startaddr + i*640)) & (addr < (X + startaddr + i*640)) ? 1'b1 : 1'b0;
	end
endgenerate

or getOut(out,temp[0],temp[1],temp[2],temp[3],temp[4],temp[5],temp[6],temp[7],temp[8],temp[9],temp[10],
	temp[11],temp[12],temp[13],temp[14],temp[15],temp[16],temp[17],temp[18],temp[19],temp[20],
	temp[21],temp[22],temp[23],temp[24],temp[25],temp[26],temp[27],temp[28],temp[29],temp[30],
	temp[31],temp[32],temp[33],temp[34],temp[35],temp[36],temp[37],temp[38],temp[39],temp[40],
	temp[41],temp[42],temp[43],temp[44],temp[45],temp[46],temp[47],temp[48],temp[49],temp[50],
	temp[51],temp[52],temp[53],temp[54],temp[55],temp[56],temp[57],temp[58],temp[59]);

endmodule