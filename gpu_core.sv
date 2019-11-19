
// Actual implementation of the interface to save compile time
module gpu_core(
    input  logic CLK_clk,
    input  logic RESET_reset,
    // Ava lon slave signals
    input  logic GPU_SLAVE_read,
    output logic [31:0] GPU_SLAVE_readdata,
    input  logic GPU_SLAVE_write,
    input  logic [31:0] GPU_SLAVE_writedata,
    input  logic [31:0] GPU_SLAVE_address,
    input  logic GPU_SLAVE_chipselect,
    // avalon master signals
    output logic [31:0] GPU_MASTER_address,
    output logic GPU_MASTER_read,
    input  logic [31:0] GPU_MASTER_readdata,
    output logic GPU_MASTER_chipselect,
    input  logic GPU_MASTER_readdatavalid,
    input  logic GPU_MASTER_writeresponsevalid,
    output logic GPU_MASTER_write,
    output logic [31:0] GPU_MASTER_writedata,
    input  logic [1:0] GPU_MASTER_response,
    input  logic GPU_MASTER_waitrequest
);

// Memory mapped registers
int frame_pointer, frame_pointer_next;
int z_buffer_pointer, z_buffer_pointer_next;
logic start, start_next;
logic done, done_next;
int scale, scale_next;
int x, x_next;
int y, y_next;
int z, z_next;
int mode, mode_next;

// rasterization variables
logic rast_start;
logic rast_cont;
byte rast_rgb[3];
int rast_xyz[3];
logic rast_done;
logic rast_ready;

int prj[4][4];

int tv1[3] = '{100 * (1<<8), 100 * (1<<8), 0};
int tv2[3] = '{50 * (1<<8), 300 * (1<<8), 0};
int tv3[3] = '{250 * (1<<8), 200 * (1<<8), 0};
byte frag_rgb[3] = '{255, 255, 0};

gen_prj_mat m1(320 * (1<< 8), 240 * (1<< 8), 5 * (1<< 8), 200 * (1<< 8), prj);

