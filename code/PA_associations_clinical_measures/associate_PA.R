library(ppcor)

second_summary_IBM_procentage<-c(20.651,19.974,22.988,17.746,17.705,20.033,26.028,33.183,16.711,14.096,19.814,17.157,21.866,22.859,28.803,15.701,26.088,22.549,16.79,16.071,26.854,19.275,24.478
,11.37,21.52,26.62,25.159,22.146,21.607,14.015)


PA_high_procentage_D<-c(0.5647,3.158,17.24,11.74,17.06,13.97,3.816,3.056,3.636,5.513,3.327,1.579,5.48,3.871,7.625,0.09563,4.625,5.676,2.025,1.443,0.815,2.138,9.905,3.593,1.465,10.95,2.33,2.086
,4.11,1.155)

PA_high_procentage_E<-c(11.18,18.01,21.53,11.28,7.474,10.14,14.44,13.51,15.4,11.51,9.991,10.81,13.18,12.45,13.55,7.494,10.21,17.74,12.87,12.17,9.627,9.556,10.02,7.417,15.99,15.11,9.942,10.24,5.618,8.883)



PA_low_procentage_D<-c(2.606,6.784,24.96,15.74,28.87,25.52,6.642,6.803,6.652,8.852,4.274,3.253,9.154,6.212,12.82,0.6259,8.225,10.67,6.483,3.565,2.618,3.732,15.46,6.963,2.366,18.6,5.707,4.493,6.756,3.968)

PA_low_procentage_E<-c(18.35,25.81,26.52,14.46,12.96,16.72,19.67,23.46,22.03,18,14.25,16.9,18.97,20,20.34,12.79,13.9,24.43,18.75,19.42,14.18,14.33,13.15,13.72,22.24,20.12,14.77,15.56,9.882,15.18)



names_infants_PA<-c("2PO74B","8PI77B","13PO79B","37PO75B","70PO79B1","70PO79B2","71PO78B","72PO86B","73PO79B","74PO81B","75PO77B","76PO77B",
	"78PO83B","79PO76B","80PO77B","81PI80B","86PO79B","95PO76B","103PO76B","107PO74B","111PO82B","114PO76B","115PO75B","116PO78B","117PI78B",
	"118PO84B","119PO79B","120PO80","62PO77B","84PO77B")



second_summary_IBM_procentage<-as.data.frame(cbind(second_summary_IBM_procentage,names_infants_PA))
PA_high_procentage_E<-as.data.frame(cbind(PA_high_procentage_E,names_infants_PA))
PA_high_procentage_D<-as.data.frame(cbind(PA_high_procentage_D,names_infants_PA))
PA_low_procentage_E<-as.data.frame(cbind(PA_low_procentage_E,names_infants_PA))
PA_low_procentage_D<-as.data.frame(cbind(PA_low_procentage_D,names_infants_PA))

colnames(second_summary_IBM_procentage)<-c("being_moved","ID_infant")
colnames(PA_high_procentage_E)<-c("PA_high_E","ID_infant")
colnames(PA_high_procentage_D)<-c("PA_high_D","ID_infant")
colnames(PA_low_procentage_E)<-c("PA_low_E","ID_infant")
colnames(PA_low_procentage_D)<-c("PA_low_D","ID_infant")


second_summary_IBM_procentage$being_moved<-as.numeric(levels(second_summary_IBM_procentage$being_moved)[as.integer(second_summary_IBM_procentage$being_moved)])
PA_high_procentage_E$PA_high_E<-as.numeric(levels(PA_high_procentage_E$PA_high_E)[as.integer(PA_high_procentage_E$PA_high_E)])
PA_high_procentage_D$PA_high_D<-as.numeric(levels(PA_high_procentage_D$PA_high_D)[as.integer(PA_high_procentage_D$PA_high_D)])
PA_low_procentage_E$PA_low_E<-as.numeric(levels(PA_low_procentage_E$PA_low_E)[as.integer(PA_low_procentage_E$PA_low_E)])
PA_low_procentage_D$PA_low_D<-as.numeric(levels(PA_low_procentage_D$PA_low_D)[as.integer(PA_low_procentage_D$PA_low_D)])


pheno_data<-read.table("PrePreg_Infant_dataset_19Dec2016.txt", header = TRUE, sep = "\t", row.names = NULL, fill=TRUE)

