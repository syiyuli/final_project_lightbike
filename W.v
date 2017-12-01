module W(data_mem, data_reg, lw, data_wb);
	input lw;
	input [31:0] data_mem, data_reg;
	
	output [31:0] data_wb;
	
	assign data_wb = lw ? data_mem:data_reg;
	
endmodule