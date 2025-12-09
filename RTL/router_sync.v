

//////////////////////////////////////////////////////////////////////////////////
   module router_syn(input clk,rst,detect_add,write_enb_reg,
	input  read_0,read_1,read_2,
	input [1:0]d_in,
	input  empty_0,empty_1,empty_2,full_0,full_1,full_2,
	output reg [2:0]write_enb,
	output valid_out_0,valid_out_1,valid_out_2,
	output reg fifo_full,
	output  reg soft_reset_0,soft_reset_1,soft_reset_2);
	reg [4:0] count_0,count_1,count_2;
	reg [1:0]addr;
always@(posedge clk)
begin 
		if(rst==1'b0)
			addr <=0  ;
		else if(detect_add==1'b1)
			addr  <= d_in ;
		end
always@(*)
	begin 
		if(write_enb_reg ==1'b1)
		//begin 
		case(addr)
		2'b00:write_enb=3'b001;
		2'b01:write_enb=3'b010;
		2'b10:write_enb=3'b100;
		default :write_enb=3'b000;
		endcase 
		//end
		else 
		write_enb=1'b0;
	end
always@(*)
	begin 
		case(addr)
		 2'b00:fifo_full =full_0;
		 2'b01:fifo_full =full_1;
		 2'b10:fifo_full =full_2;
		 default:fifo_full  = 0;
		endcase
	end 
 
		assign valid_out_0= ~empty_0;
		assign valid_out_1= ~empty_1;
		assign valid_out_2= ~empty_2;
always@(posedge clk)
begin
	if(rst==1'b0)begin
		count_0 <=0;
		soft_reset_0 <=0;end
		
	else if(valid_out_0==1'b0) begin
			count_0 <=0;
			soft_reset_0 <=0;end
	else if(read_0==1'b0)
			begin 
			if(count_0==5'd29)begin
			count_0 <=0;
			soft_reset_0 <=1;end
			else
			count_0 <=count_0+1'b1;
			end
		else 
		begin
			count_0 <=0;
			soft_reset_0 <=0;
			end
end
always@(posedge clk)
begin
	if(rst==1'b0)begin
		count_1 <=0;
		soft_reset_1 <=0;end
		
	else if(valid_out_1==1'b0) begin
			count_1 <=0;
			soft_reset_1 <=0;end
	else if(read_1==1'b0)
			begin 
			if(count_1==5'd29)begin
			count_1 <=0;
			soft_reset_1 <=1;end
			else
			count_1 <=count_1+1'b1;
			end
		else 
		begin
			count_1 <=0;
			soft_reset_1 <=0;
			end
end
always@(posedge clk)
begin
	if(rst==1'b0)begin
		count_2 <=0;
		soft_reset_2 <=0;end
		
	else if(valid_out_2==1'b0) begin
			count_2 <=0;
			soft_reset_2 <=0;end
	else if(read_2==1'b0)
			begin 
			if(count_2==5'd29)begin
			count_2 <=0;
			soft_reset_2 <=1;end
			else
			count_2 <=count_0+1'b1;
			end
		else 
		begin
			count_2 <=0;
			soft_reset_2 <=0;
			end
			
end
endmodule
