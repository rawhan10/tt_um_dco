
`timescale 1ns / 1ps
`default_nettype none
module tb ();

  // Dump the signals to a VCD file. You can view it with gtkwave or surfer.
  initial begin
    $dumpfile("tb.vcd");
    $dumpvars(0, tb);
    #1;
  end

  // Wire up the inputs and outputs:
  reg clk;
  reg rst_n;
  reg ena;
  reg [7:0] ui_in;  // Changed from wire to reg
  wire [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;
  
`ifdef GL_TEST
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  tt_um_dco user_project (
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif
      .ui_in  (ui_in),    
      .uo_out (uo_out),  
      .uio_in (uio_in),  
      .uio_out(uio_out),  
      .uio_oe (uio_oe),  
      .ena    (ena),      
      .clk    (clk),      
      .rst_n  (rst_n)     
  );

  reg [7:0] dco_code;  

  always @(*) ui_in = dco_code; // Fixed wire assignment issue
  always #10 clk = ~clk;
  
  initial begin
    clk = 0;
    rst_n = 1;
    ena = 0;
    dco_code = 8'b00000000;
    
    #10 rst_n = 0; ena = 1;
    #4000 dco_code = 8'b00000001;
    #4000 dco_code = 8'b00000010;
    #4000 dco_code = 8'b00000100;
    #4000 dco_code = 8'b00001000;
    #4000 dco_code = 8'b00010000;
    #4000 dco_code = 8'b00100000;
    #4000 dco_code = 8'b01000000;
    #4000 dco_code = 8'b10000000;
    
    #10 rst_n = 1;
    #10 rst_n = 0;
    
    #2000 $finish;
  end

endmodule
