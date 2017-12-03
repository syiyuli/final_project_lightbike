module button_to_orient(current, buttonLeft, buttonRight, buttonUp, buttonDown, out);

	input[31:0] current;
	input buttonLeft, buttonRight, buttonUp, buttonDown;
	output[31:0] out;

	wire [31:0] temp0, temp1, temp2, temp3, temp4; 
	// button = direction
	assign temp0 = current==32'd0 ? 32'd640 : current;
	assign temp1 = (buttonLeft && current!=32'd1) ? 32'b11111111111111111111111111111111:temp0;
	assign temp2 = (buttonRight && current!=32'b11111111111111111111111111111111) ? 32'd1:temp1;
	assign temp3 = (buttonUp && current!=32'd640)? 32'b11111111111111111111110110000000:temp2;
	assign out = (buttonDown && current!=32'b11111111111111111111110110000000) ? 32'd640:temp3;

	
endmodule 