
//  Class: uart_monitor
//
class uart_monitor extends uvm_monitor;
    `uvm_component_utils(uart_monitor);

    virtual uart_interface uart_inf;

    function new(string name = "uart_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        void'(uvm_config_db #(virtual uart_interface)::get(this, "", "uart_inf", uart_inf));
        `uvm_info(get_full_name, "Monitor Build Phase", UVM_LOW);
    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_full_name, "Monitor Connect Phase", UVM_LOW);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_full_name, "Monitor run phase started", UVM_HIGH);

        forever begin
            @(posedge uart_inf.pclk);

            // `uvm_info(get_full_name, $sformatf("[UART Monitor] :: TX: %d, RX: %d, IRQ: %d", uart_inf.tx_o, uart_inf.rx_i, uart_inf.irq_o), UVM_NONE);
            $display("[UART Monitor] :: TX: %d, RX: %d, IRQ: %d", uart_inf.tx_o, uart_inf.rx_i, uart_inf.irq_o);
            
        end

        
    endtask

   
    
endclass