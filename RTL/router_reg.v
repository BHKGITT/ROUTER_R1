module router_reg(input clk,rst,pkt_vld,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,
	input[7:0]d_in,
	output reg parity_done,low_pkt_vld,error,
	output reg [7:0]d_out);
 
reg[7:0] header,internal_parity,packet_parity,full_state_byte;


//output_logic          
always@(posedge clk)
begin 
	if(rst==1'b0)
		d_out <= 8'b0;
	else if(detect_add && pkt_vld && d_in[1:0]!=3)
		d_out <=d_out;
	else if(lfd_state ==1'b1)
		d_out <=header;
	else if(ld_state && !fifo_full)
		d_out <=d_in;
	else if(ld_state && fifo_full)
		d_out <=d_out;
	else if(laf_state)
		d_out <= full_state_byte;
	else 
		d_out <= d_out;
end

//header logic
 always@(posedge clk)
begin
if(rst==1'b0)
	header <=8'b0;
else if(detect_add && pkt_vld && d_in[1:0]!=2'd3)
	header <= d_in;
else 
	header <= header;
end

//full_state_byte
 always@(posedge clk)
begin
if(rst==1'b0)
	full_state_byte <=8'b0;
else if(fifo_full == 1'b1)
	full_state_byte<= d_in;

end 

//internal parity

always@(posedge clk)
begin 
	if(rst==1'b0)
		internal_parity <= 8'b0;
		
	else if(detect_add ==1'b1)
		internal_parity <= 8'b0;
	else if(lfd_state==1'b1)
		internal_parity <= internal_parity ^ header;
	else if(pkt_vld && ld_state && ~full_state)
		internal_parity <= internal_parity ^ d_in;
	else 	
		internal_parity <= internal_parity;
end 

//packet parity
always@(posedge clk)
begin 
	if(rst==1'b0)
		packet_parity<= 8'b0;
	else if(detect_add == 1'b1)
		packet_parity <= 8'b0;
	else if(ld_state && ~pkt_vld )
			packet_parity <= d_in;
	else
			packet_parity <=packet_parity;
end

//parity done
always@(posedge clk)
begin
if(rst==1'b0)
	parity_done <=1'b0;
else if ((ld_state && !pkt_vld && !fifo_full)||(laf_state && low_pkt_vld && parity_done ==1'b0))
	parity_done <=1'b1;
else if(detect_add == 1'b1)
	parity_done <=1'b0;
	
	
end
//low packet valid 
always@(posedge clk)
begin
	if(rst==1'b0)
	low_pkt_vld <=1'b0;
	else if(rst_int_reg ==1'b1)
	low_pkt_vld <=1'b0;
	else if((ld_state ==1'b1) && (pkt_vld ==1'b0))
	low_pkt_vld <=1'b1;
end 
//error logic
always@(posedge clk)
begin
if(rst==1'b0)
	error <=1'b0;
else if((parity_done==1'b1) && (packet_parity != internal_parity ))
	error <=1'b1;
else
	error<=1'b0;
end	
endmodule
