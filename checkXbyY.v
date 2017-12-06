module checkXbyY(X, Y, startaddr, addr, orient, out); 
input [2:0] orient;
input[9:0] X,Y;
input[18:0] addr, startaddr;
output out;

wire [9:0] Xleft, Xright, Ydown, Yup;
wire[29:0] temp;

wire [9:0] Xleftup, Xrightup, Ydownup, Yupup;
// Up is 0, X drawn between 
assign Xleftup = orient==32'd0   ? 10'd7 :10'd0;
assign Xrightup = orient== 32'd0 ? 10'd23:10'd30;
assign Yupup = orient==32'd0     ? 10'd0 :10'd0;
assign Ydownup = orient==32'd0   ? 10'd30:10'd30;

wire [9:0] Xleftleft, Xrightleft, Ydownleft, Yupleft;
// Left is 1, Y drawn between
assign Xleftleft = orient==32'd1   ? 10'd0 :Xleftup;
assign Xrightleft = orient== 32'd1 ? 10'd30:Xrightup;
assign Yupleft =  orient== 32'd1   ? 10'd7 :Yupup;
assign Ydownleft =  orient== 32'd1 ? 10'd23:Ydownup;

wire [9:0] Xleftdown, Xrightdown, Ydowndown, Yupdown;
// Down is 2, X draw between
assign Xleftdown = orient==32'd2  ? 10'd7   :Xleftleft;
assign Xrightdown = orient==32'd2 ? 10'd23  :Xrightleft;
assign Yupdown = orient==32'd2    ? 10'd0   :Yupleft;
assign Ydowndown = orient==32'd2  ? 10'd30  :Ydownleft;

wire [9:0] Xleftright, Xrightright, Ydownright, Yupright;
// Right is 3, Y drawn between
assign Xleftright = orient==32'd3   ? 10'd0   :Xleftdown;
assign Xrightright = orient==32'd3  ? 10'd30  :Xrightdown;
assign Yupright = orient==32'd3     ? 10'd7   :Yupdown;
assign Ydownright = orient==32'd3   ? 10'd23  :Ydowndown;

assign Xleft  = orient== 32'd5 ? 10'd0: Xleftright;
assign Xright = orient== 32'd5 ? 10'd30:Xrightright;
assign Yup    = orient== 32'd5 ? 10'd0:Yupright;
assign Ydown  = orient== 32'd5 ? 10'd30:Ydownright;

genvar i; // This is essentially Y
generate
	for (i=0;i<30;i=i+1) begin: loop
		assign temp[i] = ((i>Yup) && (i<Ydown) && (addr > (Xleft + startaddr + i*640)) && (addr < (Xright + startaddr + i*640))) ? 1'b1 : 1'b0;
	end
endgenerate


//genvar i; // This is essentially Y
//generate
//	for (i=0;i<30;i=i+1) begin: loop
//		assign temp[i] = (addr > (startaddr + i*640)) && (addr < (X + startaddr + i*640)) ? 1'b1 : 1'b0;
//	end
//endgenerate

or getOut(out,temp[1],temp[2],temp[3],temp[4],temp[5],temp[6],temp[7],temp[8],temp[9],temp[10],
	temp[11],temp[12],temp[13],temp[14],temp[15],temp[16],temp[17],temp[18],temp[19],temp[20],
	temp[21],temp[22],temp[23],temp[24],temp[25],temp[26],temp[27],temp[28],temp[29]);

endmodule