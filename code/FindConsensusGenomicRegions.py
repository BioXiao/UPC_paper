import os, sys, glob
import utilities

inFilePath = sys.argv[1]
startColumnIndex = int(sys.argv[2])
stopColumnIndex = int(sys.argv[3])
outFilePath = sys.argv[4]

data = utilities.readMatrixFromFile(inFilePath)

print "Identifying IDs"
ids = set([x[0] + "__" + x[1] for x in data])

outData = []

for id in ids:
    idData = [x for x in data if (x[0] + "__" + x[1]) == id]

    starts = [int(x[startColumnIndex]) for x in idData]
    stops = [int(x[stopColumnIndex]) for x in idData]

    outData.append(id.split("__") + [str(min(starts)), str(max(stops))])

    if len(outData) % 1000 == 0:
        print "%i / %i" % (len(outData), len(ids))

utilities.writeMatrixToFile(outData, outFilePath)
