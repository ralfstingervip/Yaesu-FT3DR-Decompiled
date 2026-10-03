# M13 manual citation list: forms the automatic patterns in m13_citations.py do not read.
# (doc file, anchor text on the line, address, kind, expected, note)
# kind: bytes ('??' wildcard, '…' gap) | be32 | le32 | ascii (bytes) | na (uncheckable) | drop | regrade
# Rows live in three per-group files (m13_manual_a.py docs 98-103 + RESUME + README, _b 104-108, _c 109-112).
import os, sys, importlib
sys.dont_write_bytecode = True
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
CITES = []
for _m in ('m13_manual_a', 'm13_manual_b', 'm13_manual_c'):
    try:
        CITES += importlib.import_module(_m).CITES
    except ModuleNotFoundError:
        pass
