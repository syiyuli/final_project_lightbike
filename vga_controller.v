module vga_controller(iRST_n,
							 clock,
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
							 bikeone_crash_out,
							 biketwo_crash_out,
							 bikethree_crash_out,
							 bikefour_crash_out,
							 reset_map,
							 four_player_mode,
							 background,
							 master_switch
							 );

input reset, reset_map, master_switch;
input iRST_n;
input [31:0] background;
input clock;
input four_player_mode;
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
wire inBike, inBikeone, inBiketwo, inBikecenter, inBikeonecenter, inBiketwocenter;
wire inBikethree, inBikefour, inBikethree_en, inBikefour_en, inBikethreecenter, inBikefourcenter, inBikethreecenter_en, inBikefourcenter_en;
wire[2:0] bikeoneDirection, biketwoDirection, bikeoneDirectionFinal, biketwoDirectionFinal; 
wire[2:0] bikethreeDirection, bikefourDirection, bikethreeDirectionFinal, bikefourDirectionFinal; 
wire [2:0] bikeoneColor, biketwoColor, bikethreeColor, bikefourColor; // Changed this so bikeoneOrient feeds into bikeoneDirection
wire[18:0] ADDRbike, ADDRbikeone, ADDRbiketwo, ADDRbikethree, ADDRbikefour, ADDRbikeHelpone, ADDRbikeHelptwo, ADDRbikeHelpthree, ADDRbikeHelpfour;
assign bikeoneColor = 3'b000;
assign biketwoColor = 3'b001;
assign bikethreeColor = 3'b010;
assign bikefourColor = 3'b011;

movement_to_orient moveorientone(bikeoneOrient, bikeoneDirection);
movement_to_orient moveorienttwo(biketwoOrient, biketwoDirection);
movement_to_orient moveorientthree(bikethreeOrient, bikethreeDirection);
movement_to_orient moveorientfour(bikefourOrient, bikefourDirection);

checkXbyY checkBikeOneLoc(.X(30),.Y(30),.startaddr(bikeone),.addr(ADDR),.orient(bikeoneDirection),.out(inBikeone));
checkXbyY checkBikeTWoLoc(.X(30),.Y(30),.startaddr(biketwo),.addr(ADDR),.orient(biketwoDirection),.out(inBiketwo));
checkXbyY checkBikeThreeLoc(.X(30),.Y(30),.startaddr(bikethree),.addr(ADDR),.orient(bikethreeDirection),.out(inBikethree));
checkXbyY checkBikeFourLoc(.X(30),.Y(30),.startaddr(bikefour),.addr(ADDR),.orient(bikefourDirection),.out(inBikefour));

checkXbyYcenter checkBikeoneCen(bikeone,ADDR,inBikeonecenter);
checkXbyYcenter checkBiketwoCen(biketwo,ADDR,inBiketwocenter);
checkXbyYcenter checkBikethreeCen(bikethree,ADDR,inBikethreecenter);
checkXbyYcenter checkBikefourCen(bikefour,ADDR,inBikefourcenter);

convertAddr getBikeAddrone(.startaddr(bikeone),.addr(ADDR),.orient(bikeoneDirection), .color(bikeoneColor),.memAddr(ADDRbikeHelpone));
convertAddr getBikeAddrtwo(.startaddr(biketwo),.addr(ADDR),.orient(biketwoDirection), .color(biketwoColor), .memAddr(ADDRbikeHelptwo));
convertAddr getBikeAddrthree(.startaddr(bikethree),.addr(ADDR),.orient(bikethreeDirection), .color(bikethreeColor),.memAddr(ADDRbikeHelpthree));
convertAddr getBikeAddrfour(.startaddr(bikefour),.addr(ADDR),.orient(bikefourDirection), .color(bikefourColor),.memAddr(ADDRbikeHelpfour));

assign ADDRbikeone = inBikeone ? ADDRbikeHelpone:ADDR;
assign ADDRbiketwo = inBiketwo ? ADDRbikeHelptwo:ADDRbikeone;
assign ADDRbikethree = inBikethree_en ? ADDRbikeHelpthree:ADDRbiketwo;
assign ADDRbikefour = inBikefour_en ? ADDRbikeHelpfour:ADDRbikethree;
assign ADDRbike = ADDRbikefour;

and andinBikethree(inBikethree_en, inBikethree, four_player_mode);
and andinBikefour(inBikefour_en, inBikefour, four_player_mode);
and andinBikethreecenter(inBikethreecenter_en, inBikethreecenter, four_player_mode);
and andinBikefourcenter(inBikefourcenter_en, inBikefourcenter, four_player_mode);
or orinBike(inBike, inBikeone, inBiketwo, inBikethree_en, inBikefour_en);
or orinBikecenter(inBikecenter, inBikeonecenter, inBiketwocenter,inBikethreecenter_en, inBikefourcenter_en);

