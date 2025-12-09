class dst_agent_config extends uvm_object;

	//factory registration
	`uvm_object_utils(dst_agent_config)

	//declare is_active
	uvm_active_passive_enum is_active=UVM_ACTIVE;

	virtual router_if vif;

	
	//methods 
	extern function new(string name = "dst_agent_config");

endclass

//constructor new method
function dst_agent_config::new(string name = "dst_agent_config");
	super.new(name);
endfunction
