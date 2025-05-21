module Async_FIFO #(
parameter ADDR_WIDTH = 4,
parameter DATA_WIDTH = 8
)(
input rd_clk,wr_clk,rst,wr_en,rd_en,
input [DATA_WIDTH-1:0] wr_data,
output [DATA_WIDTH-1:0] rd_data,
output full,empty);

localparam DEPTH = (1 << ADDR_WIDTH);

//FIFO Memory
reg [DATA_WIDTH-1:0] mem [DEPTH-1:0];

// Binary and Gray code pointers
reg [ADDR_WIDTH-1:0] rd_ptr_bin,rd_ptr_gray;
reg [ADDR_WIDTH-1:0] wr_ptr_bin,wr_ptr_gray;

// Synchronized pointers
reg [ADDR_WIDTH-1:0] rd_ptr_gray_sync1,rd_ptr_gray_sync2;
reg [ADDR_WIDTH-1:0] wr_ptr_gray_sync1,wr_ptr_gray_sync2;

//Write Logic
always @(posedge wr_clk or posedge rst) begin
    if(rst) begin
    wr_ptr_bin <= 0;
    wr_ptr_gray <= 0;
    end
    else if(wr_en && !full) begin
    mem[wr_ptr_bin[ADDR_WIDTH-1:0]] <= wr_data;
    wr_ptr_bin <= wr_ptr_bin + 1;
    wr_ptr_gray <= (wr_ptr_bin+1) ^ ((wr_ptr_bin+1)>>1);
    end
end

//Read Logic
always @(posedge rd_clk or posedge rst) begin
    if(rst) begin
    rd_ptr_bin <= 0;
    rd_ptr_gray <= 0;
    end
    else if(rd_en && !empty) begin
    rd_data <= mem[rd_ptr_bin[ADDR_WIDTH-1:0]];
    rd_ptr_bin <= rd_ptr_bin + 1;
    rd_ptr_gray <= (rd_ptr_bin +1) ^ ((rd_ptr_bin +1)>>1);
    end
end

// Synchronize read pointers to write clock domain
always @(posedge wr_clk or posedge rst) begin
    if(rst) begin
    rd_ptr_gray_sync1 <= 0;
    rd_ptr_gray_sync2 <= 0;
    end
    else begin
    rd_ptr_gray_sync1 <= rd_ptr_gray;
    rd_ptr_gray_sync2 <= rd_ptr_gray_sync1;
    end
end

// Synchronize write pointers to ead clock domain
always @(posedge rd_clk or posedge rst) begin
    if(rst) begin
    wr_ptr_gray_sync1 <= 0;
    wr_ptr_gray_sync2 <= 0;
    end
    else begin
    wr_ptr_gray_sync1 <= wr_ptr_gray;
    wr_ptr_gray_sync2 <= wr_ptr_gray_sync1;
    end
end

// Full condition logic
assign full = (wr_ptr_gray == {~rd_ptr_gray_sync2[ADDR_WIDTH-1],rd_ptr_gray_sync2[ADDR_WIDTH-2:0]});

// Empty condition logic
assign empty = (rd_ptr_gray == wr_ptr_gray_sync2);
    
endmodule 
    

