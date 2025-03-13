module Async_FIFO(
    input clk_r, clk_w, rstn, wr_en, rd_en,
    input [7:0] buf_in,
    output reg [7:0] buf_out,
    output reg buf_empty, buf_full
);

    reg [3:0] rd_ptr, wr_ptr; // Pointers for read and write
    reg [7:0] buf_mem[63:0];  // FIFO memory

    // Separate counters for read and write domains
    reg [7:0] wr_counter; // Counter for write domain
    reg [7:0] rd_counter; // Counter for read domain

    // Synchronized versions of counters for cross-clock domain
    reg [7:0] wr_counter_sync; // Synchronized write counter in read domain
    reg [7:0] rd_counter_sync; // Synchronized read counter in write domain

    // Combinational logic for empty and full flags
    always @(*) begin
        buf_empty = (wr_counter_sync == rd_counter);
        buf_full  = (wr_counter - rd_counter_sync == 64);
    end

    // Write logic
    always @(posedge clk_w or negedge rstn) begin
        if (!rstn) begin
            wr_ptr <= 0;
            wr_counter <= 0;
        end else if (!buf_full && wr_en) begin
            buf_mem[wr_ptr] <= buf_in;
            wr_ptr <= wr_ptr + 1;
            wr_counter <= wr_counter + 1;
        end
    end

    // Read logic
    always @(posedge clk_r or negedge rstn) begin
        if (!rstn) begin
            rd_ptr <= 0;
            rd_counter <= 0;
            buf_out <= 0;
        end else if (!buf_empty && rd_en) begin
            buf_out <= buf_mem[rd_ptr];
            rd_ptr <= rd_ptr + 1;
            rd_counter <= rd_counter + 1;
        end
    end

    // Synchronize wr_counter to read domain
    always @(posedge clk_r or negedge rstn) begin
        if (!rstn) begin
            wr_counter_sync <= 0;
        end else begin
            wr_counter_sync <= wr_counter;
        end
    end

    // Synchronize rd_counter to write domain
    always @(posedge clk_w or negedge rstn) begin
        if (!rstn) begin
            rd_counter_sync <= 0;
        end else begin
            rd_counter_sync <= rd_counter;
        end
    end

endmodule 