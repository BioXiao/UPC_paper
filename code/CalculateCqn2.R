inFilePath = commandArgs()[7]
depthFilePath = commandArgs()[8]
metaFilePath = commandArgs()[9]
outFilePath = commandArgs()[10]

library(cqn)
library(scales)

data = read.table(inFilePath, sep="\t", stringsAsFactors=F, header=T, row.names=NULL, check.names=FALSE)
metadata = read.table(metaFilePath, sep="\t", stringsAsFactors=F, header=FALSE, row.names=NULL)
combinedData = merge(data, metadata, by.x=1, by.y=1)
sizes = as.numeric(read.table(depthFilePath, stringsAsFactors=F, header=FALSE, row.names=NULL)[,1])

data = as.data.frame(apply(combinedData[,2:ncol(data)], 2, ceiling))

l = as.array(combinedData[,(ncol(combinedData)-1)])
gc = as.array(combinedData[,ncol(combinedData)] / 1)

result = cqn(data, lengths=l, x=gc, sizeFactors=sizes, verbose=TRUE)

normalized = result$y + result$offset
normalized = cbind(combinedData[,1], normalized)

write.table(normalized, outFilePath, sep="\t", row.names=FALSE, quote=FALSE)