pheno_data<-pheno_data[!is.na(pheno_data$ID_infant) & pheno_data$ID_infant!="" &  pheno_data$ID_infant!=" ",]

pheno_data[pheno_data=="N" & !is.na(pheno_data)]<-NA
pheno_data[pheno_data=="" & !is.na(pheno_data)]<-NA
pheno_data[pheno_data==" " & !is.na(pheno_data)]<-NA


pheno_data<-merge(pheno_data,second_summary_IBM_procentage,by="ID_infant")
pheno_data<-merge(pheno_data,PA_high_procentage_E,by="ID_infant")
pheno_data<-merge(pheno_data,PA_high_procentage_D,by="ID_infant")
pheno_data<-merge(pheno_data,PA_low_procentage_E,by="ID_infant")
pheno_data<-merge(pheno_data,PA_low_procentage_D,by="ID_infant")

#copy mothers data from twin where missing
pheno_data[pheno_data$ID_infant=="70PO79B2",c("ID","Pregnant","Age_year","Weight_kg","Height_cm","BMI","Hip1","Hip2","Hip_avg","Consent","Second_visit")]<-
		pheno_data[pheno_data$ID_infant=="70PO79B1",c("ID","Pregnant","Age_year","Weight_kg","Height_cm","BMI","Hip1","Hip2","Hip_avg","Consent","Second_visit")]

#data cleaning
pheno_data$BMI<-gsub(",", ".", pheno_data$BMI)
pheno_data$BMI<-as.numeric(pheno_data$BMI)

pheno_data$Hip_avg<-gsub(",", ".", pheno_data$Hip_avg)
pheno_data$Hip_avg<-as.numeric(pheno_data$Hip_avg)

pheno_data$I_Age_2<-gsub(",", ".", pheno_data$I_Age_2)
pheno_data$I_Age_2[30]<-22
pheno_data$I_Age_2<-as.numeric(pheno_data$I_Age_2)

pheno_data$I_FM_2<-gsub(",", ".", pheno_data$I_FM_2)
pheno_data$I_FM_2<-as.numeric(pheno_data$I_FM_2)

pheno_data$I_FFM_2<-gsub(",", ".", pheno_data$I_FFM_2)
pheno_data$I_FFM_2<-as.numeric(pheno_data$I_FFM_2)

pheno_data$I_FM_proc_2<-gsub(",", ".", pheno_data$I_FM_proc_2)
pheno_data$I_FM_proc_2<-as.numeric(pheno_data$I_FM_proc_2)

pheno_data$I_Glu0_2<-gsub(",", ".", pheno_data$I_Glu0_2)
pheno_data$I_Glu0_2<-as.numeric(pheno_data$I_Glu0_2)

pheno_data$I_Ins0_2<-gsub(",", ".", pheno_data$I_Ins0_2)
pheno_data$I_Ins0_2<-as.numeric(pheno_data$I_Ins0_2)

pheno_data$I_homocyst_2<-gsub(",", ".", pheno_data$I_homocyst_2)
pheno_data$I_homocyst_2<-as.numeric(pheno_data$I_homocyst_2)

pheno_data$I_ApoB.ApoA1_2<-gsub(",", ".", pheno_data$I_ApoB.ApoA1_2)
pheno_data$I_ApoB.ApoA1_2<-as.numeric(pheno_data$I_ApoB.ApoA1_2)

pheno_data$I_Chol_2<-gsub(",", ".", pheno_data$I_Chol_2)
pheno_data$I_Chol_2<-as.numeric(pheno_data$I_Chol_2)

pheno_data$I_TG_2<-gsub(",", ".", pheno_data$I_TG_2)
pheno_data$I_TG_2<-as.numeric(pheno_data$I_TG_2)

pheno_data$I_HDL_2<-gsub(",", ".", pheno_data$I_HDL_2)
pheno_data$I_HDL_2<-as.numeric(pheno_data$I_HDL_2)

pheno_data$I_LDL_2<-gsub(",", ".", pheno_data$I_LDL_2)
pheno_data$I_LDL_2<-as.numeric(pheno_data$I_LDL_2)

