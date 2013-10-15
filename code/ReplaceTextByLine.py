import os, sys, glob
import utilities

inFilePath = sys.argv[1]
findValue = sys.argv[2].decode('string-escape')
replaceValue = sys.argv[3].decode('string-escape')
outFilePath = sys.argv[4]

outFile = open(outFilePath, 'w')

outLines = []
lineCount = 0

for line in file(inFilePath):
    outLines.append(line.replace(findValue, replaceValue))
    lineCount += 1

    if len(outLines) % 100000 == 0:
        print lineCount
        outFile.write("".join(outLines))
        outLines = []

if len(outLines) > 0:
    print lineCount
    outFile.write("".join(outLines))

outFile.close()
