
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
        `uvm_info(get_full_name, "Monitor Build Phase", UVM_LOW);
    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info(get_full_name, "Monitor Connect Phase", UVM_LOW);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info(get_full_name, "Monitor run phase started", UVM_HIGH);

        forever begin
            @(posedge apb_inf.pclk);
            // `uvm_info(get_name, $sformatf("[APB Monitor] :: PADDR: %0d, PWDATA: %0d, PSTRB: %0d, PWRITE: %d", apb_inf.apb_req.paddr, apb_inf.apb_req.pwdata, apb_inf.apb_req.pstrb, apb_inf.apb_req.pwrite_i), UVM_NONE)

            $display("[APB Monitor] :: PADDR: %0d, PWDATA: %0d, PSTRB: %0d, PWRITE: %d | PRDATA: %0d", apb_inf.apb_req.paddr, apb_inf.apb_req.pwdata, apb_inf.apb_req.pstrb, apb_inf.apb_req.pwrite, apb_inf.apb_resp.prdata);
            
        end

        
    endtask

   
    
endclass