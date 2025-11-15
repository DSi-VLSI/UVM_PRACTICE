

//  Class: apb_driver
//
class apb_driver extends uvm_driver #(apb_seq_item);
    `uvm_component_utils(apb_driver);

    apb_seq_item item;
    virtual apb_interface apb_inf;


    function new(string name = "apb_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        void'(uvm_config_db #(virtual apb_interface)::get(this, "", "apb_inf", apb_inf));
        `uvm_info("APB_Driver", "Build", UVM_DEBUG);
    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        `uvm_info("APB_Driver", "Connected", UVM_DEBUG);
    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        `uvm_info("APB_Driver", "run phase started", UVM_DEBUG);

        forever begin
            seq_item_port.get_next_item(item);

            if(item.isReset)
                reset();
            else
                write_read();
            
            seq_item_port.item_done(item);

        end


    endtask

    task reset();
        
        apb_inf.apb_req.penable  = 1'b0;
        apb_inf.apb_req.psel     = 1'b0;
        apb_inf.apb_req.pwrite   = 1'b0;
        apb_inf.apb_req.paddr    = 0;
        apb_inf.apb_req.pwdata   = 0;
        apb_inf.apb_req.pstrb    = 0;
        apb_inf.apb_req.pprot    = 0;
        apb_inf.presetn          = 1'b0;
        
        @(posedge apb_inf.pclk);
        apb_inf.presetn          = 1'b1;

        @(posedge apb_inf.pclk);
        
    endtask

    task write_read();

        apb_inf.apb_req.psel = 1'b1;
        apb_inf.apb_req.penable = 1'b0;

        apb_inf.apb_req.pwrite  = item.write;
        apb_inf.apb_req.paddr   = item.addr;
        apb_inf.apb_req.pwdata  = item.data;
        apb_inf.apb_req.pstrb   = 4'b1111;

        @(posedge apb_inf.pclk);
        apb_inf.apb_req.penable = 1'b1;

        for(int i = 0; i<50; i++) begin
            
            if(apb_inf.apb_resp.pready === 1)
                break;
            else
                @(posedge apb_inf.pclk);
                
            if(i === 49) begin
                `uvm_fatal("APB Driver", $sformatf("Something went wrong"));
            end
        end


        apb_inf.apb_req.penable = 1'b0;
        apb_inf.apb_req.psel = 1'b0;

    endtask

   
    
endclass