pheno_data$I_LDL.HDL_2<-gsub(",", ".", pheno_data$I_LDL.HDL_2)
pheno_data$I_LDL.HDL_2<-as.numeric(pheno_data$I_LDL.HDL_2)

colnames(pheno_data)[13]<-"I_Sex"

pheno_data$I_weight_2<-as.numeric(as.character(pheno_data$I_weight_2))

attach(pheno_data)

#correlate, adjusting for other variables

#mothers BMI
pcor.test(BMI,PA_high_E,being_moved,method="spearman")
pcor.test(BMI,PA_high_D,being_moved,method="spearman")
pcor.test(BMI,PA_low_E,being_moved,method="spearman")
pcor.test(BMI,PA_low_D,being_moved,method="spearman")

#mothers BMI
pcor.test(BMI,PA_high_E,cbind(being_moved,I_Sex,I_weight),method="spearman")
pcor.test(BMI,PA_high_D,cbind(being_moved,I_Sex,I_weight),method="spearman")
pcor.test(BMI,PA_low_E,cbind(being_moved,I_Sex,I_weight),method="spearman")
pcor.test(BMI,PA_low_D,cbind(being_moved,I_Sex,I_weight),method="spearman")


#mothers hip measure
pcor.test(Hip_avg,PA_high_E,cbind(being_moved,I_Sex),method="spearman")
pcor.test(Hip_avg,PA_high_D,cbind(being_moved,I_Sex),method="spearman")
pcor.test(Hip_avg,PA_low_E,cbind(being_moved,I_Sex),method="spearman")
pcor.test(Hip_avg,PA_low_D,cbind(being_moved,I_Sex),method="spearman")

#mothers hip measure
pcor.test(Hip_avg,PA_high_E,being_moved,method="spearman")
pcor.test(Hip_avg,PA_high_D,being_moved,method="spearman")
pcor.test(Hip_avg,PA_low_E,being_moved,method="spearman")
pcor.test(Hip_avg,PA_low_D,being_moved,method="spearman")


#infants birth weight
pcor.test(I_weight,PA_high_E,cbind(being_moved,I_Sex),method="spearman")
pcor.test(I_weight,PA_high_D,cbind(being_moved,I_Sex),method="spearman")
pcor.test(I_weight,PA_low_E,cbind(being_moved,I_Sex),method="spearman")
pcor.test(I_weight,PA_low_D,cbind(being_moved,I_Sex),method="spearman")





#infants weight at visit 2, adjusted for age
pcor.test(I_weight_2[!is.na(I_weight_2)],PA_high_E[!is.na(I_weight_2)],cbind(being_moved,I_Age_2,I_Sex)[!is.na(I_weight_2)],method="spearman")
pcor.test(I_weight_2[!is.na(I_weight_2)],PA_high_D[!is.na(I_weight_2)],cbind(being_moved,I_Age_2,I_Sex)[!is.na(I_weight_2)],method="spearman")
pcor.test(I_weight_2[!is.na(I_weight_2)],PA_low_E[!is.na(I_weight_2)],cbind(being_moved,I_Age_2,I_Sex)[!is.na(I_weight_2)],method="spearman")
pcor.test(I_weight_2[!is.na(I_weight_2)],PA_low_D[!is.na(I_weight_2)],cbind(being_moved,I_Age_2,I_Sex)[!is.na(I_weight_2)],method="spearman")



#infants I_FM_ at visit 2, adjusted for age
pcor.test(I_FM_2[!is.na(I_FM_2)],PA_high_E[!is.na(I_FM_2)],cbind(being_moved,I_Age_2)[!is.na(I_FM_2)],method="spearman")
pcor.test(I_FM_2[!is.na(I_FM_2)],PA_high_D[!is.na(I_FM_2)],cbind(being_moved,I_Age_2)[!is.na(I_FM_2)],method="spearman")
pcor.test(I_FM_2[!is.na(I_FM_2)],PA_low_E[!is.na(I_FM_2)],cbind(being_moved,I_Age_2)[!is.na(I_FM_2)],method="spearman")
pcor.test(I_FM_2[!is.na(I_FM_2)],PA_low_D[!is.na(I_FM_2)],cbind(being_moved,I_Age_2)[!is.na(I_FM_2)],method="spearman")



