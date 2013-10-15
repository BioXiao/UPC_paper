import glob, os, posix, shutil, sys
import utilities
import scipy.stats
from collections import defaultdict

def calculateVarianceMean(values):
    return utilities.calculateVarianceMean(values)

def calculateMean(values):
    return utilities.calculateMean(values)

def calculateTrimmedMean(values):
    return utilities.calculateTrimmedMean(values)

def calculateTrimmedMean25(values):
    return utilities.calculateTrimmedMean(values, trimProportion=0.25)

def selectMedian(values):
    return utilities.calculateMedian(values)

def selectHighest(values):
    return sorted(values)[-1]

def averageHighestGenes(values):
    median = utilities.calculateMedian(values)
    return utilities.calculateMean([x for x in values if x > median])

def commaSeparate(values):
    return ",".join([str(x) for x in values])

patientID = sys.argv[1]
inFilePath = sys.argv[2]
dataColumnIndex = int(sys.argv[3])
keyProbeFilePath = sys.argv[4]
probeFilePath = sys.argv[5]
minNumProbesPer = int(sys.argv[6])
summarizeFunction = getattr(sys.modules[__name__], sys.argv[7])
outlierSamplesFilePath = sys.argv[8]
outFilePath = sys.argv[9]

outlierSamples = []
if os.path.exists(outlierSamplesFilePath):
    outlierSamples = utilities.readVectorFromFile(outlierSamplesFilePath)

if patientID in outlierSamples:
    print "%s is listed as an outlier, so it won't be summarized" % patientID
    sys.exit(0)

print "Get data probes"
dataProbes = set([line.rstrip().split("\t")[0] for line in file(inFilePath)])

keyProbes = utilities.readMatrixFromFile(keyProbeFilePath)
keyProbes = [x for x in keyProbes if len(list(set(x[1].split(",")) & dataProbes)) > 0]

keyProbeDict = {}
for keyProbesRow in keyProbes:
    keyProbeDict[keyProbesRow[0]] = keyProbeDict.setdefault(keyProbesRow[0], []) + keyProbesRow[1].split(",")

if os.path.exists(probeFilePath):
    print "Keeping only specified probes"
    keepProbes = set(utilities.readVectorFromFile(probeFilePath))

    for key in keyProbeDict.keys():
        keyProbeDict[key] = list(set(keyProbeDict[key]) & keepProbes)
else:
    keepProbes = list(dataProbes)

print "Removing keys with few probes"
keysToRemove = []
for key in keyProbeDict.keys():
    if len(keyProbeDict[key]) < minNumProbesPer:
        keysToRemove.append(key)
for key in keysToRemove:
    del keyProbeDict[key]

print "Reading data from %s" % inFilePath
probeValuesDict = utilities.getPatientKeyValuesDict(inFilePath, dataColumnIndex, keepProbes)

outFile = open(outFilePath, 'w')

print "Writing data to %s" % outFilePath
for key in sorted(keyProbeDict.keys()):
    probeValues = [float(probeValuesDict[probe]) for probe in keyProbeDict[key]]
    summaryValue = summarizeFunction(probeValues)

    if utilities.isNumeric(summaryValue):
        summaryValue = "%.9f" % summaryValue

    outFile.write("%s\t%s\n" % (key, summaryValue))

outFile.close()
