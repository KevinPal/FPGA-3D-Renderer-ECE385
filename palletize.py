from PIL import Image
import math

img = Image.open('sheet.png')
width, height = img.size
pixels = img.load()

color2id = {}
id2color = {}
color_id = 0

for y in range(0, height):
    for x in range(0, width):
        c = pixels[x, y]
        if c not in color2id:
            id2color[color_id] = c
            color2id[c] = color_id
            color_id += 1


id2color[color_id] = (0, 255, 255)
color2id[(0, 255, 255)] = color_id

num_pixels = width*height
addres_bits = math.ceil(math.log(num_pixels, 2))
print("There are " + str(color_id) + " colors in " + str(num_pixels) + " pixels")
data_bits = math.ceil(math.log(color_id, 2))
print("Using " + str(data_bits) + " bits per color")

with open('sprite_pallet.txt', 'w+') as f:
    for y in range(0, height):
        for x in range(0, width):
            c = pixels[x, y]
            id = color2id[c]
            f.write("{0:b}".format(id).rjust(data_bits, '0') + '\n')

    print("Padding with %d entires" %  (2**addres_bits - (width*height)))
    for i in range(width*height, 2**(addres_bits)):
        f.write("{0:b}".format(color_id).rjust(data_bits, '0') + '\n')
        
rom = '''
// AUTO GENERATED MODULE
module texutre_rom (
    input CLK,
    input [%d:0] read_address,
    output logic [%d:0] output_data
);

logic [%d:0] mem[%d];

initial
begin
    $display("Loading texture rom");
    $readmemb("sprite_pallet.txt", mem, 0, %d);
end

always_ff @ (posedge CLK) begin
    output_data <= mem[read_address];
end
endmodule
''' % (addres_bits-1, data_bits-1, data_bits-1, num_pixels, num_pixels-1)

glue = '''
// AUTO GENERATED MODULE
module texture(
    input logic CLK,
    input int UV[2],
    output byte rgb[3]
);

logic [%d:0] read_address;
logic [%d:0] color_id;

texutre_rom rom(CLK, read_address, color_id);
texture_mapper mapper(color_id, rgb);

assign read_address = (UV[0] / (1<<8)) + (UV[1] / (1<<8))*%d;

endmodule
''' % (addres_bits-1, data_bits-1, width)


mapper_start = '''
// AUTO GENERATED MODULE
module texture_mapper(
    input logic [%d:0] color_id,
    output byte rgb[3]
);

always_comb begin
    unique case(color_id)
''' % (data_bits - 1)
mapper_end = '''
        default:  begin
            $display("invalid color id: %b", color_id);
            rgb = '{000, 255, 255};
        end
    endcase
end

endmodule
'''

for i in range(0, 2**(data_bits)):
    if i in id2color:
        c = id2color[i]
    else:
        c = (0, 255, 255)
    s = '\t\t%d\'b%s: rgb = \'{%s, %s, %s};\n' % (data_bits, "{0:b}".format(i).rjust(data_bits, '0'),
                    str(c[0]).rjust(3, '0'), str(c[1]).rjust(3, '0'), str(c[2]).rjust(3, '0'))
    mapper_start += s

mapper_start += mapper_end

with open('texutres.sv', 'w+') as f:
    f.write(glue)
    f.write('\n\n')
    f.write(rom)
    f.write('\n\n')
    f.write(mapper_start)

