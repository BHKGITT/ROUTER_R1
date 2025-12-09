//class dst_agent_top extends uvm_env
class dst_agent_top extends uvm_env;

	//factory registration
	`uvm_component_utils(dst_agent_top)
	
	//declare handle for dst_agent and evn_config
	dst_agent dst_agt[];
	env_config env_cfg;

	//Methods

	extern function new(string name = "dst_agent_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	//extern task run_phase(uvm_phase phase);
  endclass
 
	//constructor new method
	function dst_agent_top::new(string name = "dst_agent_top" , uvm_component parent);
		super.new(name,parent);
	endfunction


	//build_phase
	function void dst_agent_top::build_phase(uvm_phase phase);
		if(!(uvm_config_db#(env_config)::get(this,"","env_config",env_cfg)))
	  	`uvm_fatal("env_cfg","get is failed")
	
		dst_agt=new[env_cfg.no_of_dst_agents];
	
		foreach(dst_agt[i])
	   		begin
				dst_agt[i]=dst_agent::type_id::create($sformatf("dst_agt[%0d]",i) ,this);
	        
				uvm_config_db #(dst_agent_config)::set(this,$sformatf("dst_agt[%0d]*",i),  "dst_agent_config", env_cfg.d_cfg[i]);
	   		end
	endfunction
