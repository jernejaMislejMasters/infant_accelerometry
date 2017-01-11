library(ppcor)

infant <- read.csv("final_variables.csv", header = TRUE, sep = ",", row.names = NULL)

infant

#all pairwise correlations
round(cor(infant,use="pairwise", method="spearman"),2)

IBM_variation<-infant[,c(2,3,4,5,6,7,8,9,10)]

#partial correlations
pcor.test(infant$IPA, infant$SLEEP, IBM_variation, method="spearman")

#partial correlations
pcor.test(infant$IPA, infant$FEED, IBM_variation, method="spearman")

pairs(infant)

library(Hmisc)

rcorr(PA_A,IBM,type='spearman')
