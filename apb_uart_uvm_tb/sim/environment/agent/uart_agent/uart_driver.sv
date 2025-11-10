
//  Class: uart_driver
//
class uart_driver extends uvm_driver #(seq_item);
    `uvm_component_utils(uart_driver);

    virtual uart_interface uart_inf;
    seq_item item;


    //  Constructor: new
    function new(string name = "uart_driver", uvm_component parent = null);
        super.new(name, parent);
        void'(uvm_config_db #(virtual uart_interface)::get(this, "", "uart_inf", uart_inf));
        `uvm_info(get_full_name(), "Driver Constructed", UVM_LOW);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name(), "Driver Build Phase", UVM_LOW);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_name(), "Driver Connect Phase", UVM_LOW);
    endfunction

    task run_phase();
        super.run_phase();
        `uvm_info(get_name(), "Driver run phase started", UVM_HIGH);

        

        forever begin

            seq_item_port.get_next_item(item);
            #(10);
            seq_item_port.item_done();
            
        end

    
    endtask 

endclass