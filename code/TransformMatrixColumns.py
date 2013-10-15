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
data = utilities.transposeMatrix(data)
data = [transformFunction([y for y in x]) for x in data]
data = utilities.transposeMatrix(data)
data = [[rowNames[i]] + data[i] for i in range(len(data))]

if hasHeaderRow:
    data.insert(0, headerRow)

utilities.writeMatrixToFile(data, outFilePath)
