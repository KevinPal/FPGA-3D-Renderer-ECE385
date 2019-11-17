module testbench_fifo();

timeunit 10ns;
timeprecision 1ns;

logic RD_CLK, WT_CLK;
logic [47:0] data;
logic read_req;
logic write_req;

logic [47:0] q;
logic rdempty;
logic wrfull;
logic [7:0] used;

fifo buffer(data, RD_CLK, read_req, WT_CLK, write_req, q, rdempty, wrfull, used);


always begin : CLOCK_GENERATION
#1 
WT_CLK = ~WT_CLK;
RD_CLK = ~RD_CLK;
#1
WT_CLK = ~WT_CLK;
end

initial begin: CLOCK_INITIALIZATION
    RD_CLK = 0;
    WT_CLK = 0;
end 

initial begin: TEST_VECTORS
    write_req = 1;
    data = $random;
    #1
    data = $random;
    #1
    data = $random;
    #1
    data = $random;
    #1
    data = $random;
    #1
    data = $random;
end
endmodule
