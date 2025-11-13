
//  Class: uart_monitor
//
class uart_monitor extends uvm_monitor;
    `uvm_component_utils(uart_monitor);

    uvm_analysis_port #(uart_seq_item) uart_port;

    virtual uart_interface uart_inf;
    reg_transaction reg_trans;
    
    int highest_count;
    logic [10:0] tx_data;
    logic [10:0] rx_data;
    time delay;
    

    function new(string name = "uart_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        void'(uvm_config_db #(virtual uart_interface)::get(this, "", "uart_inf", uart_inf));
        void'(uvm_config_db #(reg_transaction)::get(this, "", "reg_trans", reg_trans));
        `uvm_info("UART_Monitor", "Build Phase", UVM_DEBUG);
    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("UART_Monitor", "Connect Phase", UVM_DEBUG);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("UART_Monitor", "run phase started", UVM_DEBUG);

        fork
            tx_monitor();
            rx_monitor();
        join

        
    endtask


    task tx_monitor();

        forever begin

            @(negedge uart_inf.tx_o);

            highest_count = reg_trans.cfg_reg.STOP_BITS == 0 ? 11 : 12;
            delay = reg_trans.clk_div_reg.CLK_DIV * 10; 

            #(delay/2); // Mid bit sampling for stable read

            for(int i = 0; i < highest_count; i++) begin
                tx_data[i] = uart_inf.tx_o;
                `uvm_info("UART_Monitor", $sformatf("TX: %d", uart_inf.tx_o), UVM_FULL);
                #delay;

            end

            `uvm_info("UART_Monitor", $sformatf("==> Final Transmitted Data :: %0b", tx_data), UVM_LOW);
    
            
        end

    endtask


    task rx_monitor();

        forever begin

            @(negedge uart_inf.rx_i);

            highest_count = reg_trans.cfg_reg.STOP_BITS == 0 ? 11 : 12;
            delay = reg_trans.clk_div_reg.CLK_DIV * 10; 

            #(delay/2); // Mid bit sampling for stable read

            for(int i = 0; i < highest_count; i++) begin
                rx_data[i] = uart_inf.rx_i;
                `uvm_info("UART_Monitor", $sformatf("RX: %d", uart_inf.rx_i), UVM_FULL);
                #delay;

            end

            `uvm_info("UART_Monitor", $sformatf("==> Final Received Data :: %0b", rx_data), UVM_LOW);

        end

    endtask

   
    
endclass