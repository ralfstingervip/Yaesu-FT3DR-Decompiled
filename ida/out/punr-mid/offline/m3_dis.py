# Lane M3: linear oracle disassembly with classes. R reached by K1 folded (MK) & P6, r reached not P6, U proven-unreached run,
# p other P6, n named, . unnamed. Usage: python m3_dis.py START END [...]. Read-only.
from pathlib import Path
REPO = Path(__file__).resolve().parents[4].as_posix()  # repository root
import sys
sys.dont_write_bytecode = True
sys.path.insert(0, (REPO + "/ida/out/punr-mid/offline"))
from m3_common import dis
args = [int(x, 16) for x in sys.argv[1:]]
for i in range(0, len(args), 2):
    print("---- %06X-%06X" % (args[i], args[i + 1]))
    print("\n".join(dis(args[i], args[i + 1])))
