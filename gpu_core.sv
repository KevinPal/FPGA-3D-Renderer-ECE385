


module project_cube(
    input real scale,
    input real pos[3],
    input real prj[4][4],
    output real out[8][3]
);

// 8 vertex locations
real back_top_left[4];
real back_top_right[4];
real back_bot_left[4];
real back_bot_right[4];
real front_top_left[4];
real front_top_right[4];
real front_bot_left[4];
real front_bot_right[4];

real all_verticies[8][4];
real prj_vert[8][4];
real screen_verts[8][3];

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
    
    back_top_left[3] = 1;
    back_top_right[3] = 1;
    back_bot_left[3] = 1;
    back_bot_right[3] = 1;
    front_top_left[3] = 1;
    front_top_right[3] = 1;
    front_bot_left[3] = 1;
    front_bot_right[3] = 1;

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
    input real vec[4],
    output real out[3]
);

real pers_div[3];

always_comb begin
    // Persepective divide
    pers_div[0] = vec[0] / vec[3];
    pers_div[1] = vec[1] / vec[3];
    pers_div[2] = vec[2] / vec[3];
    // Viewport transform
    out[0] = pers_div[0] + ((1 + pers_div[0])*320);
    out[1] = pers_div[1] + ((1 - pers_div[1])*240);
    out[2] = pers_div[3];
end

endmodule
