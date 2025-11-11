
//  Class: uart_agent
//
class uart_agent extends uvm_agent;
    `uvm_component_utils(uart_agent);
    uart_driver uart_drvr;
    uart_monitor uart_mntr;
    uart_sequencer uart_seqr;



    function new(string name = "uart_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        uart_drvr = uart_driver::type_id::create("uart_drvr", this);
        uart_mntr = uart_monitor::type_id::create("uart_mntr", this);
        uart_seqr = uart_sequencer::type_id::create("uart_seqr", this);
        `uvm_info(get_full_name, "Agent Build Phase", UVM_LOW);
    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        uart_drvr.seq_item_port.connect(uart_seqr.seq_item_export);
        `uvm_info(get_full_name, "Agent Connect Phase", UVM_LOW);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        `uvm_info(get_full_name, "Agent run phase started", UVM_HIGH);
    endtask

   
    
endclass

