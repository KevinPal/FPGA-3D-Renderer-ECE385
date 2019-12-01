
module rast_line(
    input logic CLK, RESET,
    input logic init,
    input logic cont,
    input int y,
    input int left_x,
    input int left_z,
    input int right_x,
    input int right_z,
    input int top[4], // x y z bytes(r g b a)
    input int mid[4],
    input int bot[4],
    output byte rgb[3],
    output int xyz[3],
    output logic output_valid,
    output logic done
);

int x_cnt, x_cnt_next;
int z_cnt, z_cnt_next;
int dzBdx, dzBdx_next; // dz by dx

logic init_p;

pos_edge_detect pos_detect(CLK, RESET, init, init_p);

// Unpacked vertex data
int top_vert[3];
int mid_vert[3];
int bot_vert[3];

int top_rgb[3];
int mid_rgb[3];
int bot_rgb[3];

// Normal Calc
int bot_minus_mid[3];
int top_minus_mid[3];
int normal[3];
int area;

vec_sub norm_sub1(bot_vert, mid_vert, bot_minus_mid);
vec_sub norm_sub2(top_vert, mid_vert, top_minus_mid);
vec_cross norm_cross(top_minus_mid, bot_minus_mid, normal);
vec_norm norm_area(normal, area);

//barycentric interpolation calculation
int bot_minus_pos[3];
int mid_minus_pos[3];
int top_minus_pos[3];

int bot_area, bot_area_norm, bot_area_raw[3];
int mid_area, mid_area_norm, mid_area_raw[3];
int top_area, top_area_norm, top_area_raw[3];

vec_sub b_sub1(bot_vert, xyz, bot_minus_pos);
vec_sub b_sub2(mid_vert, xyz, mid_minus_pos);
vec_sub b_sub3(top_vert, xyz, top_minus_pos);

vec_cross b_cross1(mid_minus_pos, top_minus_pos, bot_area_raw);
vec_cross b_cross2(top_minus_pos, bot_minus_pos, mid_area_raw);
vec_cross b_cross3(bot_minus_pos, mid_minus_pos, top_area_raw);

vec_norm b_norm1(bot_area_raw, bot_area_norm);
vec_norm b_norm2(mid_area_raw, mid_area_norm);
vec_norm b_norm3(top_area_raw, top_area_norm);

//RGB interpolation
int bot_rgb_inter[3];
int mid_rgb_inter[3];
int top_rgb_inter[3];
int rgb_inter_temp[3];
int rgb_inter[3];

vec_mul mul_inter1(bot_rgb, bot_area, bot_rgb_inter);
vec_mul mul_inter2(mid_rgb, mid_area, mid_rgb_inter);
vec_mul mul_inter3(top_rgb, top_area, top_rgb_inter);

vec_add add_inter1(bot_rgb_inter, mid_rgb_inter, rgb_inter_temp);
vec_add add_inter2(rgb_inter_temp, top_rgb_inter, rgb_inter);


enum logic [5:0] {
    IDLE,
    INIT,
    RENDERING,
    DONE
} state = IDLE, next_state;

always_comb begin
    //default
    x_cnt_next = x_cnt;
    z_cnt_next = z_cnt;
    dzBdx_next = dzBdx;
    next_state = state;
    rgb = '{0, 0, 0};
    xyz = '{0, 0, 0};
    done = 0;
    output_valid = 0;

    // barycentric finish
    bot_area = (bot_area_norm * (1<<8))/ area;
    mid_area = (mid_area_norm * (1<<8))/ area;
    top_area = (top_area_norm * (1<<8))/ area;



    // Unpack vertex data
    top_vert[0] = top[0];
    top_vert[1] = top[1];
    top_vert[2] = top[2];
    mid_vert[0] = mid[0];
    mid_vert[1] = mid[1];
    mid_vert[2] = mid[2];
    bot_vert[0] = bot[0];
    bot_vert[1] = bot[1];
    bot_vert[2] = bot[2];

    top_rgb = '{top[3][31:24]*(1<<8), top[3][23:16]*(1<<8), top[3][15:8]*(1<<8)};
    mid_rgb = '{mid[3][31:24]*(1<<8), mid[3][23:16]*(1<<8), mid[3][15:8]*(1<<8)};
    bot_rgb = '{bot[3][31:24]*(1<<8), bot[3][23:16]*(1<<8), bot[3][15:8]*(1<<8)};

    // Repack RGB
    rgb = '{rgb_inter[0][15:8], rgb_inter[1][15:8], rgb_inter[2][15:8]};

    if(state == INIT) begin
        x_cnt_next = left_x;
	z_cnt_next = left_z;
        dzBdx_next = ((right_z - left_z) * (1<<8))  / (right_x - left_x);
    end else if(state == RENDERING) begin
        if(cont) begin
            x_cnt_next = x_cnt + (1<<8);
            z_cnt_next = z_cnt + dzBdx;
        end
        xyz = '{x_cnt, y, z_cnt};
        output_valid = 1;
    end else if(state == DONE) begin
        done = 1;
    end

    unique case(state)
        IDLE: begin
            if(init_p)
                next_state = INIT;
            else
                next_state = IDLE;
        end
        INIT: begin
            if(~init_p)
                next_state = RENDERING;
            else
                next_state = INIT;
        end
        RENDERING: begin
            if(x_cnt >= right_x)
                next_state = DONE;
            else
                next_state = RENDERING;
        end
        DONE: begin
            if(init)
                next_state = DONE;
            else
                next_state = IDLE;
        end


    endcase

