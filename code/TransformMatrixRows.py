import os, sys, glob, math
import utilities
from TransformFunctions import *

inFilePath = sys.argv[1]
hasHeaderRow = sys.argv[2] == "True"
transformFunction = getattr(sys.modules[__name__], sys.argv[3])
outFilePath = sys.argv[4]

data = utilities.readMatrixFromFile(inFilePath)

if hasHeaderRow:
    headerRow = data.pop(0)

rowNames = [x[0] for x in data]

data = [x[1:] for x in data]
data = [transformFunction([y for y in x]) for x in data]

outData = []
if hasHeaderRow:
    outData.append(headerRow)

for i in range(len(data)):
    outRow = [rowNames[i]]

    if type(data[i]) is list:
        outRow.extend(data[i])
    else:
        outRow.append(data[i])

    outData.append(outRow)

utilities.writeMatrixToFile(outData, outFilePath)
