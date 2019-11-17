
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
assign prj[2][2] = -((far + near) * (1<<8))/ (far - near);
assign prj[2][3] =  ((  ((((-2*(1<<8)) * far)/(1<<8)) * near) / (1<<8)) * (1<<8)) / (far - near);
assign prj[3][0] = 0;
assign prj[3][1] = 0;
assign prj[3][2] = -1 * (1<<8);
assign prj[3][3] = 1 * (1<<8);

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

module mat_reg(
    input logic  CLK,
    input logic  RESET,
    input int  in_data[4][4],
    output int  out_data[4][4]
);

    int data[4][4];

    always_ff @ (posedge CLK) begin
        data <= in_data;
    end

    assign out_data = data;

endmodule

