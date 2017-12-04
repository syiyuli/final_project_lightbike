module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 bikeone,
							 bikeoneOrient,
							 biketwo,
							 biketwoOrient,
							 bikethree,
							 bikethreeOrient,
							 bikefour,
							 bikefourOrient,
							 reset,
							 edge_detected,
							 reset_map
							 );

input reset, reset_map;
input iRST_n;
input iVGA_CLK;
input [31:0] bikeone, bikeoneOrient, biketwo, biketwoOrient, bikethree, bikethreeOrient, bikefour, bikefourOrient;
output reg oBLANK_n;
output reg oHS;
output reg oVS;
output [7:0] b_data;
output [7:0] g_data;  
output [7:0] r_data;                        
///////// ////                     
reg [18:0] ADDR;
reg [23:0] bgr_data;
wire VGA_CLK_n;
wire [7:0] index;
wire [23:0] bgr_data_raw;
wire cBLANK_n,cHS,cVS,rst;
////
assign rst = ~iRST_n;
video_sync_generator LTM_ins (.vga_clk(iVGA_CLK),
                              .reset(rst),
                              .blank_n(cBLANK_n),
                              .HS(cHS),
                              .VS(cVS));
////
////Address generator
always@(posedge iVGA_CLK,negedge iRST_n)
begin
  if (!iRST_n)
     ADDR<=19'd0;
  else if (cHS==1'b0 && cVS==1'b0)
     ADDR<=19'd0;
  else if (cBLANK_n==1'b1)
     ADDR<=ADDR+1;
end
//////////////////////////
//////INDEX addr.

// Write Bike
wire inBike, inBikeone, inBiketwo;
wire[1:0] bikeoneDirection, biketwoDirection, bikeoneColor, biketwoColor; // Changed this so bikeoneOrient feeds into bikeoneDirection
wire[18:0] ADDRbike, ADDRbikeone, ADDRbiketwo, ADDRbikeHelpone, ADDRbikeHelptwo;
assign bikeoneColor = 2'b00;
assign biketwoColor = 2'b01;
movement_to_orient moveorientone(bikeoneOrient, bikeoneDirection);
movement_to_orient moveorienttwo(biketwoOrient, biketwoDirection);
checkXbyY checkBikeOneLoc(.X(30),.Y(30),.startaddr(bikeone),.addr(ADDR),.out(inBikeone));
checkXbyY checkBikeTWoLoc(.X(30),.Y(30),.startaddr(biketwo),.addr(ADDR),.out(inBiketwo));
convertAddr getBikeAddrone(.startaddr(bikeone),.addr(ADDR),.orient(bikeoneDirection), .color(bikeoneColor),.memAddr(ADDRbikeHelpone));
convertAddr getBikeAddrtwo(.startaddr(biketwo),.addr(ADDR),.orient(biketwoDirection), .color(biketwoColor), .memAddr(ADDRbikeHelptwo));
assign ADDRbikeone = inBikeone ? ADDRbikeHelpone:ADDR;
assign ADDRbiketwo = inBiketwo ? ADDRbikeHelptwo:ADDRbikeone;
or orinBike(inBike, inBikeone, inBiketwo);
assign ADDRbike = ADDRbiketwo;

// Store Trail
wire bikeoneExactLoc, biketwoExactLoc, write_map;
wire [2:0] trail_input, first_color, second_color;
wire [2:0] trail_output;
wire [31:0] bikeone_middle, biketwo_middle; 
wire [11:0] store_trail_one, store_trail_two, trail_one, trail_two, trail_location, store_trail;

convertTrailAddr convertTrailAddrtrail_Location(ADDR, trail_location);

// Bike One
assign bikeone_middle = bikeone + 32'd15 + 32'd640*32'd15;
convertTrailAddr convertTrailAddrbikeone_Location(bikeone_middle[18:0], trail_one);
assign bikeoneExactLoc = (bikeone_middle == ADDR)? 1'b1:1'b0;
assign first_color = bikeoneExactLoc ? 3'd1: 3'd0;
assign store_trail_one = bikeoneExactLoc ? trail_one: trail_location;

// Bike Two
assign biketwo_middle = biketwo + 32'd15 + 32'd640*32'd15;
convertTrailAddr convertTrailAddrbiketwo_Location(biketwo_middle[18:0], trail_two);
assign biketwoExactLoc = (biketwo_middle == ADDR)? 1'b1:1'b0;
assign second_color = biketwoExactLoc ? 3'd2:first_color;
assign store_trail_two = biketwoExactLoc ? trail_two: store_trail_one;

assign trail_input = reset_map ? 3'd0:second_color;
or or_bike_reset_map(write_map, bikeoneExactLoc, biketwoExactLoc, reset_map);
assign store_trail = ~reset_map ? store_trail_two:trail_location;

// Trail and Background Memory
trail_mem trail_mem_inst (
	.aclr(reset_map),
	.clock(VGA_CLK_n),
	.data(trail_input),
	.rdaddress(trail_location),
	.wraddress(store_trail),
	.wren(write_map),
	.q(trail_output)
	);

// Edge Detection
wire edge_detected_one, edge_detected_two;
output edge_detected;
edge_detection edge_detection_one(trail_output, ADDR, bikeone_middle, bikeoneDirection, edge_detected_one);
edge_detection edge_detection_two(trail_output, ADDR, biketwo_middle, biketwoDirection, edge_detected_two);
or or_edge_detected(edge_detected, edge_detected_one, edge_detected_two);

// Lookup Bikes and Draw Bikes
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDRbike ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
//////Color table output
wire[23:0] bgr_data_help, bgr_data_bike_one, bgr_data_bike_two;
wire[23:0] bgr_data_bike_edge;
img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_help)
	);	

	
assign bgr_data_bike_one = trail_output==3'd1 ? 24'hFF0000:24'h000000;
assign bgr_data_bike_two = trail_output==3'd2 ? 24'h00A5FF:bgr_data_bike_one;
assign bgr_data_bike_edge = inBike ? bgr_data_help : bgr_data_bike_two;
//assign bgr_data_bike_edge = bgr_data_raw==24'h000000 ? bgr_data_trail : bgr_data_raw;

//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_bike_edge;
assign b_data = bgr_data[23:16];
assign g_data = bgr_data[15:8];
assign r_data = bgr_data[7:0]; 
///////////////////
//////Delay the iHD, iVD,iDEN for one clock cycle;
always@(negedge iVGA_CLK)
begin
  oHS<=cHS;
  oVS<=cVS;
  oBLANK_n<=cBLANK_n;
end

endmodule
 	















