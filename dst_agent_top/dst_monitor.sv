
//class dst_monoitor
class dst_monitor extends uvm_monitor;


	 // Factory Registration
	`uvm_component_utils(dst_monitor)

	dst_agent_config d_cfg;

	virtual router_if.DST_MON_MP vif;

	uvm_analysis_port #(dst_xtn) monitor_port;


	//Methods
	extern function new(string name = "dst_monitor", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);

endclass 


//constructor new method
function dst_monitor::new(string name = "dst_monitor",uvm_component parent);
	super.new(name,parent);
	monitor_port = new("monitor_port", this);
endfunction

//build phase
function void dst_monitor::build_phase(uvm_phase phase);
	
          super.build_phase(phase);
	
	  if(!uvm_config_db #(dst_agent_config)::get(this,"","dst_agent_config",d_cfg))
		`uvm_fatal("CONFIG","getting is failed") 
endfunction

//connect phase
function void dst_monitor::connect_phase(uvm_phase phase);
          vif = d_cfg.vif;
endfunction

//run_phase()	
task dst_monitor::run_phase(uvm_phase phase);
	`uvm_info("DST_MONITOR","This is dst_monitor run_phase",UVM_LOW)
	forever
	
             collect_data();
 	  
endtask

task dst_monitor::collect_data();
   dst_xtn data_receive;
   data_receive=dst_xtn::type_id::create("data_receive");
	@(vif.dst_mon_cb);

   while(vif.dst_mon_cb.valid_out!==1)
 	@(vif.dst_mon_cb);
	@(vif.dst_mon_cb); 
   while(vif.dst_mon_cb.read_enb!==1)
	@(vif.dst_mon_cb);
	@(vif.dst_mon_cb);
    
    data_receive.header=vif.dst_mon_cb.d_out;
    data_receive.payload=new[data_receive.header[7:2]];

	for(int i=0;i<data_receive.header[7:2];i++)
	    begin
		@(vif.dst_mon_cb);
	      data_receive.payload[i]=vif.dst_mon_cb.d_out;
             end
	@(vif.dst_mon_cb);
	data_receive.parity=vif.dst_mon_cb.d_out;
	monitor_port.write(data_receive);
	data_receive.print();
	`uvm_info("DST_MONITOR",$sformatf("printing from monitor \n %s", data_receive.sprint()),UVM_LOW) 

endtask

//report_phase
function void dst_monitor::report_phase(uvm_phase phase);
    	super.report_phase(phase);
	`uvm_info("DST_MONITOR","This is report_phase",UVM_LOW)
endfunction 

