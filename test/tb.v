`default_nettype none
`timescale 1ns / 1ps 

/* This testbench just instantiates the module and makes some convenient wires
   that can be driven / tested by the cocotb test.py.
*/
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
	reg [7:0] dco_code;
	wire dco_out;
  
  wire [7:0] ui_in;
  wire [7:0] uo_out;
  wire [7:0] uio_in, uio_out, uio_oe;

	`ifdef GL_TEST
   supply1 VPWR; // Define VPWR as a logic '1'
   supply0 VGND; // Define VGND as a logic '0'
   `endif

  // Replace tt_um_example with your module name:
  tt_um_dco user_project (

      // Include power ports for the Gate Level test:
`ifdef GL_TEST
      .VPWR(VPWR),
      .VGND(VGND),
`endif

      .ui_in  (ui_in),    // Dedicated inputs
      .uo_out (uo_out),   // Dedicated outputs
      .uio_in (uio_in),   // IOs: Input path
      .uio_out(uio_out),  // IOs: Output path
      .uio_oe (uio_oe),   // IOs: Enable path (active high: 0=input, 1=output)
      .ena    (ena),      // enable - goes high when design is selected
      .clk    (clk),      // clock
	  .rst_n  (rst_n)     // not reset
  );
assign ui_in = dco_code;
	assign uo_out = dco_out;
always #10 clk = ~clk;
  
  initial begin
    clk = 1;
    rst_n = 1;
    ena = 1;
    dco_code = 8'b00000001;
    
      #20 rst_n = 0; ena = 1;
    // #400 dco_code = 8'b00000001;
    #4000 dco_code = 8'b00000010;
    #4000 dco_code = 8'b00000100;
    #4000 dco_code = 8'b00001000;
    #4000 dco_code = 8'b00010000;
    #4000 dco_code = 8'b00100000;
    #4000 dco_code = 8'b01000000;
    #4000 dco_code = 8'b10000000;
    
//    #10 reset = 1;
//    #10 reset = 0;
    
    #60000 $finish;
  end
initial begin
    $monitor("Time=%0t | ui_in=%b, uo_out=%b | reset=%b | clk=%b",
             $time, ui_in, uo_out, rst_n, clk);
  end

endmodule
