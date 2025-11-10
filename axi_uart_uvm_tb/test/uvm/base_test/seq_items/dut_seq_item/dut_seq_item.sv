`include "dependencies.svh"

class dut_seq_item extends uvm_sequence_item;
    `uvm_object_utils(dut_seq_item)

    logic rst_n;
    uvm_tb_axi_req_t  seq_item_axi_req_t;
    uvm_tb_axi_resp_t seq_item_axi_resp_t;
    
    function new(string name="dut_seq_item");
        super.new(name);
    endfunction

endclass