#infants I_FFM at visit 2, adjusted for age
pcor.test(I_FFM_2[!is.na(I_FFM_2)],PA_high_E[!is.na(I_FFM_2)],cbind(being_moved,I_Age_2)[!is.na(I_FFM_2)],method="spearman")
pcor.test(I_FFM_2[!is.na(I_FFM_2)],PA_high_D[!is.na(I_FFM_2)],cbind(being_moved,I_Age_2)[!is.na(I_FFM_2)],method="spearman")
pcor.test(I_FFM_2[!is.na(I_FFM_2)],PA_low_E[!is.na(I_FFM_2)],cbind(being_moved,I_Age_2)[!is.na(I_FFM_2)],method="spearman")
pcor.test(I_FFM_2[!is.na(I_FFM_2)],PA_low_D[!is.na(I_FFM_2)],cbind(being_moved,I_Age_2)[!is.na(I_FFM_2)],method="spearman")



#infants I_FM_proc at visit 2, adjusted for age
pcor.test(I_FM_proc_2[!is.na(I_FM_proc_2)],PA_high_E[!is.na(I_FM_proc_2)],cbind(being_moved,I_Age_2)[!is.na(I_FM_proc_2)],method="spearman")
pcor.test(I_FM_proc_2[!is.na(I_FM_proc_2)],PA_high_D[!is.na(I_FM_proc_2)],cbind(being_moved,I_Age_2)[!is.na(I_FM_proc_2)],method="spearman")
pcor.test(I_FM_proc_2[!is.na(I_FM_proc_2)],PA_low_E[!is.na(I_FM_proc_2)],cbind(being_moved,I_Age_2)[!is.na(I_FM_proc_2)],method="spearman")
pcor.test(I_FM_proc_2[!is.na(I_FM_proc_2)],PA_low_D[!is.na(I_FM_proc_2)],cbind(being_moved,I_Age_2)[!is.na(I_FM_proc_2)],method="spearman")



#infants I_Glu0 at visit 2, adjusted for age
pcor.test(I_Glu0_2[!is.na(I_Glu0_2)],PA_high_E[!is.na(I_Glu0_2)],cbind(being_moved,I_Age_2)[!is.na(I_Glu0_2)],method="spearman")
pcor.test(I_Glu0_2[!is.na(I_Glu0_2)],PA_high_D[!is.na(I_Glu0_2)],cbind(being_moved,I_Age_2)[!is.na(I_Glu0_2)],method="spearman")
pcor.test(I_Glu0_2[!is.na(I_Glu0_2)],PA_low_E[!is.na(I_Glu0_2)],cbind(being_moved,I_Age_2)[!is.na(I_Glu0_2)],method="spearman")
pcor.test(I_Glu0_2[!is.na(I_Glu0_2)],PA_low_D[!is.na(I_Glu0_2)],cbind(being_moved,I_Age_2)[!is.na(I_Glu0_2)],method="spearman")



#infants I_Ins0 at visit 2, adjusted for age
pcor.test(I_Ins0_2[!is.na(I_Ins0_2)],PA_high_E[!is.na(I_Ins0_2)],cbind(being_moved,I_Age_2)[!is.na(I_Ins0_2)],method="spearman")
pcor.test(I_Ins0_2[!is.na(I_Ins0_2)],PA_high_D[!is.na(I_Ins0_2)],cbind(being_moved,I_Age_2)[!is.na(I_Ins0_2)],method="spearman")
pcor.test(I_Ins0_2[!is.na(I_Ins0_2)],PA_low_E[!is.na(I_Ins0_2)],cbind(being_moved,I_Age_2)[!is.na(I_Ins0_2)],method="spearman")
pcor.test(I_Ins0_2[!is.na(I_Ins0_2)],PA_low_D[!is.na(I_Ins0_2)],cbind(being_moved,I_Age_2)[!is.na(I_Ins0_2)],method="spearman")



