module movement_to_orient(bikeoneOrient,bikeOrient);
	input [31:0] bikeoneOrient;
	output [2:0] bikeOrient;

	wire [2:0] temporientup, temporientdown, temporientleft, temporientright;
	
	assign temporientup = bikeoneOrient == 32'd0 ? 3'd5:3'd0;
	assign temporientleft = bikeoneOrient == 32'b11111111111111111111111111111111 ? 3'd1: temporientup;
	assign temporientdown = bikeoneOrient == 32'd640 ? 3'd2: temporientleft;
	assign bikeOrient = bikeoneOrient == 32'd1 ? 3'd3: temporientdown;
	
endmodule