
//class src_driver 
class src_driver extends uvm_driver#(src_xtn);

	//factory registration
	`uvm_component_utils(src_driver)

	//Declare handle of src_agent_config 
	src_agent_config s_cfg;

   	virtual router_if.SRC_DRV_MP vif;
	

	//Methods
	extern function new(string name="src_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(src_xtn sxtn);
	extern function void report_phase(uvm_phase phase);

endclass

//constructor new function
	function src_driver::new(string name="src_driver",uvm_component parent);
		super.new(name,parent);
	endfunction

//build phase
	function void src_driver::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db#(src_agent_config)::get(this,"","src_agent_config",s_cfg)))
		`uvm_fatal("s_cfg","get is failed")
	endfunction

//connect phase
	function void src_driver::connect_phase(uvm_phase phase);
          	vif = s_cfg.vif;
	endfunction


//run_phase
	task src_driver::run_phase(uvm_phase phase);
		@(vif.src_drv_cb);
		vif.src_drv_cb.resetn<=1'b0;
    		repeat(2)
		@(vif.src_drv_cb);
		vif.src_drv_cb.resetn<=1'b1;
     		forever 
			begin
				
	  			seq_item_port.get_next_item(req);
	  			send_to_dut(req);
	  			seq_item_port.item_done();
			end
	endtask

	task src_driver::send_to_dut(src_xtn sxtn);
	
		while(vif.src_drv_cb.busy!==0)
	  	@(vif.src_drv_cb);
		vif.src_drv_cb.pkt_valid<=1'b1;
		vif.src_drv_cb.d_in<=sxtn.header;
	  	@(vif.src_drv_cb);
		foreach(sxtn.payload[i])
	   	begin
               		while(vif.src_drv_cb.busy!==0)
		    	@(vif.src_drv_cb);
			vif.src_drv_cb.d_in<=sxtn.payload[i];
		    	@(vif.src_drv_cb);
	    	end
	  	vif.src_drv_cb.pkt_valid<=1'b0;
          	vif.src_drv_cb.d_in<=sxtn.parity;  
		sxtn.print();
		`uvm_info("SRC_DRIVER",$sformatf("printing from driver \n %s", sxtn.sprint()),UVM_LOW) 
	endtask

//report_phase
	function void src_driver::report_phase(uvm_phase phase);
    		super.report_phase(phase);
		`uvm_info("SRC_DRIVER","This is report_phase",UVM_LOW)
	endfunction 
