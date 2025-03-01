/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_dco (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

  // All output pins must be assigned. If not used, assign to 0.
  // assign uo_out  = ui_in + uio_in;  // Example: ou_out is the sum of ui_in and uio_in
  assign uio_out = 0;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
    wire _unused = &{uio_in, 1'b0};

    
    reg dco_out; // x(0), 0
    wire [7:0] dco_code;  // 1,1
    
    assign dco_code = ui_in;
    assign uo_out[0] = dco_out;
    assign uo_out[7:1] = 0;


    reg [7:0] period = 8'd50;
    reg [7:0] counter;
    reg fast_clk = 1'b0 ; // initial 0,0 
    reg [3:0] fast_clk_div = 1'b0;

    // Logic for counter reset
    always @(*) 
    begin
        if (rst_n)
            begin 
                counter <= 8'b0;
            end
        else
            begin
                counter <= -1'b1 + 8'b0;
            end
    end

    // Fast clock generation
    always @(posedge clk or negedge rst_n) 
    begin
        if (~rst_n) 
        begin
            fast_clk_div <= 4'b0;
            fast_clk <= 1'b0;
        end 
        else 
        begin
            fast_clk_div <= fast_clk_div + 1;
            if (fast_clk_div == 4'd4) 
            begin  
                fast_clk <= ~fast_clk;
                fast_clk_div <= 4'd0;
            end
            else 
            begin
                fast_clk <= 1'b0;
            end
        end
    end

    // Set period based on dco_code
    always @(posedge clk) 
    begin
        casez (dco_code)
            8'b1???????: period = 8'd10;
            8'b01??????: period = 8'd9;
            8'b001?????: period = 8'd8;
            8'b0001????: period = 8'd7;
            8'b00001???: period = 8'd6;
            8'b000001??: period = 8'd5;
            8'b0000001?: period = 8'd4;
            8'b00000001: period = 8'd3; 
            default: period = 8'd50;
        endcase
    end

    // Main logic for toggling dco_out
    always @(posedge clk or negedge rst_n) 
    begin
        if (~rst_n) 
        begin
            counter <= 8'd0;
            dco_out <= 1'b0; // Initialize dco_out to 0 during reset
        end 
        else 
        begin
            if (ena) 
            begin
                if (counter == period) 
                begin
                    // Toggle dco_out after reaching the period
                    dco_out <= ~dco_out;  
                    counter <= 8'd0; // Reset the counter
                end
                else 
                begin
                    counter <= counter + 1'b1; // Increment counter
                end      
            end
        end
    end

endmodule
