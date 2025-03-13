# Asynchronous-FIFO

# Overview
An Asynchronous FIFO is a memory buffer that allows data to be written and read at different clock rates. This implementation uses separate counters for the read and write domains and synchronizes them to ensure reliable operation across clock domains. The FIFO also includes flags to indicate when it is empty or full.

# Features
-> Asynchronous Operation: Supports independent read and write clocks (clk_r and clk_w).
-> Separate Counters: Uses separate counters (wr_counter and rd_counter) for the write and read domains.
-> Synchronization: Implements synchronization for counters to safely cross clock domains.
-> Full and Empty Flags: Provides buf_full and buf_empty signals to indicate FIFO status.
->Configurable Depth: The FIFO depth is fixed at 64, but the code can be easily modified for other depths.

# Code Structure
The Verilog code consists of the following key components:

-> Pointers: Read and write pointers (rd_ptr and wr_ptr) to track the current position in the FIFO.
-> Counters: Separate counters (wr_counter and rd_counter) for the write and read domains.
-> Synchronization: Synchronized versions of counters (wr_counter_sync and rd_counter_sync) for cross-clock domain communication.

# Inputs and Outputs

# Inputs:
-> clk_r: Read clock.
->clk_w: Write clock.
-> rstn: Active-low reset.
-> wr_en: Write enable signal.
-> rd_en: Read enable signal.
-> buf_in: Input data (8-bit width).

# Outputs:
-> buf_out: Output data (8-bit width).
-> buf_empty: Indicates FIFO is empty.
-> buf_full: Indicates FIFO is full.

