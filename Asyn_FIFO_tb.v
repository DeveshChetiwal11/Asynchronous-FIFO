module Async_FIFO_tb;

parameter DATA_WIDTH = 8;
parameter ADDR_WIDTH = 3;

reg wr_clk,rd_clk,rst;
reg wr_en,rd_en;
reg [DATA_WIDTH-1:0] wr_data;
wire [DATA_WIDTH-1:0] rd_data;
wire full,empty;

	Async_FIFO dut (.wr_clk(wr_clk),.rst(rst),.rd_clk(rd_clk),.wr_en(wr_en),.rd_en(rd_en),.rd_data(rd_data),.wr_data(wr_data),.full(full),.empty(empty));

initial begin
$monitor("time = %0t, wr_en = %b,rd_en = %b,wr_data = %h,rd_data =%h, full = %b,empty =%b",$time,wr_en,rd_en,wr_data,rd_data,full,empty);

wr_clk = 0;
forever #5 wr_clk = ~wr_clk;
end

initial begin
rd_clk = 0;
forever #10 rd_clk = ~rd_clk;
end

initial begin
rst = 1;
wr_en =0;
rd_en =0;

#10;
rst = 0;

repeat(16) begin
@(posedgewr_clk);
if(!full) begin
wr_en = 1;
wr_data = $random;
end
end

@(posedge wr_clk);
wr_en = 0;

repeat(16) begin
	@(posedge(rd_clk):
	if(!empty) begin
	rd_en=1;
	end
	@(posedge rd_clk);
	rd_en =0;
end
	#50;
	$finish;
end 
endmodule
	

