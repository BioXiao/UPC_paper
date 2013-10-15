#source("http://bioconductor.org/biocLite.R")
#biocLite()
library(affy)
library(methods)

inDirPath = commandArgs()[7]
outFilePath = commandArgs()[8]

inFilePattern = "*"
if (length(commandArgs()) > 8)
  inFilePattern = commandArgs()[9]

execDirPath = getwd()

setwd(inDirPath)
fileNames = list.files(pattern=glob2rx(inFilePattern))
rawdata = ReadAffy(filenames=fileNames)
setwd(execDirPath)

expressionSet <- rma(rawdata)

write.exprs(expressionSet, file=outFilePath, sep="\t", quote=FALSE)
