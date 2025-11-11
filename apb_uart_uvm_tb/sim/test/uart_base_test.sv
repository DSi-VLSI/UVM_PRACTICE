
`include "apb/typedef.svh"

class uart_base_test extends uvm_test;

    import base_pkg::REG_CTRL_ADDR;
    import base_pkg::REG_CONFIG_ADDR;
    import base_pkg::REG_CLK_DIV_ADDR;
    import base_pkg::REG_TX_FIFO_STAT_ADDR;
    import base_pkg::REG_RX_FIFO_STAT_ADDR;
    import base_pkg::REG_TX_FIFO_DATA_ADDR;
    import base_pkg::REG_RX_FIFO_DATA_ADDR;
    import base_pkg::REG_RX_FIFO_PEEK_ADDR;

    import base_pkg::ctrl_reg_t;
    import base_pkg::config_reg_t;
    import base_pkg::clk_div_reg_t;
    import base_pkg::tx_fifo_stat_reg_t;
    import base_pkg::rx_fifo_stat_reg_t;
    import base_pkg::tx_fifo_data_reg_t;
    import base_pkg::rx_fifo_data_reg_t;
    import base_pkg::rx_fifo_peek_reg_t;

    `uvm_component_utils(uart_base_test)

    uart_environment    env;
    apb_base_seq        base_seq;
    apb_write_seq       write_seq;
    apb_read_seq        read_seq;
    apb_reset_seq       reset_seq;


    function new(string name = "uart_base_test", uvm_component parent = null);
        super.new(name, parent);
        env = uart_environment::type_id::create("env", this);
        `uvm_info(get_full_name, "Base Test Constructed", UVM_LOW);
    endfunction



    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        `uvm_info(get_full_name, "Base Test Build Phase", UVM_LOW);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_full_name, "Base Test Connect Phase", UVM_LOW)
    endfunction

    task run_phase(uvm_phase phase);
        phase.raise_objection(this);
        `uvm_info(get_full_name, "Base Test run phase started, objection raised.", UVM_LOW)

        phase.drop_objection(this);
        `uvm_info(get_full_name, "Base Test run phase finished, objection dropped.", UVM_LOW)
    endtask

    task write(bit random, addr_width_t paddr, data_width_t pwdata, strb_width_t pstrb);
        write_seq = apb_write_seq::type_id::create("write_seq");
        write_seq.pwdata = pwdata;
        write_seq.paddr = paddr;
        write_seq.pstrb = pstrb;
        write_seq.isRandom = random;
        write_seq.start(env.apb_agnt.apb_seqr); 
    endtask

    task reset();
        reset_seq = apb_reset_seq::type_id::create("reset_seq");
        reset_seq.start(env.apb_agnt.apb_seqr); 
    endtask

    task read(bit random, addr_width_t paddr);
        read_seq = apb_read_seq::type_id::create("read_seq");
        read_seq.paddr = paddr;
        read_seq.isRandom = random;
        read_seq.start(env.apb_agnt.apb_seqr); 
    endtask

endclass
