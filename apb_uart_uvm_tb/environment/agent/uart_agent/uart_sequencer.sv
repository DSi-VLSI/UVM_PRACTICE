
//  Class: uart_sequencer
//
class uart_sequencer extends uvm_sequencer #(seq_item);
    `uvm_component_utils(uart_sequencer);

    function new(string name = "uart_sequencer", uvm_component parent = null);
        super.new(name, parent);
        `uvm_info("", $sformatf("[Sequencer] :: Sequencer Constructed"), UVM_LOW);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("", $sformatf("[Sequencer] :: Sequencer Build Phase"), UVM_LOW);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("", $sformatf("[Sequencer] :: Sequencer Connect Phase"), UVM_LOW)
    endfunction
    
    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("", $sformatf("[Sequencer] :: Sequencer run phase started"), UVM_HIGH);
    endtask

    
endclass
