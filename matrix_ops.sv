
module gen_prj_mat(
    input int  half_width,
    input int  half_height,
    input int  near,
    input int  far,
    output int  prj[4][4]
);

assign prj[0][0] = (near * (1<<8)) / half_width;
assign prj[0][1] = 0;
assign prj[0][2] = 0;
assign prj[0][3] = 0;
assign prj[1][0] = 0;
assign prj[1][1] = (near * (1<<8)) / half_height;
assign prj[1][2] = 0;
assign prj[1][3] = 0;
assign prj[2][0] = 0;
assign prj[2][1] = 0;
assign prj[2][2] = (far * (1<<8)) / (near - far);
assign prj[2][3] = (-1) * (1<<8);
assign prj[3][0] = 0;
assign prj[3][1] = 0;
assign prj[3][2] = (near*far/(1<<8))/(near-far);
assign prj[3][3] = 0;

endmodule

module gen_trans_mat(
    input int scale,
    input int pos[3],
    output int out[4][4]
);

assign out[0][0] = scale;
assign out[0][1] = 0;
assign out[0][2] = 0;
assign out[0][3] = pos[0];
assign out[1][0] = 0;
assign out[1][1] = scale;
assign out[1][2] = 0;
assign out[1][3] = pos[1];
assign out[2][0] = 0;
assign out[2][1] = 0;
assign out[2][2] = scale;
assign out[2][3] = pos[2];
assign out[3][0] = 0;
assign out[3][1] = 0;
assign out[3][2] = 0;
assign out[3][3] = 1 * (1<<8);

endmodule

module gen_camera_mat(
    input int x_axis[3],
    input int y_axis[3],
    input int z_axis[3],
    input int camera_pos[3],
    output int out[4][4]
);

int dot_pos[3];

vec_dot dot1(x_axis, camera_pos, dot_pos[0]);
vec_dot dot2(y_axis, camera_pos, dot_pos[1]);
vec_dot dot3(z_axis, camera_pos, dot_pos[2]);

assign out[0][0] = x_axis[0];
assign out[0][1] = y_axis[0];
assign out[0][2] = z_axis[0];
assign out[0][3] = 0;
assign out[1][0] = x_axis[1];
assign out[1][1] = y_axis[1];
assign out[1][2] = z_axis[1];
assign out[1][3] = 0;
assign out[2][0] = x_axis[2];
assign out[2][1] = y_axis[2];
assign out[2][2] = z_axis[2];
assign out[2][3] = 0;
assign out[3][0] = dot_pos[0];
assign out[3][1] = dot_pos[1];
assign out[3][2] = dot_pos[2];
assign out[3][3] = 1 * (1<<8);

endmodule

module mat_vec_mul(
    input int  m1[4][4],
    input int vec[4],
    output int out[4]
);

assign out[0] =   ((m1[0][0] * vec[0])/(1<<8)) + ((m1[0][1] * vec[1])/(1<<8)) + ((m1[0][2] * vec[2])/(1<<8)) + ((m1[0][3] * vec[3])/(1<<8));
assign out[1] =   ((m1[1][0] * vec[0])/(1<<8)) + ((m1[1][1] * vec[1])/(1<<8)) + ((m1[1][2] * vec[2])/(1<<8)) + ((m1[1][3] * vec[3])/(1<<8));
assign out[2] =   ((m1[2][0] * vec[0])/(1<<8)) + ((m1[2][1] * vec[1])/(1<<8)) + ((m1[2][2] * vec[2])/(1<<8)) + ((m1[2][3] * vec[3])/(1<<8));
assign out[3] =   ((m1[3][0] * vec[0])/(1<<8)) + ((m1[3][1] * vec[1])/(1<<8)) + ((m1[3][2] * vec[2])/(1<<8)) + ((m1[3][3] * vec[3])/(1<<8));

endmodule

module mat_mat_mul(
    input int    m1[4][4],
    input int    m2[4][4],
    output int   out[4][4]
);

