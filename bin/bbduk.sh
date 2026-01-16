#!/usr/bin/env python3
import sys
import shutil
import os

# Parse arguments
args = {}
for arg in sys.argv[1:]:
    if '=' in arg:
        key, value = arg.split('=', 1)
        args[key] = value

infile = args.get('in')
outfile = args.get('out')
in2 = args.get('in2')
out1 = args.get('out1')
out2 = args.get('out2')
outm1 = args.get('outm1')
outm2 = args.get('outm2')

def interleave(r1, r2, out_stream):
    try:
        with open(r1, 'rb') as f1, open(r2, 'rb') as f2:
            while True:
                l1 = f1.readline()
                if not l1: break
                out_stream.write(l1) # @
                out_stream.write(f1.readline()) # seq
                out_stream.write(f1.readline()) # +
                out_stream.write(f1.readline()) # qual

                l2 = f2.readline()
                if not l2: break
                out_stream.write(l2)
                out_stream.write(f2.readline())
                out_stream.write(f2.readline())
                out_stream.write(f2.readline())
    except BrokenPipeError:
        pass

def deinterleave(in_stream, o1, o2):
    try:
        with open(o1, 'wb') as f1, open(o2, 'wb') as f2:
            while True:
                # Read 4 lines for Read 1
                l1 = in_stream.readline()
                if not l1: break
                f1.write(l1)
                f1.write(in_stream.readline())
                f1.write(in_stream.readline())
                f1.write(in_stream.readline())

                # Read 4 lines for Read 2
                l2 = in_stream.readline()
                if not l2: break
                f2.write(l2)
                f2.write(in_stream.readline())
                f2.write(in_stream.readline())
                f2.write(in_stream.readline())
    except BrokenPipeError:
        pass

if infile and in2 and outfile == 'stdout.fq':
    # Interleave R1 and R2 to stdout
    interleave(infile, in2, sys.stdout.buffer)

elif infile == 'stdin.fq' and out1 and out2:
    # Deinterleave stdin to out1 and out2
    deinterleave(sys.stdin.buffer, out1, out2)

elif infile and not in2 and outfile == 'stdout.fq':
    # Passthrough single file to stdout
    with open(infile, 'rb') as f:
        shutil.copyfileobj(f, sys.stdout.buffer)

# Handle outputting to dummy matched/unmatched files if requested
if outm1:
    with open(outm1, 'w') as f: pass
if outm2:
    with open(outm2, 'w') as f: pass
