import os, sys, glob, random
import utilities

inFilePath = sys.argv[1]
hasHeader = sys.argv[2] == "True"
numValues = int(sys.argv[3])
outFilePath = sys.argv[4]

data = utilities.readMatrixFromFile(inFilePath)

header = None
if hasHeader:
    header = data.pop(0)

indices = range(len(data))
random.shuffle(indices)
indices = indices[:numValues]

outData = []

if hasHeader:
    outData.append(header)

for index in indices:
    outData.append(data[index])

utilities.writeMatrixToFile(outData, outFilePath)
