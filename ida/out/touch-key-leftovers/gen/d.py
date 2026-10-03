import sys; sys.path.insert(0,'.')
from l6lib import *
import argparse
ap=argparse.ArgumentParser(); ap.add_argument('start',type=lambda x:int(x,16)); ap.add_argument('end',type=lambda x:int(x,16))
a=ap.parse_args()
for l in dis(a.start,a.end): print(l)
