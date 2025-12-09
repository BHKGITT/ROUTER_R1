//class src_sequencer extends from uvm_sequencer
class src_sequencer extends uvm_sequencer #(src_xtn);

	// Factory registration 
	`uvm_component_utils(src_sequencer)

	// METHODS
	// Standard UVM Methods:
	extern function new(string name = "src_sequencer",uvm_component parent);
endclass

//constructor new method
function src_sequencer::new(string name = "src_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction
