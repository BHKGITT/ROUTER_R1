// Extend ram_base_test from uvm_test;
class base_test extends uvm_test;

 	// Factory Registration
	`uvm_component_utils(base_test)
	
	// Handles for ram_tb & ram_env_config
    	env envh;
        env_config env_cfg;
	src_agent_config s_cfg[];
	dst_agent_config d_cfg[];
	
	int no_of_src_agents=1;
	int no_of_dst_agents=3;

	uvm_active_passive_enum is_active=UVM_ACTIVE;

	//Methods
	extern function new(string name = "base_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
endclass

// Constructor new() function
function base_test::new(string name = "base_test" , uvm_component parent);
	super.new(name,parent);
endfunction

//build_phase
function void base_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
	env_cfg=env_config::type_id::create("env_cfg");
		
	s_cfg = new[no_of_src_agents];
	env_cfg.s_cfg=new[no_of_src_agents];

	foreach(s_cfg[i])
	  begin 
	    s_cfg[i]=src_agent_config::type_id::create($sformatf("s_cfg[%0d]",i));
 	    if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("src_if%0d",i),s_cfg[i].vif))
            `uvm_fatal("vif","getting is failed")				
	    s_cfg[i].is_active=UVM_ACTIVE;
            env_cfg.s_cfg[i]=s_cfg[i];
	  end


	d_cfg = new[no_of_dst_agents];
	env_cfg.d_cfg=new[no_of_dst_agents];

	foreach(d_cfg[i])
	  begin 
	    d_cfg[i]=dst_agent_config::type_id::create($sformatf("d_cfg[%0d]",i));
	    if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("dst_if%0d",i),d_cfg[i].vif))
            `uvm_fatal("vif","getting is failed")
	    d_cfg[i].is_active=UVM_ACTIVE;
	     env_cfg.d_cfg[i]=d_cfg[i];

	end
	 
	env_cfg.no_of_src_agents=no_of_src_agents;
	env_cfg.no_of_dst_agents=no_of_dst_agents;

	uvm_config_db #(env_config)::set(this,"*","env_config",env_cfg);
	  	
	envh=env::type_id::create("envh", this);
endfunction

function void base_test::end_of_elaboration_phase(uvm_phase phase);
	
	uvm_top.print_topology();
endfunction

//Extend small_test from base_test
class small_test extends base_test;

	//factory registration
	`uvm_component_utils(small_test)

	bit [1:0] addr;

	// Declare the handle for  small_packet sequence
	 small_packet s_seq;
	 normal_sequence n_seq;
	 
	// Standard UVM Methods:
 	extern function new(string name = "small_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

// Define Constructor new() function
function small_test::new(string name = "small_test" , uvm_component parent);
	super.new(name,parent);
endfunction

//build() phase method
function void small_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//run_phase
task small_test::run_phase(uvm_phase phase);
   	phase.raise_objection(this);
	s_seq=small_packet::type_id::create("s_seq");
	n_seq=normal_sequence::type_id::create("n_seq");
    	addr=$random%3;
	uvm_config_db #(bit [1:0])::set(this,"*","bit [1:0]",addr);
	//foreach(envh.src_top.src_agt[i])
	fork
 	s_seq.start(envh.src_top.src_agt[0].src_seqrh);
	n_seq.start(envh.dst_top.dst_agt[addr].dst_seqrh);
	join
	#100;
	phase.drop_objection(this);
endtask

//Extend medium_test from base_test
class medium_test extends base_test;

	//factory registration
	`uvm_component_utils(medium_test)

	bit [1:0] addr;

	// Declare the handle for  medium_packet sequence
	 medium_packet m_seq;
	 normal_sequence n_seq;

	// Standard UVM Methods:
 	extern function new(string name = "medium_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

// Define Constructor new() function
function medium_test::new(string name = "medium_test" , uvm_component parent);
	super.new(name,parent);
endfunction

//build() phase method
function void medium_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//run_phase
task medium_test::run_phase(uvm_phase phase);
   	phase.raise_objection(this);
	m_seq=medium_packet::type_id::create("m_seq");
	n_seq=normal_sequence::type_id::create("n_seq");
    	addr=2'b01;
	uvm_config_db #(bit [1:0])::set(this,"*","bit [1:0]",addr);
	foreach(envh.src_top.src_agt[i])
 	m_seq.start(envh.src_top.src_agt[i].src_seqrh);
	#100;
	phase.drop_objection(this);
endtask

//Extend large_test from base_test
class large_test extends base_test;

	//factory registration
	`uvm_component_utils(large_test)

	bit [1:0] addr;

	// Declare the handle for  large_test sequence
	 large_packet l_seq;
	 normal_sequence n_seq;

	// Standard UVM Methods:
 	extern function new(string name = "large_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

// Define Constructor new() function
function large_test::new(string name = "large_test" , uvm_component parent);
	super.new(name,parent);
endfunction

//build() phase method
function void large_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//run_phase
task large_test::run_phase(uvm_phase phase);
   	phase.raise_objection(this);
	l_seq=large_packet::type_id::create("l_seq");
	n_seq=normal_sequence::type_id::create("n_seq");
    	addr=2'b10;
	uvm_config_db #(bit [1:0])::set(this,"*","bit [1:0]",addr);
	foreach(envh.src_top.src_agt[i])
 	l_seq.start(envh.src_top.src_agt[i].src_seqrh);
	#100;
	phase.drop_objection(this);
endtask


//Extend small_test from base_test
class small_test_sr extends base_test;

	//factory registration
	`uvm_component_utils(small_test_sr)

	bit [1:0] addr;

	// Declare the handle for  small_packet sequence
	 small_packet s_seq;
	 soft_rst_seqs soft_seq;
	 
	// Standard UVM Methods:
 	extern function new(string name = "small_test_sr" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

// Define Constructor new() function
function small_test_sr::new(string name = "small_test_sr" , uvm_component parent);
	super.new(name,parent);
endfunction

//build() phase method
function void small_test_sr::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//run_phase
task small_test_sr::run_phase(uvm_phase phase);
   	phase.raise_objection(this);
	s_seq=small_packet::type_id::create("s_seq");
	soft_seq=soft_rst_seqs::type_id::create("soft_seq");
    	addr=$random%3;
	uvm_config_db #(bit [1:0])::set(this,"*","bit [1:0]",addr);
	foreach(envh.src_top.src_agt[i])
	fork
 	s_seq.start(envh.src_top.src_agt[i].src_seqrh);
	soft_seq.start(envh.dst_top.dst_agt[addr].dst_seqrh);
	join
	#100;
	phase.drop_objection(this);
endtask


//Extend small_test from base_test
class medium_test_sr extends base_test;

	//factory registration
	`uvm_component_utils(medium_test_sr)

	bit [1:0] addr;

	// Declare the handle for  small_packet sequence
	 medium_packet m_seq;
	 soft_rst_seqs soft_seq;
	 
	// Standard UVM Methods:
 	extern function new(string name = "medium_test_sr" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

// Define Constructor new() function
function medium_test_sr::new(string name = "medium_test_sr" , uvm_component parent);
	super.new(name,parent);
endfunction

//build() phase method
function void medium_test_sr::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//run_phase
task medium_test_sr::run_phase(uvm_phase phase);
   	phase.raise_objection(this);
	m_seq=medium_packet::type_id::create("m_seq");
	soft_seq=soft_rst_seqs::type_id::create("soft_seq");
    	addr=$random%3;
	uvm_config_db #(bit [1:0])::set(this,"*","bit [1:0]",addr);
	foreach(envh.src_top.src_agt[i])
	fork
 	m_seq.start(envh.src_top.src_agt[i].src_seqrh);
	soft_seq.start(envh.dst_top.dst_agt[addr].dst_seqrh);
	join
	#100;
	phase.drop_objection(this);
endtask

//Extend small_test from base_test
class large_test_sr extends base_test;

	//factory registration
	`uvm_component_utils(large_test_sr)

	bit [1:0] addr;

	// Declare the handle for  small_packet sequence
	 large_packet l_seq;
	 soft_rst_seqs soft_seq;
	 
	// Standard UVM Methods:
 	extern function new(string name = "large_test_sr" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
endclass

// Define Constructor new() function
function large_test_sr::new(string name = "large_test_sr" , uvm_component parent);
	super.new(name,parent);
endfunction

//build() phase method
function void large_test_sr::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

//run_phase
task large_test_sr::run_phase(uvm_phase phase);
   	phase.raise_objection(this);
	l_seq=large_packet::type_id::create("l_seq");
	soft_seq=soft_rst_seqs::type_id::create("soft_seq");
    	addr=$random%3;
	uvm_config_db #(bit [1:0])::set(this,"*","bit [1:0]",addr);
	foreach(envh.src_top.src_agt[i])
	fork
	 	l_seq.start(envh.src_top.src_agt[i].src_seqrh);
		soft_seq.start(envh.dst_top.dst_agt[addr].dst_seqrh);
	join
	#100;
	phase.drop_objection(this);
endtask

