
//  Class: uart_scoreboard
//
class uart_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_scoreboard)
    `uvm_analysis_imp_decl(_apb)
    `uvm_analysis_imp_decl(_uart)

    uvm_analysis_imp_apb #(apb_seq_item, uart_scoreboard) apb_imp;
    uvm_analysis_imp_uart #(uart_seq_item, uart_scoreboard) uart_imp;


    function new(string name = "uart_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        apb_imp = new("apb_imp", this);
        uart_imp = new("uart_imp", this);
        `uvm_info("Scoreboard", "Build", UVM_DEBUG);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
    
        `uvm_info("Scoreboard", "Connected", UVM_DEBUG)
        
    endfunction



    virtual function void write_apb(apb_seq_item item);
        // `uvm_info("Scoreboard", $sformatf("APB Item Received: ADDR=0x%0h, DATA=0x%0h, WRITE=%0b", item.addr, item.data, item.is_write), UVM_DEBUG);
        // Add comparison logic here
    endfunction

    virtual function void write_uart(uart_seq_item item);
        // `uvm_info("Scoreboard", $sformatf("UART Item Received: RX_DATA=0x%0h", item.rx_data), UVM_DEBUG);
        // Add comparison logic here
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("Scoreboard", "run phase started, objection raised.", UVM_DEBUG)
    
        
    
        phase.drop_objection(this);
        `uvm_info("Scoreboard", "run phase finished, objection dropped.", UVM_DEBUG)
    endtask: run_phase
    
    
    

    
endclass