end


always_ff @ (posedge CLK) begin
    if(RESET) begin
        x_cnt <= 0;
        z_cnt <= 0;
        dzBdx <= 0;
        state <= IDLE;
    end else begin
        x_cnt <= x_cnt_next;
        z_cnt <= z_cnt_next;
        dzBdx <= dzBdx_next;
        state <= next_state;
    end

end

endmodule

// Rasterizes a triangle
module rast_triangle(
    input logic CLK, RESET,
    input logic start,
    input logic cont,
    input int v1_p[4], // x y z int(r g b a)
    input int v2_p[4],
    input int v3_p[4],
    output logic draw_ready,
    output byte rgb[3],
    output int  xyz[3],
    output logic done
);

int v1[3];
int v2[3];
int v3[3];

// Vertex soring vars
int top_p[4];
int mid_p[4];
int bot_p[4];
int temp_p[4];

// Unpacked verticies
int top[3];
int mid[3];
int bot[3];

// Edge inputs/outputs
logic init;
logic e1_step, e2_step, e3_step;

int e1_pos[3], e2_pos[3], e3_pos[3]; 
int e1_min[3], e2_min[3], e3_min[3]; 
int e1_max[3], e2_max[3], e3_max[3]; 


// Edge 1 is from bot to mid, E2 is from mid to top, E3 from ot to top
vert_edge E1(CLK, RESET, init, e1_step, bot, mid, e1_pos, e1_min, e1_max);
vert_edge E2(CLK, RESET, init, e2_step, mid, top, e2_pos, e2_min, e2_max);
vert_edge E3(CLK, RESET, init, e3_step, bot, top, e3_pos, e3_min, e3_max);

// Ceiling functions

// E1 y min ceiling, ...
int e1_ymin_c, e1_ymax_c; 
int e2_ymin_c, e2_ymax_c;
// E1 x ceiling, ...
int e1_x_c, e2_x_c, e3_x_c;

ceil c1(e1_min[1], e1_ymin_c);
ceil c2(e1_max[1], e1_ymax_c);
ceil c3(e2_min[1], e2_ymin_c);
ceil c4(e2_max[1], e2_ymax_c);

ceil c5(e1_pos[0], e1_x_c);
ceil c6(e2_pos[0], e2_x_c);
ceil c7(e3_pos[0], e3_x_c);


// vertical rasterization variables
int y_cnt, y_cnt_next;
int rast_x_min, rast_x_max;
int rast_left_z, rast_right_z;

// horizontal rasterization variables
logic h_rast_init;
logic line_done;
logic h_rast_valid;
rast_line h_rast(CLK, RESET, h_rast_init, cont, y_cnt, rast_x_min, rast_left_z, rast_x_max, rast_right_z,
                            top_p, mid_p, bot_p, rgb, xyz, h_rast_valid, line_done);

assign draw_ready = h_rast_valid;

enum logic [5:0] {
    IDLE,
    INIT1,
    INIT2,
    RENDER_BOT,
    RENDER_TOP,
    WAIT
} state = IDLE, next_state;



