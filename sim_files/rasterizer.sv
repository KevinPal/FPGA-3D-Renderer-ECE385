module Edge(
    input logic CLK, RESET,
    input logic init,
    input logic step,
    input longint bot[3],
    input longint top[3],
    output longint current_pos[3]
);

longint current_pos_next[3];
longint dxBdy; // dx by dy
longint dzBdy; // dz by dy
longint yPreStep;


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
