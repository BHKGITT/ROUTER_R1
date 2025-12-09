class virtual_sequencer extends uvm_sequencer #(uvm_sequence_item);

   `uvm_component_utils(virtual_sequencer)
   
      src_sequencer s_seqrh[];
      dst_sequencer d_seqrh[];
    
      env_config env_cfg;

    extern function new(string name="virtual_sequencer",uvm_component parent);
    extern function void build_phase(uvm_phase phase);

endclass
   

function virtual_sequencer::new(string name="virtual_sequencer",uvm_component parent);
  super.new(name,parent);
endfunction


function void virtual_sequencer::build_phase(uvm_phase phase); 
  super.build_phase(phase);  
   if(!uvm_config_db #(env_config)::get(this,"","env_config",env_cfg))
      `uvm_fatal("CONFIG","cannot get env_cfg from uvm_config_db")
      
      s_seqrh=new[env_cfg.no_of_src_agents];
      d_seqrh=new[env_cfg.no_of_dst_agents];

endfunction
