


module Edge(
    input logic CLK, RESET,
    input logic init,
    input logic step,
    input int bot[3],
    input int top[3],
    output int current_pos[3]
);

int current_pos_next[3];

always_comb begin
    current_pos_next = current_pos;

    if(init) begin

    end
end


always_ff @ (posedge CLK) begin
    if(RESET)
        current_pos <= '{0, 0, 0};
    else
        current_pos <= current_pos_next;
end

endmodule


module project_cube(
    input int scale,
    input int pos[3],
    input int prj[4][4],
    output int out[8][3]
);

// 8 vertex locations
int back_top_left[4];
int back_top_right[4];
int back_bot_left[4];
int back_bot_right[4];
int front_top_left[4];
int front_top_right[4];
int front_bot_left[4];
int front_bot_right[4];

int all_verticies[8][4];
int prj_vert[8][4];
int screen_verts[8][3];

assign all_verticies = '{back_top_left, back_top_right, back_bot_left, back_bot_right, front_top_left, front_top_right, front_bot_left, front_bot_right};

mat_vec_mul projectors[8](.m1(prj), .vec(all_verticies), .out(prj_vert));
viewport_trans view_transformers[8](.vec(prj_vert), .out(screen_verts));

assign out = screen_verts;

always_comb begin
    // Start at position
    back_top_left[0] = pos[0];
    back_top_right[0] = pos[0];
    back_bot_left[0] = pos[0];
    back_bot_right[0] = pos[0];
    front_top_left[0] = pos[0];
    front_top_right[0] = pos[0];
    front_bot_left[0] = pos[0];
    front_bot_right[0] = pos[0];

    back_top_left[1] = pos[1];
    back_top_right[1] = pos[1];
    back_bot_left[1] = pos[1];
    back_bot_right[1] = pos[1];
    front_top_left[1] = pos[1];
    front_top_right[1] = pos[1];
    front_bot_left[1] = pos[1];
    front_bot_right[1] = pos[1];

    back_top_left[2] = pos[2];
    back_top_right[2] = pos[2];
    back_bot_left[2] = pos[2];
    back_bot_right[2] = pos[2];
    front_top_left[2] = pos[2];
    front_top_right[2] = pos[2];
    front_bot_left[2] = pos[2];
    front_bot_right[2] = pos[2];

    // W component is 1
    
    back_top_left[3] = 1 * (1<<8);
    back_top_right[3] = 1 * (1<<8);
    back_bot_left[3] = 1 * (1<<8);
    back_bot_right[3] = 1 * (1<<8);
    front_top_left[3] = 1 * (1<<8);
    front_top_right[3] = 1 * (1<<8);
    front_bot_left[3] = 1 * (1<<8);
    front_bot_right[3] = 1 * (1<<8);

    // All right verticies need to be shifted to the right by scale
    back_top_right[0] += scale;
    back_bot_right[0] += scale;
    front_top_right[0] += scale;
    front_bot_right[0] += scale;

    // All bot verticies need to be shifted down by scale
    back_bot_left[1] -= scale;
    back_bot_right[1] -= scale;
    front_bot_left[1] -= scale;
    front_bot_right[1] -= scale;

    // All front verticies need to be shifted fowards by scale
    front_top_left[2] += scale;
    front_top_right[2] += scale;
    front_bot_left[2] += scale;
    front_bot_right[2] += scale;
end

endmodule

module viewport_trans(
    input int vec[4],
    output int out[3]
);

int pers_div[3];

always_comb begin
    // Persepective divide
    pers_div[0] = (vec[0]*(1<<8)) / vec[3];
    pers_div[1] = (vec[1]*(1<<8)) / vec[3];
    pers_div[2] = (vec[2]*(1<<8)) / vec[3];
    // Viewport transform
    out[0] = pers_div[0] + ((((1*(1<<8)) + pers_div[0])*(320*(1<<8)))/(1<<8));
    out[1] = pers_div[1] + ((((1*(1<<8)) - pers_div[1])*(240*(1<<8)))/(1<<8));
    out[2] = pers_div[2];
end

endmodule
