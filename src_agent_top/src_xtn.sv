// Extend src_xtn from uvm_sequence_item
class src_xtn extends uvm_sequence_item;

	// UVM Factory Registration Macro
    	`uvm_object_utils(src_xtn)

	//declare properties
	rand bit[7:0] header,payload[];
	bit [7:0] parity;
	bit err;

	//constraint
	constraint valid_addr{header[1:0]!=2'b11;}
	constraint valid_length{header[7:0]!=0;}
	constraint valid_size{payload.size==header[7:2];}

	
	//Methods
	extern function new(string name = "src_xtn");
	extern function void do_print(uvm_printer printer);
	extern function void post_randomize();
endclass

//constructor new method
function src_xtn::new(string name = "src_xtn");
	super.new(name);
endfunction:new

//do_print method
function void src_xtn::do_print(uvm_printer printer);
  super.do_print(printer);
	printer.print_field("header",this.header,8,UVM_DEC);
	
	for(int i=0; i<header[7:2]; i++)
	printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);

	printer.print_field("parity",this.parity,8,UVM_DEC);
	printer.print_field("err",this.err,1,UVM_DEC);
endfunction

function void src_xtn::post_randomize();
  parity=header;
  foreach(payload[i])
     begin
         parity=payload[i]^parity;
     end
endfunction