assign out[0][0] =((m1[0][0] * m2[0][0])/(1<<8)) + ((m1[0][1] * m2[1][0])/(1<<8)) + ((m1[0][2] * m2[2][0])/(1<<8)) + ((m1[0][3] * m2[3][0])/(1<<8));
assign out[0][1] =((m1[0][0] * m2[0][1])/(1<<8)) + ((m1[0][1] * m2[1][1])/(1<<8)) + ((m1[0][2] * m2[2][1])/(1<<8)) + ((m1[0][3] * m2[3][1])/(1<<8));
assign out[0][2] =((m1[0][0] * m2[0][2])/(1<<8)) + ((m1[0][1] * m2[1][2])/(1<<8)) + ((m1[0][2] * m2[2][2])/(1<<8)) + ((m1[0][3] * m2[3][2])/(1<<8));
assign out[0][3] =((m1[0][0] * m2[0][3])/(1<<8)) + ((m1[0][1] * m2[1][3])/(1<<8)) + ((m1[0][2] * m2[2][3])/(1<<8)) + ((m1[0][3] * m2[3][3])/(1<<8));
assign out[1][0] =((m1[1][0] * m2[0][0])/(1<<8)) + ((m1[1][1] * m2[1][0])/(1<<8)) + ((m1[1][2] * m2[2][0])/(1<<8)) + ((m1[1][3] * m2[3][0])/(1<<8));
assign out[1][1] =((m1[1][0] * m2[0][1])/(1<<8)) + ((m1[1][1] * m2[1][1])/(1<<8)) + ((m1[1][2] * m2[2][1])/(1<<8)) + ((m1[1][3] * m2[3][1])/(1<<8));
assign out[1][2] =((m1[1][0] * m2[0][2])/(1<<8)) + ((m1[1][1] * m2[1][2])/(1<<8)) + ((m1[1][2] * m2[2][2])/(1<<8)) + ((m1[1][3] * m2[3][2])/(1<<8));
assign out[1][3] =((m1[1][0] * m2[0][3])/(1<<8)) + ((m1[1][1] * m2[1][3])/(1<<8)) + ((m1[1][2] * m2[2][3])/(1<<8)) + ((m1[1][3] * m2[3][3])/(1<<8));
assign out[2][0] =((m1[2][0] * m2[0][0])/(1<<8)) + ((m1[2][1] * m2[1][0])/(1<<8)) + ((m1[2][2] * m2[2][0])/(1<<8)) + ((m1[2][3] * m2[3][0])/(1<<8));
assign out[2][1] =((m1[2][0] * m2[0][1])/(1<<8)) + ((m1[2][1] * m2[1][1])/(1<<8)) + ((m1[2][2] * m2[2][1])/(1<<8)) + ((m1[2][3] * m2[3][1])/(1<<8));
assign out[2][2] =((m1[2][0] * m2[0][2])/(1<<8)) + ((m1[2][1] * m2[1][2])/(1<<8)) + ((m1[2][2] * m2[2][2])/(1<<8)) + ((m1[2][3] * m2[3][2])/(1<<8));
assign out[2][3] =((m1[2][0] * m2[0][3])/(1<<8)) + ((m1[2][1] * m2[1][3])/(1<<8)) + ((m1[2][2] * m2[2][3])/(1<<8)) + ((m1[2][3] * m2[3][3])/(1<<8));
assign out[3][0] =((m1[3][0] * m2[0][0])/(1<<8)) + ((m1[3][1] * m2[1][0])/(1<<8)) + ((m1[3][2] * m2[2][0])/(1<<8)) + ((m1[3][3] * m2[3][0])/(1<<8));
assign out[3][1] =((m1[3][0] * m2[0][1])/(1<<8)) + ((m1[3][1] * m2[1][1])/(1<<8)) + ((m1[3][2] * m2[2][1])/(1<<8)) + ((m1[3][3] * m2[3][1])/(1<<8));
assign out[3][2] =((m1[3][0] * m2[0][2])/(1<<8)) + ((m1[3][1] * m2[1][2])/(1<<8)) + ((m1[3][2] * m2[2][2])/(1<<8)) + ((m1[3][3] * m2[3][2])/(1<<8));
assign out[3][3] =((m1[3][0] * m2[0][3])/(1<<8)) + ((m1[3][1] * m2[1][3])/(1<<8)) + ((m1[3][2] * m2[2][3])/(1<<8)) + ((m1[3][3] * m2[3][3])/(1<<8));

endmodule

module vec_cross(
    input int a[3],
    input int b[3],
    output int out[3]
);

assign out[0] = (a[1]/(1<<8))*b[2] - (a[2]/(1<<8))*b[1];
assign out[1] = (a[2]/(1<<8))*b[0] - (a[0]/(1<<8))*b[2];
assign out[2] = ((a[0]*b[1])/(1<<8)) + (-1 * ((a[1]*b[0])/(1<<8)));

int temp1;
int temp2;
assign temp1 = ((a[0]*b[1])/(1<<8));
assign temp2 = ((a[1]*b[0])/(1<<8));

endmodule

module vec_sub(
    input int a[3],
    input int b[3],
    output int out[3]
);

assign out[0] = a[0] - b[0];
assign out[1] = a[1] - b[1];
assign out[2] = a[2] - b[2];

endmodule

module vec_dot(
    input int a[3],
    input int b[3],
    output int out
);

longint a_l[3];
longint b_l[3];

always_comb begin
a_l[0] = a[0];
a_l[1] = a[1];
a_l[2] = a[2];
b_l[0] = b[0];
b_l[1] = b[1];
b_l[2] = b[2];

out = ((a_l[0] * b_l[0])/(1<<8)) + ((a_l[1] * b_l[1])/(1<<8)) + ((a_l[2] * b_l[2])/(1<<8));
end

endmodule

//https://dspguru.com/dsp/tricks/magnitude-estimator/
// Estimates vel 2D vec len
module vec2d_norm(
    input int a,
    input int b,
    output int out
);

int abs_x, abs_y;

abs a1(a, abs_x);
abs a2(b, abs_y);

int min, max;

always_comb begin
    if(abs_x > abs_y) begin
        min = abs_y;
        max = abs_x;
    end else begin
        min = abs_x;
        max = abs_y;
    end
    out = ((243 * max) / (1<<8)) + ((100 * min)/(1<<8));
end

endmodule

module vec_norm(
    input int a[3],
    output int out
);

int temp;
vec2d_norm n1(a[0], a[1], temp);
vec2d_norm n2(temp, a[2], out);

endmodule

module vec_mul(
    input int a[3],
    input int b,
    output int out[3]
);

assign out[0] = (a[0]/(1<<8)) * b;
assign out[1] = (a[1]/(1<<8)) * b;
assign out[2] = (a[2]/(1<<8)) * b;

endmodule

module vec2_mul(
    input int a[2],
    input int b,
    output int out[2]
);

assign out[0] = (a[0]/(1<<8)) * b;
assign out[1] = (a[1]/(1<<8)) * b;

endmodule

module vec_add(
    input int a[3],
    input int b[3],
    output int out[3]
);

assign out[0] = a[0] + b[0];
assign out[1] = a[1] + b[1];
assign out[2] = a[2] + b[2];

endmodule


module vec2_add(
    input int a[2],
    input int b[2],
    output int out[2]
);

assign out[0] = a[0] + b[0];
assign out[1] = a[1] + b[1];

endmodule
