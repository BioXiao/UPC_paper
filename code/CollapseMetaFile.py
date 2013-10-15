import os, sys, glob
from utilities import *

inFilePath = sys.argv[1]
outFilePath = sys.argv[2]

keyMetaDict = {}

for line in file(inFilePath):
    lineItems = line.rstrip().split("\t")

    keyMetaDict[lineItems[0]] = keyMetaDict.setdefault(lineItems[0], []) + [lineItems]

outData = []
for key in keyMetaDict:
    values = keyMetaDict[key]
    minPosition = min([int(x[2]) for x in values])
    maxPosition = max([int(x[3]) for x in values])
    lengthSum = sum([int(x[4]) for x in values])
    gcSum = sum([int(x[5]) for x in values])

    outData.append([key, values[0][1], minPosition, maxPosition, lengthSum, gcSum])

writeMatrixToFile(outData, outFilePath)
