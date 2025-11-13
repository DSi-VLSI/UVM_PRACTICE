`include "dependencies.svh"

class axi_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(axi_scoreboard)

    function new(string name="axi_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    `uvm_analysis_imp_decl(_axi)
    `uvm_analysis_imp_decl(_tx)
    `uvm_analysis_imp_decl(_rx)
    
    uvm_analysis_imp_axi #(dut_seq_item, axi_scoreboard) m_analysis_imp;
    uvm_analysis_imp_tx  #(uart_tx_item, axi_scoreboard) uart_tx_analysis_imp;
    uvm_analysis_imp_rx  #(uart_rx_item, axi_scoreboard) uart_rx_analysis_imp;

    virtual reset_intf u_reset_intf;

    uvm_tb_axi_req_t    axi_config_req [$];
    uvm_tb_axi_resp_t   axi_config_resp [$];
    uvm_tb_axi_req_t    axi_tx_data_req [$];
    uvm_tb_axi_resp_t   axi_tx_data_resp [$];
    uvm_tb_axi_req_t    axi_rx_data_req [$];
    uvm_tb_axi_resp_t   axi_rx_data_resp [$];

    serial_to_parallel_t tx_array_queue [$];
    serial_to_parallel_t rx_array_queue [$];

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_analysis_imp = new("m_analysis_imp", this);
        uart_tx_analysis_imp = new("uart_tx_analysis_imp", this);
        uart_rx_analysis_imp = new("uart_rx_analysis_imp", this);
        if(uvm_config_db #(virtual reset_intf)::get(this, "", "reset_intf", u_reset_intf)) begin
            `uvm_info(get_name(), "RESET INTERFACE FOUND", UVM_HIGH)
        end else begin
            `uvm_error(get_name(), "RESET INTERFACE NOT FOUND")
        end
    endfunction

    virtual function void write_axi(dut_seq_item item);
        `uvm_info(get_name(), $sformatf("axi_write_item: %p\ndata: %p\nresp: %p\n", item.axi_req.aw, item.axi_req.w, item.axi_resp.b), UVM_HIGH);
        `uvm_info(get_name(), $sformatf("axi_read_item: %p\nresp: %p\n", item.axi_req.ar, item.axi_resp.r), UVM_HIGH);
        if (item.axi_req.aw.addr == 16'h14) begin
            `uvm_info(get_name(), "TX DATA FIFO WRITTEN", UVM_LOW);
            axi_tx_data_req.push_back(item.axi_req);
            axi_tx_data_resp.push_back(item.axi_resp);
        end else if (item.axi_req.ar.addr == 16'h1C) begin
            axi_rx_data_req.push_back(item.axi_req);
            axi_rx_data_resp.push_back(item.axi_resp);
        end else begin
            axi_config_req.push_back(item.axi_req);
            axi_config_resp.push_back(item.axi_resp);
        end
    endfunction

    virtual function void write_tx(uart_tx_item item);
        `uvm_info(get_name(), $sformatf("tx_item: %b", item.tx_array), UVM_HIGH);
        tx_array_queue.push_back(item.tx_array);
    endfunction

    virtual function void write_rx(uart_rx_item item);
        `uvm_info(get_name(), $sformatf("rx_item: %b", item.rx_array), UVM_HIGH);
        rx_array_queue.push_back(item.rx_array);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);

        fork
            begin
                evaluate_tx_write();
            end
            begin
                evaluate_rx_read();
            end
        join

    endtask

    task evaluate_tx_write();
        forever begin
            @(posedge u_reset_intf.clk);

            if(axi_tx_data_req.size() > 0 && axi_tx_data_resp.size() > 0 && tx_array_queue.size() > 0) begin
                uvm_tb_axi_req_t axi_req;
                uvm_tb_axi_resp_t axi_resp;
                serial_to_parallel_t tx_array;

                axi_req = axi_tx_data_req.pop_front();
                axi_resp = axi_tx_data_resp.pop_front();
                tx_array = tx_array_queue.pop_front();

                if (axi_req.w.data === tx_array) begin
                    `uvm_info(get_name(), "PASSED: TX BUFFER WRITE DATA FOUND IN TX", UVM_LOW)
                end else begin
                    `uvm_error(get_name(), "FAILED: TX BUFFER WRITE DATA NOT FOUND IN TX")
                end
            end
        end
    endtask

    task evaluate_rx_read();
        forever begin
            @(posedge u_reset_intf.clk);

            if(axi_rx_data_req.size() > 0 && axi_rx_data_resp.size() > 0 && rx_array_queue.size() > 0) begin
                uvm_tb_axi_req_t axi_req;
                uvm_tb_axi_resp_t axi_resp;
                serial_to_parallel_t rx_array;

                axi_req = axi_rx_data_req.pop_front();
                axi_resp = axi_rx_data_resp.pop_front();
                rx_array = rx_array_queue.pop_front();

                if (axi_resp.r.data === rx_array) begin
                    `uvm_info(get_name(), "PASSED: RX FOUND IN RX BUFFER READ DATA", UVM_LOW)
                end else begin
                    `uvm_error(get_name(), "FAILED: RX NOT FOUND IN RX BUFFER WRITE DATA")
                end
            end
        end
    endtask
endclass

    