rast_cube cube_renderer(CLK_clk, RESET_reset, rast_start, rast_cont, 
    scale, '{x, y, z}, prj, rast_ready, rast_rgb, rast_xyz, rast_done);


int clear_counter, clear_counter_next;

enum logic [5:0] {
    IDLE,
    RUNNING,
    DONE
} state = IDLE, next_state;

always_comb begin

    //default slave
    GPU_SLAVE_readdata = 32'hzzzz;
    //default master
    GPU_MASTER_address = 32'hzzzz;
    GPU_MASTER_read = 0;
    GPU_MASTER_chipselect = 0;
    GPU_MASTER_write = 0;
    GPU_MASTER_writedata = 32'hzzzz;
    //'next' defaults
    frame_pointer_next = frame_pointer;
    next_state = state;
    start_next = start;
    done_next = done;
    z_buffer_pointer_next = z_buffer_pointer;
    scale_next = scale;
    x_next = x;
    y_next = y;
    z_next = z;
    clear_counter_next = clear_counter;
    mode_next = mode;

    // rast defaults
    rast_start = 0;
    rast_cont = 0;

    // Slave
    if(GPU_SLAVE_chipselect) begin
        // Slave Reads
        if(GPU_SLAVE_read) begin
            case(GPU_SLAVE_address)
                0: GPU_SLAVE_readdata = frame_pointer;
                1: GPU_SLAVE_readdata = start;
                2: GPU_SLAVE_readdata = done;
                3: GPU_SLAVE_readdata = z_buffer_pointer;
                4: GPU_SLAVE_readdata = scale;
                5: GPU_SLAVE_readdata = x;
                6: GPU_SLAVE_readdata = y;
                7: GPU_SLAVE_readdata = z;
                8: GPU_SLAVE_readdata = mode;
            endcase
        end

        // Slave Writes
        if(GPU_SLAVE_write) begin
            case(GPU_SLAVE_address)
                0: frame_pointer_next    = GPU_SLAVE_writedata;
                1: start_next            = GPU_SLAVE_writedata;
                2: done_next             = GPU_SLAVE_writedata;
                3: z_buffer_pointer_next = GPU_SLAVE_writedata;
                4: scale_next            = GPU_SLAVE_writedata;
                5: x_next                = GPU_SLAVE_writedata;
                6: y_next                = GPU_SLAVE_writedata;
                7: z_next                = GPU_SLAVE_writedata;
                8: mode_next             = GPU_SLAVE_writedata;
            endcase
        end

    end

    if(state == RUNNING) begin
        if(mode == 1) begin // Cube rendering
            if(rast_ready) begin
                GPU_MASTER_chipselect = 1;
                GPU_MASTER_write = 1;
                GPU_MASTER_writedata = {2'h00, rast_rgb[2], rast_rgb[1], rast_rgb[0]};
                GPU_MASTER_address = frame_pointer + (( ((rast_xyz[1]/(1<<8))*640) + (rast_xyz[0]/(1<<8)))*4);
                if(GPU_MASTER_writeresponsevalid & ~GPU_MASTER_waitrequest)
                    rast_cont = 1;
            end
        end else if(mode == 2) begin // Clearing
            GPU_MASTER_chipselect = 1;
            GPU_MASTER_write = 1;
            GPU_MASTER_writedata = {8'h00, 8'h20, 8'h20, 8'h20};
            GPU_MASTER_address = frame_pointer + clear_counter*4;
            if(GPU_MASTER_writeresponsevalid & ~GPU_MASTER_waitrequest)
                clear_counter_next = clear_counter + 1;
        end
    end

    // Next state
    unique case(state)
        IDLE: begin
            if(start) begin
                next_state = RUNNING;
                if(mode == 1)
                    rast_start = 1; //rast
                else if(mode == 2)
                    clear_counter_next = 0; // clear
                else
                    next_state = DONE;
            end
            else
                next_state = IDLE;
        end
        RUNNING: begin
            if(mode == 1) begin //rast
                rast_start = 1;
                if(rast_done) begin 
                    done_next = 1; 
                    next_state = DONE;
                end
            end else if(mode == 2) begin //clear
                if(clear_counter > (640 * 480)) begin
                    next_state = DONE;
                    done_next = 1;
                end
                else
                    next_state = RUNNING;
            end
            else
                next_state = RUNNING;
        end
        DONE: begin
            if(~start)
                next_state = IDLE;
            else
                next_state = DONE;
        end
        default:
            next_state = state;
    endcase
end

always_ff @ (posedge CLK_clk) begin
    if(RESET_reset) begin
        frame_pointer <= 0;
        start <= 0;
        done <= 0;
        state <= IDLE;
        z_buffer_pointer <= 0;
        scale <= 0;
        x <= 0;
        y <= 0;
        z <= 0;
        clear_counter <= 0;
        mode <= 0;
    end else begin
        frame_pointer <= frame_pointer_next;
        start <= start_next;
        done <= done_next;
        state <= next_state;
        z_buffer_pointer <= z_buffer_pointer_next;
        scale <= scale_next;
        x <= x_next;
        y <= y_next;
        z <= z_next;
        clear_counter <= clear_counter_next;
        mode <= mode_next;
    end
end

endmodule


module rast_cube(
    input logic CLK,
    input logic RESET,
    input logic start,
    input logic cont,
    input int scale,
    input int pos[3],
    input int prj[4][4],
    output logic rast_ready,
    output byte rgb[3],
    output int xyz[3],
    output logic done
);

enum logic [5:0] { //TODO back
    IDLE,
    TOP_1, TOP_2,
    BOT_1, BOT_2,
    FRONT_1, FRONT_2,
    LEFT_1, LEFT_2,
    RIGHT_1, RIGHT_2,
    BACK_1, BACK_2,
    DONE
} state = IDLE, next_state;


//0 -> back_top_left
//1 -> back_top_right
//2 -> back_bot_left
//3 -> back_bot_right
//4 -> front_top_left
//5 -> front_top_right
//6 -> front_bot_left
//7 -> front_bot_right
int verticies[8][3];

int test_scale = 16 * (1<<8);
int test_vec[3] = '{15 * (1<< 8), 0 * (1<< 8) ,  -70* (1<< 8)};

project_cube projector(scale, pos, prj, verticies);

// Rasterization variables
logic rast_done;
logic rast_start = 0;
int v1[3];
int v2[3];
int v3[3];
byte frag_rgb[3];
int tv1[3] = '{0, 0, 0};
int tv2[3] = '{0, 0, 0};
int tv3[3] = '{0, 0, 0};

rast_triangle triangle_renderer(CLK, RESET, rast_start, cont,
    tv3, tv2, tv1, frag_rgb, rast_ready, rgb, xyz, rast_done);

always_comb begin
    next_state = state;
    rast_start = 0;
    tv1 = '{0, 0, 0};
    tv2 = '{0, 0, 0};
    tv3 = '{0, 0, 0};
    frag_rgb = '{0, 0, 0};
    done = 0;

    // state logic
    unique case(state)
        IDLE: begin
            if(start) begin
                next_state = TOP_1;
                rast_start = 1;
            end
        end
        TOP_1: begin
            tv1 = verticies[0];
            tv2 = verticies[1];
            tv3 = verticies[4];
            frag_rgb = '{255, 255, 255};
            if(rast_done) begin
                rast_start = 0;
                next_state = TOP_2;
            end
        end
        TOP_2: begin
            rast_start = 1;
            tv1 = verticies[1];
            tv2 = verticies[5];
            tv3 = verticies[4];
            frag_rgb = '{255, 255, 255};
            if(rast_done) begin
                rast_start = 0;
                next_state = BOT_1;
            end
        end
        BOT_1: begin
            rast_start = 1;
            tv1 = verticies[2];
            tv2 = verticies[3];
            tv3 = verticies[6];
            frag_rgb = '{0, 0, 0};
            if(rast_done) begin
                rast_start = 0;
                next_state = BOT_2;
            end
        end
        BOT_2: begin
            rast_start = 1;
            tv1 = verticies[3];
            tv2 = verticies[7];
            tv3 = verticies[6];
            frag_rgb = '{0, 0, 0};
            if(rast_done) begin
                rast_start = 0;
                next_state = BACK_1; 
            end
        end
        BACK_1: begin
            rast_start = 1;
            tv1 = verticies[0];
            tv2 = verticies[1];
            tv3 = verticies[2];
            frag_rgb = '{255, 0, 255};
            if(rast_done) begin
                rast_start = 0;
                next_state = BACK_2;
            end
        end
        BACK_2: begin
            rast_start = 1;
            tv1 = verticies[1];
            tv2 = verticies[3];
            tv3 = verticies[2];
            frag_rgb = '{255, 0, 255};
            if(rast_done) begin
                rast_start = 0;
                next_state = FRONT_1;  // --
            end
        end
        LEFT_1: begin
            rast_start = 1;
            tv1 = verticies[0];
            tv2 = verticies[2];
            tv3 = verticies[4];
            frag_rgb = '{0, 255, 0};
            if(rast_done) begin
                rast_start = 0;
                next_state = LEFT_2;
            end
        end
        LEFT_2: begin
            rast_start = 1;
            tv1 = verticies[4];
            tv2 = verticies[6];
            tv3 = verticies[7];
            frag_rgb = '{0, 255, 0};
            if(rast_done) begin
                rast_start = 0;
                next_state = RIGHT_1;
            end
        end
        RIGHT_1: begin
            rast_start = 1;
            tv1 = verticies[1];
            tv2 = verticies[3];
            tv3 = verticies[7];
            frag_rgb = '{255, 0, 0};
            if(rast_done) begin
                rast_start = 0;
                next_state = RIGHT_2;
            end
        end
        RIGHT_2: begin
            rast_start = 1;
            tv1 = verticies[1];
            tv2 = verticies[5];
            tv3 = verticies[7];
            frag_rgb = '{255, 0, 0};
            if(rast_done) begin
                rast_start = 0;
                next_state = FRONT_1;
            end
        end
        FRONT_1: begin
            rast_start = 1;
            tv1 = verticies[4];
            tv2 = verticies[5];
            tv3 = verticies[7];
            frag_rgb = '{0, 255, 255};
            if(rast_done) begin
                rast_start = 0;
                next_state = FRONT_2;
            end
        end
        FRONT_2: begin
            rast_start = 1;
            tv1 = verticies[4];
            tv2 = verticies[6];
            tv3 = verticies[7];
            frag_rgb = '{0, 255, 255};
            if(rast_done) begin
                rast_start = 0;
                next_state = DONE;
            end
        end
        DONE: begin
            done = 1;
            next_state = IDLE;
        end
    endcase
end


always_ff @ (posedge CLK) begin
    if(RESET) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

endmodule

// TODO make sequencial
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
