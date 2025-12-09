// Extend env from uvm_env
class env extends uvm_env;

 	// Factory Registration
     	`uvm_component_utils(env)
	
	env_config env_cfg;
	
	//declare handle for src_agent_top, dst_agent_top and scoreboard
	src_agent_top src_top;
	dst_agent_top dst_top;
	scoreboard sb;
	

	//Methods
	extern function new(string name = "env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	
endclass

//constructor new method
function env::new(string name = "env", uvm_component parent);
	super.new(name,parent);
endfunction

//build_phase
function void env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	// get the config object using uvm_config_db 
	  if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
		`uvm_fatal("CONFIG","cannot get() from env_config")

	src_top=src_agent_top::type_id::create("src_top",this);

	dst_top=dst_agent_top::type_id::create("dst_top",this);

	sb=scoreboard::type_id::create("sb",this);
	

endfunction

	function void env::connect_phase(uvm_phase phase);
 	 	super.connect_phase(phase);

		foreach(src_top.src_agt[i])
			src_top.src_agt[i].monh.monitor_port.connect(sb.fifo_srh[i].analysis_export);
		foreach(dst_top.dst_agt[i])
			dst_top.dst_agt[i].monh.monitor_port.connect(sb.fifo_dsh[i].analysis_export);
endfunction 
