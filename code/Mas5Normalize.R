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
rawData = ReadAffy(filenames=fileNames)
setwd(execDirPath)

eset <- mas5(rawData)
write.exprs(eset, file=outFilePath)
