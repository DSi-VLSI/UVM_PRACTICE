
//  Class: uart_scoreboard
//
class uart_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_scoreboard)
    `uvm_analysis_imp_decl(_apb)
    `uvm_analysis_imp_decl(_uart)

    uvm_analysis_imp_apb #(apb_seq_item, uart_scoreboard) apb_imp;
    uvm_analysis_imp_uart #(uart_seq_item, uart_scoreboard) uart_imp;

    apb_seq_item    tx_exp_q [$];
    uart_seq_item   tx_act_q [$];
    uart_seq_item   rx_exp_q [$];
    apb_seq_item    rx_act_q [$];

    apb_seq_item    tx_exp, rx_act;
    uart_seq_item   rx_exp, tx_act;

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

    function void write_apb(apb_seq_item item);

        item.print();

        if(item.write && item.addr == base_pkg::REG_TX_FIFO_DATA_ADDR) begin
            tx_exp_q.push_front(item);
        end
        else if(item.write == 0 && item.addr == base_pkg::REG_RX_FIFO_DATA_ADDR) begin
            rx_act_q.push_front(item);
        end

        `uvm_info("Scoreboard", $sformatf("APB Item Received"), UVM_HIGH);
    endfunction

    function void write_uart(uart_seq_item item);

        item.print();


        if(item.isTx) begin
            tx_act_q.push_front(item);
        end
        else begin
            rx_exp_q.push_front(item);
        end

        `uvm_info("Scoreboard", $sformatf("UART Item Received"), UVM_FULL);
    endfunction

    task run_phase(uvm_phase phase);
        fork
            tx_compare();
            rx_compare();
        join
    endtask


    task tx_compare();
        forever begin

            
            wait(tx_act_q.size() > 0 && tx_exp_q.size() > 0);

            tx_exp =  tx_exp_q.pop_back();
            tx_act = tx_act_q.pop_back();

            if(tx_exp.data == tx_act.data) begin
                `uvm_info("Scoreboard", $sformatf("[PASSED] :: Expexted TX: %0d | Actual TX: %0d", tx_exp.data, tx_act.data), UVM_LOW);
            end
            else begin
                `uvm_info("Scoreboard", $sformatf("[FAILED] :: Expexted TX: %0d | Actual TX: %0d", tx_exp.data, tx_act.data), UVM_LOW);
            end

        end

    endtask

    task rx_compare();
        forever begin
            wait(rx_exp_q.size() > 0 && rx_act_q.size() > 0);

            rx_act = rx_act_q.pop_back();
            rx_exp = rx_exp_q.pop_back();

            if(rx_act.data == rx_exp.data) begin
                `uvm_info("Scoreboard", $sformatf("[PASSED] :: Expexted RX: %0d | Actual RX: %0d", rx_act.data, rx_exp.data), UVM_LOW);
            end
            else begin
                `uvm_info("Scoreboard", $sformatf("[FAILED] :: Expexted RX: %0d | Actual RX: %0d", rx_act.data, rx_exp.data), UVM_LOW);
            end

        end

    endtask



        
    
    
    

    
endclass
