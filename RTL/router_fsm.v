module router_fsm( input clk,rst,pkt_vld,fifo_full,low_pkt_valid,parity_done,
 input [1:0]d_in,
 input soft_reset_0,soft_reset_1,soft_reset_2,
 input fifo_empty_0,fifo_empty_1,fifo_empty_2,
 output detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy);
 
 parameter DECODE_ADD= 3'b000,
				LOAD_FIRST_DATA=3'b001,
				WAIT_TILL_EMPTY=3'b010,
				LOAD_DATA=3'b011,
				LOAD_PARITY=3'b100,
				CHECK_PARITY_ERROR=3'b101,
				FIFO_FULL_STATE=3'b110,
				LOAD_AFTER_FULL=3'b111;
 reg [2:0]p_s,n_s;
 reg [1:0] addr;
 always@(posedge clk)
 begin
if(rst==1'b0)
	p_s<=DECODE_ADD;
else if(soft_reset_0||soft_reset_1||soft_reset_2)
	p_s<=DECODE_ADD;            
else
	p_s <= n_s;
end
always@(posedge clk)begin
	if(rst==1'b0)
		addr <=2'b0;
	else if(soft_reset_0||soft_reset_1||soft_reset_2)
		addr<=2'b0;
	else 
		addr<=d_in;
	end
always@(*)
begin
	n_s=DECODE_ADD;
	case(p_s)
	DECODE_ADD: begin if((pkt_vld &(d_in[1:0]==0) & fifo_empty_0)||
						(pkt_vld &(d_in[1:0]==1) & fifo_empty_1)||
						(pkt_vld &(d_in[1:0]==2) & fifo_empty_2))
					    n_s=LOAD_FIRST_DATA;
					else if((pkt_vld &(d_in[1:0]==0) & ! fifo_empty_0)||
						(pkt_vld &(d_in[1:0]==1) & ! fifo_empty_1)||
						(pkt_vld &(d_in[1:0]==2) & ! fifo_empty_2))
						n_s=WAIT_TILL_EMPTY;
					else
						n_s=DECODE_ADD; end
	WAIT_TILL_EMPTY:begin if(fifo_empty_0 && (addr==0)||
							fifo_empty_1 && (addr==1)||
							fifo_empty_2 && (addr==2)) n_s=LOAD_FIRST_DATA;
						else 
							n_s=WAIT_TILL_EMPTY; end
	
	LOAD_FIRST_DATA:n_s=LOAD_DATA;
	LOAD_DATA:begin if(fifo_full) n_s=FIFO_FULL_STATE;
				else if(!fifo_full && !pkt_vld) n_s=LOAD_PARITY;
				else n_s=LOAD_DATA; end
	FIFO_FULL_STATE:begin if(!fifo_full) n_s=LOAD_AFTER_FULL;
						  else if (fifo_full) n_s=FIFO_FULL_STATE; end
	
	LOAD_AFTER_FULL:begin if(!parity_done && !low_pkt_valid)
								n_s=LOAD_DATA;
							else if(!parity_done && low_pkt_valid)
							n_s=LOAD_PARITY;
						else if(parity_done) n_s=DECODE_ADD; end
	LOAD_PARITY: n_s=CHECK_PARITY_ERROR;
	CHECK_PARITY_ERROR:begin if(!fifo_full) n_s=DECODE_ADD;
							else if(fifo_full) n_s=FIFO_FULL_STATE; end 
							endcase
	end
	assign busy=((p_s ==DECODE_ADD)||(p_s==LOAD_DATA) )? 1'b0:1'b1;
	assign detect_add=(p_s==DECODE_ADD) ?1'b1:1'b0;
	assign ld_state=(p_s==LOAD_DATA) ?1'b1:1'b0;
	assign laf_state=(p_s==LOAD_AFTER_FULL)?1'b1:1'b0;
	assign full_state=(p_s==FIFO_FULL_STATE)?1'b1:1'b0;
	assign write_enb_reg=((p_s==LOAD_DATA)||(p_s==LOAD_PARITY)||(p_s==LOAD_AFTER_FULL))?1'b1:1'b0;
	assign rst_int_reg=(p_s==CHECK_PARITY_ERROR)?1'b1:1'b0;
	assign lfd_state=(p_s==LOAD_FIRST_DATA)?1'b1:1'b0;
	
endmodule
