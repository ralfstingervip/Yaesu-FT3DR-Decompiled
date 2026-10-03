import struct,sys
def sections(d):
    pe=struct.unpack_from('<I',d,0x3C)[0]
    nsec=struct.unpack_from('<H',d,pe+6)[0]
    oh=struct.unpack_from('<H',d,pe+20)[0]
    magic=struct.unpack_from('<H',d,pe+24)[0]
    base=struct.unpack_from('<Q' if magic==0x20b else '<I',d,pe+24+(24 if magic==0x20b else 28))[0]
    t=pe+24+oh; out=[]
    for i in range(nsec):
        o=t+40*i
        nm=d[o:o+8].rstrip(b'\0').decode('latin1')
        vs,va,rs,ra=struct.unpack_from('<IIII',d,o+8)
        out.append((nm,va,vs,ra,rs))
    return base,out
f=sys.argv[1]; d=open(f,'rb').read()
base,secs=sections(d)
if len(sys.argv)==2:
    print('imagebase %#x'%base)
    for nm,va,vs,ra,rs in secs: print('%-9s va %#x vsz %#x raw %#x rsz %#x'%(nm,base+va,vs,ra,rs))
    sys.exit()
va=int(sys.argv[2],16); n=int(sys.argv[3],0) if len(sys.argv)>3 else 64
for nm,sva,vs,ra,rs in secs:
    if base+sva<=va<base+sva+max(vs,rs):
        off=ra+(va-base-sva)
        blob=d[off:off+n]
        print('section %s file_off %#x'%(nm,off))
        for i in range(0,len(blob),16):
            row=blob[i:i+16]
            print('%08X  %-47s  %s'%(va+i,' '.join('%02X'%b for b in row),
                ''.join(chr(b) if 32<=b<127 else '.' for b in row)))
        break
else: print('va not in a section')