#infants I_homocyst at visit 2, adjusted for age
pcor.test(I_homocyst_2[!is.na(I_homocyst_2)],PA_high_E[!is.na(I_homocyst_2)],cbind(being_moved,I_Age_2)[!is.na(I_homocyst_2)],method="spearman")
pcor.test(I_homocyst_2[!is.na(I_homocyst_2)],PA_high_D[!is.na(I_homocyst_2)],cbind(being_moved,I_Age_2)[!is.na(I_homocyst_2)],method="spearman")
pcor.test(I_homocyst_2[!is.na(I_homocyst_2)],PA_low_E[!is.na(I_homocyst_2)],cbind(being_moved,I_Age_2)[!is.na(I_homocyst_2)],method="spearman")
pcor.test(I_homocyst_2[!is.na(I_homocyst_2)],PA_low_D[!is.na(I_homocyst_2)],cbind(being_moved,I_Age_2)[!is.na(I_homocyst_2)],method="spearman")



#infants I_ApoB at visit 2, adjusted for age
pcor.test(I_ApoB_2[!is.na(I_ApoB_2)],PA_high_E[!is.na(I_ApoB_2)],cbind(being_moved,I_Age_2)[!is.na(I_ApoB_2)],method="spearman")
pcor.test(I_ApoB_2[!is.na(I_ApoB_2)],PA_high_D[!is.na(I_ApoB_2)],cbind(being_moved,I_Age_2)[!is.na(I_ApoB_2)],method="spearman")
pcor.test(I_ApoB_2[!is.na(I_ApoB_2)],PA_low_E[!is.na(I_ApoB_2)],cbind(being_moved,I_Age_2)[!is.na(I_ApoB_2)],method="spearman")
pcor.test(I_ApoB_2[!is.na(I_ApoB_2)],PA_low_D[!is.na(I_ApoB_2)],cbind(being_moved,I_Age_2)[!is.na(I_ApoB_2)],method="spearman")



#infants I_ApoA1 at visit 2, adjusted for age
pcor.test(I_ApoA1_2[!is.na(I_ApoA1_2)],PA_high_E[!is.na(I_ApoA1_2)],cbind(being_moved,I_Age_2)[!is.na(I_ApoA1_2)],method="spearman")
pcor.test(I_ApoA1_2[!is.na(I_ApoA1_2)],PA_high_D[!is.na(I_ApoA1_2)],cbind(being_moved,I_Age_2)[!is.na(I_ApoA1_2)],method="spearman")
pcor.test(I_ApoA1_2[!is.na(I_ApoA1_2)],PA_low_E[!is.na(I_ApoA1_2)],cbind(being_moved,I_Age_2)[!is.na(I_ApoA1_2)],method="spearman")
pcor.test(I_ApoA1_2[!is.na(I_ApoA1_2)],PA_low_D[!is.na(I_ApoA1_2)],cbind(being_moved,I_Age_2)[!is.na(I_ApoA1_2)],method="spearman")



#infants I_ApoB/ApoA1 at visit 2, adjusted for age
pcor.test(I_ApoB.ApoA1_2[!is.na(I_ApoB.ApoA1_2)],PA_high_E[!is.na(I_ApoB.ApoA1_2)],cbind(being_moved,I_Age_2)[!is.na(I_ApoB.ApoA1_2)],method="spearman")
pcor.test(I_ApoB.ApoA1_2[!is.na(I_ApoB.ApoA1_2)],PA_high_D[!is.na(I_ApoB.ApoA1_2)],cbind(being_moved,I_Age_2)[!is.na(I_ApoB.ApoA1_2)],method="spearman")
pcor.test(I_ApoB.ApoA1_2[!is.na(I_ApoB.ApoA1_2)],PA_low_E[!is.na(I_ApoB.ApoA1_2)],cbind(being_moved,I_Age_2)[!is.na(I_ApoB.ApoA1_2)],method="spearman")
pcor.test(I_ApoB.ApoA1_2[!is.na(I_ApoB.ApoA1_2)],PA_low_D[!is.na(I_ApoB.ApoA1_2)],cbind(being_moved,I_Age_2)[!is.na(I_ApoB.ApoA1_2)],method="spearman")



#infants I_Chol at visit 2, adjusted for age
pcor.test(I_Chol_2[!is.na(I_Chol_2)],PA_high_E[!is.na(I_Chol_2)],cbind(being_moved,I_Age_2)[!is.na(I_Chol_2)],method="spearman")
pcor.test(I_Chol_2[!is.na(I_Chol_2)],PA_high_D[!is.na(I_Chol_2)],cbind(being_moved,I_Age_2)[!is.na(I_Chol_2)],method="spearman")
pcor.test(I_Chol_2[!is.na(I_Chol_2)],PA_low_E[!is.na(I_Chol_2)],cbind(being_moved,I_Age_2)[!is.na(I_Chol_2)],method="spearman")
pcor.test(I_Chol_2[!is.na(I_Chol_2)],PA_low_D[!is.na(I_Chol_2)],cbind(being_moved,I_Age_2)[!is.na(I_Chol_2)],method="spearman")



