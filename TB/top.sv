module rout_top;

	import uvm_pkg::*;
	import test_pkg::*; 


//	`include "uvm_macros.svh"

	bit clock;  
	always 
		#5 clock=!clock;  
	

	router_if src_if0(clock);
   	router_if dst_if0(clock);
   	router_if dst_if1(clock);
   	router_if dst_if2(clock);

	router_top DUT(.clk(clock),
			.pkt_vld(src_if0.pkt_valid),
			.rst(src_if0.resetn),
			.error(src_if0.error),
			.busy(src_if0.busy),
			.d_in(src_if0.d_in),
			.data_out_0(dst_if0.d_out),.data_out_1(dst_if1.d_out),.data_out_2(dst_if2.d_out),
			.valid_out_0(dst_if0.valid_out),.valid_out_1(dst_if1.valid_out),.valid_out_2(dst_if2.valid_out),
			.re_enb_0(dst_if0.read_enb),.re_enb_1(dst_if1.read_enb),.re_enb_2(dst_if2.read_enb));


 initial
	begin	

			`ifdef VCS
         		$fsdbDumpvars(0,rout_top);
        		`endif


		uvm_config_db #(virtual router_if)::set(null,"*","src_if0",src_if0);
		uvm_config_db #(virtual router_if)::set(null,"*","dst_if0",dst_if0);
		uvm_config_db #(virtual router_if)::set(null,"*","dst_if1",dst_if1);
		uvm_config_db #(virtual router_if)::set(null,"*","dst_if2",dst_if2);
 
		run_test();
	end
     
endmodule
