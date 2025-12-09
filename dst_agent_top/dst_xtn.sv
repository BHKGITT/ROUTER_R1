
class dst_xtn extends uvm_sequence_item;

	// UVM Factory Registration Macro
    	`uvm_object_utils(dst_xtn)

	bit [7:0] header,payload[];
 	bit [7:0]parity;
	bit err;
	bit read_enb,valid_out;

	rand bit [5:0] no_of_cycle; 

	//Methods
	extern function new(string name = "dst_xtn");
	extern function void do_print(uvm_printer printer);
endclass

//constructor new method
function dst_xtn::new(string name = "dst_xtn");
	super.new(name);
endfunction:new

//do_print
function void dst_xtn::do_print(uvm_printer printer);
   	super.do_print(printer);
		printer.print_field("header",this.header,8,UVM_DEC);
	
		for(int i=0; i<header[7:2]; i++)
		printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);

		printer.print_field("parity",this.parity,8,UVM_DEC);
		printer.print_field("err",this.err,1,UVM_DEC);

		printer.print_field("read_enb",this.read_enb,1,UVM_DEC);
		printer.print_field("valid_out",this.valid_out,1,UVM_DEC);
	
		printer.print_field("no_of_cycle",this.no_of_cycle,6,UVM_DEC);
endfunction

