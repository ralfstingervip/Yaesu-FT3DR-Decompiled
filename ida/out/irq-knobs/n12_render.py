r"""Lane N12: render the RGB565 sprite drawn by the SUB DIAL KNOB CHANGE value screen (descriptor 0xFFED0A8C).
Read-only: reads decrypted\FT3D_SUB_ver102_ALL.bin, writes a PNG (4x scale) next to this script."""
import sys
import struct, zlib, os, sys
ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))))
sys.exit('The firmware image is not in this repository.')
B = 0xFFC00000
def render(desc, out, scale=4):
    o = desc - B
    w, h, src, key, tint, mode = struct.unpack_from('<HHIHHH', s, o)
    px = s[src - B: src - B + w * h * 2]
    rows = []
    for y in range(h):
        row = bytearray([0])
        for x in range(w):
            v = struct.unpack_from('<H', px, (y * w + x) * 2)[0]
            r, g, b = (v >> 11) << 3, ((v >> 5) & 63) << 2, (v & 31) << 3
            if v == key and mode == 0:
                r, g, b = 255, 0, 255  # key colour (transparent) shown magenta
            row += bytes([r, g, b]) * scale
        rows += [bytes(row)] * scale
    raw = b''.join(rows)
    def chunk(t, d): return struct.pack('>I', len(d)) + t + d + struct.pack('>I', zlib.crc32(t + d) & 0xffffffff)
    png = b'\x89PNG\r\n\x1a\n' + chunk(b'IHDR', struct.pack('>IIBBBBB', w * scale, h * scale, 8, 2, 0, 0, 0)) \
        + chunk(b'IDAT', zlib.compress(raw)) + chunk(b'IEND', b'')
    open(out, 'wb').write(png)
    return w, h, src, key, tint, mode
here = os.path.dirname(os.path.abspath(__file__))
print(render(0xFFED0A8C, os.path.join(here, 'sprite_FFED0A8C.png')))
