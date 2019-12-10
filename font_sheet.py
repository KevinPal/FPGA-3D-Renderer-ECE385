from PIL import Image
import math

img = Image.open('font_sheet.png')
width, height = img.size
pixels = img.load()

font = 'char font_data[%d][%d] = {' % (height, width)
for y in range(0, height):
    line = '{'
    for x in range(0, width):
        c = pixels[x, y]
        line += '0, ' if c > 0 else '1, '
    font += line[:-2] + '},\n'

print(font[:-2] + '};')
