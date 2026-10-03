import re
def norm(t):
    t=re.sub(r"0x[0-9a-f]+","n",t); t=re.sub(r"\ber[0-7]\b","ERn",t); t=re.sub(r"\b[re][0-7]\b","Rn",t); t=re.sub(r"\br[0-7][lh]\b","RnB",t)
    t=re.sub(r"\.[+-]?\d+ \(n\)","disp",t)
    t=re.sub(r"ERn-ERn","ERn-ERm",t); t=re.sub(r"#\d+","#k",t); return t
