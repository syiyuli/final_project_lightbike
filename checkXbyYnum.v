module checkXbyYnum(startaddr, addr,out); 
input[18:0] addr, startaddr;
output out;

wire[49:0] temp;

genvar i;
generate
	for (i=0;i<50;i=i+1) begin: loop
		assign temp[i] = (addr >= (startaddr + i*640)) && (addr < (40 + startaddr + i*640)) ? 1'b1 : 1'b0;
	end
endgenerate
 
assign out=	temp[0] || temp[1] || temp[2] || temp[3] || temp[4] || temp[5] || temp[6] || temp[7] || 
				temp[8] || temp[9] || temp[10]|| temp[11]|| temp[12]|| temp[13]|| temp[14]|| temp[15]||
				temp[16]|| temp[17]|| temp[18]|| temp[19]|| temp[20]|| temp[21]|| temp[22]|| temp[23]||
				temp[24]|| temp[25]|| temp[26]|| temp[27]|| temp[28]|| temp[29]|| temp[30]|| temp[31]||
				temp[32]|| temp[33]|| temp[34]|| temp[35]|| temp[36]|| temp[37]|| temp[38]|| temp[39]||
				temp[40]|| temp[41]|| temp[42]|| temp[43]|| temp[44]|| temp[45]|| temp[46]|| temp[47]||
				temp[48]|| temp[49];

endmodule 