// Store Trail
wire bikeoneExactLoc, biketwoExactLoc, bikethreeExactLoc, bikefourExactLoc, write_map;
wire [2:0] bikeone_trailcolor, biketwo_trailcolor, bikethree_trailcolor, bikefour_trailcolor;
wire [2:0] trail_input, first_color, second_color, third_color, fourth_color;
wire [2:0] trail_output;
wire [31:0] bikeone_middle, biketwo_middle, bikethree_middle, bikefour_middle; 
wire [11:0] store_trail_one, store_trail_two, store_trail_three, store_trail_four, trail_one, trail_two, trail_three, trail_four;
wire [11:0] trail_location, menu_location, store_trail;
wire [13:0] background_location;

convertTrailAddr convertTrailAddrtrail_Location(ADDR, trail_location);
convertTrailAddr convertTrailmenu_location(ADDR, menu_location);
convertBackground convertBackground_Location(ADDR, background[4:0], background_location);

// Bike One
assign bikeone_trailcolor = bikeoneColor + 3'd1;
assign bikeone_middle = bikeone + 32'd15 + 32'd640*32'd15;
convertTrailAddr convertTrailAddrbikeone_Location(bikeone_middle[18:0], trail_one);
assign bikeoneExactLoc = (bikeone_middle == ADDR)? 1'b1:1'b0;
assign first_color = bikeoneExactLoc ? bikeone_trailcolor: 3'd0;
assign store_trail_one = bikeoneExactLoc ? trail_one: trail_location;

// Bike Two
assign biketwo_trailcolor = biketwoColor + 3'd1;
assign biketwo_middle = biketwo + 32'd15 + 32'd640*32'd15;
convertTrailAddr convertTrailAddrbiketwo_Location(biketwo_middle[18:0], trail_two);
assign biketwoExactLoc = (biketwo_middle == ADDR)? 1'b1:1'b0;
assign second_color = biketwoExactLoc ? biketwo_trailcolor:first_color;
assign store_trail_two = biketwoExactLoc ? trail_two: store_trail_one;

// Bike Three
assign bikethree_trailcolor = bikethreeColor + 3'd1;
assign bikethree_middle = bikethree + 32'd15 + 32'd640*32'd15;
convertTrailAddr convertTrailAddrbikethree_Location(bikethree_middle[18:0], trail_three);
assign bikethreeExactLoc = (bikethree_middle == ADDR && four_player_mode)? 1'b1:1'b0;
assign third_color = bikethreeExactLoc ? bikethree_trailcolor: second_color;
assign store_trail_three = bikethreeExactLoc ? trail_three: store_trail_two;

// Bike Four
assign bikefour_trailcolor = bikefourColor + 3'd1;
assign bikefour_middle = bikefour + 32'd15 + 32'd640*32'd15;
convertTrailAddr convertTrailAddrbikefour_Location(bikefour_middle[18:0], trail_four);
assign bikefourExactLoc = (bikefour_middle == ADDR && four_player_mode)? 1'b1:1'b0;
assign fourth_color = bikefourExactLoc ? bikefour_trailcolor: third_color;
assign store_trail_four = bikefourExactLoc ? trail_four: store_trail_three;

assign trail_input = reset_map ? 3'd0:fourth_color;
or or_bike_reset_map(write_map, bikeoneExactLoc, biketwoExactLoc, bikethreeExactLoc, bikefourExactLoc, reset_map);
assign store_trail = ~reset_map ? store_trail_four:trail_location;
	
// Screen Detection
wire bikeone_bounded, biketwo_bounded, bikethree_bounded, bikefour_bounded;
checkScreenBound checkscreenBikeone(.addr(bikeone),.orient(bikeoneOrient),.out(bikeone_bounded));
checkScreenBound checkscreenBiketwo(.addr(biketwo),.orient(biketwoOrient),.out(biketwo_bounded));
checkScreenBound checkscreenBikethree(.addr(bikethree),.orient(bikethreeOrient),.out(bikethree_bounded));
checkScreenBound checkscreenBikefour(.addr(bikefour),.orient(bikefourOrient),.out(bikefour_bounded));
	
// Edge Detection
wire edge_detected_one, edge_detected_two, edge_detected_three, edge_detected_four;
edge_detection edge_detection_one(trail_output, ADDR, bikeone_middle, bikeoneDirection, edge_detected_one, master_switch);
edge_detection edge_detection_two(trail_output, ADDR, biketwo_middle, biketwoDirection, edge_detected_two, master_switch);
edge_detection edge_detection_three(trail_output, ADDR, bikethree_middle, bikethreeDirection, edge_detected_three, master_switch);
edge_detection edge_detection_four(trail_output, ADDR, bikefour_middle, bikefourDirection, edge_detected_four, master_switch);

