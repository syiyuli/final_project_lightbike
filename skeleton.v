module skeleton(reset, 
	ps2_clock, ps2_data, 										// ps2 related I/O
	debug_data_in, debug_addr, leds, 						// extra debugging ports
	lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon,// LCD info
	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8,		// seven segements
	VGA_CLK,   														//	VGA Clock
	VGA_HS,															//	VGA H_SYNC
	VGA_VS,															//	VGA V_SYNC
	VGA_BLANK,														//	VGA BLANK
	VGA_SYNC,														//	VGA SYNC
	VGA_R,   														//	VGA Red[9:0]
	VGA_G,	 														//	VGA Green[9:0]
	VGA_B,															//	VGA Blue[9:0]
	CLOCK_50,
	reset_map,
	master_switch,
	four_player_mode,
	master_switch_out,
	reg27);  													// 50 MHz clock
		
	////////////////////////	VGA	////////////////////////////
	output			VGA_CLK;   				//	VGA Clock
	output			VGA_HS;					//	VGA H_SYNC
	output			VGA_VS;					//	VGA V_SYNC
	output			VGA_BLANK;				//	VGA BLANK
	output			VGA_SYNC;				//	VGA SYNC
	output	[7:0]	VGA_R;   				//	VGA Red[9:0]
	output	[7:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[7:0]	VGA_B;   				//	VGA Blue[9:0]
	output			master_switch_out;
	output			reg27;
	input				CLOCK_50;
	input				four_player_mode;
	input				master_switch;
	input				reset_map;
	
	////////////////////////	PS2	////////////////////////////
	input 			reset;
	wire				resetn;
	assign resetn = ~reset; // Inverted Reset because it was annoying me
	inout 			ps2_data, ps2_clock;
	
	////////////////////////	LCD and Seven Segment	////////////////////////////
	output 			   lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon;
	output 	[7:0] 	leds, lcd_data;
	output 	[6:0] 	seg1, seg2, seg3, seg4, seg5, seg6, seg7, seg8;
	output 	[31:0] 	debug_data_in;
	output   [11:0]   debug_addr;
	
	assign master_switch_out = reg27;
	
	wire			 clock;
	wire			 lcd_write_en;
	wire 	[31:0] lcd_write_data;
	wire	[7:0]	 ps2_key_data;
	wire			 ps2_key_pressed;
	wire	[7:0]	 ps2_out;
	
	// clock divider (by 5, i.e., 10 MHz)
	pll div(CLOCK_50,inclock);
	// pll div2(inclock, inclock2);
	// assign clock = CLOCK_50;
	
	// UNCOMMENT FOLLOWING LINE AND COMMENT ABOVE LINE TO RUN AT 50 MHz
	assign clock = inclock;
	
	// your processor
	wire bikeoneleft, bikeoneright, bikeoneup, bikeonedown, biketwoleft, biketworight, biketwoup, biketwodown, bikethreeleft, bikethreeright, bikethreeup, bikethreedown, bikefourup, bikefourleft, bikefourright, bikefourdown;
	wire [7:0] oneleft, oneright, oneup, onedown, twoleft, tworight, twoup, twodown, threeleft, threeright, threeup, threedown, fourup, fourdown, fourright, fourleft;
	assign oneleft = 8'h1c;
	assign oneright = 8'h23;
	assign oneup = 8'h1d;
	assign onedown = 8'h1b;
	
	assign twoleft = 8'h2b;
	assign tworight = 8'h33;
	assign twoup = 8'h2c;
	assign twodown = 8'h34;
	
	assign threeleft = 8'h3b;
	assign threeright = 8'h4b;
	assign threeup = 8'h43;
	assign threedown = 8'h42;
	
	assign fourleft = 8'h6b;
	assign fourright = 8'h74;
	assign fourup = 8'h75;
	assign fourdown = 8'h73;
	
	// Bike Controls
	bike_controls bike_controls_one(bikeoneleft,bikeoneright,bikeoneup,bikeonedown,oneleft,oneright,oneup,onedown,ps2_key_pressed, ps2_key_data);
	bike_controls bike_controls_two(biketwoleft,biketworight,biketwoup,biketwodown,twoleft,tworight,twoup,twodown,ps2_key_pressed, ps2_key_data);
	bike_controls bike_controls_three(bikethreeleft,bikethreeright,bikethreeup,bikethreedown,threeleft,threeright,threeup,threedown,ps2_key_pressed, ps2_key_data);
	bike_controls bike_controls_four(bikefourleft,bikefourright,bikefourup,bikefourdown,fourleft,fourright,fourup,fourdown,ps2_key_pressed, ps2_key_data);

	wire [7:0] backgroundzero, backgroundone, backgroundtwo, backgroundthree, backgroundfour;
	assign backgroundzero = 8'h16;
	assign backgroundone = 8'h1e;
	assign backgroundtwo = 8'h26;
	assign backgroundthree = 8'h25;
	assign backgroundfour = 8'h2e;
	
	// Background Controls
	background_controls background_controls_1(background_out, background_in, backgroundzero, backgroundone, backgroundtwo, backgroundthree, backgroundfour,ps2_key_pressed, ps2_key_data);
	
	// May Have to do Edge Detection for Bikes themselves	
	wire [31:0] bikeone, bikeoneOrient, bikeoneOrient_IN, biketwoOrient_IN, bikethreeOrient_IN, bikefourOrient_IN, biketwo, biketwoOrient, bikethree, bikethreeOrient, bikefour, bikefourOrient;
	wire [31:0] bikeoneOrient_INtemp, biketwoOrient_INtemp, bikethreeOrient_INtemp, bikefourOrient_INtemp;
	wire master_switch_help, final_edge, bikeone_crash, biketwo_crash, bikethree_crash, bikefour_crash, bikeone_total, biketwo_total, bikethree_total, bikefour_total, game_finished, four_player_mode_final;	
	game_over game_over_finished(bikeone_crash, biketwo_crash, bikethree_crash, bikefour_crash, four_player_mode, game_finished);
	edge_clock edge_clock_final(clock, resetn, game_finished, final_edge);
	and masterFinal(master_switch_help, master_switch, ~final_edge);
	
	button_to_orient changespeedone(bikeoneOrient, bikeoneleft, bikeoneright, bikeoneup, bikeonedown, bikeone_crash, bikeoneOrient_IN);
	button_to_orient changespeedtwo(biketwoOrient, biketwoleft, biketworight, biketwoup, biketwodown, biketwo_crash, biketwoOrient_IN);
	button_to_orient changespeedthree(bikethreeOrient, bikethreeleft, bikethreeright, bikethreeup, bikethreedown, bikethree_crash, bikethreeOrient_IN);
	button_to_orient changespeedfour(bikefourOrient, bikefourleft, bikefourright, bikefourup, bikefourdown, bikefour_crash, bikefourOrient_IN);
	
	wire [31:0] bikeonepowerup_in,  biketwopowerup_in, bikethreepowerup_in, bikefourpowerup_in, bikeonepowerup_out, biketwopowerup_out, bikethreepowerup_out, bikefourpowerup_out;
	wire [31:0] background_in, background_out;
	// processor myprocessor(.masterSwitch(master_switch_help), .bikeoneOrient_IN(bikeoneOrient_IN) ,.biketwoOrient_IN(biketwoOrient_IN), .bikethreeOrient_IN(bikethreeOrient_IN), .bikefourOrient_IN(bikefourOrient_IN), .clock(clock), .reset(~resetn), .bikeone(bikeone), .bikeoneOrient(bikeoneOrient), .biketwo(biketwo), .biketwoOrient(biketwoOrient), .bikethree(bikethree),.bikethreeOrient(bikethreeOrient), .bikefour(bikefour),.bikefourOrient(bikefourOrient),.reg27(reg27));
	processor myprocessor(.masterSwitch(master_switch_help),
								.bikeoneOrient_IN(bikeoneOrient_IN) ,
								.biketwoOrient_IN(biketwoOrient_IN), 
								.bikethreeOrient_IN(bikethreeOrient_IN), 
								.bikefourOrient_IN(bikefourOrient_IN), 
								.clock(clock), 
								.reset(~resetn), 
								.bikeone(bikeone), 
								.bikeoneOrient(bikeoneOrient), 
								.biketwo(biketwo), 
								.biketwoOrient(biketwoOrient), 
								.bikethree(bikethree),
								.bikethreeOrient(bikethreeOrient),
								.bikefour(bikefour),
								.bikefourOrient(bikefourOrient),
								.reg27(reg27),
								.bikeonepowerup_in(bikeonepowerup_in),
								.biketwopowerup_in(biketwopowerup_in),
								.bikethreepowerup_in(bikethreepowerup_in),
								.bikefourpowerup_in(bikefourpowerup_in),
								.background_in(background_in),
								.bikeonepowerup_out(bikeonepowerup_out),
								.biketwopowerup_out(biketwopowerup_out),
								.bikethreepowerup_out(bikethreepowerup_out),
								.bikefourpowerup_out(bikefourpowerup_out),
								.background_out(background_out)
								);

	// keyboard controller
	PS2_Interface myps2(clock, resetn, ps2_clock, ps2_data, ps2_key_data, ps2_key_pressed, ps2_out);
	
	// lcd controller
	lcd mylcd(clock, ~resetn, 1'b1, bikeoneOrient_IN[7:0], lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);
	
	// example for sending ps2 data to the first two seven segment displays
	Hexadecimal_To_Seven_Segment hex1(ps2_out[3:0], seg1);
	Hexadecimal_To_Seven_Segment hex2(ps2_out[7:4], seg2);
	
	// VGA
	Reset_Delay			r0	(.iCLK(CLOCK_50),.oRESET(DLY_RST));
	VGA_Audio_PLL 		p1	(.areset(~DLY_RST),.inclk0(CLOCK_50),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);
	vga_controller vga_ins(.iRST_n(DLY_RST),
								 .clock(clock),
								 .iVGA_CLK(VGA_CLK),
								 .oBLANK_n(VGA_BLANK),
								 .oHS(VGA_HS),
								 .oVS(VGA_VS),
								 .b_data(VGA_B),
								 .g_data(VGA_G),
								 .r_data(VGA_R),
								 .bikeone(bikeone),
								 .bikeoneOrient(bikeoneOrient),
								 .biketwo(biketwo),
								 .biketwoOrient(biketwoOrient),
								 .bikethree(bikethree),
								 .bikethreeOrient(bikethreeOrient),
								 .bikefour(bikefour),
								 .bikefourOrient(bikefourOrient),
								 .reset(resetn),
								 .bikeone_crash(bikeone_crash),
								 .biketwo_crash(biketwo_crash),
								 .bikethree_crash(bikethree_crash),
								 .bikefour_crash(bikefour_crash),
								 .four_player_mode(four_player_mode),
								 .master_switch(~master_switch_help),
								 .background(background_out),
								 .reset_map(reset_map));
endmodule