always_comb begin

    // defaults
    temp_p[0] = 0;
    temp_p[1] = 0;
    temp_p[2] = 0;
    init = 0;
    y_cnt_next = y_cnt;
    next_state = state;
    rast_x_min = 0;
    rast_x_max = 0;
    rast_left_z = 0;
    rast_right_z = 0;
    e1_step = 0;
    e2_step = 0;
    e3_step = 0;
    h_rast_init = 0;
    done = 0;

    // Sorting logic
    // 0 is top of screen, so bot is really at the top
    
    top_p = v1_p;
    mid_p = v2_p;
    bot_p = v3_p;

    if(bot_p[1] > mid_p[1]) begin // If bot 'below' mid, swap
        temp_p = bot_p;
        bot_p = mid_p;
        mid_p = temp_p;
    end

    if (mid_p[1] > top_p[1]) begin // If mid is below top, swap
        temp_p = mid_p;
        mid_p = top_p;
        top_p = temp_p;
    end

    if (bot_p[1] > mid_p[1]) begin
        temp_p = bot_p;
        bot_p = mid_p;
        mid_p = temp_p;
    end

    // Unpack verticies
    bot[0] = bot_p[0];
    bot[1] = bot_p[1];
    bot[2] = bot_p[2];
    mid[0] = mid_p[0];
    mid[1] = mid_p[1];
    mid[2] = mid_p[2];
    top[0] = top_p[0];
    top[1] = top_p[1];
    top[2] = top_p[2];

    // State output logic
    if((state == INIT1) | (state == INIT2))
        init = 1;
    else
    if(state == RENDER_BOT) begin //TODO y clipping
        // Find left and right edge
        if(e1_pos[0] < e3_pos[0]) begin 
            rast_x_min = e1_x_c;
            rast_x_max = e3_x_c;
            rast_left_z = e1_pos[2];
            rast_right_z = e3_pos[2];
        end else begin
            rast_x_min = e3_x_c;
            rast_x_max = e1_x_c;
            rast_left_z = e3_pos[2];
            rast_right_z = e1_pos[2];
        end
        //TODO  Draw line from x_min to x_max, and lerp z, and y=y_cnt
        if(line_done) begin
            e1_step = 1;
            e3_step = 1;
            y_cnt_next = y_cnt + (1<<8);
            h_rast_init = 0;
        end else begin
            h_rast_init = 1;
        end
        

    end
    else if(state == RENDER_TOP) begin
        if(e2_pos[0] < e3_pos[0]) begin
            rast_x_min = e2_x_c;
            rast_x_max = e3_x_c;
            rast_left_z = e2_pos[2];
            rast_right_z = e3_pos[2];
        end else begin
            rast_x_min = e3_x_c;
            rast_x_max = e2_x_c;
            rast_left_z = e3_pos[2];
            rast_right_z = e2_pos[2];
        end
        //TODO  Draw line from x_min to x_max, and lerp z, and y=y_cnt
        if(line_done) begin
            e2_step = 1;
            e3_step = 1;
            y_cnt_next = y_cnt + (1<<8);
            h_rast_init = 0;
        end else begin
            h_rast_init = 1;
        end
    end else if(state == WAIT) begin
        done = 1;
    end
    

    // Next state logic
    unique case(state)
        IDLE: begin
            if(start)
                next_state = INIT1;
            else 
                next_state = IDLE;
        end
        INIT1: begin
            next_state = INIT2;
        end
        INIT2: begin
            next_state = RENDER_BOT;
            y_cnt_next = e1_ymin_c;
        end
        RENDER_BOT: begin
            if(y_cnt >= e1_ymax_c) begin
                next_state = RENDER_TOP;
                y_cnt_next = e2_ymin_c;
            end
            else begin
                next_state = RENDER_BOT;
            end
        end
        RENDER_TOP: begin
            if(y_cnt >= e2_ymax_c)
                next_state = WAIT;
            else 
                next_state = RENDER_TOP;
        end
        WAIT: begin
            if(~start) 
                next_state = IDLE;
            else
                next_state = WAIT;
        end
        default:
            next_state = state;
    endcase


end

always_ff @ (posedge CLK) begin
    if(RESET) begin
        state <= IDLE;
        y_cnt <= 0;
    end else begin
        state <= next_state;
        y_cnt <= y_cnt_next;
    end
        
end

endmodule

// TODO figure out why init takes 2 cycles
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
    yPreStep = 32'hxxxx; 
    steps[0] = 32'hxxxxxxxx;
    steps[1] = 32'hxxxxxxxx;
    steps[2] = 32'hxxxxxxxx;

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

