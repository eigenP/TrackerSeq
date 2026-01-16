#!/usr/bin/env python3
import sys
import shutil

args = {}
for arg in sys.argv[1:]:
    if '=' in arg:
        key, value = arg.split('=', 1)
        args[key] = value

in1 = args.get('in1')
in2 = args.get('in2')
out1 = args.get('out1')
out2 = args.get('out2')

# Logic derived from analysis of 1_preprocessing.sh:
# Usage: bbduk (R2) | repair in1=stdin (R2) in2=R1 out1=pair_R1 out2=pair_R2
# So we map in2 -> out1 (R1 -> pair_R1)
# And in1/stdin -> out2 (R2 -> pair_R2)

if in2 and out1:
    shutil.copy(in2, out1)

if in1 == 'stdin.fq' and out2:
    try:
        with open(out2, 'wb') as f:
            shutil.copyfileobj(sys.stdin.buffer, f)
    except BrokenPipeError:
        pass
elif in1 and out2:
    shutil.copy(in1, out2)
