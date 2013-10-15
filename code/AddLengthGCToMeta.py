import os, sys, glob
from operator import itemgetter, attrgetter
import utilities
from VariantUtilities import *

inMetaFilePath = sys.argv[1]
genomeDirPath = sys.argv[2]
outFilePath = sys.argv[3]

def getChromosomeSequence(filePath):
    sequence = ""
    for line in file(filePath):
        if not line.startswith(">"):
            sequence += line.rstrip().upper()
    return sequence

outData = []
inMeta = utilities.readMatrixFromFile(inMetaFilePath)

chromosomes = sorted(list(set([parseChromosome(x[1]) for x in inMeta])))

for chromosome in chromosomes:
    print "Processing %s" % chromosome
    faFilePath = genomeDirPath + "/" + chromosome + ".fa"

    if not os.path.exists(faFilePath):
        faFilePath = genomeDirPath + "/" + chromosome.replace("chr", "") + ".fa"

    if not os.path.exists(faFilePath):
        print "Ignoring %s because no chromosome file exists" % chromosome
        continue

    inMetaChromosome = [x for x in inMeta if x[1] == parseChromosome(chromosome)]
    chromosomeSequence = getChromosomeSequence(faFilePath)

    for inMetaItem in inMetaChromosome:
        start = int(inMetaItem[2])
        stop = int(inMetaItem[3])
        length = stop - start + 1
        sequence = chromosomeSequence[(start-1):stop].upper()
        gcCount = sequence.count("G") + sequence.count("C")

        outData.append(inMetaItem + [length, gcCount])

utilities.writeMatrixToFile(outData, outFilePath)
