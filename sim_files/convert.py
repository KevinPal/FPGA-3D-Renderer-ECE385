from PIL import Image

img = Image.new('RGB', (320, 240), color = 'black')
depth = Image.new('RGB', (320, 240), color = 'black')
pixels = img.load()
depth_pixels = depth.load()
with open('output.txt', 'r') as f:
    for y in range(0, 240):
        for x in range(0, 320):
            line = f.readline()
            a = int(line[0:2], 16)
            b = int(line[6:8], 16)
            g = int(line[4:6], 16)
            r = int(line[2:4], 16)
            pixels[x, y] = (r, g, b)
    for y in range(0, 240):
        for x in range(0, 320):
            line = f.readline()
            a = int(line[0:2], 16)
            b = int(line[6:8], 16)
            g = int(line[4:6], 16)
            r = int(line[2:4], 16)
            depth_pixels[x, y] = (r, g, b)


img.save('render.png')
depth.save('depth.png')


