
//Extend dst_seqs from uvm_sequence;
class dst_seqs extends uvm_sequence #(dst_xtn);  
  	// Factory registration 
	`uvm_object_utils(dst_seqs)


	// METHODS

	// Standard UVM Methods:
    	extern function new(string name ="dst_seqs");
	
endclass
// constructor new method
function dst_seqs::new(string name = "dst_seqs");
	super.new(name);
endfunction

	// Extend normal_sequence from dst_seqs;
class normal_sequence extends dst_seqs;

	//factory registration 
	`uvm_object_utils(normal_sequence)

	//UVM Methods
	extern function new(string name ="normal_sequence");
	extern task body();
                                                                                                                   endclass
	//new constructor
	function normal_sequence::new(string name = "normal_sequence");
		super.new(name);
	endfunction

	task normal_sequence::body();
		begin
			req=dst_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize()with{no_of_cycle inside {[1:29]};});
			`uvm_info("DST_N_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
			finish_item(req);
		end
	endtask


//soft_reset
class soft_rst_seqs extends dst_seqs;

	//factory registration 
	`uvm_object_utils(soft_rst_seqs)

	//UVM Methods
	extern function new(string name ="soft_rst_seqs");
	extern task body();
endclass

	//new constructor
	function soft_rst_seqs::new(string name = "soft_rst_seqs");
		super.new(name);
	endfunction
	

	//task body
	task soft_rst_seqs::body();
		begin
			req=dst_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize()with{no_of_cycle>30;});
			`uvm_info("DST_S_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH) 
			finish_item(req);
		end
	endtask


