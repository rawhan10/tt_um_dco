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

    wire [7:0] dco_code;
    reg dco_out;

    assign dco_code = ui_in;
    assign dco_out = uo_out[0];
    assign uo_out[7:1] = 0;

    module dco(
    input        clk,
    input        rst_n,
    input        ena,
    input  [7:0] dco_code,
    output reg   dco_out
);
  
    wire [7:0] coarse;  
    assign coarse = dco_code[7:0];

    reg [7:0] period;
    reg [7:0] counter;
    reg [7:0] prev_period;
    reg fast_clk;  
    reg [3:0] fast_clk_div;
    wire resetn = ~rst_n;
    
    // Compute period based on coarse control bits (example mapping)
    always @(*) begin
        casez (coarse)
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
    
    // Fast clock generation
    always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            fast_clk_div <= 4'd0;
            fast_clk <= 1'b0;
        end else begin
            fast_clk_div <= fast_clk_div + 1;
            if (fast_clk_div == 4'd4) begin  
                fast_clk <= ~fast_clk;
                fast_clk_div <= 4'd0;
            end
        end
    end
    
    // DCO operation
    always @(posedge clk or negedge resetn) begin
        if (~resetn) begin
            counter <= 8'd0;
            dco_out <= 1'b0;
        end else if (ena) begin
            if (counter >= prev_period) begin
                dco_out <= ~dco_out;
                counter <= 8'd0;
            end else begin
                counter <= counter + 1;
            end        
        end
    end
    
    always @(posedge fast_clk) begin 
        prev_period <= period;
    end
    
endmodule

    



