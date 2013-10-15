mlln=function(y,x,gam=NULL){
 if(is.null(gam))
   gam=rep(1,length(y))

 bhat=solve(t(x)%*%(gam*x))%*%t(x)%*%(gam*log(y))
 shat=sqrt(sum(gam*(log(y)-x%*%bhat)^2)/sum(gam))

 return(list(bhat=bhat,shat=shat))
}

barcode=function(genecounts,l=NULL,gc=NULL, conv=0.01)
{
  return(RS_BC(genecounts, l, gc, conv=conv)$probs)
}

#RS_BC=function(y,l=NULL,gc=NULL,start=NULL,conv){
#  x = cbind(matrix(rep(1,length(y)),ncol=1),l,gc)

#  thetaold=Inf
#  if(is.null(start)){
    #y1=y[y<=median(y)];y2=y[y>=median(y)]
#    p=.5
#    theta1=mlln(y,x,y>=median(y))
#    theta2=mlln(y,x,y<median(y))
 # } else {
   # p=start[1]
   # theta1=start[2:3]
   # theta2=start[4:5]
  #}
  #theta=c(p,theta1$bhat,theta1$shat,theta2$bhat,theta2$shat)

  #it=0

 # while (max(abs((thetaold-theta)/theta)) > conv)
 # {
    #print(paste("Iteration", it))
    #E-STEP
#    gam=p*dlnorm(y,x%*%theta1$bhat,theta1$shat)/(p*dlnorm(y,x%*%theta1$bhat,theta1$shat)+(1-p)*dlnorm(y,x%*%theta2$bhat,theta2$shat))

    #M-STEP
#    p=mean(gam)
#    theta1=mlln(y,x,gam)
#    theta2=mlln(y,x,1-gam)

  #  thetaold=theta
  #  theta=c(p,theta1$bhat,theta1$shat,theta2$bhat,theta2$shat)
  #  it=it+1

   # print(paste("Iteration ", it, ": c = ", max(abs((thetaold-theta)/theta)), sep=""))

   # if (it == 100)
   # {
    #  print("Stopped after 100 iterations")
   #   break
  #  }
 # }

#  print(paste("Total iterations:", it))

#  y.sim=c(rlnorm(floor(10000*p),x%*%theta1$bhat,theta1$shat),rlnorm(floor(10000*(1-p)),x%*%theta2$bhat,theta2$shat))
#  gam=p*dlnorm(y,x%*%theta1$bhat,theta1$shat)/(p*dlnorm(y,x%*%theta1$bhat,theta1$shat)+(1-p)*dlnorm(y,x%*%theta2$bhat,theta2$shat))

#  return(list(p=p,theta1=theta1,theta2=theta2,probs=gam))
#}

