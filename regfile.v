module regfile (
    clock,
    ctrl_writeEnable,
    ctrl_reset, ctrl_writeReg,
    ctrl_readRegA, ctrl_readRegB, data_writeReg,
    data_readRegA, data_readRegB, bikeone, bikeoneOrient, biketwo, 
		biketwoOrient, bikethree, bikethreeOrient, bikefour, bikefourOrient, 
		masterSwitch, reg27, bikeoneOrient_IN, biketwoOrient_IN, bikethreeOrient_IN, bikefourOrient_IN,
		background_in, bikeonepowerup_in, biketwopowerup_in, bikethreepowerup_in, bikefourpowerup_in,
		background_out, bikeonepowerup_out, biketwopowerup_out, bikethreepowerup_out, bikefourpowerup_out,
		speed_in, speed_out
		);

   input clock, ctrl_writeEnable, ctrl_reset;
   input [4:0] ctrl_writeReg, ctrl_readRegA, ctrl_readRegB;
   input [31:0] data_writeReg, bikeoneOrient_IN, biketwoOrient_IN, bikethreeOrient_IN, bikefourOrient_IN; //5 3 1;
	input masterSwitch;
	input [31:0] background_in, bikeonepowerup_in, biketwopowerup_in, bikethreepowerup_in, bikefourpowerup_in;
   output [31:0] data_readRegA, data_readRegB;
	output reg27;
	
	wire [31:0] out_decoder;
	wire [31:0] writeEnable;
	wire [31:0] out_decoderReadA;
	wire [31:0] out_decoderReadB;
	wire [31:0] allRegisters [31:0];
   /* YOUR CODE HERE */
	
	// decoder
	decoder decoder1(out_decoder, ctrl_writeReg);
	
	// register	
