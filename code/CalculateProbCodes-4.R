##########################################################################
# Copyright (c) 2012 W. Evan Johnson, Boston University School of Medicine
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
##########################################################################

##############################################################################
# Define functions
##############################################################################

######## New normal Barcode
UPC_normal=function(y,l=NULL,gc=NULL,conv=.01) {
  x = cbind(matrix(rep(1,length(y)),ncol=1),l,l^2,gc,gc^2)
  
  paramsold=Inf
  theta=solve(t(x)%*%x)%*%t(x)%*%y
  large=1.*(y>median(y))
    
  #large=y>x%*%theta
  p=mean(large)
  fit=mln2(y,x,large)

  params=c(p,fit$bhat1,fit$bhat2,fit$shat)
  it=0
  
  while (max(abs((paramsold-params)/params)) > conv)
  {
    #E-STEP
    gam=p*dnorm(y,x%*%fit$bhat1,fit$shat)/(p*dnorm(y,x%*%fit$bhat1,fit$shat)+(1-p)*dnorm(y,x%*%fit$bhat2,fit$shat))
    
    #M-STEP
    p=mean(gam)
    fit=mln2(y,x,gam)

    paramsold=params
    params=c(p,fit$bhat1,fit$bhat2,fit$shat)
    it=it+1

    print(paste("Iteration ", it, ": c = ", max(abs((paramsold-params)/params)),": p = ",p, sep=""))

    if (it == 100)
    {
      print("Stopped after 100 iterations")
      break
    }
  }

  print(paste("Total iterations:", it))

  gam=p*dnorm(y,x%*%fit$bhat1,fit$shat)/(p*dnorm(y,x%*%fit$bhat1,fit$shat)+(1-p)*dnorm(y,x%*%fit$bhat2,fit$shat))
    
  return(list(p=p,bhat1=fit$bhat1,bhat2=fit$bhat2,shat=fit$shat,probs=gam))
}

mln2=function(y,x,gam){
 bhat1=solve(t(x)%*%(gam*x))%*%t(x)%*%(gam*y)
 bhat2=solve(t(x)%*%((1-gam)*x))%*%t(x)%*%((1-gam)*y)
 shat=sqrt((sum(gam*(y-x%*%bhat1)^2)+sum((1-gam)*(y-x%*%bhat2)^2))/length(y))
 return(list(bhat1=bhat1,bhat2=bhat2,shat=shat))
}

########### NEW Log-normal UPC ###########
UPC_lognorm=function(y,l=NULL,gc=NULL,conv){
  x = cbind(matrix(rep(1,length(y)),ncol=1),l,l^2,gc,gc^2)
  
  paramsold=Inf
  theta=solve(t(x)%*%x)%*%t(x)%*%log(y)
  large=c(y>x%*%theta)
  p=mean(large)
  fit=mlln2(y,x,large)

  params=c(p,fit$bhat1,fit$bhat2,fit$shat)
  it=0

  while (max(abs((paramsold-params)/params)) > conv)
  {
    #E-STEP
    gam=p*dlnorm(y,x%*%fit$bhat1,fit$shat)/(p*dlnorm(y,x%*%fit$bhat1,fit$shat)+(1-p)*dlnorm(y,x%*%fit$bhat2,fit$shat))
    
    #M-STEP
    p=mean(gam)
    fit=mlln2(y,x,gam)

    paramsold=params
    params=c(p,fit$bhat1,fit$bhat2,fit$shat)
    it=it+1

    print(paste("Iteration ", it, ": c = ", max(abs((paramsold-params)/params)), sep=""))

    if (it == 100)
    {
      print("Stopped after 100 iterations")
      break
    }
  }

  print(paste("Total iterations:", it))

  gam=p*dlnorm(y,x%*%fit$bhat1,fit$shat)/(p*dlnorm(y,x%*%fit$bhat1,fit$shat)+(1-p)*dlnorm(y,x%*%fit$bhat2,fit$shat))
    
  return(list(p=p,bhat1=fit$bhat1,bhat2=fit$bhat2,shat=fit$shat,probs=gam))
}

mlln2=function(y,x,gam){
 bhat1=solve(t(x)%*%(gam*x))%*%t(x)%*%(gam*log(y))
 bhat2=solve(t(x)%*%((1-gam)*x))%*%t(x)%*%((1-gam)*log(y))
 shat=sqrt((sum(gam*(log(y)-x%*%bhat1)^2)+sum((1-gam)*(log(y)-x%*%bhat2)^2))/length(y))
 return(list(bhat1=bhat1,bhat2=bhat2,shat=shat))
}

