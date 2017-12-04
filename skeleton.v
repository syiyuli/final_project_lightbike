module skeleton(resetn, 
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
	input				master_switch;
	input				reset_map;
	
	////////////////////////	PS2	////////////////////////////
	input 			resetn;
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
	wire [7:0] ps2_out_mod1;
	wire [7:0] ps2_out_mod2;
	wire [7:0] ps2_out_mod3;
	wire [7:0] ps2_out_modfinal;	
	
	// clock divider (by 5, i.e., 10 MHz)
	pll div(CLOCK_50,inclock);
	// pll div2(inclock,inclock2);
	// assign clock = CLOCK_50;
	
	// UNCOMMENT FOLLOWING LINE AND COMMENT ABOVE LINE TO RUN AT 50 MHz
	assign clock = inclock;
	
	// your processor
	wire bikeoneleft, bikeoneright, bikeoneup, bikeonedown, biketwoleft, biketworight, biketwoup, biketwodown;
	wire [7:0] oneleft, oneright, oneup, onedown, twoleft, tworight, twoup, twodown;
	assign oneleft = 8'h1c;
	assign oneright = 8'h23;
	assign oneup = 8'h1d;
	assign onedown = 8'h1b;
	assign twoleft = 8'h2b;
	assign tworight = 8'h33;
	assign twoup = 8'h2c;
	assign twodown = 8'h34;
	bike_controls bike_controls_one(bikeoneleft,bikeoneright,bikeoneup,bikeonedown,oneleft,oneright,oneup,onedown,ps2_key_pressed, ps2_key_data);
	bike_controls bike_controls_two(biketwoleft,biketworight,biketwoup,biketwodown,twoleft,tworight,twoup,twodown,ps2_key_pressed, ps2_key_data);

	// May Have to do Edge Detection for Bikes themselves	
	wire [31:0] bikeone, bikeoneOrient, bikeoneOrient_IN, biketwoOrient_IN, bikethreeOrient_IN, bikefourOrient_IN, biketwo, biketwoOrient, bikethree, bikethreeOrient, bikefour, bikefourOrient;
	wire master_switch_help, bikeone_bounded, biketwo_bounded, edge_detected, final_edge;
	checkScreenBound checkBikeone(.addr(bikeone),.orient(bikeoneOrient),.out(bikeone_bounded));
	checkScreenBound checkBiketwo(.addr(biketwo),.orient(biketwoOrient),.out(biketwo_bounded));
	edge_clock edge_clock_1(VGA_CLK, resetn, edge_detected, final_edge);
	and masterFinal(master_switch_help, master_switch, ~bikeone_bounded, ~biketwo_bounded, ~final_edge);
	
	button_to_orient changespeedone(bikeoneOrient, bikeoneleft, bikeoneright, bikeoneup, bikeonedown, bikeoneOrient_IN);
	button_to_orient changespeedtwo(biketwoOrient, biketwoleft, biketworight, biketwoup, biketwodown, biketwoOrient_IN);
	processor myprocessor(.masterSwitch(master_switch_help), .bikeoneOrient_IN(bikeoneOrient_IN) ,.biketwoOrient_IN(biketwoOrient_IN), .bikethreeOrient_IN(bikethreeOrient_IN), .bikefourOrient_IN(bikefourOrient_IN), .clock(clock), .reset(~resetn), .bikeone(bikeone), .bikeoneOrient(bikeoneOrient), .biketwo(biketwo), .biketwoOrient(biketwoOrient), .bikethree(bikethree),.bikethreeOrient(bikethreeOrient), .bikefour(bikefour),.bikefourOrient(bikefourOrient),.reg27(reg27));
	
	// keyboard controller
	PS2_Interface myps2(clock, resetn, ps2_clock, ps2_data, ps2_key_data, ps2_key_pressed, ps2_out);
	
	// lcd controller
	lcd mylcd(clock, ~resetn, 1'b1, bikeoneOrient_IN[7:0], lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);
	
	// example for sending ps2 data to the first two seven segment displays
	Hexadecimal_To_Seven_Segment hex1(ps2_out[3:0], seg1);
	Hexadecimal_To_Seven_Segment hex2(ps2_out[7:4], seg2);
	
	// the other seven segment displays are currently set to 0
	Hexadecimal_To_Seven_Segment hex3(4'b0, seg3);
	Hexadecimal_To_Seven_Segment hex4(4'b0, seg4);
	Hexadecimal_To_Seven_Segment hex5(4'b0, seg5);
	Hexadecimal_To_Seven_Segment hex6(4'b0, seg6);
	Hexadecimal_To_Seven_Segment hex7(4'b0, seg7);
	Hexadecimal_To_Seven_Segment hex8(4'b0, seg8);
	
	// some LEDs that you could use for debugging if you wanted
	assign leds = 8'b00101011;
	
	// VGA
	Reset_Delay			r0	(.iCLK(CLOCK_50),.oRESET(DLY_RST));
	VGA_Audio_PLL 		p1	(.areset(~DLY_RST),.inclk0(CLOCK_50),.c0(VGA_CTRL_CLK),.c1(AUD_CTRL_CLK),.c2(VGA_CLK)	);
	vga_controller vga_ins(.iRST_n(DLY_RST),
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
								 .edge_detected(edge_detected),
								 .reset_map(reset_map));
endmodule
