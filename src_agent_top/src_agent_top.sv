
//class src_agent_top extends uvm_env
class src_agent_top extends uvm_env;

	//factory registration
	`uvm_component_utils(src_agent_top)
	
	//declare handle for src_agent and evn_config
	src_agent src_agt[];
	env_config env_cfg;

	//Methods
	extern function new(string name = "src_agent_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	//extern task run_phase(uvm_phase phase);
endclass
 
	//constructor new method
	function src_agent_top::new(string name = "src_agent_top" , uvm_component parent);
		super.new(name,parent);
	endfunction

	//build_phase
	function void src_agent_top::build_phase(uvm_phase phase);
		if(!(uvm_config_db#(env_config)::get(this,"","env_config",env_cfg)))
	  	`uvm_fatal("env_cfg","get is failed")
	
		src_agt=new[env_cfg.no_of_src_agents];
		//$display("env_cfg.no_of_src_agents=%0d",env_cfg.no_of_src_agents);
		foreach(src_agt[i])
	   		begin
				src_agt[i]=src_agent::type_id::create($sformatf("src_agt[%0d]",i) ,this);
	        		//$display("src_agent_config[%0d]=%p",i,env_cfg.s_cfg[i]);
				uvm_config_db #(src_agent_config)::set(this,$sformatf("src_agt[%0d]*",i),  "src_agent_config", env_cfg.s_cfg[i]);
	   		end
	endfunction
