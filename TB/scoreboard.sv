
class scoreboard extends uvm_scoreboard;

	// Factory registration
	`uvm_component_utils(scoreboard)

	uvm_tlm_analysis_fifo #(src_xtn) fifo_srh[];
  	uvm_tlm_analysis_fifo #(dst_xtn) fifo_dsh[];

	env_config env_cfg;
	src_xtn src_data;
	dst_xtn dst_data;

	src_xtn src_cov_data;
	dst_xtn dst_cov_data;	

covergroup router_fcov1;
option.per_instance=1;

 	ADDR : coverpoint src_cov_data.header[1:0] {
					bins addr0 = {0};
					bins addr1 = {1};
					bins addr2 = {2};
				}
	PAYLOAD : coverpoint src_cov_data.header[7:2] {
                  			 bins small_packet  =  {[1:15]};
		   			 bins medium_packet =  {[16:30]};
 		   			 bins large_packet =  {[31:63]};
		   		 }
	PARITY : coverpoint src_cov_data.err {
                  			 bins no_error  =  {0};
		   			 bins error =  {1};
		   		 }
endgroup

covergroup router_fcov2;
option.per_instance=1;

 	ADDR : coverpoint dst_cov_data.header[1:0] {
					bins addr0 = {0};
					bins addr1 = {1};
					bins addr2 = {2};
				}
	PAYLOAD : coverpoint dst_cov_data.header[7:2] {
                  			 bins small_packet  =  {[1:15]};
		   			 bins medium_packet =  {[16:30]};
 		   			 bins large_packet =  {[31:63]};
		   		 }
endgroup


	//Methods
	extern function new(string name="scoreboard",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task compare_data(src_xtn src,dst_xtn dst);
	extern function void report_phase(uvm_phase phase);

endclass

//constructor new method
function scoreboard::new(string name="scoreboard",uvm_component parent);
		super.new(name,parent);

		router_fcov1 =new();
		router_fcov2= new(); 
endfunction

function void scoreboard::build_phase(uvm_phase phase);
  	super.build_phase(phase);
    	env_cfg=env_config::type_id::create("env_cfg");
     	if(!uvm_config_db#(env_config)::get(this," ","env_config",env_cfg))
       `uvm_fatal("TB CONFIG","cannot get config")

	fifo_srh=new[env_cfg.no_of_src_agents];
  	fifo_dsh=new[env_cfg.no_of_dst_agents];
	
	foreach(fifo_srh[i])
   	fifo_srh[i]=new($sformatf("fifo_srh[%0d]",i),this);
	foreach(fifo_dsh[i])
   	fifo_dsh[i]=new($sformatf("fifo_dsh[%0d]",i),this);

endfunction


task scoreboard::run_phase(uvm_phase phase);
   forever
      begin
        fork
              begin:A
                   fifo_srh[0].get(src_data);
                   src_data.print();
		   src_cov_data = src_data;
		   router_fcov1.sample();
              end
              begin:B
                fork
                  begin
                   fifo_dsh[0].get(dst_data);
                   dst_data.print();
                   compare_data(src_data,dst_data);
		   dst_cov_data = dst_data;
		   router_fcov2.sample();

                  end
                  begin
                   fifo_dsh[1].get(dst_data);
                   dst_data.print();
                   compare_data(src_data,dst_data);
		   dst_cov_data = dst_data;
    		   router_fcov2.sample();

                  end
                  begin
                   fifo_dsh[2].get(dst_data);
                   dst_data.print();
                   compare_data(src_data,dst_data);
		   dst_cov_data = dst_data;
    		   router_fcov2.sample();

                  end
              join_any
              disable fork;
             end
          join
        end
endtask

task scoreboard::compare_data(src_xtn src,dst_xtn dst);
	src=src_xtn::type_id::create("src");
	dst=dst_xtn::type_id::create("dst");
  if(src.header==dst.header)
	
    `uvm_info("SCOREBOARD","header data match",UVM_LOW)
  else
     `uvm_info("SCOREBOARD","header data mismatch",UVM_LOW)

  foreach(src.payload[i])

  if(src.payload[i]==dst.payload[i])
    `uvm_info("SCOREBOARD","payload data match",UVM_LOW)
  else
    `uvm_info("SCOREBOARD","payload data mismatch",UVM_LOW)

endtask

function void scoreboard::report_phase(uvm_phase phase);
   `uvm_info("ROUTER_SCOREBOARD","this is scoreboard phase",UVM_LOW)
endfunction

