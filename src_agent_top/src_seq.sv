

//Extend src_base_seqs from uvm_sequence;
class src_seqs extends uvm_sequence #(src_xtn);  
  
	// Factory registration 
	`uvm_object_utils(src_seqs)

	// METHODS

	// Standard UVM Methods:
	extern function new(string name ="src_seqs");

	
endclass
// constructor new method
function src_seqs::new(string name = "src_seqs");
	super.new(name);
endfunction

//small_packet extends from src_seqs
class small_packet extends src_seqs;

	// Factory registration using 
  	`uvm_object_utils(small_packet)
	
	bit[1:0] addr;

	//standard UVM Methods
	extern function new(string name ="small_packet");
        extern task body();
endclass

//constructor new method
function small_packet::new(string name = "small_packet");
	super.new(name);
endfunction

//task body
task small_packet::body();
//repeat(2)
	  begin
   	   req=src_xtn::type_id::create("req");
	   if(!uvm_config_db #(bit [1:0])::get(null,get_full_name,"bit [1:0]",addr))
	   `uvm_fatal(get_type_name(),"getting is failed")
	    start_item(req);
	    assert(req.randomize() with {header[7:2]<15;header[1:0]==addr;});
	    finish_item(req);
	  end
endtask

//medium_packet extends from src_seqs
class medium_packet extends src_seqs;

	// Factory registration using 
  	`uvm_object_utils(medium_packet)
	
	bit[1:0] addr;

	//standard UVM Methods
	extern function new(string name ="medium_packet");
        extern task body();
endclass

//constructor new method
function medium_packet::new(string name = "medium_packet");
	super.new(name);
endfunction

//task body
task medium_packet::body();
//repeat(2)
	  begin
   	   req=src_xtn::type_id::create("req");
	   if(!uvm_config_db #(bit [1:0])::get(null,get_full_name,"bit [1:0]",addr))
	   `uvm_fatal(get_type_name(),"getting is failed")
	    start_item(req);
	    assert(req.randomize() with {header[7:2]>15;header[7:2]<30;header[1:0]==addr;});
	    finish_item(req);
	  end
endtask

//large_packet extends from src_seqs
class large_packet extends src_seqs;

	// Factory registration using 
  	`uvm_object_utils(large_packet)
	
	bit[1:0] addr;

	//standard UVM Methods
	extern function new(string name ="large_packet");
        extern task body();
endclass

//constructor new method
function large_packet::new(string name = "large_packet");
	super.new(name);
endfunction

//task body
task large_packet::body();
//repeat(2)
	  begin
   	   req=src_xtn::type_id::create("req");
	   if(!uvm_config_db #(bit [1:0])::get(null,get_full_name,"bit [1:0]",addr))
	   `uvm_fatal(get_type_name(),"getting is failed")
	    start_item(req);
	    assert(req.randomize() with {header[7:2]>30;header[7:2]<64;header[1:0]==addr;});
	    finish_item(req);
	  end
endtask
