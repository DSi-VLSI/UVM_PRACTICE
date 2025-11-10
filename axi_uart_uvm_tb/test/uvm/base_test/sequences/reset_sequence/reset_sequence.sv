`include "dependencies.svh"

class reset_sequence extends uvm_sequence;
    `uvm_object_utils(reset_sequence)
    
    function new(string name="reset_sequence");
        super.new(name);
    endfunction

    virtual task body();
        dut_seq_item item;

        item = dut_seq_item::type_id::create("reset_seq_item");
        start_item(item);
        item.rst_n = '1;
        finish_item(item);

        item = dut_seq_item::type_id::create("reset_seq_item");
        start_item(item);
        item.rst_n = '0;
        finish_item(item);

        item = dut_seq_item::type_id::create("reset_seq_item");
        start_item(item);
        item.rst_n = '0;
        finish_item(item);

        item = dut_seq_item::type_id::create("reset_seq_item");
        start_item(item);
        item.rst_n = '0;
        finish_item(item);
        
        item = dut_seq_item::type_id::create("reset_seq_item");
        start_item(item);
        item.rst_n = '0;
        finish_item(item);

        item = dut_seq_item::type_id::create("reset_seq_item");
        start_item(item);
        item.rst_n = '1;
        finish_item(item);

    endtask

endclass