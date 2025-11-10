// ============================================================================
// UART Register Interface Module
// ============================================================================
// Description:
//   Memory-mapped register interface for UART peripheral control and data
//   transfer. Provides access to control, configuration, status, and FIFO
//   data registers through a simple memory interface.
//
// Register Map:
//   0x00 - Control Register (RW)       : Clock enable and FIFO flush control
//   0x04 - Configuration Register (RW) : UART communication parameters
//   0x08 - Clock Divisor Register (RW) : Baud rate divisor
//   0x0C - TX FIFO Status (R)          : TX FIFO occupancy count
//   0x10 - RX FIFO Status (R)          : RX FIFO occupancy count
//   0x14 - TX FIFO Data (W)            : Write data to transmit
//   0x20 - RX FIFO Data (R)            : Read and pop received data
//   0x28 - RX FIFO Peek (R)            : Read received data (non-destructive)
// ============================================================================

module uart_reg_if #(
    localparam int ADDR_WIDTH = 6,  // Address bus width (supports up to 64 byte address space)
    localparam int DATA_WIDTH = 32, // Data bus width

    // ========================================================================
    // Register Addresses
    // ========================================================================

    localparam int REG_CTRL_ADDR = 6'h00,
    localparam int REG_CONFIG_ADDR = 6'h04,
    localparam int REG_CLK_DIV_ADDR = 6'h08,
    localparam int REG_TX_FIFO_STAT_ADDR = 6'h0C,
    localparam int REG_RX_FIFO_STAT_ADDR = 6'h10,
    localparam int REG_TX_FIFO_DATA_ADDR = 6'h14,
    localparam int REG_RX_FIFO_DATA_ADDR = 6'h18,
    localparam int REG_RX_FIFO_PEEK_ADDR = 6'h1C
) (
    // ========================================================================
    // Global Signals
    // ========================================================================
    input logic arst_ni,  // Active-low asynchronous reset
    input logic clk_i,    // System clock

    // ========================================================================
    // Memory Write Interface
    // ========================================================================
    input  logic                    mem_we_i,     // Write enable
    input  logic [  ADDR_WIDTH-1:0] mem_waddr_i,  // Write address
    input  logic [  DATA_WIDTH-1:0] mem_wdata_i,  // Write data
    input  logic [DATA_WIDTH/8-1:0] mem_wstrb_i,  // Write strobe (byte enables)
    output logic [             1:0] mem_wresp_o,  // Write response (00: OKAY, 10: SLVERR)

    // ========================================================================
    // Memory Read Interface
    // ========================================================================
    input  logic                  mem_re_i,     // Read enable
    input  logic [ADDR_WIDTH-1:0] mem_raddr_i,  // Read address
    output logic [DATA_WIDTH-1:0] mem_rdata_o,  // Read data
    output logic [           1:0] mem_rresp_o,  // Read response (00: OKAY, 10: SLVERR)

    // ========================================================================
    // Control Register (0x00) Outputs
    // ========================================================================
    output logic ctrl_clk_en_o,    // Clock enable for UART
    output logic tx_fifo_flush_o,  // Flush TX FIFO (self-clearing)
    output logic rx_fifo_flush_o,  // Flush RX FIFO (self-clearing)

    // ========================================================================
    // Configuration Register (0x04) Outputs
    // ========================================================================
    output logic cfg_parity_en_o,    // Enable parity checking
    output logic cfg_parity_type_o,  // Parity type (0: Even, 1: Odd)
    output logic cfg_stop_bits_o,    // Stop bits (0: 1 bit, 1: 2 bits)
    output logic cfg_rx_int_en_o,    // RX interrupt enable

    // ========================================================================
    // Clock Divisor Register (0x08) Output
    // ========================================================================
    output logic [DATA_WIDTH-1:0] clk_div_o,  // Clock divisor for baud rate generation

    // ========================================================================
    // TX FIFO Status Register (0x0C) Input
    // ========================================================================
    input logic [DATA_WIDTH-1:0] tx_fifo_count_i,  // Current TX FIFO occupancy

    // ========================================================================
    // RX FIFO Status Register (0x10) Input
    // ========================================================================
    input logic [DATA_WIDTH-1:0] rx_fifo_count_i,  // Current RX FIFO occupancy

    // ========================================================================
    // TX FIFO Data Register (0x14) Interface
    // ========================================================================
    output logic [7:0] tx_fifo_data_o,        // Data to be transmitted
    output logic       tx_fifo_data_valid_o,  // Data valid signal
    input  logic       tx_fifo_data_ready_i,  // FIFO ready to accept data

    // ========================================================================
    // RX FIFO Data Register (0x20) Interface
    // ========================================================================
    input  logic [7:0] rx_fifo_data_i,        // Received data from FIFO
    input  logic       rx_fifo_data_valid_i,  // Data valid from FIFO
    output logic       rx_fifo_data_ready_o   // Ready to read data (pop from FIFO)
);

  // ==========================================================================
  // Write Logic (Combinational)
  // ==========================================================================
  // Handles write operations to writable registers. Returns OKAY response
  // when write is successful, SLVERR otherwise. Some writes are conditional
  // based on FIFO state or readiness.
  // ==========================================================================
  always_comb begin : write_logic
    mem_wresp_o = 2'b10;  // Default: SLVERR (slave error)
    tx_fifo_data_o = mem_wdata_i[7:0];
    tx_fifo_data_valid_o = 1'b0;
    if (mem_we_i) begin
      case (mem_waddr_i)

        REG_CTRL_ADDR: begin
          // Control register: Always writable
          mem_wresp_o = 2'b00;  // OKAY
        end

        REG_CONFIG_ADDR: begin
          // Configuration register: Only writable when both FIFOs are empty
          // This prevents changing UART parameters mid-transaction
          if (tx_fifo_count_i == 0 && rx_fifo_count_i == 0) begin
            mem_wresp_o = 2'b00;  // OKAY
          end
        end

        REG_CLK_DIV_ADDR: begin
          // Clock divisor register: Only writable when both FIFOs are empty
          // This prevents baud rate changes during active communication
          if (tx_fifo_count_i == 0 && rx_fifo_count_i == 0) begin
            mem_wresp_o = 2'b00;  // OKAY
          end
        end

        REG_TX_FIFO_DATA_ADDR: begin
          // TX FIFO data register: Only writable when FIFO has space
          if (tx_fifo_data_ready_i) begin
            mem_wresp_o = 2'b00;  // OKAY
            tx_fifo_data_valid_o = 1'b1;  // Assert valid to push data
          end
        end

      endcase
    end
  end

  // ==========================================================================
  // Read Logic (Combinational)
  // ==========================================================================
  // Handles read operations from readable registers. Returns OKAY response
  // when read is successful, SLVERR otherwise. Some reads are conditional
  // based on FIFO data availability.
  // ==========================================================================
  always_comb begin : read_logic
    mem_rresp_o = 2'b10;  // Default: SLVERR (slave error)
    rx_fifo_data_ready_o = 1'b0;
    if (mem_re_i) begin
      case (mem_raddr_i)

        REG_CTRL_ADDR: begin
          // Read control register
          mem_rresp_o = 2'b00;  // OKAY
          mem_rdata_o = {'0, rx_fifo_flush_o, tx_fifo_flush_o, ctrl_clk_en_o};
        end

        REG_CONFIG_ADDR: begin
          // Read configuration register
          mem_rresp_o = 2'b00;  // OKAY
          mem_rdata_o = {'0, cfg_rx_int_en_o, cfg_stop_bits_o, cfg_parity_type_o, cfg_parity_en_o};
        end

        REG_CLK_DIV_ADDR: begin
          // Read clock divisor register
          mem_rresp_o = 2'b00;  // OKAY
          mem_rdata_o = {'0, clk_div_o};
        end

        REG_TX_FIFO_STAT_ADDR: begin
          // Read TX FIFO status (occupancy count)
          mem_rresp_o = 2'b00;  // OKAY
          mem_rdata_o = {'0, tx_fifo_count_i};
        end

        REG_RX_FIFO_STAT_ADDR: begin
          // Read RX FIFO status (occupancy count)
          mem_rresp_o = 2'b00;  // OKAY
          mem_rdata_o = {'0, rx_fifo_count_i};
        end

        REG_RX_FIFO_DATA_ADDR: begin
          // Read RX FIFO data (destructive read - pops from FIFO)
          if (rx_fifo_data_valid_i) begin
            mem_rresp_o = 2'b00;  // OKAY
            rx_fifo_data_ready_o = 1'b1;  // Assert ready to pop data
            mem_rdata_o = {'0, rx_fifo_data_i};
          end
        end

        REG_RX_FIFO_PEEK_ADDR: begin
          // Peek RX FIFO data (non-destructive read - does not pop)
          if (rx_fifo_data_valid_i) begin
            mem_rresp_o = 2'b00;  // OKAY
            mem_rdata_o = {'0, rx_fifo_data_i};
          end
        end

      endcase
    end
  end

  // ==========================================================================
  // Register Update Logic (Sequential)
  // ==========================================================================
  // Updates register values on successful writes. Registers are reset to
  // default values on async reset.
  // ==========================================================================
  always_ff @(posedge clk_i or negedge arst_ni) begin
    if (~arst_ni) begin
      // Reset all registers to default values
      ctrl_clk_en_o     <= '0;
      tx_fifo_flush_o   <= '0;
      rx_fifo_flush_o   <= '0;
      cfg_parity_en_o   <= '0;
      cfg_parity_type_o <= '0;
      cfg_stop_bits_o   <= '0;
      cfg_rx_int_en_o   <= '0;
      clk_div_o         <= '0;
    end else begin
      // Update registers on successful write (OKAY response)
      if (mem_wresp_o == 0) begin
        unique case (mem_waddr_i)

          REG_CTRL_ADDR: begin
            // Update control register fields
            ctrl_clk_en_o   <= mem_wdata_i[0];  // Bit 0: Clock enable
            tx_fifo_flush_o <= mem_wdata_i[1];  // Bit 1: TX FIFO flush
            rx_fifo_flush_o <= mem_wdata_i[2];  // Bit 2: RX FIFO flush
          end

          REG_CONFIG_ADDR: begin
            // Update configuration register fields
            cfg_parity_en_o   <= mem_wdata_i[0];  // Bit 0: Parity enable
            cfg_parity_type_o <= mem_wdata_i[1];  // Bit 1: Parity type
            cfg_stop_bits_o   <= mem_wdata_i[2];  // Bit 2: Stop bits
            cfg_rx_int_en_o   <= mem_wdata_i[3];  // Bit 3: RX interrupt enable
          end

          REG_CLK_DIV_ADDR: begin
            // Update clock divisor register (full 32-bit value)
            clk_div_o <= mem_wdata_i[DATA_WIDTH-1:0];
          end

          REG_TX_FIFO_DATA_ADDR: begin
            // TX FIFO data write - no register state to update
            // Data is pushed to FIFO via tx_fifo_data_o and tx_fifo_data_valid_o
          end

        endcase
      end
    end
  end

endmodule
