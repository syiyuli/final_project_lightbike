module vga_controller(iRST_n,
                      iVGA_CLK,
                      oBLANK_n,
                      oHS,
                      oVS,
                      b_data,
                      g_data,
                      r_data,
							 //bikeOrient
							 );

	
input iRST_n;
input iVGA_CLK;
//input[1:0] bikeOrient;
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

wire[23:0] bikeLocation;
assign bikeOrient = 2'd1;
assign bikeLocation = 24'd12000;

wire inBike;
checkXbyY checkBikeLoc(.X(30),.Y(30),.startaddr(bikeLocation),.addr(ADDR),.out(inBike));

wire[18:0] ADDRbike, ADDRbikeHelp;
convertAddr getBikeAddr(.startaddr(bikeLocation),.addr(ADDR),.orient(bikeOrient),.memAddr(ADDRbikeHelp));

assign ADDRbike = inBike ? ADDRbikeHelp : 19'd1;

assign VGA_CLK_n = ~iVGA_CLK;
img_data	img_data_inst (
	.address ( ADDRbike ),
	.clock ( VGA_CLK_n ),
	.q ( index )
	);
	
/////////////////////////
//////Add switch-input logic here
	
//////Color table output
wire[23:0] bgr_data_help;

img_index	img_index_inst (
	.address ( index ),
	.clock ( iVGA_CLK ),
	.q ( bgr_data_help)
	);	

assign bgr_data_raw = inBike ? bgr_data_help : 24'h000000;
//307200 words


//////
//////latch valid data at falling edge;
always@(posedge VGA_CLK_n) bgr_data <= bgr_data_raw;
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
 	















