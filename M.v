module M(swen, clock, data_write, data_where, data_mem, readXM, renWB, readWB, dataWB, data_writefinal);
	input swen, clock, renWB;
	input [4:0] readWB, readXM;
	input [31:0] data_write, dataWB;
	input [11:0] data_where;

	output [31:0] data_mem, data_writefinal;
	
	// If storing data and register that holds data is being written back, bypass with data
	wire memBy, BmemnotequalWB;
	wire [31:0] readXMext, readWBext;
	assign readXMext[4:0] = readXM;
	assign readWBext[4:0] = readWB;
	assign readXMext[31:5] = 27'b000000000000000000000000000;
	assign readWBext[31:5] = 27'b000000000000000000000000000;
	subtracter subtracterreadAWB(.A(readXMext),.B(readWBext),.c0(1'b0),.isNotEqual(BmemnotequalWB));
	
	and andmemBy(memBy, renWB, ~BmemnotequalWB);
	assign data_writefinal = memBy ? dataWB:data_write;
	
	dmem mydmem(.address(data_where),.clock (~clock),.data(data_writefinal), .wren(swen),.q(data_mem));

endmodule