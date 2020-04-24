
import sys
print("Native byteorder: ", sys.byteorder)

f = "./image1.jpg"

with open(f, 'rb') as f:
    header = f.read(4)
    trailer = f.read()[-2:]

if header:
    print("header: " + str(header))


print("trailer: " + str(trailer))



b1 = b'123456'
b2 = bytearray(b'123456')

print(type(b1))
print(type(b2))

s1 = bytes(b1).decode('utf-8')
s2 = bytes(b2).decode('utf-8')

print(s1)
print(s2)
