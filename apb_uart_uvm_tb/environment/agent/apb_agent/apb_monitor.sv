
//  Class: apb_monitor
//
class apb_monitor extends uvm_monitor;
    `uvm_component_utils(apb_monitor);

    virtual apb_interface apb_inf;

    function new(string name = "apb_monitor", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        void'(uvm_config_db #(virtual apb_interface)::get(this, "", "apb_inf", apb_inf));
        `uvm_info("", "Monitor Build Phase", UVM_LOW);
    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("", "Monitor Connect Phase", UVM_LOW);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("", "Monitor run phase started", UVM_HIGH);

        forever begin
            @(posedge apb_inf.pclk);

            if(apb_inf.apb_resp.pready === 1)
                `uvm_info("APB_MONITOR", $sformatf("=> [APB Monitor] :: PADDR: %0h, PWDATA: %0d | PRDATA: %0d, PSTRB: %0d, PWRITE: %d", apb_inf.apb_req.paddr, apb_inf.apb_req.pwdata, apb_inf.apb_resp.prdata, apb_inf.apb_req.pstrb, apb_inf.apb_req.pwrite), UVM_NONE)


            
            
        end

        
    endtask

   
    
endclass