#infants I_TG at visit 2, adjusted for age
pcor.test(I_TG_2[!is.na(I_TG_2)],PA_high_E[!is.na(I_TG_2)],cbind(being_moved,I_Age_2)[!is.na(I_TG_2)],method="spearman")
pcor.test(I_TG_2[!is.na(I_TG_2)],PA_high_D[!is.na(I_TG_2)],cbind(being_moved,I_Age_2)[!is.na(I_TG_2)],method="spearman")
pcor.test(I_TG_2[!is.na(I_TG_2)],PA_low_E[!is.na(I_TG_2)],cbind(being_moved,I_Age_2)[!is.na(I_TG_2)],method="spearman")
pcor.test(I_TG_2[!is.na(I_TG_2)],PA_low_D[!is.na(I_TG_2)],cbind(being_moved,I_Age_2)[!is.na(I_TG_2)],method="spearman")



#infants I_HDL at visit 2, adjusted for age
pcor.test(I_TG_2[!is.na(I_TG_2)],PA_high_E[!is.na(I_TG_2)],cbind(being_moved,I_Age_2)[!is.na(I_TG_2)],method="spearman")
pcor.test(I_TG_2[!is.na(I_TG_2)],PA_high_D[!is.na(I_TG_2)],cbind(being_moved,I_Age_2)[!is.na(I_TG_2)],method="spearman")
pcor.test(I_TG_2[!is.na(I_TG_2)],PA_low_E[!is.na(I_TG_2)],cbind(being_moved,I_Age_2)[!is.na(I_TG_2)],method="spearman")
pcor.test(I_TG_2[!is.na(I_TG_2)],PA_low_D[!is.na(I_TG_2)],cbind(being_moved,I_Age_2)[!is.na(I_TG_2)],method="spearman")



#infants I_LDL at visit 2, adjusted for age
pcor.test(I_LDL_2[!is.na(I_LDL_2)],PA_high_E[!is.na(I_LDL_2)],cbind(being_moved,I_Age_2)[!is.na(I_LDL_2)],method="spearman")
pcor.test(I_LDL_2[!is.na(I_LDL_2)],PA_high_D[!is.na(I_LDL_2)],cbind(being_moved,I_Age_2)[!is.na(I_LDL_2)],method="spearman")
pcor.test(I_LDL_2[!is.na(I_LDL_2)],PA_low_E[!is.na(I_LDL_2)],cbind(being_moved,I_Age_2)[!is.na(I_LDL_2)],method="spearman")
pcor.test(I_LDL_2[!is.na(I_LDL_2)],PA_low_D[!is.na(I_LDL_2)],cbind(being_moved,I_Age_2)[!is.na(I_LDL_2)],method="spearman")



#infants I_LDL/HDL at visit 2, adjusted for age
pcor.test(I_LDL.HDL_2[!is.na(I_LDL.HDL_2)],PA_high_E[!is.na(I_LDL.HDL_2)],cbind(being_moved,I_Age_2)[!is.na(I_LDL.HDL_2)],method="spearman")
pcor.test(I_LDL.HDL_2[!is.na(I_LDL.HDL_2)],PA_high_D[!is.na(I_LDL.HDL_2)],cbind(being_moved,I_Age_2)[!is.na(I_LDL.HDL_2)],method="spearman")
pcor.test(I_LDL.HDL_2[!is.na(I_LDL.HDL_2)],PA_low_E[!is.na(I_LDL.HDL_2)],cbind(being_moved,I_Age_2)[!is.na(I_LDL.HDL_2)],method="spearman")
pcor.test(I_LDL.HDL_2[!is.na(I_LDL.HDL_2)],PA_low_D[!is.na(I_LDL.HDL_2)],cbind(being_moved,I_Age_2)[!is.na(I_LDL.HDL_2)],method="spearman")