//	genvar i; 
//	generate 
//		for(i=0;i<9;i=i+1) begin: loop1
//			and andEnable(writeEnable[i], ctrl_writeEnable,out_decoder[i]);
//			register a_register(data_writeReg, writeEnable[i], clock, ctrl_reset,allRegisters[i]);
//		end
//	endgenerate
	
	genvar i; 
	generate 
		for(i=0;i<8;i=i+1) begin: loop1
			and andEnable(writeEnable[i], ctrl_writeEnable,out_decoder[i]);
			register a_register(data_writeReg, writeEnable[i], clock, ctrl_reset,allRegisters[i]);
		end
	endgenerate

	input [31:0] speed_in;
	output [31:0] speed_out;
	wire [31:0] speed_in_final;
	and andEnable8(writeEnable[8], ctrl_writeEnable,out_decoder[8]);
	assign speed_in_final = writeEnable[8] ? data_writeReg:speed_in;
	register register_8(speed_in_final, ~masterSwitch, clock, ctrl_reset, allRegisters[8]);
	assign speed_out = allRegisters[8];
 
	wire [31:0] background_final, bikeonepowerup_final, biketwopowerup_final, bikethreepowerup_final, bikefourpowerup_final;
	and andEnable9(writeEnable[9], ctrl_writeEnable,out_decoder[9]);
	assign bikefourpowerup_final = writeEnable[9] ? data_writeReg:bikefourpowerup_in;
	register register_9(bikefourpowerup_final, 1'b1, clock, ctrl_reset,allRegisters[9]);
 
	and andEnable10(writeEnable[10], ctrl_writeEnable,out_decoder[10]);
	assign bikethreepowerup_final = writeEnable[10] ? data_writeReg:bikethreepowerup_in;
	register register_10(bikethreepowerup_final, 1'b1, clock, ctrl_reset,allRegisters[10]);

	and andEnable11(writeEnable[11], ctrl_writeEnable,out_decoder[11]);
	assign biketwopowerup_final = writeEnable[11] ? data_writeReg:biketwopowerup_in;
	register register_11(biketwopowerup_final, 1'b1, clock, ctrl_reset,allRegisters[11]);
	
	and andEnable12(writeEnable[12], ctrl_writeEnable,out_decoder[12]);
	assign bikeonepowerup_final = writeEnable[12] ? data_writeReg:bikeonepowerup_in;
	register register_12(bikeonepowerup_final, 1'b1, clock, ctrl_reset,allRegisters[12]);
	
	and andEnable13(writeEnable[13], ctrl_writeEnable,out_decoder[13]);
	assign background_final = writeEnable[13] ? data_writeReg:background_in;
	register register_13(background_final, ~masterSwitch, clock,1'b0,allRegisters[13]);	
	
	genvar m; 
	generate 
		for(m=14;m<21;m=m+1) begin: loopm
			and andEnable(writeEnable[m], ctrl_writeEnable,out_decoder[m]);
			register a_register(data_writeReg, writeEnable[m], clock, ctrl_reset,allRegisters[m]);
		end
	endgenerate
	
	and and_22(writeEnable[22], ctrl_writeEnable,out_decoder[22]);
	register a_register22(data_writeReg, writeEnable[22], clock, ctrl_reset,allRegisters[22]);
	
	and and_24(writeEnable[24], ctrl_writeEnable,out_decoder[24]);
	register a_register24(data_writeReg, writeEnable[24], clock, ctrl_reset,allRegisters[24]);

	and and_26(writeEnable[26], ctrl_writeEnable,out_decoder[26]);
	register a_register26(data_writeReg, writeEnable[26], clock, ctrl_reset,allRegisters[26]);
	
	wire [31:0] masterIn;
	assign masterIn[0] = masterSwitch;
	assign masterIn[31:1] = 31'd0;
	
	register register_27(masterIn, 1'b1, clock, ctrl_reset,allRegisters[27]);
	assign reg27 = allRegisters[27][0];

	wire [31:0] bikeoneOrient_final, biketwoOrient_final, bikethreeOrient_final, bikefourOrient_final;
	
	and andEnable21(writeEnable[21], ctrl_writeEnable,out_decoder[21]);
	assign bikefourOrient_final = writeEnable[21] ? data_writeReg:bikefourOrient_IN;
	register register_21(bikefourOrient_final, 1'b1, clock, ctrl_reset,allRegisters[21]);
	
	and andEnable23(writeEnable[23], ctrl_writeEnable,out_decoder[23]);
	assign bikethreeOrient_final = writeEnable[23] ? data_writeReg:bikethreeOrient_IN;
	register register_23(bikethreeOrient_final, 1'b1, clock, ctrl_reset,allRegisters[23]);
	
	and andEnable25(writeEnable[25], ctrl_writeEnable,out_decoder[25]);
	assign biketwoOrient_final = writeEnable[25] ? data_writeReg:biketwoOrient_IN;
	register register_25(biketwoOrient_final, 1'b1, clock, ctrl_reset,allRegisters[25]);
	
	and andEnable28(writeEnable[28], ctrl_writeEnable,out_decoder[28]);
	assign bikeoneOrient_final = writeEnable[28] ? data_writeReg:bikeoneOrient_IN;
	register register_28(bikeoneOrient_final, 1'b1, clock, ctrl_reset,allRegisters[28]);
	
	genvar k; 
	generate 
		for(k=29;k<32;k=k+1) begin: loop10
			and andEnable(writeEnable[k], ctrl_writeEnable,out_decoder[k]);
			register a_register(data_writeReg, writeEnable[k], clock, ctrl_reset,allRegisters[k]);
		end
	endgenerate
	
	decoder decoderRead1(out_decoderReadA, ctrl_readRegA);
	decoder decoderRead2(out_decoderReadB, ctrl_readRegB);
	
	// tri-state buffer
	genvar j;
	generate
		for(j=0;j<32;j=j+1) begin: loop2
			tristate tristateA(allRegisters[j],out_decoderReadA[j], data_readRegA);
			tristate tristateB(allRegisters[j],out_decoderReadB[j], data_readRegB);
		end
	endgenerate
	
//	// read bike four values
	output [31:0] bikefour, bikefourOrient; 
	assign bikefour = allRegisters[22];
	assign bikefourOrient = allRegisters[21];
	output [31:0] bikefourpowerup_out;
	assign bikefourpowerup_out = allRegisters[9];
	
	// read bike three values
	output[31:0] bikethree, bikethreeOrient;
	assign bikethree = allRegisters[24];
	assign bikethreeOrient = allRegisters[23];
	output [31:0] bikethreepowerup_out; 
	assign bikethreepowerup_out = allRegisters[10];

	// read bike two values
	output[31:0] biketwo, biketwoOrient;
	assign biketwo = allRegisters[26];
	assign biketwoOrient = allRegisters[25];
	output[31:0] biketwopowerup_out;
	assign biketwopowerup_out = allRegisters[11];
	
	// read bike one values 
	output[31:0] bikeone, bikeoneOrient;
	assign bikeone = allRegisters[29];
	assign bikeoneOrient = allRegisters[28];
	output[31:0] bikeonepowerup_out;
	assign bikeonepowerup_out = allRegisters[12];

	output[31:0] background_out;
	assign background_out = allRegisters[13];
endmodule

module register(data, write_enable, clock, ctrl_reset, qout);
	input [31:0] data;
	input write_enable, clock, ctrl_reset;
	
	output [31:0] qout;

	genvar i;
	generate
		for(i=0;i<32;i=i+1) begin: loop3
			dffe1 a_dff(.d(data[i]),.q(qout[i]),.clk(clock),.ena(write_enable),.clrn(~ctrl_reset),.prn(1'b1));
		end
	endgenerate
	
endmodule

module dffe1(d, clk, clrn, prn, ena, q);
    input d, clk, ena, clrn, prn;
    wire clr;
    wire pr;

    output q;
    reg q;

    assign clr = ~clrn;
    assign pr = ~prn;

    initial
    begin
        q = 1'b0;
    end
	
    always @(posedge clk or posedge clr) begin
        if (q == 1'bx) begin
            q = 1'b0;
        end else if (clr) begin
            q <= 1'b0;
        end else if (ena) begin
            q <= d;
        end
    end
endmodule

module decoder(out, select);
	input [4:0] select;
	output [31:0] out; 
	
	and and0(out[0],~select[4],~select[3],~select[2],~select[1],~select[0]); //00000
	and and1(out[1],~select[4],~select[3],~select[2],~select[1],select[0]);  //00001
	and and2(out[2],~select[4],~select[3],~select[2],select[1],~select[0]);  //00010
	and and3(out[3],~select[4],~select[3],~select[2],select[1],select[0]);   //00011
	and and4(out[4],~select[4],~select[3],select[2],~select[1],~select[0]);  //00100
	and and5(out[5],~select[4],~select[3],select[2],~select[1],select[0]);   //00101
	and and6(out[6],~select[4],~select[3],select[2],select[1],~select[0]);   //00110
	and and7(out[7],~select[4],~select[3],select[2],select[1],select[0]);    //00111
	and and8(out[8],~select[4],select[3],~select[2],~select[1],~select[0]);  //01000
	and and9(out[9],~select[4],select[3],~select[2],~select[1],select[0]);   //01001
	and and10(out[10],~select[4],select[3],~select[2],select[1],~select[0]); //01010
	and and11(out[11],~select[4],select[3],~select[2],select[1],select[0]);  //01011
	and and12(out[12],~select[4],select[3],select[2],~select[1],~select[0]); //01100
	and and13(out[13],~select[4],select[3],select[2],~select[1],select[0]);  //01101
	and and14(out[14],~select[4],select[3],select[2],select[1],~select[0]);  //01110
	and and15(out[15],~select[4],select[3],select[2],select[1],select[0]);   //01111
		
	and and16(out[16],select[4],~select[3],~select[2],~select[1],~select[0]); //10000
	and and17(out[17],select[4],~select[3],~select[2],~select[1],select[0]);  //10001
	and and18(out[18],select[4],~select[3],~select[2],select[1],~select[0]);  //10010
	and and19(out[19],select[4],~select[3],~select[2],select[1],select[0]);   //10011
	and and20(out[20],select[4],~select[3],select[2],~select[1],~select[0]);  //10100
	and and21(out[21],select[4],~select[3],select[2],~select[1],select[0]);   //10101
	and and22(out[22],select[4],~select[3],select[2],select[1],~select[0]);   //10110
	and and23(out[23],select[4],~select[3],select[2],select[1],select[0]);    //10111 
	and and24(out[24],select[4],select[3],~select[2],~select[1],~select[0]);  //11000
	and and25(out[25],select[4],select[3],~select[2],~select[1],select[0]);   //11001
	and and26(out[26],select[4],select[3],~select[2],select[1],~select[0]);   //11010
	and and27(out[27],select[4],select[3],~select[2],select[1],select[0]);    //11011
	and and28(out[28],select[4],select[3],select[2],~select[1],~select[0]);   //11100
	and and29(out[29],select[4],select[3],select[2],~select[1],select[0]);    //11101
	and and30(out[30],select[4],select[3],select[2],select[1],~select[0]);    //11110
	and and31(out[31],select[4],select[3],select[2],select[1],select[0]);     //11111

	
endmodule

module tristate(in, oe, out);
	input oe;
	input [31:0]in;
	output [31:0]out;
	
	assign out = oe ? in : 32'bz;
	
endmodule