inFilePath = commandArgs()[7]
metaFilePath = commandArgs()[8]
outFilePath = commandArgs()[9]

library(cqn)
library(scales)

data = read.table(inFilePath, sep="\t", stringsAsFactors=F, header=T, row.names=NULL, check.names=FALSE)
metadata = read.table(metaFilePath, sep="\t", stringsAsFactors=F, header=FALSE, row.names=NULL)
combinedData = merge(data, metadata, by.x=1, by.y=1)

data = as.data.frame(apply(combinedData[,2:ncol(data)], 2, ceiling))

l = as.array(combinedData[,(ncol(combinedData)-1)])
gc = as.array(combinedData[,ncol(combinedData)] / 1)
sizes = apply(data, 2, function(x) { ceiling(sum(x)) })

result = cqn(data, lengths=l, x=gc, sizeFactors=sizes, verbose=TRUE)

normalized = result$y + result$offset
normalized = cbind(combinedData[,1], normalized)

write.table(normalized, outFilePath, sep="\t", row.names=FALSE, quote=FALSE)
