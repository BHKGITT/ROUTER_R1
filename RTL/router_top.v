module router_top(input clk,rst,pkt_vld,re_enb_0,re_enb_1,re_enb_2,
input [7:0] d_in,
output busy,error,
output valid_out_0,valid_out_1,valid_out_2,
output [7:0]data_out_0,data_out_1,data_out_2);

wire [2:0] write_enb;
wire [7:0]d_out;



router_fsm FSM ( clk,rst,pkt_vld,fifo_full,low_pkt_valid,parity_done,d_in[1:0],soft_reset_0,soft_reset_1,soft_reset_2,
				empty_0,empty_1,empty_2,
				detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy);

	
router_syn SYNC ( clk,rst,detect_add,write_enb_reg,re_enb_0,re_enb_1,re_enb_2,d_in[1:0],
						empty_0,empty_1,empty_2,full_0,full_1,full_2,write_enb,
						valid_out_0,valid_out_1,valid_out_2, fifo_full, soft_reset_0,soft_reset_1,soft_reset_2);
	

router_reg REG(clk,rst,pkt_vld,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,d_in,
					parity_done,low_pkt_valid,error,d_out);
	
		
router_fifo FIFO_0(clk,rst,soft_reset_0,write_enb[0],re_enb_0,d_out,lfd_state,data_out_0,full_0,empty_0);
router_fifo FIFO_1(clk,rst,soft_reset_1,write_enb[1],re_enb_1,d_out,lfd_state,data_out_1,full_1,empty_1);

router_fifo FIFO_2(clk,rst,soft_reset_2,write_enb[2],re_enb_2,d_out,lfd_state,data_out_2,full_2,empty_2);



endmodule
