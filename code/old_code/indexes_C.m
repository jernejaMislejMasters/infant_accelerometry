%each subject
for subj=1:30
    
    disp(strcat(num2str(subj),'. subjects'))
    
    %load data
    indexes_PA_C=csvread(strcat('../proccessed_data/PA/',num2str(subj),'_infant_PA_corrected_intensities_indexes.csv'));
    
    indexes_PA_C=indexes_PA_C+1;
    
    indexes_PA_C=find(indexes_PA_C==1)-1;
    
    dlmwrite(strcat('../proccessed_data/PA/',num2str(subj),'_infant_PA_C.csv'),indexes_PA_C ,'precision',7);
    
end