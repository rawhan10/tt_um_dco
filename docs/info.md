Credits : We gratefully acknowledge the COE in Integrated Circuits and Systems (ICAS) and Department of ECE. Our special thanks to Dr K S Geetha (Vice Principal) and, Dr. K N Subramanya (principal) for their constant support and encouragement to do TAPEOUT in Tiny Tapeout 10 .

## How it works

The tt_um_mac module is a Multiply-Accumulate (MAC) unit designed for high-performance digital signal processing and embedded system applications. This module integrates a Dadda multiplier and a Kogge-Stone adder to achieve efficient and fast computations. The MAC unit performs a sequence of multiplication and accumulation operations, which are essential in various digital signal processing tasks, such as filtering and convolution. Functional Description Input and Output Ports • Inputs: o ui_in (8-bit): Dedicated input for the first operand. o uio_in (8-bit): Input/Output interface for the second operand. o clk (1-bit): Clock signal to synchronize all operations. o rst_n (1-bit): Active-low reset signal to initialize the internal state of the MAC unit. • Outputs: o uo_out (8-bit): Output that holds the final accumulated result. o uio_oe (8-bit): Output enable signal, set to 0 indicating the uio is used as input. o uio_out (8-bit): Unused output path in the current context. Internal Architecturee

## How to test

To verify the functionality of the tt_um_mac module, a testbench (tt_um_mac_tb) has been provided. The testbench simulates different input scenarios and observes the output behavior of the tt_um_mac module to ensure that it works correctly.

The testbench will output the results of the simulation, including the values of the inputs and the resulting output for each test case.
Monitor the output in the console or waveform viewer to ensure the tt_um_mac module behaves as expected.

## External hardware

During the simulation, you can monitor the console or waveform outputs for detailed step-by-step results. The testbench uses $monitor to display real-time updates of the inputs and the resulting output.
