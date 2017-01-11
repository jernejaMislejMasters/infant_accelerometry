close all
axis_perms=perms(1:3);
axis_names=['x','y','z'];
figure('Position',[0,0,1500,900]);

subjects_correlations=zeros(28,1);
mean_percent_random_correlations=zeros(28,1);
random_correlations_p_value=zeros(28,1);

for subj=1:28
    
    disp(strcat(num2str(subj),'. subjects'))
    
    infant_torso=csvread(strcat('../proccessed_data/timed/',strcat(num2str(subj),'_infant_torso_timed_wear.csv')));
    infant_ankle=csvread(strcat('../proccessed_data/timed/',strcat(num2str(subj),'_infant_ankle_timed_wear.csv')));
    
    %examine correlation between each axis combination and the
    %summary of all
    
    disp('windowed correlation')
    
    %windowed over 5minutes
    window_length=12000;
    
    
    
    %examine all combinations of axis alignment of the two sensors
    
    window_index=1;
    for window=1:window_length:min(length(infant_torso(:,1)),length(infant_ankle(:,1)))
        
        window_end=min([window+window_length-1, length(infant_torso(:,1)), length(infant_ankle(:,1))]);
        
        infant_torso_x=hampel(infant_torso(window:window_end,1),11);
        infant_torso_y=hampel(infant_torso(window:window_end,2),11);
        infant_torso_z=hampel(infant_torso(window:window_end,3),11);
        
        mean_infant_torso_x=mean(infant_torso_x);
        mean_infant_torso_y=mean(infant_torso_y);
        mean_infant_torso_z=mean(infant_torso_z);
                
        x_correlation=[];
        y_correlation=[];
        z_correlation=[];
        
        x_p=[];
        y_p=[];
        z_p=[];
        
        sum_of_all_correlations=[];
        
        mean_differences=[];
        
        for axis_perm=1:6
           
            axis_order=axis_perms(axis_perm,:);
            
            mean_infant_ankle_axis_1=mean(infant_ankle(window:window_end,axis_order(1)));
            mean_infant_ankle_axis_2=mean(infant_ankle(window:window_end,axis_order(2)));
            mean_infant_ankle_axis_3=mean(infant_ankle(window:window_end,axis_order(3)));
            
            [R_x, P_x]=corrcoef(infant_torso_x,hampel(infant_ankle(window:window_end,axis_order(1)),11));
            [R_y, P_y]=corrcoef(infant_torso_y,hampel(infant_ankle(window:window_end,axis_order(2)),11));
            [R_z, P_z]=corrcoef(infant_torso_z,hampel(infant_ankle(window:window_end,axis_order(3)),11));
            
            %if all not bigger than 0.5, set as zero
            x_correlation(axis_perm)=R_x(2,1)*(R_x(2,1)>=0.5&&R_y(2,1)>=0.5&&R_z(2,1)>=0.5);
            y_correlation(axis_perm)=R_y(2,1)*(R_x(2,1)>=0.5&&R_y(2,1)>=0.5&&R_z(2,1)>=0.5);
            z_correlation(axis_perm)=R_z(2,1)*(R_x(2,1)>=0.5&&R_y(2,1)>=0.5&&R_z(2,1)>=0.5);
            
            x_p(axis_perm)=P_x(2,1);
            y_p(axis_perm)=P_y(2,1);
            z_p(axis_perm)=P_z(2,1);
            
            sum_of_all_correlations(axis_perm)=sum([x_correlation(axis_perm), y_correlation(axis_perm), z_correlation(axis_perm)]);
            
            mean_differences(axis_perm)=sum(abs([mean_infant_torso_x, mean_infant_torso_y, mean_infant_torso_z]-[mean_infant_ankle_axis_1, mean_infant_ankle_axis_2, mean_infant_ankle_axis_3]));
            
        end
        
        %get index of the biggest if any of all combinations had all three
        %axis significantly correlated
        if(max(sum_of_all_correlations)>0)
            
            max_correlation_indexes=intersect(find(sum_of_all_correlations==max(sum_of_all_correlations)),find(mean_differences==min(mean_differences(find(sum_of_all_correlations==max(sum_of_all_correlations))))));
            max_correlation_index=max_correlation_indexes(1);
            
            max_correlation_combination=axis_perms(max_correlation_index,:);
            
            %check for 10 random windows with the same axis combination
            random_correlations=[];
            random_p_values=[];
            
            random_indexes=round(rand(100,1)*(length(infant_ankle(:,1))-window_length));
            for random_index=1:100
               random_window_1=infant_ankle(random_indexes(random_index):random_indexes(random_index)+window_length-1,max_correlation_combination(1));
               random_window_2=infant_ankle(random_indexes(random_index):random_indexes(random_index)+window_length-1,max_correlation_combination(2));
               random_window_3=infant_ankle(random_indexes(random_index):random_indexes(random_index)+window_length-1,max_correlation_combination(3));
            
               [R_x, P_x]=corrcoef(infant_torso_x,random_window_1);
               [R_y, P_y]=corrcoef(infant_torso_y,random_window_2);
               [R_z, P_z]=corrcoef(infant_torso_z,random_window_3);
               
               random_correlations(1,random_index)=R_x(2,1);
               random_correlations(2,random_index)=R_y(2,1);
               random_correlations(3,random_index)=R_z(2,1);
               
               random_p_values(1,random_index)=P_x(2,1);
               random_p_values(2,random_index)=P_y(2,1);
               random_p_values(3,random_index)=P_z(2,1);              
            end
            
            disp('number of random correlations bigger then 0.5')
            disp({length(find(random_correlations>0.5)),'correlations out of 100 with average p value ', mean(random_p_values(random_correlations>0.5))})
            
            mean_percent_random_correlations(subj)=mean_percent_random_correlations(subj)+length(find(random_correlations>0.5));
            random_correlations_p_value(subj)=random_correlations_p_value(subj)+mean(random_p_values(random_correlations>0.5));
            
            %print the combination and the correlation coefficients
            disp(strcat([num2str(subj), '. subjects in the ', num2str(window_index),'. window have the biggest significant correlation for axis combination :']))
            disp('x y z')
            disp([axis_names(max_correlation_combination(1)),' ',axis_names(max_correlation_combination(2)),' ',axis_names(max_correlation_combination(3))])
            disp('first pair correlation and p value')
            x_correlation(max_correlation_index)
            x_p(max_correlation_index)
            disp('second pair correlation and p value')
            y_correlation(max_correlation_index)   
            y_p(max_correlation_index)
            disp('third pair correlation and p value')
            z_correlation(max_correlation_index)
            z_p(max_correlation_index)
            
            %display and save as subplots
            clf
            subplot(2,1,1)
            plot(window:window_end, infant_torso_x)
            title({strcat([num2str(subj), '. subjects in the ', num2str(window_index),'. window ', ' with correlation ',num2str(round(x_correlation(max_correlation_index),2)),' and p value ',num2str(x_p(max_correlation_index))]),' ',' ','infant torso x axis'})
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:2400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([(window-1)/2400:round((window_end+1)/2400)]')))
            subplot(2,1,2)
            plot(window:window_end, infant_ankle(window:window_end,max_correlation_combination(1)))
            title(strcat(['infant ankle ' ,axis_names(max_correlation_combination(1)),' axis']));
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:2400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([(window-1)/2400:round((window_end+1)/2400)]')))
            saveas(gcf,strcat(num2str(subj), '_subject_',num2str(window_index),'_window_x', axis_names(max_correlation_combination(1)),'.png'))
            
            clf
            subplot(2,1,1)
            plot(window:window_end, infant_torso_y)
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:2400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([(window-1)/2400:round((window_end+1)/2400)]')))
            title({strcat([num2str(subj), '. subjects in the ', num2str(window_index),'. window ', ' with correlation ',num2str(round(y_correlation(max_correlation_index),2)),' and p value ',num2str(y_p(max_correlation_index))]),' ',' ','infant torso y axis'})
            subplot(2,1,2)
            plot(window:window_end, infant_ankle(window:window_end,max_correlation_combination(2)))
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:2400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([(window-1)/2400:round((window_end+1)/2400)]')))
            title(strcat(['infant ankle ',axis_names(max_correlation_combination(2)),' axis']));
            saveas(gcf,strcat(num2str(subj), '_subject_',num2str(window_index),'_window_y', axis_names(max_correlation_combination(2)),'.png'))
            
            clf
            subplot(2,1,1)
            plot(window:window_end, infant_torso_z)
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:2400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([(window-1)/2400:round((window_end+1)/2400)]')))
            title({strcat([num2str(subj), '. subjects in the ', num2str(window_index),'. window ', ' with correlation ',num2str(round(z_correlation(max_correlation_index),2)),' and p value ',num2str(z_p(max_correlation_index))]),' ',' ','infant torso z axis'})
            subplot(2,1,2)
            plot(window:window_end, infant_ankle(window:window_end,max_correlation_combination(3)))
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:2400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([(window-1)/2400:round((window_end+1)/2400)]')))
            title(strcat(['infant ankle ',axis_names(max_correlation_combination(3)),' axis']));
            saveas(gcf,strcat(num2str(subj), '_subject_',num2str(window_index),'_window_z', axis_names(max_correlation_combination(3)),'.png'))
                
            subjects_correlations(subj)=subjects_correlations(subj)+1;
        end
        
        window_index=window_index+1;
        
    end
    mean_percent_random_correlations(subj)=mean_percent_random_correlations(subj)/subjects_correlations(subj);
    random_correlations_p_value(subj)=random_correlations_p_value(subj)/subjects_correlations(subj);
end

disp('correlations overall')

disp(strcat(num2str([1:28]'),'. subjects had alltogether::',num2str(subjects_correlations),' significant correlations with mean percent of random significant correlations::', num2str(round(mean_percent_random_correlations,1)),'% having an overall mean p value::', num2str(random_correlations_p_value)))

