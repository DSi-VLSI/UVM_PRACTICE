package axi_uart_tb_pkg;

    int xactn_len = 0;

    int baud_divisor = 10417;
    typedef logic [15:0] serial_to_parallel_t;
    typedef enum {
        IDLE,
        START,
        DATA,
        PARITY,
        STOP
    } uart_state_t;

endpackage