fileNames <- commandArgs(trailingOnly = TRUE)

if(length(fileNames)==3){	

dataIn_ankle <- read.csv(fileNames[1], header = FALSE, sep = ",", row.names = NULL, fill=TRUE, col.names=c(1:34549))
dataIn_subtracted <- read.csv(fileNames[2], header = FALSE, sep = ",", row.names = NULL, fill=TRUE, col.names=c(1:34549))
dataIn_torso <- read.csv(fileNames[3], header = FALSE, sep = ",", row.names = NULL, fill=TRUE, col.names=c(1:34549))


ankle<-apply(dataIn_ankle, 1, mean,na.rm=TRUE)
subtracted<-apply(dataIn_subtracted, 1, mean,na.rm=TRUE)
torso<-apply(dataIn_torso, 1, mean,na.rm=TRUE)


ankle_subtracted<-cbind(t(t(ankle)),t(t(subtracted)))
ankle_torso<-cbind(t(t(ankle)),t(t(torso)))
torso_subtracted<-cbind(t(t(torso)),t(t(subtracted)))


colnames(ankle_subtracted)<-c("ankle","subtracted")
colnames(ankle_torso)<-c("ankle","torso")
colnames(torso_subtracted)<-c("torso","subtracted")


png(paste("pngs/",fileNames[1],fileNames[2],".png",sep=""),width=4000,height=2000)
par(mar=c(7,7,4,2)+0.1,mgp=c(5,2,2))
boxplot(ankle_subtracted, yaxt='n', xaxt='n')
axis(side=1,line=0.5, lwd=0, cex.axis=2.5, cex.lab=3.5,labels=c("ankle","subtracted"),at=c(1,2))
title(paste(fileNames[1],fileNames[2]),cex.main=2.5, ylab="mean g", cex.lab=2.5)
dev.off()

png(paste("pngs/",fileNames[1],fileNames[3],".png",sep=""),width=4000,height=2000)
par(mar=c(7,7,4,2)+0.1,mgp=c(5,2,2))
boxplot(ankle_torso, yaxt='n', xaxt='n')
axis(side=1,line=0.5, lwd=0, cex.axis=2.5, cex.lab=3.5,labels=c("ankle","torso"),at=c(1,2))
title(paste(fileNames[1],fileNames[3]),cex.main=2.5, ylab="mean g", cex.lab=2.5)
dev.off()

png(paste("pngs/",fileNames[3],fileNames[2],".png",sep=""),width=4000,height=2000)
par(mar=c(7,7,4,2)+0.1,mgp=c(5,2,2))
boxplot(torso_subtracted, yaxt='n', xaxt='n')
axis(side=1,line=0.5, lwd=0, cex.axis=2.5, cex.lab=3.5,labels=c("torso","subtracted"),at=c(1,2))
title(paste(fileNames[3],fileNames[2]),cex.main=2.5, ylab="mean g", cex.lab=2.5)
dev.off()

t_test_ankle_subtracted<-capture.output(t.test(ankle_subtracted[,1],ankle_subtracted[,2], var.equal=FALSE))
t_test_ankle_torso<-capture.output(t.test(ankle_torso[,1],ankle_torso[,2], var.equal=FALSE))
t_test_torso_subtracted<-capture.output(t.test(torso_subtracted[,1],torso_subtracted[,2], var.equal=FALSE))

cat(t_test_ankle_subtracted, file=paste("outputs/",fileNames[1],fileNames[2],"_t_test_means",sep=""), sep="\n")
cat(t_test_ankle_torso, file=paste("outputs/",fileNames[1],fileNames[3],"_t_test_means",sep=""), sep="\n")
cat(t_test_torso_subtracted, file=paste("outputs/",fileNames[3],fileNames[2],"_t_test_means",sep=""), sep="\n")

library(car)

ankle_subtracted_stacked<-stack(list(ankle=ankle, subtracted=subtracted))
leveneTest_ankle_subtracted <-capture.output(leveneTest(values~ind, ankle_subtracted_stacked))
cat(leveneTest_ankle_subtracted, file=paste("outputs/",fileNames[1],fileNames[2],"_leveneTest_ankle_subtracted_output",sep=""), sep="")

ankle_torso_stacked<-stack(list(ankle=ankle, torso=torso))
leveneTest_ankle_torso <-capture.output(leveneTest(values~ind, ankle_torso_stacked))
cat(leveneTest_ankle_torso, file=paste("outputs/",fileNames[1],fileNames[3],"_leveneTest_ankle_torso_output",sep=""), sep="")

torso_subtracted_stacked<-stack(list(torso=torso, subtracted=subtracted))
leveneTest_torso_subtracted <-capture.output(leveneTest(values~ind, torso_subtracted_stacked))
cat(leveneTest_torso_subtracted, file=paste("outputs/",fileNames[3],fileNames[2],"_leveneTest_torso_subtracted_output",sep=""), sep="")


} else {

	dataIn_filter <- read.csv(fileNames[1], header = FALSE, sep = ",", row.names = NULL, fill=TRUE, col.names=c(1:34549))
	dataIn_norm <- read.csv(fileNames[2], header = FALSE, sep = ",", row.names = NULL, fill=TRUE, col.names=c(1:34549))


	filter<-apply(dataIn_filter, 1, mean,na.rm=TRUE)
	norm<-apply(dataIn_norm, 1, mean,na.rm=TRUE)

	filter_norm<-cbind(t(t(filter)),t(t(norm)))

	colnames(filter_norm)<-c("filter","norm")

	png(paste("pngs/",fileNames[1],fileNames[2],".png",sep=""),width=4000,height=2000)
	par(mar=c(7,7,4,2)+0.1,mgp=c(5,2,2))
	boxplot(filter_norm, yaxt='n', xaxt='n')
	axis(side=1,line=0.5, lwd=0, cex.axis=2.5, cex.lab=3.5,labels=c("filter","norm"),at=c(1,2))
	title(paste(fileNames[1],fileNames[2]),cex.main=2.5, ylab="mean g", cex.lab=2.5)
	dev.off()

	t_test_filter_norm<-capture.output(t.test(filter_norm[,1],filter_norm[,2], var.equal=FALSE))

	cat(t_test_filter_norm, file=paste("outputs/",fileNames[1],fileNames[2],"_t_test_means",sep=""), sep="\n")

	library(car)

	filter_norm_stacked<-stack(list(filter=filter, norm=norm))
	leveneTest_filter_norm <-capture.output(leveneTest(values~ind, filter_norm_stacked))
	cat(leveneTest_filter_norm, file=paste("outputs/",fileNames[1],fileNames[2],"_leveneTest_filter_norm_output",sep=""), sep="")

}
