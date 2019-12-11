// Interface for an avalon streaming core that
// converts an color ID stream into an RGB value
module avalon_color_mapper_interface (
    input  logic CLK_clk,
    input  logic RESET_reset,
    // Avalon sink signals
    input shortint COLOR_ID_SINK_1_data,
    input logic COLOR_ID_SINK_endofpacket,
    input logic COLOR_ID_SINK_startofpacket,
    input logic COLOR_ID_SINK_ready,
    input logic COLOR_ID_SINK_valid,
    // Avalon source signals
    output logic [23:0] RGB_SOURCE_data,
    output logic RGB_SOURCE_endofpacket,
    output logic RGB_SOURCE_startofpacket,
    output logic RGB_SOURCE_ready,
    output logic RGB_SOURCE_valid
);

assign RGB_SOURCE_startofpacket = COLOR_ID_SINK_startofpacket;
assign RGB_SOURCE_endofpacket = COLOR_ID_SINK_endofpacket;
assign RGB_SOURCE_ready = COLOR_ID_SINK_ready;
assign RGB_SOURCE_valid = COLOR_ID_SINK_valid;

byte rgb[3];
// looks up the color id
texture_mapper mapper(COLOR_ID_SINK_1_data, rgb[0], rgb[1], rgb[2]);

assign RGB_SOURCE_data = {rgb[0], rgb[1], rgb[2]};

endmodule
