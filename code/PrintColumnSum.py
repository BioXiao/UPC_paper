import os, sys, glob
import utilities

inFilePath = sys.argv[1]
columnIndex = int(sys.argv[2])

total = 0.0

for line in file(inFilePath):
    value = float(line.rstrip().split("\t")[columnIndex])
    total += value

print total