RS_BC=function(y,l=NULL,gc=NULL,start=NULL,conv){
  #x = cbind(matrix(rep(1,length(y)),ncol=1),l,l^2,gc)
  #print(y[1:10])
  x = cbind(matrix(rep(1,length(y)),ncol=1),1.*(y>median(y)),l,l^2,l^3,gc,gc^2,gc^3)

  paramsold=Inf
  if(is.null(start)){
    #y1=y[y<=median(y)];y2=y[y>=median(y)]
    p=.5
  #  theta1=mlln(y,x,y>=median(y))
  #  theta2=mlln(y,x,y<median(y))
   theta=mlln(y,x)
   
  } else {
    p=start[1]
    theta1=start[2:3]
    theta2=start[4:5]
  }
#  theta=c(p,theta1$bhat,theta1$shat,theta2$bhat,theta2$shat)
  params=c(p,theta$bhat,theta$shat)
  it=0

  while (max(abs((paramsold-params)/params)) > conv)
  {
    
    #print(paste("Iteration", it))
    #E-STEP
#    gam=p*dlnorm(y,x%*%theta1$bhat,theta1$shat)/(p*dlnorm(y,x%*%theta1$bhat,theta1$shat)+(1-p)*dlnorm(y,x%*%theta2$bhat,theta2$shat))
    x_1=cbind(1,1,x[,-c(1:2)]);
    x_2=cbind(1,0,x[,-c(1:2)]);
    gam=p*dlnorm(y,x_1%*%theta$bhat,theta$shat)/(p*dlnorm(y,x_1%*%theta$bhat,theta$shat)+(1-p)*dlnorm(y,x_2%*%theta$bhat,theta$shat))
    x=cbind(1,gam,x[,-c(1:2)])
    
    #M-STEP
    p=mean(gam)
    theta=mlln(y,x)
    print(theta$bhat)
    print(theta$shat)
    #theta1=mlln(y,x,gam)
    #theta2=mlln(y,x,1-gam)

    paramsold=params
    #theta=c(p,theta1$bhat,theta1$shat,theta2$bhat,theta2$shat)
    params=c(p,theta$bhat,theta$shat)
    it=it+1

    print(paste("Iteration ", it, ": c = ", max(abs((paramsold-params)/params)), sep=""))

    if (it == 100)
    {
      print("Stopped after 100 iterations")
      break
    }
  }

  print(paste("Total iterations:", it))

  #y.sim=c(rlnorm(floor(10000*p),x%*%theta1$bhat,theta1$shat),rlnorm(floor(10000*(1-p)),x%*%theta2$bhat,theta2$shat))
  y.sim=rlnorm(length(y),x%*%theta$bhat,theta$shat)
  par(mfrow=c(2,1))
  #hist(y,breaks=250, xlim=c(0,30))
  #hist(y.sim,breaks=250,col=2, xlim=c(0,30))
  x_1=cbind(1,1,x[,-c(1:2)]);
  x_2=cbind(1,0,x[,-c(1:2)]);
  gam=p*dlnorm(y,x_1%*%theta$bhat,theta$shat)/(p*dlnorm(y,x_1%*%theta$bhat,theta$shat)+(1-p)*dlnorm(y,x_2%*%theta$bhat,theta$shat))

  return(list(p=p,theta=theta,probs=gam))
  #return(list(p=p,theta1=theta1,theta2=theta2,probs=gam))
}


