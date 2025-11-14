
//  Class: apb_monitor
//
class apb_monitor extends uvm_monitor;
    `uvm_component_utils(apb_monitor);
    uvm_analysis_port #(apb_seq_item) apb_port;

    virtual apb_interface apb_inf;

    apb_seq_item item;

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

            if(apb_inf.presetn != 0&& apb_inf.apb_resp.pready) begin

                if(apb_inf.apb_req.pwrite && apb_inf.apb_req.paddr == base_pkg::REG_TX_FIFO_DATA_ADDR) begin
                    item = apb_seq_item::type_id::create("item");
                    item.pwdata = apb_inf.apb_req.pwdata;
                    item.isTx = 1;
                    item.isRx = 0;
                    apb_port.write(item);
                end
                else if(apb_inf.apb_req.pwrite == 0 && apb_inf.apb_req.paddr == base_pkg::REG_RX_FIFO_DATA_ADDR ) begin
                    item = apb_seq_item::type_id::create("item");
                    item.pwdata = apb_inf.apb_req.pwdata;
                    item.isRx = 1;
                    item.isTx = 0;
                    apb_port.write(item);

                end
                

            end
                


            // if(apb_inf.apb_resp.pready)
            //     `uvm_info("APB_MONITOR", $sformatf("PADDR: %0h, PWDATA: %0d | PRDATA: %0d, PSTRB: %0d, PWRITE: %d", apb_inf.apb_req.paddr, apb_inf.apb_req.pwdata, apb_inf.apb_resp.prdata, apb_inf.apb_req.pstrb, apb_inf.apb_req.pwrite), UVM_LOW)


            
            
        end

        
    endtask

   
    
endclass