// Background Detection
wire background_detected_one, background_detected_two, background_detected_three, background_detected_four;
bgr_detection backg_detection_one(background[4:0],bgr_background_data,ADDR,bikeone_middle,bikeoneDirection, background_detected_one);
bgr_detection backg_detection_two(background[4:0],bgr_background_data,ADDR,biketwo_middle,biketwoDirection, background_detected_two);
bgr_detection backg_detection_three(background[4:0],bgr_background_data,ADDR,bikethree_middle,bikethreeDirection, background_detected_three); 
bgr_detection backg_detection_four(background[4:0],bgr_background_data,ADDR,bikefour_middle,bikefourDirection, background_detected_four);

// Determine if Crash or not
output bikeone_crash_out, biketwo_crash_out, bikethree_crash_out, bikefour_crash_out;
or or_one_died(bikeone_crash, edge_detected_one, background_detected_one, bikeone_bounded);
or or_two_died(biketwo_crash, edge_detected_two, background_detected_two, biketwo_bounded);
or or_three_died(bikethree_crash, edge_detected_three, background_detected_three, bikethree_bounded);
or or_four_died(bikefour_crash, edge_detected_four, background_detected_four, bikefour_bounded);

// Latch Bike Crashes
wire bikeone_crash, biketwo_crash, bikethree_crash, bikefour_crash;
dffe1 bikeone_crashdff(.d(bikeone_crash),.q(bikeone_crash_out),.clk(clock),.ena(1'b1),.clrn(reset),.prn(1'b1));
dffe1 biketwo_crashdff(.d(biketwo_crash),.q(biketwo_crash_out),.clk(clock),.ena(1'b1),.clrn(reset),.prn(1'b1));
dffe1 bikethree_crashdff(.d(bikethree_crash),.q(bikethree_crash_out),.clk(clock),.ena(1'b1),.clrn(reset),.prn(1'b1));
dffe1 bikefour_crashdff(.d(bikefour_crash),.q(bikefour_crash_out),.clk(clock),.ena(1'b1),.clrn(reset),.prn(1'b1));

// Lookup Bikes and Draw Bikes
assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDRbike ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
//////Color table output
img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q (bgr_data_help)
	);
	
// Trail Memory
trail_mem trail_mem_inst (
	.aclr(reset_map),
	.clock(iVGA_CLK),
	.data(trail_input),
	.rdaddress(trail_location),
	.wraddress(store_trail),
	.wren(write_map),
	.q(trail_output)
	);
	
// Lookup Background and Draw Background
wire [7:0] background_index;
background_mem background_mem_inst(
	.address ( background_location ),
	.clock ( VGA_CLK_n ),
	.q ( background_index )
	);
wire [23:0] bgr_background_data; 
background_color background_color_inst(
	.address ( background_index ),
	.clock ( iVGA_CLK ),
	.q (bgr_background_data)
	);

wire [7:0] menu_color_index;
// Put Menu on the Screen need to change this module
menu_index menu_index_inst(
	.address ( menu_location ),
	.clock ( VGA_CLK_n ),
	.q ( menu_color_index )
	);
wire [23:0] bgr_menu_data; 	
menu_color menu_color_inst(
	.address ( menu_color_index ),
	.clock ( iVGA_CLK ),
	.q (bgr_menu_data)
	);

// Lookup Numbers and Draw Numbers
	
	
// Lookup Powerups and Draw Powerups

// Convert Trail Outputs into Color 
wire[23:0] trail_output_color, trail_output_color_1, trail_output_color_2, trail_output_color_3, trail_output_color_4;
assign trail_output_color_2 = trail_output==3'd2 ? 24'h0072FF:24'hFFBA00;
assign trail_output_color_3 = trail_output==3'd3 ? 24'h12F100:trail_output_color_2;
assign trail_output_color = trail_output==3'd4 ? 24'hFF00D8:trail_output_color_3;

wire[23:0] bgr_data_bike, bgr_data_help, bgr_data_bike_one, bgr_data_bike_two, bgr_data_bike_three, bgr_data_bike_four, bgr_data_bike_final;
wire[23:0] bgr_data_bike_edge, bgr_trail_color;

assign bgr_trail_color = (trail_output!=0 && ~inBikecenter) ? trail_output_color:bgr_background_data;
assign bgr_data_bike = inBike && bgr_data_help!=24'h000000 ? bgr_data_help: bgr_trail_color;
assign bgr_data_bike_edge = (bgr_menu_data!=24'h000000 && master_switch)?bgr_menu_data:bgr_data_bike;

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
 	















