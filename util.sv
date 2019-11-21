

//  Ceiling of the min and max of 2 24.8 fixed point numbers
module ceil_min_max(
    input int a,
    input int b,
    output int min,
    output int max
);

int min_raw;
int max_raw;

always_comb begin
    if(a < b) begin
        min_raw = a;
        max_raw = b;
    end else begin
        min_raw = b;
        max_raw = a;
    end

    if(min_raw[7:0] == 0)
        min = min_raw;
    else begin
        min = min_raw + (1 << 8);
        min[7:0] = 0;
    end

    if(max_raw[7:0] == 0)
        max = max_raw;
    else begin
        max = max_raw + (1 << 8);
        max[7:0] = 0;
    end
end

endmodule


module pos_edge_detect(
    input logic CLK,
    input logic RESET,
    input logic signal,
    output logic pe
);

logic last_sig = 0;
logic delayed_sig = 0;

always_ff @ (posedge CLK) begin
    if(RESET) begin
        delayed_sig <= 0;
        last_sig <= 0;
    end else begin
        last_sig <= signal;
        delayed_sig <= last_sig;
    end
end

assign pe = signal & (~delayed_sig);

endmodule


// Ceiling of a 24.8 fixed point number
module ceil(
    input int val,
    output int out
);

always_comb begin
    if(val[7:0] == 0)
        out = val;
    else begin
        out = val + (1 << 8);
        out[7:0] = 0;
    end
end

endmodule

module abs(
    input int a,
    output int b
);

assign b = (a < 0) ? (-1 * a) : a;

endmodule
