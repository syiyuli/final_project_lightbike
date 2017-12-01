module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);

   input [31:0] data_operandA, data_operandB;
   input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

   output [31:0] data_result;
   output isNotEqual, isLessThan, overflow;

   // YOUR CODE HERE //
	
	//Adder
	wire [31:0] adderSum;
	wire adderOvf;
	wire addercarryout;
	cla cla1(adderSum, adderOvf, addercarryout, data_operandA, data_operandB, 1'b0);
	
	//Subtracter
	wire [31:0] subtracterSum;
	wire subtracterOvf;
	wire subtractercarryout;
	wire tempEqual;
	wire tempLessThan;
	subtracter subtracter(subtracterSum, subtracterOvf, subtractercarryout, data_operandA, data_operandB, 1'b1, tempEqual, tempLessThan);
	
	//And
	wire [31:0] anderSum;
	ander ander1(anderSum,data_operandA,data_operandB);
	
	//Or
	wire [31:0] orerSum;
	orer orer1(orerSum,data_operandA,data_operandB);
	
	//Shift Left
	wire [31:0] leftshiftSum;
	leftshifter leftshifter1(leftshiftSum, data_operandA, ctrl_shiftamt);
	
	//Shift Right
	wire [31:0] rightshiftSum;
	rightshifter rightshifter1(rightshiftSum, data_operandA, ctrl_shiftamt);
	
	//OpCode Decoder
	aluopcodeDecoder aluopcodeDecoder1(data_result,overflow,isNotEqual,isLessThan,adderSum,subtracterSum,anderSum,orerSum,leftshiftSum,rightshiftSum,adderOvf,subtracterOvf,tempEqual,tempLessThan,ctrl_ALUopcode);
	

endmodule