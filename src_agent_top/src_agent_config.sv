//extend src_agent_config from uvm_object
 
class src_agent_config extends uvm_object;

	//factory registration
	`uvm_object_utils(src_agent_config)

	//declare is_active
	uvm_active_passive_enum is_active=UVM_ACTIVE;

	virtual router_if vif;
	//methods 
	extern function new(string name = "src_agent_config");

endclass

//constructor new method
function src_agent_config::new(string name = "src_agent_config");
	super.new(name);
endfunction
