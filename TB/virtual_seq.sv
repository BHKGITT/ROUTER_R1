class virtual_seqs extends uvm_sequence #(uvm_sequence_item);

	`uvm_object_utils(virtual_seqs)

	virtual_sequencer v_seqrh;
    	env_config env_cfg;
    	src_sequencer s_seqrh[];
    	dst_sequencer d_seqrh[];

	small_packet  s_seq;
   	medium_packet m_seq;
  	large_packet  l_seq;

	normal_sequence n_seq;
	soft_rst_seqs sr_seq;

	 bit [1:0]addr;
 
  	extern function new(string name="virtual_seqs");
  	extern task body();

endclass

function virtual_seqs::new(string name="virtual_seqs");
  	super.new(name);
endfunction

task virtual_seqs::body();
   if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",env_cfg))
     `uvm_fatal("TB CONFIG","cannot get env_cfg from uvm_config_db")

    s_seqrh=new[env_cfg.no_of_src_agents];
    d_seqrh=new[env_cfg.no_of_dst_agents];
  
   assert($cast(v_seqrh,m_sequencer))
    else
      begin
         `uvm_error("BODY", "Error in $cast of virtual sequencer")
      end
   
     foreach(s_seqrh[i])
        s_seqrh[i]=v_seqrh.s_seqrh[i];
     foreach(d_seqrh[i])
        d_seqrh[i]=v_seqrh.d_seqrh[i];
endtask
