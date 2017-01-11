
fileName <- commandArgs(trailingOnly = TRUE)	

dataIn <- read.csv(fileName[1], header = FALSE, sep = ",", row.names = NULL, fill=TRUE, col.names=c(1:34549))

data<-t(dataIn)

#plot

if(substr(fileName[1],nchar(fileName[1])-4,nchar(fileName[1]))=="ratio"){

	png(paste("pngs/",fileName[1],".png",sep=""),width=4000,height=2000)
	par(mar=c(7,7,4,2)+0.1,mgp=c(5,2,2))
	boxplot(data, xaxt='n', yaxt='n',ylim=c(-1,1000))
	axis(side=1,line=0.5, lwd=0, cex.axis=2.5, cex=1.5, cex.lab=4.5, at=c(1:30), labels=c(1:30))
	axis(side=2,line=0.5, lwd=0, cex.axis=2.5, cex=1.5, cex.lab=4.5)

	title(fileName[1],cex.main=2.5, xlab="subjects", ylab="g", cex.lab=2.5)
	dev.off()

}else{
	png(paste("pngs/",fileName[1],".png",sep=""),width=4000,height=2000)
	par(mar=c(7,7,4,2)+0.1,mgp=c(5,2,2))
	boxplot(data, xaxt='n', yaxt='n')
	axis(side=1,line=0.5, lwd=0, cex.axis=2.5, cex=1.5, cex.lab=4.5, at=c(1:30), labels=c(1:30))
	axis(side=2,line=0.5, lwd=0, cex.axis=2.5, cex=1.5, cex.lab=4.5)

	title(fileName[1],cex.main=2.5, xlab="subjects", ylab="g", cex.lab=2.5)
	dev.off()
}


library(reshape2)
data<-melt(t(dataIn))
data<-data[-1]
data[,1]<-factor(data[,1])
pairwise_t_test_data<-capture.output(pairwise.t.test(data[,2],data[,1], p.adj="bonferroni",paired=F,var.equal=F,pool.sd=T))
pairwise_t_test<-pairwise.t.test(data[,2],data[,1], p.adj="bonferroni",paired=F,var.equal=F,pool.sd=T)
cat(pairwise_t_test_data, file=paste("outputs/",fileName[1],"_pairwise_t_test_data_output",sep=""), sep="")

cat(cbind(t(t( which(pairwise_t_test[[3]]<0.05, arr.ind = TRUE,useNames = TRUE)[,1]))+1,t(t( which(pairwise_t_test[[3]]<0.05, arr.ind = TRUE,useNames = TRUE)[,2]))),file=paste("outputs/",fileName[1],"_pairwise_t_test_significant_differences",sep=""), sep="\n")


library(car)
leveneTest_data <-capture.output(leveneTest(data[,2],data[,1]))
cat(leveneTest_data, file=paste("outputs/",fileName[1],"_leveneTest_data_output",sep=""), sep="")

#aov_subjects<-aov(data[,2]~data[,1])
#summary_aov_subjects<-capture.output(summary(aov_subjects))
#TukeyHSD_aov_subject<-capture.output(TukeyHSD(aov_subjects))
#Tukey_subjects<-TukeyHSD(aov_subjects)
#kruskal_test_data<-capture.output(kruskal.test(data[,2],data[,1]))
#cat(summary_aov_subjects, file=paste("outputs/",fileName[1],"_summary_aov_output",sep=""), sep="")
#cat(TukeyHSD_aov_subject, file=paste("outputs/",fileName[1],"_TukeyHSD_aov_subject_output",sep=""), sep="")
#cat(kruskal_test_data, file=paste("outputs/",fileName[1],"_kruskal_test_data_output",sep=""), sep="")
#cat(rownames(Tukey_subjects[[1]])[Tukey_subjects[[1]][,4]<0.05], file=paste("outputs/",fileName[1],"_significant_differences",sep=""), sep="\n")
