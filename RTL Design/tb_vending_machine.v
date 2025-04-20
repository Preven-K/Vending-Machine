module tb_vending_machine;

    parameter MAX_ITEMS = 1024;
    parameter MAX_CURRENCY = 100;

    reg clk;                
    reg rstn;
    reg cfg_mode;

    reg pclk;             
    reg prstn;
    reg psel;
    reg pwrite;
    reg [14:0] paddr;
    reg [31:0] pwdata;
    wire [31:0] prdata;
    wire pready;

    reg currency_clk;       
    reg currency_valid;
    reg [$clog2(MAX_CURRENCY)-1:0] currency_value;
    reg item_select_valid;
    reg [$clog2(MAX_ITEMS)-1:0] item_select; 

    wire item_dispense_valid;
    wire [$clog2(MAX_ITEMS)-1:0] item_dispense;
    wire [$clog2(MAX_CURRENCY)-1:0] currency_change;

    vending_machine #(.MAX_ITEMS(MAX_ITEMS),.MAX_CURRENCY(MAX_CURRENCY)) 
        uut( 
        .clk(clk),
        .rstn(rstn),
        .cfg_mode(cfg_mode),
        .pclk(pclk),
        .prstn(prstn),
        .psel(psel),
        .pwrite(pwrite),
        .paddr(paddr),
        .pwdata(pwdata),
        .prdata(prdata),
        .pready(pready),
        .currency_clk(currency_clk),
        .currency_valid(currency_valid),
        .currency_value(currency_value),
        .item_select(item_select),
        .item_select_valid(item_select_valid),
        .item_dispense_valid(item_dispense_valid),
        .item_dispense(item_dispense),
        .currency_change(currency_change)
    );

    // Clock generation
    always #5 clk = ~clk; // 100MHz system clock
    always #50 pclk = ~pclk;// 10MHz config clock
    always #100 currency_clk = ~currency_clk;// 5MHz currency clock

    initial begin
        clk = 0;
        pclk = 0;
        currency_clk = 0;
        rstn = 0;
        cfg_mode = 0;
        prstn = 0;
        psel = 0;
        pwrite = 0;
        paddr = 0;
        pwdata = 0;
        currency_valid = 0;
        currency_value = 0;
        item_select = 0;
        item_select_valid = 0;
/////////////////////////////////////////////////////////////
        #10 rstn = 1; prstn = 1;

        cfg_mode = 1;
        #20;

        // Item 0
        @(posedge pclk);
        psel = 1;
        pwrite = 1;
        paddr = 15'd4;  // 4-4/4 = 0
        pwdata = {8'd0, 8'd10, 16'd10}; // {Dispensed Items, Available Items, Price}
        @(posedge pclk);
        psel = 0;
        
        // Item 1
        @(posedge pclk);
        psel = 1;
        pwrite = 1; 
        paddr = 15'd8;  // 8-4 / 4 = 1
        pwdata = {8'd0, 8'd5, 16'd20}; // {Dispensed Items, Available Items, Price}
        @(posedge pclk);
        psel = 0;
        
        // Item 2
        @(posedge pclk);
        psel = 1;
        pwrite = 1;
        paddr = 15'd12; // 12-4 / 4 = 2
        pwdata = {8'd0, 8'd4, 16'd30}; // {Dispensed Items, Available Items, Price}
        @(posedge pclk);
        psel = 0;
        
        // Item 3
        @(posedge pclk);
        psel = 1;
        pwrite = 1;
        paddr = 15'd16; 
        pwdata = {8'd0, 8'd3, 16'd40}; // {Dispensed Items, Available Items, Price}
        @(posedge pclk);
        psel = 0;
        
        // Item 4
        @(posedge pclk);
        psel = 1;
        pwrite = 1;
        paddr = 15'd20; 
        pwdata = {8'd0, 8'd1, 16'd50}; // {Dispensed Items, Available Items, Price}
        @(posedge pclk);
        psel = 0;        
//////////////////////////////////////////////////////////        
        @(posedge pclk);
        cfg_mode = 0; 
        pwrite = 0; 
        #50;
    // Test 1
    @(posedge clk);
    item_select_valid = 1;
    item_select = 10'd2; // Item 2
    @(posedge clk);
    item_select_valid = 0;
    #1000;
    @(posedge currency_clk);
    currency_valid = 1;
    currency_value = 7'd99; // currency = 99rs
    @(posedge currency_clk);
    currency_valid = 0;
    #1000; 
    
    // Test 2
    @(posedge clk);
    item_select_valid = 1;
    item_select = 10'd2; // Item 2
    item_select_valid = 0;
    #1000;
    @(posedge currency_clk);
    currency_valid = 1;
    currency_value = 7'd50;// rs 50
    @(posedge currency_clk);
    currency_valid = 0;
    #1000;
    
    // Test 3
    @(posedge clk);
    item_select_valid = 1;
    item_select = 10'd3; // Item 3 
    @(posedge clk);
    item_select_valid = 0;
    #1000;
    @(posedge currency_clk);
    currency_valid = 1;
    currency_value = 7'd50; // rs 50
    @(posedge currency_clk);
    currency_valid = 0;
    #1000;
    
    // Test 4
    @(posedge clk);
    item_select_valid = 1;
    item_select = 10'd1; // Item 1 
    @(posedge clk);
    item_select_valid = 0;
    #1000;
    @(posedge currency_clk);
    currency_valid = 1;
    currency_value = 7'd5; // rs 5
    @(posedge currency_clk);
    currency_valid = 0;
    #1000;

    
    // Test 5
    @(posedge clk);
    item_select_valid = 1;
    item_select = 10'd4; // Item 4
    @(posedge clk);
    item_select_valid = 0;
    #1000;
    @(posedge currency_clk);
    currency_valid = 1;
    currency_value = 7'd50; // rs 50 
    @(posedge currency_clk);
    currency_valid = 0;
    #1000;
    
        // Test 6: 
    @(posedge clk);
    item_select_valid = 1;
    item_select = 10'd4; // Item 4
    @(posedge clk);
    item_select_valid = 0;
    #1000;
    @(posedge currency_clk);
    currency_valid = 1;
    currency_value = 7'd50; // rs 50
    @(posedge currency_clk);
    currency_valid = 0;
    #1000;
        // Test 7: 
    @(posedge clk);
    item_select_valid = 1;
    item_select = 10'd6; // Item 6
    @(posedge clk);
    item_select_valid = 0;
    #1000;
    @(posedge currency_clk);
    currency_valid = 1;
    currency_value = 7'd100; // rs 100
    @(posedge currency_clk);
    currency_valid = 0;
    #1000;
   

    

    #5000;
    $finish;
end


endmodule