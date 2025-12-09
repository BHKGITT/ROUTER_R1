
//class src_agent extends from uvm_agent

class src_agent extends uvm_agent;

	// Factory Registration
	`uvm_component_utils(src_agent)

	//handle of src_agent_config
	src_agent_config s_cfg;

	//handle for src_driver,src_monitor,src_sequencer
	src_driver drvh;
	src_monitor monh;
	src_sequencer src_seqrh;

//Methods
 extern function new(string name= "src_agent", uvm_component parent);
 extern function void build_phase(uvm_phase phase);
 extern function void connect_phase(uvm_phase phase);

endclass

//constructor new method
	function src_agent::new(string name="src_agent", uvm_component parent);
		super.new(name,parent);
	endfunction

//build phase
	function void src_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db#(src_agent_config)::get(this,"","src_agent_config",s_cfg))
		`uvm_fatal("s_cfg","get is failed")
			monh=src_monitor::type_id::create("monh",this);
				if(is_active==UVM_ACTIVE)
					begin
						drvh=src_driver::type_id::create("drvh",this);
						src_seqrh=src_sequencer::type_id::create("src_seqrh",this);
					end
	endfunction

//connect phase
	function void src_agent::connect_phase(uvm_phase phase);
		if(s_cfg.is_active==UVM_ACTIVE)
			begin
				drvh.seq_item_port.connect(src_seqrh.seq_item_export);
			end
	endfunction
