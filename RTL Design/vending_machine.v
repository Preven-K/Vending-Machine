module vending_machine #(
    parameter MAX_ITEMS = 1024,   
    parameter MAX_CURRENCY = 100 
)(
    input wire clk, // 100MHz system clock
    input wire rstn,  // Active-low reset
    input wire cfg_mode,        

    input wire pclk,  // 10MHz config clck
    input wire prstn,              
    input wire psel,              
    input wire pwrite,
    input wire [14:0] paddr,
    input wire [31:0] pwdata,
    output reg [31:0] prdata,   
    output reg pready,  

    input wire currency_clk,      // 5MHz for currency input
    input wire currency_valid,    
    input wire [$clog2(MAX_CURRENCY)-1:0] currency_value, 
    input wire item_select_valid,  
    input wire [$clog2(MAX_ITEMS)-1:0] item_select,     

    output reg item_dispense_valid, 
    output reg [$clog2(MAX_ITEMS)-1:0] item_dispense,    
    output reg [$clog2(MAX_CURRENCY)-1:0] currency_change
);

    localparam RESET = 2'b00;
    localparam CONFIG_MODE = 2'b01;
    localparam OPERATION_MODE = 2'b10;
    localparam EMPTY_ITEM = MAX_ITEMS - 1; // 11111111


    reg [1:0] state;
    reg [31:0] memory [0:MAX_ITEMS-1];
    reg [$clog2(MAX_ITEMS)-1:0] selected_item;
    reg item_selected;

    wire [15:0] item_price = memory[selected_item][15:0];
    wire [7:0] available_items = memory[selected_item][23:16];
    wire [7:0] dispensed_items = memory[selected_item][31:24];
    

     
    integer i;
    reg [7:0] new_dispensed_items;
    reg [7:0] new_available_items;
    
    // CDC synchronization
    reg currency_valid_sync1, currency_valid_sync2;
    reg [$clog2(MAX_CURRENCY)-1:0] currency_value_sync1, currency_value_sync2;
    reg currency_valid_pulse;


    // Clock Domain Crossing
    always @(posedge currency_clk or negedge rstn) begin
        if (!rstn) begin
            currency_valid_sync1 <= 0;
            currency_value_sync1 <= 0;
        end else begin
            currency_valid_sync1 <= currency_valid;
            currency_value_sync1 <= currency_value;
        end
    end
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            currency_valid_sync2 <= 0;
            currency_value_sync2 <= 0;
            currency_valid_pulse <= 0;
        end else begin
            currency_valid_sync2 <= currency_valid_sync1;
            currency_value_sync2 <= currency_value_sync1;
            currency_valid_pulse <= currency_valid_sync2 & ~currency_valid_sync1;
        end
    end

    // FSM
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            state <= RESET;
            item_dispense_valid <= 0;
            currency_change <= 0;
            item_dispense <= 0;
            pready <= 0;
            prdata <= 0;
            selected_item <= 0;
            item_selected <= 0;

            for (i = 0; i < MAX_ITEMS; i = i + 1)
                memory[i] <= 32'b0;
        end else begin
            case (state)
                RESET: begin
                    state <= cfg_mode ? CONFIG_MODE : OPERATION_MODE;
                end

                CONFIG_MODE: begin
                    if (psel) begin
                        pready <= 1;
                        if (pwrite)
                            memory[(paddr - 15'h0004) >> 2] <= pwdata;
                        else 
                            prdata <= memory[(paddr - 15'h0004) >> 2];
                    end else begin
                        pready <= 0;
                    end
                    if (!cfg_mode) state <= OPERATION_MODE;
                end

                OPERATION_MODE: begin
                    item_dispense_valid <= 1'b0;
                    
                    if (item_select_valid) begin
                        if (memory[item_select][23:16] > 0) begin // Check availability
                            selected_item <= item_select;
                            item_selected <= 1'b1;
                            currency_valid_sync2 <= 0; 
                        end else begin
                            // Item unavailable
                            item_dispense_valid <= 1'b1;
                            item_dispense <= EMPTY_ITEM;
                            selected_item <= -1;
                            item_selected <= 0;
                            currency_change <= -1;
                            currency_valid_sync2 <= 0;
                        end
                    end
                    
                    if (item_selected) begin
                        if (currency_valid_pulse) begin
                            case (currency_value_sync2)
                                5, 10, 15, 20, 50, 100: begin
                                    if (( currency_value_sync2) >= item_price) begin
                                        item_dispense_valid <= 1'b1;
                                        item_dispense <= selected_item;
                                        currency_change <= currency_value_sync2 - item_price;
                                  
                                        new_dispensed_items = dispensed_items + 1;
                                        new_available_items = available_items - 1;
                
                                        
                                        memory[selected_item] <= {new_dispensed_items, new_available_items, item_price};
                                        item_selected <= 1'b0;
                                        currency_valid_sync2 <= 0;
                                    end
                                    else begin
                                        item_dispense_valid <= 1'b1;
                                        item_dispense <= EMPTY_ITEM;
                                        currency_change <=  currency_value_sync2;
                                    end
                                end
                                default: begin
                                    item_dispense_valid <= 1'b1;
                                    item_dispense <= EMPTY_ITEM;
                                    currency_change <=  currency_value_sync2;
                                end
                            endcase
                        end
                        
                    end
                   if (cfg_mode) state <= OPERATION_MODE;

                end 
            endcase
        end
    end
endmodule