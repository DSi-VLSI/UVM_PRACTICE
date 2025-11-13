
//  Class: uart_basic_test
//

class uart_basic_test extends uart_base_test;

    `uvm_component_utils(uart_basic_test)

    ctrl_reg_t           ctl_reg;
    cfg_reg_t            cfg_reg;
    clk_div_reg_t        clk_div_reg;
    tx_fifo_data_reg_t   tx_fifo_data_reg;
    rx_fifo_data_reg_t   rx_fifo_data_reg;

    reg_transaction      reg_trans;


    function new(string name = "uart_basic_test", uvm_component parent = null);
        super.new(name, parent);
    endfunction


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        reg_trans = new();
        uvm_config_db #(reg_transaction)::set(this, "env.uart_agnt.*", "reg_trans", reg_trans);
        `uvm_info("Basic Test", "Build", UVM_DEBUG);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("Basic Test", "Connected", UVM_DEBUG);
    endfunction

    task configure_phase(uvm_phase phase);
        phase.raise_objection(this);
    
        // Initialize UART Control Register
        ctl_reg.CLK_EN = 'b1;
        ctl_reg.TX_FIFO_FLUSH = 'b0;
        ctl_reg.RX_FIFO_FLUSH = 'b0;
        ctl_reg.Reserved = '0;


        // Initialize UART Configuration Register
        cfg_reg.PARITY_EN = 'b1;
        cfg_reg.PARITY_TYPE = 'b00;
        cfg_reg.STOP_BITS = 'b0;
        cfg_reg.RX_INT_EN = 'b1;
        cfg_reg.Reserved = '0;
        
        // Initialize UART Clock Divider Register
        clk_div_reg.CLK_DIV = 868; // Assuming a clock divider value of 868 for baud 115200 with a 100MHz clock

        // Initialize UART TX FIFO Data Register
        tx_fifo_data_reg.TX_DATA = 'b10111010; // Example data to transmit
        tx_fifo_data_reg.Reserved = '0;

        // Assign to reg_transaction
        rx_fifo_data_reg.Reserved = 'b0;
        rx_fifo_data_reg.RX_DATA = 'b00111100; // Example received data



        
        reg_trans.ctrl_reg          = ctl_reg;
        reg_trans.cfg_reg           = cfg_reg;
        reg_trans.clk_div_reg       = clk_div_reg;
        reg_trans.tx_fifo_data_reg  = tx_fifo_data_reg;
        reg_trans.rx_fifo_data_reg  = rx_fifo_data_reg;

    
        phase.drop_objection(this);
    endtask
    

    

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info("Basic Test", "run phase started, objection raised.", UVM_DEBUG);

        $display("ctl_reg = %b", ctl_reg);
        
        reset();
        write(1'b0, REG_CTRL_ADDR, {ctl_reg}, 'b1111);
        write(1'b0, REG_CFG_ADDR, {cfg_reg}, 'b1111);
        write(1'b0, REG_CLK_DIV_ADDR, {clk_div_reg}, 'b1111);

        write(1'b0, REG_TX_FIFO_DATA_ADDR, {tx_fifo_data_reg}, 'b1111);
        write(1'b0, REG_TX_FIFO_DATA_ADDR, {tx_fifo_data_reg}, 'b1111);
        // tx_fifo_data_reg.TX_DATA = 'b00111100;
        // write(1'b0, REG_TX_FIFO_DATA_ADDR, {tx_fifo_data_reg}, 'b1111);

        rx_transfer(1'b0, rx_fifo_data_reg.RX_DATA); // Non-random RX transfer with specified data
        rx_transfer(1'b0, rx_fifo_data_reg.RX_DATA); // Non-random RX transfer with specified data



        #350us;
    
        phase.drop_objection(this);
        `uvm_info("Basic Test", "run phase finished, objection dropped.", UVM_DEBUG);
    endtask
    
endclass