########### NEW negative binomial UPC ###########
UPC_negbinom=function(y,l=NULL,gc=NULL,start=NULL,conv=.001,sam=10000){
  library(MASS)

  x = cbind(matrix(rep(1,length(y)),ncol=1),l,l^2,gc,gc^2)
  y1=round(y)
    
  paramsold=Inf
  use=1:length(y1)
  if (sam < length(y1)){use=sample(use,sam)}

  fit=suppressWarnings(glm.nb(y1[use]~-1+x[use,]))
  keep1=y>exp(x%*%fit$coefficients)
  p=mean(keep1)

  fit1=suppressWarnings(glm.nb(y1[use]~-1+x[use,],weights=keep1[use]))
  fit2=suppressWarnings(glm.nb(y1[use]~-1+x[use,],weights=1-keep1[use]))

  params=c(p,fit1$theta,fit1$coefficients,fit2$theta,fit2$coefficients)
  it=0

  while (max(abs((paramsold-params)/params)) > conv)
  {
    #E-STEP
    gam=p*dnbinom(y1,size=fit1$theta,mu=exp(x%*%fit1$coefficients))/(p*dnbinom(y1,size=fit1$theta,mu=exp(x%*%fit1$coefficients))+(1-p)*dnbinom(y1,size=fit2$theta,mu=exp(x%*%fit2$coefficients)))

    #M-STEP
    p=mean(gam[use])
    fit1=suppressWarnings(glm.nb(y1[use]~-1+x[use,],weights=gam[use]))
  	fit2=suppressWarnings(glm.nb(y1[use]~-1+x[use,],weights=1-gam[use]))

	paramsold=params
    params=c(p,fit1$theta,fit1$coefficients,fit2$theta,fit2$coefficients)
  	it=it+1

    print(paste("Iteration ", it, ": c = ", max(abs((paramsold-params)/params)),sep=""))
    #print(paste("p=", p,sep=''))

    if (it == 100)
    {
      print("Stopped after 100 iterations")
      break
    }
  }

  print(paste("Total iterations:", it))

  gam=p*dnbinom(y1,size=fit1$theta,mu=exp(x%*%fit1$coefficients))/(p*dnbinom(y1,size=fit1$theta,mu=exp(x%*%fit1$coefficients))+(1-p)*dnbinom(y1,size=fit2$theta,mu=exp(x%*%fit2$coefficients)))
    
  return(list(p=p,probs=gam))
}

##############################################################################
# Parse input parameters
##############################################################################

inFilePath = commandArgs()[7]
transformType = commandArgs()[8]
outFilePath = commandArgs()[9]

if (length(commandArgs()) > 9)
{
  conv = as.numeric(commandArgs()[10])
} else
{
  conv = 0.01 # the default
}

print("Reading data")
data = read.table(inFilePath, sep="\t", header=FALSE, stringsAsFactors=FALSE, row.names=NULL, quote="\"")

zeroData = data[which(data[,2]==0),1:2]
data = data[which(data[,2]!=0),]

featureNames = data[,1]
data = data.matrix(data[,-1])

expr = data[,1]

lengths = NULL
gc = NULL

if (ncol(data) >= 3)
{
  print("Getting length and GC information")
  rawLengths = data[,2]
  rawGC = data[,3]

  if (all(!is.na(rawLengths)))
  {
    # Only adjust for length if they are not all the same
    if (length(unique(rawLengths))>1)
      lengths = log2(as.numeric(rawLengths))

    if (all(!is.na(rawGC)))
      gc = as.numeric(rawGC) / as.numeric(rawLengths)
  }
}

print("Calculating bar codes")
if (transformType == "nn")
  barcodes = UPC_normal(log2(expr + 2), l=lengths, gc=gc, conv=conv)

if (transformType == "ln")
  barcodes = UPC_lognorm(log2(expr + 2), l=lengths, gc=gc, conv=conv)

if (transformType == "nb")
{
  tryNegBinom = function()
  {
    return(UPC_negbinom(log2(expr + 2), l=lengths, gc=gc, conv=conv))
  }
  retryNegBinom = function(e)
  {
    message(e)
    message("\nRetrying...")
    return(UPC_negbinom(log2(expr + 2), l=lengths, gc=gc, conv=conv))
  }

  barcodes = tryCatch(tryNegBinom(), error=retryNegBinom)
}

if (!(transformType%in%c("nn", "ln", "nb")))
  stop("transformType specified is invalid")

outData = cbind(featureNames, round(barcodes$probs, 6))
outData = rbind(outData, as.matrix(zeroData))

write.table(outData, outFilePath, quote=FALSE, sep="\t", row.names=FALSE, col.names=FALSE)
