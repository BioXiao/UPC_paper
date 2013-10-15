import os, sys, glob, math
import utilities
from TransformFunctions import *

# See http://fluxcapacitor.wikidot.com/forum/t-333476

mappedReadsFilePath = sys.argv[1]
metaFilePath = sys.argv[2]
outFilePath = sys.argv[3]

mappedReads = utilities.readMatrixFromFile(mappedReadsFilePath)
READ_NR = math.fsum([float(x[1]) for x in mappedReads])

metaDict = {}
for metaRow in utilities.readMatrixFromFile(metaFilePath):
    metaDict[metaRow[0]] = metaRow[4]

outData = []
for mappedRead in mappedReads:
    id = mappedRead[0]

    if id not in metaDict:
        continue

    reads = float(mappedRead[1])
    length = float(metaDict[id])

    rpkm = (reads * 1000000000) / (length * READ_NR)

    outData.append((id, "%.9f" % rpkm))

utilities.writeMatrixToFile(outData, outFilePath)
