#source("http://bioconductor.org/biocLite.R")
#biocLite("frma")
#biocLite("frmaTools")

library(frma)
library(affy)

inDirPath = commandArgs()[7]
frmaOutFilePath = commandArgs()[8]
barcodeOutFilePath = commandArgs()[9]
barcodeProbabilitiesOutFilePath = commandArgs()[10]
barcodeLodsOutFilePath = commandArgs()[11]
barcodeZScoresOutFilePath = commandArgs()[12]

inFilePattern = "*"
if (length(commandArgs()) > 10)
  inFilePattern = commandArgs()[11]

##input.vecs = list(normVec=NULL, probeVec=NULL, probeVarBetween=NULL, probeVarWithin=NULL, probesetSD=NULL)
##if (length(commandArgs()) > 11)
##{
##  probeMatrixFilePath = paste(commandArgs()[12], "/probeMatrix.txt", sep="")
##  probesetMatrixFilePath = paste(commandArgs()[12], "/probesetMatrix.txt", sep="")
##  probeMatrix = read.table(probeMatrixFilePath, sep="\t", header=TRUE, row.names=NULL)
##  probesetMatrix = read.table(probesetMatrixFilePath, sep="\t", header=TRUE, row.names=NULL)
##  input.vecs = list(normVec=probeMatrix$normVec, probeVec=probeMatrix$probeVec, probeVarBetween=probeMatrix$probeVarBetween, probeVarWithin=probeMatrix$probeVarWithin, probesetSD=probesetMatrix$probesetSD, medianSD=probesetMatrix$medianSD)
##}

execDirPath = getwd()

setwd(inDirPath)
fileNames = list.files(pattern=inFilePattern)
rawdata = ReadAffy(filenames=fileNames)
setwd(execDirPath)

##normResult = frma(rawdata, input.vecs=input.vecs)
normResult = frma(rawdata)

write.exprs(normResult, file=frmaOutFilePath, sep="\t", quote=FALSE, col.names=NA)

barcodes = barcode(normResult)
write.table(barcodes, file=barcodeOutFilePath, sep="\t", quote=FALSE, row.names=TRUE, col.names=NA)

barcodeProbabilities = 1 - barcode(normResult, output="p-value")
write.table(barcodeProbabilities, file=barcodeProbabilitiesOutFilePath, sep="\t", quote=FALSE, row.names=TRUE, col.names=NA)

barcodeLods = barcode(normResult, output="lod")
write.table(barcodeLods, file=barcodeLodsOutFilePath, sep="\t", quote=FALSE, row.names=TRUE, col.names=NA)

barcodeZScores = barcode(normResult, output="z-score")
write.table(barcodeZScores, file=barcodeZScoresOutFilePath, sep="\t", quote=FALSE, row.names=TRUE, col.names=NA)
