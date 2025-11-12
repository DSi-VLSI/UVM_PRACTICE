`include "dependencies.svh"

class axi_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(axi_scoreboard)

    function new(string name="axi_scoreboard", uvm_component parent=null);
        super.new(name, parent);
    endfunction

    uvm_analysis_imp #(dut_seq_item, axi_scoreboard) m_analysis_imp;

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        m_analysis_imp = new("m_analysis_imp", this);
    endfunction

    virtual function void write(dut_seq_item item);
    endfunction

endclass

    