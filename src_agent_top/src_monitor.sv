
//class src_monoitor
class src_monitor extends uvm_monitor;


	 // Factory Registration
	`uvm_component_utils(src_monitor)

	src_agent_config s_cfg;

	virtual router_if.SRC_MON_MP vif;

	uvm_analysis_port #(src_xtn) monitor_port;
	
	//Methods
	extern function new(string name = "src_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);
endclass 




	//constructor new method----------------------------------------------------
	function src_monitor::new(string name = "src_monitor",uvm_component parent);
		super.new(name,parent);
		monitor_port = new("monitor_port", this);
	endfunction

	function void src_monitor::build_phase(uvm_phase phase);
	
          	super.build_phase(phase);
	
	  	if(!uvm_config_db #(src_agent_config)::get(this,"","src_agent_config",s_cfg))
		`uvm_fatal("CONFIG","getting is failed") 
	endfunction

	//connect phase--------------------------------------------------------------------
	function void src_monitor::connect_phase(uvm_phase phase);
        	vif = s_cfg.vif;
	endfunction

	//run_phase()----------------------------------------------------------------------	
	task src_monitor::run_phase(uvm_phase phase);
		`uvm_info("SRC_MONITOR","This is src_monitor run_phase",UVM_LOW)
		forever
 			collect_data();

	endtask



	//collect_data---------------------------------------------------------------------
	task src_monitor::collect_data();
		src_xtn data_sent;
		data_sent=src_xtn::type_id::create("data_sent");
		//@(posedge vif.src_mon_cb.pkt_valid);
		@( vif.src_mon_cb);

		while(vif.src_mon_cb.pkt_valid!==0)
		@(vif.src_mon_cb);

		data_sent.header=vif.src_mon_cb.d_in;

		data_sent.payload=new[data_sent.header[7:2]];

		for(int i=0;i<data_sent.header[7:2];i++)
	    	begin

  			@(vif.src_mon_cb);

			while(vif.src_mon_cb.busy!==0)
			@(vif.src_mon_cb);
			data_sent.payload[i]=vif.src_mon_cb.d_in;
		end

		@(vif.src_mon_cb);
		while(vif.src_mon_cb.pkt_valid!==0)
		@(vif.src_mon_cb);
		data_sent.parity=vif.src_mon_cb.d_in;
		monitor_port.write(data_sent);
		data_sent.print();
		`uvm_info("SRC_MONITOR",$sformatf("printing from monitor \n %s", data_sent.sprint()),UVM_LOW) 

	endtask

	//report_phase------------------------------------------------------------------
	function void src_monitor::report_phase(uvm_phase phase);
	    	super.report_phase(phase);
		`uvm_info("SRC_MONITOR","This is report_phase",UVM_LOW)
	endfunction 


