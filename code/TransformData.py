import os, sys, glob, math, random
import utilities
from TransformFunctions import *

inFilePath = sys.argv[1]
hasHeaderRow = sys.argv[2] == "True"
transformFunction = getattr(sys.modules[__name__], sys.argv[3])
if sys.argv[4] != "1" and sys.argv[4] != "2":
    print "Argument 3 must be 1 (for row) or 2 (for column)"
byColumn = sys.argv[4] == "2"
outFilePath = sys.argv[5]

data = utilities.readMatrixFromFile(inFilePath)

if hasHeaderRow:
    headerRow = data.pop(0)

rowNames = [x[0] for x in data]
data = [x[1:] for x in data]
data = [[float(y) for y in x] for x in data]

if byColumn:
    data = utilities.transposeMatrix(data)

data = [transformFunction(x) for x in data]

if byColumn:
    data = utilities.transposeMatrix(data)

outText = ""

if hasHeaderRow:
    outText = "\t".join(headerRow) + "\n"

for i in range(len(data)):
    outText += "\t".join([rowNames[i]] + [str(x) for x in data[i]]) + "\n"

utilities.writeScalarToFile(outText, outFilePath)
