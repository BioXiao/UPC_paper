import os, sys, glob, uuid, random, math
from operator import itemgetter, attrgetter

def parseMetadata():
    print "Parsing metadata"
    metadata = [line.rstrip().split("\t") for line in file(metaFilePath) if not line.startswith("#")]
    metadata = [(x[0], x[1], int(x[2]), int(x[3])) for x in metadata]

    keys = list(set(x[0] for x in metadata))
    chromosomes = set([formatChromosome(x[1]) for x in metadata])

    metadataDict = {}
    for chromosome in chromosomes:
        metadataChr = [[x[i] for i in [0,2,3]] for x in metadata if formatChromosome(x[1]) == chromosome]
        metadataChr.sort(key=itemgetter(1))
        metadataDict[chromosome] = metadataChr

    return keys, metadataDict

def formatChromosome(x):
    return x.replace("chr", "")

def readSgrFileLines():
    sgrData = []

    for line in sgrFile:
        lineItems = line.rstrip().split("\t")

        value = float(lineItems[2])
        if value == 0.0:
            continue

        chromosome = formatChromosome(lineItems[0])
        positionStart = int(lineItems[1])
        positionEnd = positionStart + (sgrSegmentSize - 1)

        sgrData.append((chromosome, positionStart, positionEnd, value))

        if len(sgrData) == 100000:
            break

    return sgrData

def writeOut(data):
    out = ""
    for row in data:
        out += ("%s\t%.6f\n" % row)

    outFile.write(out)

sgrFilePath = sys.argv[1]
sgrSegmentSize = int(sys.argv[2])
metaFilePath = sys.argv[3]
outFilePath = sys.argv[4]

metaKeys, metadataDict = parseMetadata()

sgrFile = open(sgrFilePath)
sgrData = readSgrFileLines()

outFile = open(outFilePath, 'w')

outData = []

for metaKey in metaKeys:
    outData.append((metaKey, 0.0))
writeOut(outData)

while len(sgrData) > 0:
    for chromosome in sorted(list(set([x[0] for x in sgrData]))):
        if not chromosome in metadataDict.keys():
            continue

        sgrDataChr = [x[1:] for x in sgrData if x[0] == chromosome]
        sgrDataChr.sort(key=itemgetter(0))

        print "Processing %i values for %s at %i" % (len(sgrDataChr), chromosome, sgrDataChr[0][0])

        for metaRow in metadataDict[chromosome]:
            metaName = metaRow[0]
            metaStart = metaRow[1]
            metaEnd = metaRow[2]

            while len(sgrDataChr) > 0 and sgrDataChr[0][0] < metaStart:
                sgrDataChr.pop(0)

            if len(sgrDataChr) == 0:
                break

            for sgrRow in sgrDataChr:
                sgrStart = sgrRow[0]
                sgrEnd = sgrRow[1]
                sgrNumReads = sgrRow[2]

                if sgrStart >= metaStart and sgrEnd <= metaEnd:
                    outData.append((metaName, sgrNumReads))

                if sgrEnd > metaEnd:
                    break

    writeOut(outData)
    outData = []
    sgrData = readSgrFileLines()

writeOut(outData)
outFile.close()
