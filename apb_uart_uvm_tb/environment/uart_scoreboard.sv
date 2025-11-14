
//  Class: uart_scoreboard
//
class uart_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(uart_scoreboard)
    `uvm_analysis_imp_decl(_apb)
    `uvm_analysis_imp_decl(_uart)

    uvm_analysis_imp_apb #(apb_seq_item, uart_scoreboard) apb_imp;
    uvm_analysis_imp_uart #(uart_seq_item, uart_scoreboard) uart_imp;

    apb_seq_item    exp_tx [$];
    uart_seq_item   exp_rx [$];
    uart_seq_item   act_tx [$];
    apb_seq_item    act_rx [$];

    apb_seq_item apb_item_exp, apb_item_act;
    uart_seq_item uart_item_exp, uart_item_act;

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
        if(item.isTx) begin
            exp_tx.push_front(item);
        end
        else if(item.isRx) begin
            act_rx.push_front(item);
        end

        `uvm_info("Scoreboard", $sformatf("APB Item Received"), UVM_HIGH);
    endfunction

    function void write_uart(uart_seq_item item);
        // item.print();

        if(item.isRx) begin
            exp_rx.push_front(item);
        end
        else if(item.isTx) begin
            act_tx.push_front(item);
        end


        `uvm_info("Scoreboard", $sformatf("UART Item Received"), UVM_HIGH);
    endfunction

    task run_phase(uvm_phase phase);
       forever begin
            compare();
       end
    endtask

    task compare();
        fork
            tx_compare();
            rx_compare();
       join
    endtask


    task tx_compare();
        forever begin

            wait(act_tx.size() > 0 && exp_tx.size() > 0);

            apb_item_exp =  exp_tx.pop_back();
            uart_item_act = act_tx.pop_back();

            if(apb_item_exp.pwdata == uart_item_act.tx_data) begin
                `uvm_info("Scoreboard", $sformatf("[PASSED] :: Expexted TX: %0d | Actual TX: %0d", apb_item_exp.pwdata, uart_item_act.tx_data), UVM_LOW);
            end
            else begin
                `uvm_info("Scoreboard", $sformatf("[FAILED] :: Expexted TX: %0d | Actual TX: %0d", apb_item_exp.pwdata, uart_item_act.tx_data), UVM_LOW);
            end

        end

    endtask

    task rx_compare();
        forever begin
            wait(exp_rx.size() > 0 && act_rx.size() > 0);

            apb_item_act =  act_rx.pop_back();
            uart_item_exp = exp_rx.pop_back();

            if(apb_item_act.pwdata == uart_item_exp.rx_data) begin
                `uvm_info("Scoreboard", $sformatf("[PASSED] :: Expexted RX: %0d | Actual RX: %0d", apb_item_act.pwdata, uart_item_exp.rx_data), UVM_LOW);
            end
            else begin
                `uvm_info("Scoreboard", $sformatf("[FAILED] :: Expexted RX: %0d | Actual RX: %0d", apb_item_act.pwdata, uart_item_exp.rx_data), UVM_LOW);
            end

        end

    endtask



        
    
    
    

    
endclass
