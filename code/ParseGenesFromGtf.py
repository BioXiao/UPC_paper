import os, sys, glob
from utilities import *
from VariantUtilities import *

gtfFilePath = sys.argv[1]
outFilePath = sys.argv[2]

geneChromosomeDict = {}
geneExonsDict = {}

for line in file(gtfFilePath):
    lineItems = line.rstrip().split("\t")
    source = lineItems[1]
    featureType = lineItems[2]

    #if source != "protein_coding" or featureType != "exon":
    if featureType != "exon":
        continue

    chromosome = parseChromosome(lineItems[0])
    start = int(lineItems[3])
    stop = int(lineItems[4])
    gene = lineItems[8].split("; ")[0].replace("gene_id \"", "").replace("\"", "")

    geneChromosomeDict[gene] = chromosome
    geneExonsDict[gene] = geneExonsDict.setdefault(gene, []) + [(start, stop)]

outData = []

for gene in geneExonsDict:
    coveredBases = set()
    for exon in geneExonsDict[gene]:
        for i in range(exon[0], exon[1] + 1):
            coveredBases.add(i)
    coveredBases = sorted(list(coveredBases))

    outData.append([gene, geneChromosomeDict[gene], min(coveredBases), max(coveredBases)])

writeMatrixToFile(outData, outFilePath)
