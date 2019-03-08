## Replication of
## Table 1: Randomization Check for Label Experiment
rm(list=ls())
install.packages("ebal")
library(Matching)
library(foreign)
library(ebal)

d <- load("repTable1and2.RData")
set.seed(1234)

## Table 1: Randomization Check for Label Experiment
covarsexp1 <- colnames(x)[c(4:15,26:40)]
out.b <- MatchBalance(x$exp1_treat~as.matrix(x[,covarsexp1]),
                      match.out=NULL,nboots=1000)
bal.b <- baltest.collect(matchbal.out=out.b,
                         var.names=covarsexp1,after=FALSE)
tab1 <- round(bal.b[,c(1,2,6,7)],2)

coffees <- c("Avg. Sales FR Regular Bulk ($)",
               "Avg. Sales Coffee Blend Bulk ($)",
               "Avg. Sales All Bulk Coffees ($)",
               "Avg. Sales All Instant Coffees ($)",
               "Avg. Sales All Packaged Coffees ($)")

rownames(tab1)  <-
  c("Total Store Sales 2008 ($)",
   "Total Store Sales Growth 2008-2009 (%)",
  paste(coffees,
   c("4 Weeks"),sep="-"),
  paste(coffees,
   c("52 Weeks"),sep="-"),
  "Total Population",
  "African American Pop (%)",
  "Foreign Born Pop (%)",
  "Median HH Income ($)",
  "HHs with Soc. Security Income (%)",
  "Public Assistance per capita ($)",
  "Family HHs (%)",
  "HH Head Aged 15-34 (%)",
  "HH Head Aged 65+ (%)",
  "In High School (%)",
  "In College (%)",
  "High School Dropouts (%)",
  "High School Graduates (%)",
  "BA Degree (%)",
  "Graduate Degree (%)")

tab1
install.packages("xtable")
library(xtable)

export <- xtable(tab1)
print(export,type="html",file="replication.html")


#table of potential outcomes
treated <- x[which(x$exp1_treat==1),]
control <- x[which(x$exp1_treat==0),]
diff <- mean(treated$storesales2008) - mean(control$storesales2008)
diff
x$y0 <- ifelse(x$exp1_treat==1, paste0("(", x$storesales2008, ")"), paste0(x$storesales2008))
x$y1 <- ifelse(x$exp1_treat==0, paste0("(", x$storesales2008, ")"), paste0(x$storesales2008))
table <- data.frame(x$store, x$exp1_treat,x$storesales2008,x$y0,x$y1)
names(table) <- c("Store","Actual Treatment","Observed Outcome","Y(0)","Y(1)")

newobject <- xtable(table)
print(newobject,type="html",file="fisher.html")


foo <- data.frame(x$store, x$storesales2008)

# Assignment function
assignment <- function() {
  # Four coin flips, establishing random assignment
  assig        <- foo[sample(1:2),]
  assig[3:4,]  <- foo[sample(3:4),]
  assig[5:6,]  <- foo[sample(5:6),]
  assig[7:8,]  <- foo[sample(7:8),]
  assig[9:10,]  <- foo[sample(9:10),]
  assig[11:12,]  <- foo[sample(11:12),]
  assig[13:14,]  <- foo[sample(13:14),]
  assig[15:16,]  <- foo[sample(15:16),]
  assig[17:18,]  <- foo[sample(17:18),]
  assig[19:20,]  <- foo[sample(19:20),]
  assig[21:22,]  <- foo[sample(21:22),]
  assig[23:24,]  <- foo[sample(23:24),]
  assig[25:26,]  <- foo[sample(25:26),]
  
  treatment.group   <- assig[c(1,3,5,7,9,11,13,15,17,19,21,23,25),]
  control.group     <- assig[c(2,4,6,8,10,12,14,16,18,20,22,24,26),]
  
  return(mean(treatment.group[,2]) - mean(control.group[,2]))
}

# Iterating the Assignment function
iter.RI <- function(iterations = 10000000) {
  for (i in 1:iterations) 
  {storage.vector[i] <- assignment()
  #to see the simulation progress
  print(i)
  }
  
  return(storage.vector)
}

storage.vector <- NULL
results <- iter.RI()

# Exploring the results

quantile(results, prob = c(0.025, 0.975))

length(unique(results))

hist(results)
plot(density(results),ylab="Probability Density",xlab="Treated - Control Sales in USD",main=NULL)
abline(v = -9768164, lwd = 2, col = "red")
abline(v = 9752275, lwd = 2, col = "red")
abline(v = diff, lwd = 2, col = "purple")
abline(h = 0, lwd = 2, col = "red")

#find probability density for observed test statistic
approx(density(results)$x,density(results)$y,xout=1095907)
