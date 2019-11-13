import math

data = []
for y in range(0, 480):
    for x in range(0, 640):
        c = math.sqrt((x - 320)**2 + (y - 240)**2)
        data.append(c % 255)

print('char image_buffer[] = {')
for c in data:
    print(str(int(c)) + ', ')
print('};')
