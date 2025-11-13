
//  Class: apb_monitor
//
class apb_monitor extends uvm_monitor;
    `uvm_component_utils(apb_monitor);
    uvm_analysis_port #(apb_seq_item) apb_port;

    virtual apb_interface apb_inf;

    function new(string name = "apb_monitor", uvm_component parent = null);
        super.new(name, parent);
        apb_port = new("apb_port", this);
        `uvm_info("APB_Monitor", "Constructed", UVM_DEBUG);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        void'(uvm_config_db #(virtual apb_interface)::get(this, "", "apb_inf", apb_inf));
        `uvm_info("APB_Monitor", "Build", UVM_DEBUG);
    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("APB_Monitor", "Connected", UVM_DEBUG);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("APB_Monitor", "run phase started", UVM_DEBUG);

        forever begin
            @(posedge apb_inf.pclk);

            if(apb_inf.apb_resp.pready)
                `uvm_info("APB_MONITOR", $sformatf("PADDR: %0h, PWDATA: %0d | PRDATA: %0d, PSTRB: %0d, PWRITE: %d", apb_inf.apb_req.paddr, apb_inf.apb_req.pwdata, apb_inf.apb_resp.prdata, apb_inf.apb_req.pstrb, apb_inf.apb_req.pwrite), UVM_LOW)


            
            
        end

        
    endtask

   
    
endclass