import os, sys, glob

inFilePath = sys.argv[1]
numLeftCharsToKeep = int(sys.argv[2])
outFilePath = sys.argv[3]

outFile = open(outFilePath, 'w')

lineCount = 0
outText = ""

for line in file(inFilePath):
    modulo = lineCount % 4
    if modulo == 1 or modulo == 3:
        line = line[:numLeftCharsToKeep] + "\n"

    outText += line
    lineCount += 1

    if lineCount % 1000000 == 0:
        print lineCount
        outFile.write(outText)
        outText = ""

outFile.write(outText)
outFile.close()
