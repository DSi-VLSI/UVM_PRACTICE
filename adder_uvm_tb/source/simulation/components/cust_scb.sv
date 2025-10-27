//----------------------------------------------------------------------
// Class: cust_scb
//
// The scoreboard verifies the correctness of the DUT. It receives
// input operands (opa, opb) and the calculated result (sum) from
// one or more monitors. It synchronizes these transactions and checks
// if `sum` is equal to `opa + opb`.
//----------------------------------------------------------------------

`ifndef __CUST_CUST_SCB_SV__
`define __CUST_CUST_SCB_SV__ 0

`include "rsp_item.sv"

// The `uvm_analysis_imp_decl` macro is used to create a unique analysis
// implementation port for each input stream (opa, opb, sum). This is
// necessary because a component can only have one `write` function by
// default. By using this macro, we create specialized `uvm_analysis_imp`
// classes (`uvm_analysis_imp_opa`, `uvm_analysis_imp_opb`, etc.) that
// will call unique `write` functions (`write_opa`, `write_opb`, etc.).
`uvm_analysis_imp_decl(_opa)
`uvm_analysis_imp_decl(_opb)
`uvm_analysis_imp_decl(_sum)

class cust_scb extends uvm_scoreboard;

  // UVM Factory Registration: Registers this component with the UVM factory.
  `uvm_component_utils(cust_scb)

  //--------------------------------------------------------------------
  // Component Handles
  //--------------------------------------------------------------------

  // Analysis implementation ports to receive transactions from the monitors.
  // Each port is connected to a monitor and calls a specific `write` function
  // when a transaction is received.
  uvm_analysis_imp_opa #(rsp_item, cust_scb) m_analysis_imp_opa;
  uvm_analysis_imp_opb #(rsp_item, cust_scb) m_analysis_imp_opb;
  uvm_analysis_imp_sum #(rsp_item, cust_scb) m_analysis_imp_sum;

  //--------------------------------------------------------------------
  // Data Members
  //--------------------------------------------------------------------

  // Queues to store incoming transactions from each monitor. Using queues
  // allows the scoreboard to handle transactions arriving at different times
  // and synchronize them before performing the check.
  protected rsp_item opa_q[$];
  protected rsp_item opb_q[$];
  protected rsp_item sum_q[$];

  // Counters to track the number of passed and failed checks.
  protected int pass_count = 0;
  protected int fail_count = 0;

  //--------------------------------------------------------------------
  // Methods
  //--------------------------------------------------------------------

  // Constructor: new
  // Standard UVM constructor.
  function new(string name = "cust_scb", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  // Function: build_phase
  // Create the analysis implementation ports.
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create an instance of each analysis
    m_analysis_imp_opa = new($sformatf("m_analysis_imp_opa"), this);
    m_analysis_imp_opb = new($sformatf("m_analysis_imp_opb"), this);
    m_analysis_imp_sum = new($sformatf("m_analysis_imp_sum"), this);
  endfunction

  // Function: write_opa
  // Implementation for the `opa` analysis port. Called by the monitor.
  function void write_opa(rsp_item item);
    `uvm_info(get_type_name(), $sformatf("Received OPA item: %s", item.sprint()), UVM_HIGH)
    opa_q.push_back(item);
  endfunction

  // Function: write_opb
  // Implementation for the `opb` analysis port. Called by the monitor.
  function void write_opb(rsp_item item);
    `uvm_info(get_type_name(), $sformatf("Received OPB item: %s", item.sprint()), UVM_HIGH)
    opb_q.push_back(item);
  endfunction

  // Function: write_sum
  // Implementation for the `sum` analysis port. Called by the monitor.
  function void write_sum(rsp_item item);
    `uvm_info(get_type_name(), $sformatf("Received SUM item: %s", item.sprint()), UVM_HIGH)
    sum_q.push_back(item);
  endfunction

  // Task: run_phase
  // This task contains the main checking logic of the scoreboard. It runs
  // continuously, waiting for transactions from all input monitors,
  // calculating the expected result, and comparing it against the actual
  // result from the DUT.
  task run_phase(uvm_phase phase);
    // Local handles for transactions popped from the queues.
    rsp_item opa_item, opb_item, sum_item;
    // Variable to hold the predicted result.
    bit [127:0] expected_sum;
    // Variable to store the DUT's data width from the config_db.
    int DATA_WIDTH;

    // Retrieve the 'data_width' that was set in the testbench top module.
    // This makes the scoreboard adaptable to different DUT configurations.
    // If the configuration is not found, it's a critical setup error.
    if (!uvm_config_db#(int)::get(uvm_root::get(), "dut", "data_width", DATA_WIDTH)) begin
      `uvm_fatal(get_type_name(),
                 "Failed to get 'data_width' from uvm_config_db. Check tb_adder_top.sv.")
    end

    // The main checking loop runs for the duration of the test.
    forever begin
      // 1. SYNCHRONIZE: Wait until we have at least one item in each queue.
      // This is the core synchronization point. The scoreboard will block here
      // until it has received an operand A, an operand B, and a sum from the DUT.
      wait (opa_q.size() > 0 && opb_q.size() > 0 && sum_q.size() > 0);

      // 2. GET: Dequeue one transaction from each input stream.
      // This assumes a 1-to-1 correspondence and ordering of transactions.
      opa_item = opa_q.pop_front();
      opb_item = opb_q.pop_front();
      sum_item = sum_q.pop_front();

      // 3. PREDICT: Calculate the expected result based on the inputs.
      expected_sum = opa_item.data + opb_item.data;

      // Since the transaction 'data' field is 128 bits wide, we must mask the
      // result to the actual DATA_WIDTH of the DUT. This ensures that any
      // overflow bits from the addition are ignored, mimicking the DUT's behavior.
      for (int i = DATA_WIDTH; i < 128; i++) begin
        expected_sum[i] = 0;
      end

      // 4. CHECK: Compare the actual result from the DUT with the predicted result.
      if (sum_item.data == expected_sum) begin
        `uvm_info(get_type_name(), $sformatf("PASS: %0d + %0d == %0d", opa_item.data,
                                             opb_item.data, sum_item.data), UVM_MEDIUM)
        pass_count++;
      end else begin
        // The error message includes the inputs, the incorrect actual result,
        // and the correct expected result for easier debugging.
        `uvm_error(get_type_name(), $sformatf(
                   "FAIL: %0d + %0d => DUT produced %0d, but expected %0d",
                   opa_item.data,
                   opb_item.data,
                   sum_item.data,
                   expected_sum
                   ))
        fail_count++;
      end
    end
  endtask

  // Function: report_phase
  // Reports the final pass/fail statistics.
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("--- Scoreboard Summary ---"), UVM_NONE)
    `uvm_info(get_type_name(), $sformatf("Passed: %0d", pass_count), UVM_NONE)
    `uvm_info(get_type_name(), $sformatf("Failed: %0d", fail_count), UVM_NONE)
    `uvm_info(get_type_name(), "--------------------------", UVM_NONE)
    if (fail_count > 0) begin
      `uvm_error(get_type_name(), "Test FAILED")
    end else begin
      `uvm_info(get_type_name(), "Test PASSED", UVM_NONE)
    end
  endfunction

endclass

`endif