nn_barcode=function(y,l=NULL,gc=NULL,conv=.05,q=1) {
  quan=quantile(l,c(1:(q-1)/q))
  groups=rep(1,length(y))
  #for (i in quan){groups[l>i]=groups[l>i]+1}
  #groups=floor(l)
  #groups[groups>17]=17
  #groups[groups<8]=8
  #print(table(groups))
  probs=numeric(length(y))
  for (j in unique(groups)){
#    print(j)
    use=(groups==j)
    #print(c(i,quan, sum(use)))
    X=1.*cbind(matrix(1,nrow=length(y),ncol=1),l,l^2,gc)[use,]
    y1=y[use]

    pi_h=.5

    x_1=cbind(X[y1>median(y1),])
    beta_1=solve(t(x_1)%*%x_1)%*%t(x_1)%*%y1[y1>median(y1)]
    sigma2_1=var(y1[y1>median(y1)])

    x_2=cbind(X[y1<=median(y1),])
    beta_2=solve(t(x_2)%*%x_2)%*%t(x_2)%*%y1[y1<=median(y1)]
    sigma2_2=var(y1[y1<=median(y1)])

    theta=c(pi_h,beta_1,beta_2)#,sigma2_1,sigma2_2)
    thetaold=theta+1000
    i<- 0

    gamma=1.*(y1>median(y1))
    x=cbind(1,gamma,X[,-1])
    beta=solve(t(x)%*%(x))%*%t(x)%*%y1

    while(max(abs((theta-thetaold)/thetaold))>conv)
   {
     thetaold=theta 
     
     #E-step
     #gamma <- (pi_h*dnorm(y1,X%*%beta_1,sqrt(sigma2_1)))/(pi_h*dnorm(y1,X%*%beta_1,sqrt(sigma2_1))+(1-pi_h)*dnorm(y1,X%*%beta_2,sqrt(sigma2_2)))
     gamma <- (pi_h*dnorm(y1,cbind(1,1,X[,-1])%*%beta,sqrt(sigma2_1)))/(pi_h*dnorm(y1,cbind(1,1,X[,-1])%*%beta,sqrt(sigma2_1))+(1-pi_h)*dnorm(y1,cbind(1,0,X[,-1])%*%beta,sqrt(sigma2_2)))

     x=cbind(1,gamma,X[,-1])
     
     #M-step
     beta=solve(t(x)%*%(x))%*%t(x)%*%y1
#    beta_1 <- solve(t(X)%*%(gamma*X))%*%t(X)%*%(gamma*y1)
#    beta_2 <- solve(t(X)%*%((1-gamma)*X))%*%t(X)%*%((1-gamma)*y1)
    # print(beta)
     #sigma2_1 <- (t(y1-X%*%beta_1)%*%(gamma*(y1-X%*%beta_1)))/(sum(gamma))
     #sigma2_1 <- predict(loess((y1-X%*%beta_1)^2~l,weights=gamma))
     #sigma2_2 <- (t(y1-X%*%beta_2)%*%((1-gamma)*(y1-X%*%beta_2)))/(sum(1-gamma))
     #sigma2_2 <- predict(loess((y1-X%*%beta_2)^2~l,weights=1-gamma))
     #sigma2_1  <- sigma2_2 <- predict(loess(((y1-gamma*X%*%beta_2-(1-gamma)*X%*%beta_1)^2)~l))
     #sigma2_1  <- sigma2_2 <- predict(loess(((y1-x%*%beta)^2)~l))
     sigma2_1  <- sigma2_2 <- sum((y1-x%*%beta)^2)/length(y1)
     
     #sigma2_1=sigma2_2=mean(c(sigma2_1,sigma2_2))
    
     pi_h <- mean(gamma)

     theta=c(pi_h,beta_1,beta_2)#,sigma2_1,sigma2_2)
    
     i <- i+1
     print(paste("Iteration", i))
     print(max(abs((theta-thetaold)/thetaold)))

     # Abort if most values are to one extreme
     if (sum(x[,2] > 0.99) > nrow(x) * 0.99)
     {
       warning("Most values were close to 1.0, so stopping. Perhaps try with a higher convergence threshold.")
       break
     }
     if (sum(x[,2] < 0.01) > nrow(x) * 0.99)
     {
       warning("Most values were close to 0.0, so stopping. Perhaps try with a higher convergence threshold.")
       break
     }

     if (i == 100)
     {
       print("Stopped at 100 iterations")
       break
     }
   }
   #return(gamma)
   probs[use]=gamma
  }
  y.sim=rnorm(length(y),x%*%beta,sqrt(sigma2_1))
  par(mfrow=c(2,1))
  #hist(y,breaks=250, xlim=c(0,30))
  #hist(y.sim,breaks=250,col=2, xlim=c(0,30))
 
  probs
}

