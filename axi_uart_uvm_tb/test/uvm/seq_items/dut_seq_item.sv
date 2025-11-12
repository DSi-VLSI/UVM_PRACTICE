`include "dependencies.svh"

class dut_seq_item extends uvm_sequence_item;

    `uvm_object_utils(dut_seq_item)

    rand uvm_tb_axi_req_t   axi_req;
    rand uvm_tb_axi_resp_t  axi_resp;
    rand logic              tx;
    rand logic              rx;
    rand logic              irq;

    function new(string name="dut_seq_item");
        super.new(name);
    endfunction
    
endclass

