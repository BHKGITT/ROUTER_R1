
module router_fifo(input clk,rst,soft_reset,we_enb,re_enb,
	input [7:0]d_in,
	input lfd_state,
	output reg [7:0] data_out,
	output full,empty);
reg [4:0]we_ptr,re_ptr;
reg [8:0] mem[15:0];
reg [5:0] fifo_count;
reg lfd_s;
integer i,j;

always@(posedge clk)
  begin
    if(rst==1'b1)
	   lfd_s<=1'b0;
		else
		lfd_s<=lfd_state;
   end
always@(posedge clk)
	begin
		if(!rst)
		begin
			//data_out <=0;
			we_ptr <=0;
		for(i=0;i<16;i=i+1)
			mem[i] <= 0;
		end
		else if(soft_reset)
			for(j=0;j<16;j=j+1)
				mem[i] <=0;
			
		else if(we_enb && !full)
			begin
				mem[we_ptr[3:0]] <={lfd_s,d_in};
				we_ptr <=we_ptr+1'b1;
			end
	end
always@(posedge clk)
	begin 
		if(!rst) begin
			data_out<=8'b0;
			re_ptr <=0;
			end
		else if(soft_reset)
		begin			
			re_ptr <=0;
			data_out <={8{1'bz}};
		end	
		else if(re_enb && !empty)
			begin
				data_out <= mem[re_ptr[3:0]][7:0];
				re_ptr <= re_ptr+1'b1;

			end
		else if(!full && empty && fifo_count==1'd0)
		data_out <={8{1'bz}};
	end
always@(posedge clk)
begin
	if(rst==1'b0)
		fifo_count <=5'b0;
	else if(soft_reset ==1'b1)
		fifo_count <=1'b0;
	else if(lfd_s==1'b1)
		fifo_count <= mem[re_ptr[3:0]][7:2]+1'b1;
	else if(re_enb==1'b1)
		begin
			if(mem[re_ptr[3:0]][8]==1'b1)
				fifo_count <= fifo_count;
			else 
				fifo_count <= fifo_count-1'b1;
				end
	else 
		fifo_count <=0;
end
assign  full=(we_ptr=={~re_ptr[4],re_ptr[3:0]});
assign empty=(we_ptr == re_ptr);			
endmodule
