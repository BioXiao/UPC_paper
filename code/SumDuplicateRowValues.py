import os, sys, glob, uuid, random, math
import utilities

inFilePath = sys.argv[1]
outFilePath = sys.argv[2]

hasHeader = False
if len(sys.argv) > 3:
    hasHeader = sys.argv[3] == "True"

outDict = {}

inFile = open(inFilePath)

header = None
if hasHeader:
  header = inFile.readline().rstrip()

for line in inFile:
    lineItems = line.rstrip().split("\t")
    meta = lineItems[0]
    values = [float(x) for x in lineItems[1:]]

    outDict[meta] = outDict.setdefault(meta, []) + [values]

inFile.close()

outData = []

if header != None:
    outData.append([header])

for meta in outDict.keys():
    outValues = [meta]
    for i in range(len(outDict[meta][0])):
        iValues = [x[i] for x in outDict[meta]]
        outValues.append(sum(iValues))

    outData.append(outValues)

utilities.writeMatrixToFile(outData, outFilePath)
