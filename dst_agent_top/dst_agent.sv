
//class dst_agent extends from uvm_agent

class dst_agent extends uvm_agent;

	// Factory Registration
	`uvm_component_utils(dst_agent)

	//handle of dst_agent_config
	dst_agent_config d_cfg;

	//handle for dst_driver,dst_monitor,dst_sequencer
	dst_driver drvh;
	dst_monitor monh;
	dst_sequencer dst_seqrh;

//Methods
 	extern function new(string name= "dst_agent", uvm_component parent);
 	extern function void build_phase(uvm_phase phase);
 	extern function void connect_phase(uvm_phase phase);

endclass

	//constructor new method
	function dst_agent::new(string name="dst_agent", uvm_component parent);
	super.new(name,parent);
	endfunction

	//build phase
	function void dst_agent::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db#(dst_agent_config)::get(this,"","dst_agent_config",d_cfg)))
		`uvm_fatal("d_cfg","get is failed")
			monh=dst_monitor::type_id::create("monh",this);
		if(is_active==UVM_ACTIVE)
			begin
				drvh=dst_driver::type_id::create("drvh",this);
				dst_seqrh=dst_sequencer::type_id::create("dst_seqrh",this);
			end
	endfunction



	//connect phase
	function void dst_agent::connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if(d_cfg.is_active==UVM_ACTIVE)
			begin
				drvh.seq_item_port.connect(dst_seqrh.seq_item_export);
			end
	endfunction
