
//  Class: uart_basic_test
//



class uart_basic_test extends uart_base_test;
    `uvm_component_utils(uart_basic_test)

    uart_ctl_reg_t        ctl_reg;
    uart_cfg_reg_t        cfg_reg;
    uart_clk_div_reg_t    clk_div_reg;
    uart_tx_fifo_data_t   tx_fifo_data_reg;


    function new(string name = "uart_basic_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        // Initialize UART Control Register
        ctl_reg.CLK_EN = 'b1;
        ctl_reg.TX_FIFO_FLUSH = 'b1;
        ctl_reg.RX_FIFO_FLUSH = 'b1;
        ctl_reg.reserved = 0;


        // Initialize UART Configuration Register
        cfg_reg.PARITY_EN = 'b1;
        cfg_reg.PARITY_TYPE = 'b00;
        cfg_reg.STOP_BITS = 'b0;
        cfg_reg.RX_INT_EN = 'b1;
        cfg_reg.reserved = 0;
        
        // Initialize UART Clock Divider Register
        clk_div_reg.CLK_DIV = 'd26; // Assuming a clock divider value of 26

        // Initialize UART TX FIFO Data Register
        tx_fifo_data_reg.TX_DATA = 'b10111010; // Example data to transmit
        tx_fifo_data_reg.reserved = 0;

        `uvm_info(get_full_name, "Basic Test Build Phase", UVM_LOW);

    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_full_name, "Basic Test Connect Phase", UVM_LOW);
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_full_name, "Basic Test run phase started, objection raised.", UVM_LOW);
        
        reset();
        write(1'b0, UART_CTL_REG_ADDR, {ctl_reg}, 'b1111);
        // write(1'b0, UART_CFG_REG_ADDR, {cfg_reg}, 'b1111);
        // write(1'b0, UART_CLK_DIV_REG_ADDR, {clk_div_reg}, 'b1111);
        // write(1'b0, UART_TX_FIFO_DATA_ADDR, {tx_fifo_data_reg}, 'b1111);

        read(1'b0, REG_TX_FIFO_STATUS_ADDR);

        #100;
        
    
        phase.drop_objection(this);
        `uvm_info(get_full_name, "Basic Test run phase finished, objection dropped.", UVM_LOW);
    endtask
    



    
endclass
