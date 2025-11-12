`include "dependencies.svh"

class axi_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(axi_scoreboard)

    function new(string name="axi_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    `uvm_analysis_imp_decl(_axi)
    `uvm_analysis_imp_decl(_tx)
    `uvm_analysis_imp_decl(_rx)

    typedef logic serial_to_parallel_t [16];
    
    uvm_analysis_imp_axi #(dut_seq_item, axi_scoreboard) m_analysis_imp;
    uvm_analysis_imp_tx  #(uart_tx_item, axi_scoreboard) uart_tx_analysis_imp;
    uvm_analysis_imp_rx  #(uart_rx_item, axi_scoreboard) uart_rx_analysis_imp;

    uvm_tb_axi_req_t    axi_config_req [$];
    uvm_tb_axi_resp_t   axi_config_resp [$];
    uvm_tb_axi_req_t    axi_tx_data_req [$];
    uvm_tb_axi_resp_t   axi_tx_data_resp [$];
    uvm_tb_axi_req_t    axi_rx_data_req [$];
    uvm_tb_axi_resp_t   axi_rx_data_resp [$];

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_analysis_imp = new("m_analysis_imp", this);
        uart_tx_analysis_imp = new("uart_tx_analysis_imp", this);
        uart_rx_analysis_imp = new("uart_rx_analysis_imp", this);
    endfunction

    virtual function void write_axi(dut_seq_item item);
        `uvm_info(get_name(), $sformatf("axi_write_item: %p\ndata: %p\nresp: %p\n", item.axi_req.aw, item.axi_req.w, item.axi_resp.b), UVM_LOW);
        `uvm_info(get_name(), $sformatf("axi_read_item: %p\nresp: %p\n", item.axi_req.ar, item.axi_resp.r), UVM_LOW);
        if (item.axi_req.aw.addr == 16'h14) begin
            axi_tx_data_req.push_back(item.axi_req);
            axi_tx_data_resp.push_back(item.axi_resp);
        end else begin
            
        end
    endfunction

    virtual function void write_tx(uart_tx_item item);
        `uvm_info(get_name(), $sformatf("tx_item: %b", item.tx_array), UVM_LOW);
    endfunction

    virtual function void write_rx(uart_rx_item item);
        `uvm_info(get_name(), $sformatf("rx_item: %b", item.rx_array), UVM_LOW);
    endfunction

endclass

    