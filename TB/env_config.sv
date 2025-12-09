
// extend env_config from uvm_object

class env_config extends uvm_object;

//declare handle of src_agent_config and dst_agent_config
src_agent_config s_cfg[];
dst_agent_config d_cfg[];

int no_of_src_agents=1;
int no_of_dst_agents=3;

//factory registration
`uvm_object_utils(env_config)

//Methods
extern function new(string name = "env_config");

endclass

//constructor new method
function env_config::new(string name = "env_config");
  super.new(name);
endfunction
