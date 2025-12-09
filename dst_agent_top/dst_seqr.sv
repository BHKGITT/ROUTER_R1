
//class dst_sequencer extends from uvm_sequencer
class dst_sequencer extends uvm_sequencer #(dst_xtn);

	// Factory registration 
	`uvm_component_utils(dst_sequencer)

	// METHODS
	// Standard UVM Methods:
	extern function new(string name = "dst_sequencer",uvm_component parent);
endclass

//constructor new method
function dst_sequencer::new(string name = "dst_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction

