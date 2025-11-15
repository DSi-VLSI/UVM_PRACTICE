
//  Class: uart_driver
//
class uart_driver extends uvm_driver #(uart_seq_item);
    `uvm_component_utils(uart_driver);

    virtual uart_interface uart_inf;
    reg_transaction reg_trans;
    uart_seq_item item;

    time delay;


    //  Constructor: new
    function new(string name = "uart_driver", uvm_component parent = null);
        super.new(name, parent);
        void'(uvm_config_db #(virtual uart_interface)::get(this, "", "uart_inf", uart_inf));
        void'(uvm_config_db #(reg_transaction)::get(this, "", "reg_trans", reg_trans));
        `uvm_info("UART_Driver", "Constructed", UVM_DEBUG);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info("UART_Driver", "Build", UVM_DEBUG);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("UART_Driver", "Connected", UVM_DEBUG);
    endfunction

    function logic get_parity_bit(input logic [7:0] data, input logic parity_type);
        logic parity;
        begin
            parity = ^data;        // XOR all bits → gives even parity
            if (parity_type)       // if parity_type = 1 → odd parity
                get_parity_bit = ~parity;
            else                   // parity_type = 0 → even parity
                get_parity_bit = parity;
        end
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("UART_Driver", "run phase started", UVM_DEBUG);

        

        forever begin

            seq_item_port.get_next_item(item);

            delay = reg_trans.clk_div_reg.CLK_DIV * 10; 

            #delay;

            uart_inf.rx_i = 0;  // Start bit
            #delay;

            for(int i = 0; i < 8; i++) begin
                uart_inf.rx_i = item.data[i];
                #delay;
            end

            uart_inf.rx_i = get_parity_bit(item.data, reg_trans.cfg_reg.PARITY_TYPE); // parity bit
            #delay;

            uart_inf.rx_i = 1; // stop bit
            #delay;

            seq_item_port.item_done();
            
        end

    
    endtask 

endclass