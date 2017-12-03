module movement_to_orient(bikeoneOrient,bikeOrient);
	input [31:0] bikeoneOrient;
	output [1:0] bikeOrient;

	wire [1:0] temporientup, temporientdown, temporientleft, temporientright;
	
	assign temporientup = 2'b00;
	assign temporientleft = bikeoneOrient == 32'b11111111111111111111111111111111 ? 2'b01: temporientup;
	assign temporientdown = bikeoneOrient == 32'd640 ? 2'b10: temporientleft;
	assign bikeOrient = bikeoneOrient == 32'd1 ? 2'b11: temporientdown;
	
endmodule