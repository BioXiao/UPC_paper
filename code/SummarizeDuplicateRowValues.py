import glob, os, sys
import utilities
from TransformFunctions import *

inFilePath = sys.argv[1]
summarizeFunction = getattr(sys.modules[__name__], sys.argv[2])
outFilePath = sys.argv[3]

keys = set()
for line in file(inFilePath):
    keys.add(line.rstrip().split("\t")[0])

summedDict = {}
for key in keys:
    summedDict[key] = []

for line in file(inFilePath):
    values = line.rstrip().split("\t")
    key = values.pop(0)

    summedDict[key].extend(values)

outLines = []
for key in summedDict.keys():
    out = [key]
    values = [x for x in summedDict[key] if x != ""]

    if len(values) == 0:
        out.append("NA")
    elif len(values) == 1:
        out.append(values[0])
    else:
        out.append(summarizeFunction(values)[0])

    outLines.append(out)

utilities.writeMatrixToFile(outLines, outFilePath)
