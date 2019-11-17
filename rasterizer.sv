

module rect_rast(
    input logic CLK, RESET,
    input logic init,
    input int vec1[3],
    input int vec2[3],
    input int vec3[3],
    input int vec4[3]
);

int top[3];
int bot[3];
int left[3];
int right[3];

always_comb begin
    // Bot has smallest Y
    bot = vec1;
    if(vec2[1] < bot[1])
        bot = vec2
    if(vec3[1] < bot[1])
        bot = vec3
    if(vec4[1] < bot[1])
        bot = vec4

    // Top has largest Y
    top = vec1;
    if(vec2[1] > top[1])
        top = vec2
    if(vec3[1] > top[1])
        top = vec3
    if(vec4[1] > top[1])
        top = vec4

    // Left has smallest X
    left = vec1;
    if(vec2[0] < left[0])
        left = vec2
    if(vec3[0] < left[0])
        left = vec3
    if(vec4[0] < left[0])
        left = vec4

    // Right has largest X
    right = vec1;
    if(vec2[0] > right[0])
        right = vec2
    if(vec3[0] > right[0])
        right = vec3
    if(vec4[0] > right[0])
        right = vec4

end

endmodule

module vert_edge(
    input logic CLK, RESET,
    input logic init,
    input logic step,
    input int bot[3],
    input int top[3],
    output int current_pos[3],
    output int mins[3],
    output int maxs[3]
);

int current_pos_next[3];
int dxBdy, dxBdyNext; // dx by dy
int dzBdy, dzBdyNext; // dz by dy
int yPreStep;
int steps[3]; //dx, dy, dz

int min_pos[3];
int max_pos[3];

logic init_p, step_p; // positive edge of control singals

pos_edge_detect posdetectors(CLK, RESET, init, init_p);

ceil_min_max minmaxers[3](bot, top, min_pos, max_pos);

always_comb begin
    current_pos_next = current_pos;
    dxBdyNext = dxBdy;
    dzBdyNext = dzBdy;

    // helper vars during init, not needed other times
    yPreStep = 4'hxxxx; 
    steps[0] = 8'hxxxxxxxx;
    steps[1] = 8'hxxxxxxxx;
    steps[2] = 8'hxxxxxxxx;

    if(init) begin
        steps[0] = top[0] - bot[0];
        steps[1] = top[1] - bot[1];
        steps[2] = top[2] - bot[2];

        yPreStep = min_pos[1] - bot[1];  // minY - bot.Y
        dxBdyNext = (steps[0] * (1<<8))/steps[1];
        dzBdyNext = (steps[2] * (1<<8))/steps[1];
        current_pos_next[0] = (bot[0] + ((yPreStep * dxBdyNext)/(1<<8)));
        current_pos_next[2] = (bot[2] + ((yPreStep * dzBdyNext)/(1<<8)));

        current_pos_next[1] = (bot[1] + yPreStep);
    end else if(step) begin
        current_pos_next[0] += dxBdy;
        current_pos_next[2] += dzBdy;
        current_pos_next[1] += (1<<8);
    end
end

assign mins = min_pos;
assign maxs = max_pos;

always_ff @ (posedge CLK) begin
    if(RESET) begin
        current_pos <= '{0, 0, 0};
        dxBdy <= 0;
        dzBdy <= 0;
    end
    else begin
        current_pos <= current_pos_next;
        dxBdy <= dxBdyNext; 
        dzBdy <= dzBdyNext; 
    end
end

endmodule

module pos_edge_detect(
    input logic CLK,
    input logic RESET,
    input logic signal,
    output logic pe
);

logic delayed_sig = 0;

always_ff @ (posedge CLK) begin
    if(RESET)
        delayed_sig <= 0;
    else
        delayed_sig <= signal;
end

assign pe = signal & (~delayed_sig);

endmodule

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