#nn_barcode=function(y,l=NULL,gc=NULL,conv=.01) {
#	X=1.*cbind(y>median(y),y<=median(y),l,gc)
#
#	pi_h=.5
#	beta=solve(t(X)%*%X)%*%t(X)%*%y
#	sigma2_1=var(y[y>median(y)])
#	sigma2_2=var(y[y<=median(y)])
#	x_1=cbind(matrix(c(1,0),length(y),2,byrow=T),X[,-c(1:2)])
#	x_2=cbind(matrix(c(0,1),length(y),2,byrow=T),X[,-c(1:2)])
#	
#	theta=c(pi_h,beta,sigma2_1,sigma2_2)
#	thetaold=theta+1000
#	i<- 0
#
#	while(max(abs((theta-thetaold)/thetaold))>conv)
#    {
#      thetaold=theta	
#
#      #E-step
#      gamma <- (pi_h*dnorm(y,x_1%*%beta,sqrt(sigma2_1)))/(pi_h*dnorm(y,x_1%*%beta,sqrt(sigma2_1))+(1-pi_h)*dnorm(y,x_2%*%beta,sqrt(sigma2_2)))
#      x=cbind(gamma,1-gamma,X[,-c(1:2)])
#
#      #M-step
#      Sigma <- (gamma*sigma2_1+(1-gamma)*sigma2_2)^(-1)
#      beta <- solve(t(X)%*%(Sigma*X))%*%t(X)%*%(Sigma*y)
#	
#      sigma2_1 <- (t(y-X%*%beta)%*%(gamma*(y-X%*%beta)))/(sum(gamma))
#      sigma2_2 <- (t(y-X%*%beta)%*%((1-gamma)*(y-X%*%beta)))/(sum(1-gamma))
#	
#      pi_h <- mean(gamma)
#
#      theta=c(pi_h,beta,sigma2_1,sigma2_2)
#	
#      i <- i+1
#      print(paste("Iteration", i))
#      print(max(abs((theta-thetaold)/thetaold)))
#
#      if (i == 100)
#      {
#        print("Stopped at 100 iterations")
#        break
#      }
#    }
#
#    return(gamma)
#}

inFilePath = commandArgs()[7]
transformType = commandArgs()[8]
outFilePath = commandArgs()[9]
if (length(commandArgs()) > 9)
{
  conv = as.numeric(commandArgs()[10])
} else
{
  conv = 0.005
}

print("Reading data")
data = read.table(inFilePath, sep="\t", header=FALSE, stringsAsFactors=FALSE, row.names=NULL, quote="\"")

zeroData = data[which(data[,2]==0),1:2]
data = data[which(data[,2]!=0),]

featureNames = data[,1]
data = data.matrix(data[,-1])

expr = log2(data[,1]+2)

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
{
##  set.seed(1)
##  tinyNoise = runif(length(expr), 0, 0.001)

  barcodes = nn_barcode(expr, l=lengths, gc=gc, conv=conv)
} else
{
  barcodes = barcode(expr, l=lengths, gc=gc, conv=conv)
}

outData = cbind(featureNames, round(barcodes, 6))
outData = rbind(outData, as.matrix(zeroData))

write.table(outData, outFilePath, quote=FALSE, sep="\t", row.names=FALSE, col.names=FALSE)

### Simulated data ###
#gc = 1:5000
#ln = rnorm(5000, 100, 1)
#mu=rep(c(0,1),5000)
#x = rlnorm(5000, mu+gc*.001+.01*ln, 1)
#probCodes = calc(x,ln,gc)


### Debug  ####

#setwd('/Users/evan/Desktop/Evan_UPC_Demo')
#data = read.table("Data/Xu_prob_in.txt", sep="\t", header=FALSE, stringsAsFactors=FALSE, row.names=1, quote="\"")
#expr = log2(data[,1]+2)

#lengths = NULL
#gc = NULL

#if (ncol(data) >= 3)
#{
#  print("Getting length and GC information")
#  rawLengths = data[,2]
#  rawGC = data[,3]

#  if (all(!is.na(rawLengths)))
#  {
#    # Only adjust for length if they are not all the same
#    if (length(unique(rawLengths))>1)
#      lengths = log2(as.numeric(rawLengths))

#    if (all(!is.na(rawGC)))
#      gc = as.numeric(rawGC) / as.numeric(rawLengths)
#  }
#}

#l=lengths;conv=.01;q=4;y=expr

#barcodes = nn_barcode(expr, l=lengths, gc=gc, conv=conv)
#barcode(expr,l=l,gc=gc, conv=0.01)

#outData = cbind(rownames(data), round(barcodes, 6))

#write.table(outData, outFilePath, quote=FALSE, sep="\t", row.names=FALSE, col.names=FALSE)

