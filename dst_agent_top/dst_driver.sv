//class dst_driver 
class dst_driver extends uvm_driver#(dst_xtn);

	//factory registration
	`uvm_component_utils(dst_driver)

	//Declare handle of src_agent_config 
	dst_agent_config d_cfg;

	virtual router_if.DST_DRV_MP vif;

	//Methods
	extern function new(string name="dst_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(dst_xtn dxtn);
	extern function void report_phase(uvm_phase phase);

endclass

	//----------------------------------//constructor new function----------------------------------

	function dst_driver::new(string name="dst_driver",uvm_component parent);
		super.new(name,parent);
	endfunction
	
	//--------------------------------------//build phase-------------------------------------------

	function void dst_driver::build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!(uvm_config_db#(dst_agent_config)::get(this,"","dst_agent_config",d_cfg)))
		`uvm_fatal("d_cfg","get is failed")
	endfunction

	//--------------------------------------//connect phase------------------------------------------

	function void dst_driver::connect_phase(uvm_phase phase);
          	vif = d_cfg.vif;
	endfunction

	//--------------------------------------//run_phase-----------------------------------------------

	task dst_driver::run_phase(uvm_phase phase);
		//phase.raise_objection(this);
	  	`uvm_info("DST_DRIVER","This is dst_driver run_phase",UVM_LOW)
	 	//#10;
		//phase.drop_objection(this);
	
		forever
 			begin
				//req=dst_xtn::type_id::create("req");
	   			seq_item_port.get_next_item(req);
	   			send_to_dut(req);
				//$display("no_of_cycles",req.no_of_cycle);
	   			seq_item_port.item_done();
			end
	endtask


	task dst_driver::send_to_dut(dst_xtn dxtn);
	//@(vif.dst_drv_cb);

  	vif.dst_drv_cb.read_enb<=1'b0;
	@(vif.dst_drv_cb);

 	while(vif.dst_drv_cb.valid_out!==1)
 	@(vif.dst_drv_cb);

  	repeat(dxtn.no_of_cycle)
	@(vif.dst_drv_cb);

	//@(vif.dst_drv_cb);
  	vif.dst_drv_cb.read_enb<=1'b1;
	@(vif.dst_drv_cb);

  	while(vif.dst_drv_cb.valid_out!==0)
	@(vif.dst_drv_cb);
	@(vif.dst_drv_cb);

  	vif.dst_drv_cb.read_enb<=1'b0;
	@(vif.dst_drv_cb);

	dxtn.print();
	`uvm_info("DST_DRIVER",$sformatf("printing from driver \n %s", dxtn.sprint()),UVM_LOW) 
	//`uvm_info("DST_DRIVER","This is dst_driver",UVM_LOW)

	endtask



//-----------------------------------------------//report_phase//--------------------------------------------------
	function void dst_driver::report_phase(uvm_phase phase);
    		super.report_phase(phase);
		`uvm_info("DST_DRIVER","This is report_phase",UVM_LOW)
	endfunction

