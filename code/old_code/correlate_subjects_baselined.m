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
        
        infant_torso_x=infant_torso(window:window_end,1);
        infant_torso_y=infant_torso(window:window_end,2);
        infant_torso_z=infant_torso(window:window_end,3);
        
        %check several baselines(from tight-fit to loose), tight-fit has
        %advantage and breaks at average axis 0.7 correlation
            
        baseline_params=[5,10,100,1000,10000,100000,1000000,10000000,100000000,1000000000];
        
        %prepare matrices for up to 10 baseline parameters and 6 axis
        %combinations

        x_correlation=[];
        y_correlation=[];
        z_correlation=[];

        x_p=[];
        y_p=[];
        z_p=[];

        sum_of_all_correlations=[];

        mean_differences=[];
            
        for baseline_param=1:10
            
            %extract baseline
            [~,infant_torso_x_baseline]=baseline_correction(infant_torso_x,baseline_params(baseline_param),0.5);
            [~,infant_torso_y_baseline]=baseline_correction(infant_torso_y,baseline_params(baseline_param),0.5);
            [~,infant_torso_z_baseline]=baseline_correction(infant_torso_z,baseline_params(baseline_param),0.5);   

            %mean for extra check
            mean_infant_torso_x=mean(infant_torso_x_baseline);
            mean_infant_torso_y=mean(infant_torso_y_baseline);
            mean_infant_torso_z=mean(infant_torso_z_baseline);
            
            for axis_perm=1:6
           
                axis_order=axis_perms(axis_perm,:);
                
                %extract baseline for ankle for this baseline param and
                %this axis combination
                [~,infant_ankle_1_baseline]=baseline_correction(infant_ankle(window:window_end,axis_order(1)),baseline_params(baseline_param),0.5);
                [~,infant_ankle_2_baseline]=baseline_correction(infant_ankle(window:window_end,axis_order(2)),baseline_params(baseline_param),0.5);
                [~,infant_ankle_3_baseline]=baseline_correction(infant_ankle(window:window_end,axis_order(3)),baseline_params(baseline_param),0.5);
                
                %mean for extra check
                mean_infant_ankle_axis_1=mean(infant_ankle_1_baseline);
                mean_infant_ankle_axis_2=mean(infant_ankle_2_baseline);
                mean_infant_ankle_axis_3=mean(infant_ankle_3_baseline);

                %correlate
                [R_x, P_x]=corrcoef(infant_torso_x_baseline,infant_ankle_1_baseline);
                [R_y, P_y]=corrcoef(infant_torso_y_baseline,infant_ankle_2_baseline);
                [R_z, P_z]=corrcoef(infant_torso_z_baseline,infant_ankle_3_baseline);

                %if all not bigger than 0.5, set as zero and save in matrix
                x_correlation(baseline_param, axis_perm)=abs(R_x(2,1))*(abs(R_x(2,1))>=0.5&&abs(R_y(2,1))>=0.5&&abs(R_z(2,1))>=0.5);
                y_correlation(baseline_param, axis_perm)=abs(R_y(2,1))*(abs(R_x(2,1))>=0.5&&abs(R_y(2,1))>=0.5&&abs(R_z(2,1))>=0.5);
                z_correlation(baseline_param, axis_perm)=abs(R_z(2,1))*(abs(R_x(2,1))>=0.5&&abs(R_y(2,1))>=0.5&&abs(R_z(2,1))>=0.5);

                x_p(baseline_param, axis_perm)=P_x(2,1);
                y_p(baseline_param, axis_perm)=P_y(2,1);
                z_p(baseline_param, axis_perm)=P_z(2,1);

                sum_of_all_correlations(baseline_param, axis_perm)=sum([x_correlation(baseline_param, axis_perm), y_correlation(baseline_param, axis_perm), z_correlation(baseline_param, axis_perm)]);

                mean_differences(baseline_param, axis_perm)=sum(abs([mean_infant_torso_x, mean_infant_torso_y, mean_infant_torso_z]-[mean_infant_ankle_axis_1, mean_infant_ankle_axis_2, mean_infant_ankle_axis_3]));

            end
            
            %check if any significant correlation for such baseline and
            %break if
            if(max(sum_of_all_correlations)>2.1)
                break;
            end
                
                
        end
                
        %get index of the biggest if any of all combinations and baseline parameters had all three
        %axis significantly correlated
        if(max(sum_of_all_correlations)>0)
            
            max_correlation_indexes=intersect(find(sum_of_all_correlations==max(max(sum_of_all_correlations))),find(mean_differences==min(min(mean_differences(find(sum_of_all_correlations==max(max(sum_of_all_correlations))))))));
            max_correlation_index=max_correlation_indexes(1);

            max_correlation_combination=axis_perms(ceil(max_correlation_index/length(sum_of_all_correlations(:,1))),:);
            baseline_param_index=rem(max_correlation_index,length(sum_of_all_correlations(:,1)))+length(sum_of_all_correlations(:,1))*(rem(max_correlation_index,length(sum_of_all_correlations(:,1)))==0);
            max_correlation_baseline_parameter=baseline_params(baseline_param_index);

            %the baselines of the maximum correlation
            [~, infant_torso_x_best]=baseline_correction(infant_torso_x,max_correlation_baseline_parameter,0.5);
            [~, infant_torso_y_best]=baseline_correction(infant_torso_y, max_correlation_baseline_parameter,0.5);
            [~, infant_torso_z_best]=baseline_correction(infant_torso_z, max_correlation_baseline_parameter,0.5);
            
            [~,  infant_ankle_1_best]=baseline_correction(infant_ankle(window:window_end,max_correlation_combination(1)), max_correlation_baseline_parameter,0.5);
            [~,  infant_ankle_2_best]=baseline_correction(infant_ankle(window:window_end,max_correlation_combination(2)), max_correlation_baseline_parameter,0.5);
            [~,  infant_ankle_3_best]=baseline_correction(infant_ankle(window:window_end,max_correlation_combination(3)), max_correlation_baseline_parameter,0.5);

%             
%             %check for 100 random windows with the same axis combination
%             %and baseline parameter
%             random_correlations=[];
%             random_p_values=[];
%             
%             random_indexes=round(rand(100,1)*(length(infant_ankle(:,1))-window_length));
%             for random_index=1:100
%                [~, random_window_1]=baseline_correction(infant_ankle(random_indexes(random_index):random_indexes(random_index)+window_length-1,max_correlation_combination(1)), max_correlation_baseline_parameter, 0.5);
%                [~, random_window_2]=baseline_correction(infant_ankle(random_indexes(random_index):random_indexes(random_index)+window_length-1,max_correlation_combination(2)), max_correlation_baseline_parameter, 0.5);
%                [~, random_window_3]=baseline_correction(infant_ankle(random_indexes(random_index):random_indexes(random_index)+window_length-1,max_correlation_combination(3)), max_correlation_baseline_parameter, 0.5);
%             
%                [R_x, P_x]=corrcoef(infant_torso_x_best, random_window_1(1:length(infant_torso_x_best)));
%                [R_y, P_y]=corrcoef(infant_torso_y_best, random_window_2(1:length(infant_torso_y_best)));
%                [R_z, P_z]=corrcoef(infant_torso_z_best, random_window_3(1:length(infant_torso_z_best)));
%                
%                random_correlations(1,random_index)=abs(R_x(2,1));
%                random_correlations(2,random_index)=abs(R_y(2,1));
%                random_correlations(3,random_index)=abs(R_z(2,1));
%                
%                random_p_values(1,random_index)=P_x(2,1);
%                random_p_values(2,random_index)=P_y(2,1);
%                random_p_values(3,random_index)=P_z(2,1);              
%             end
%             
%             disp('number of random correlations bigger then 0.5')
%             disp({length(find(random_correlations>0.5)),'correlations out of 100 with average p value ', mean(random_p_values(random_correlations>0.5))})
%             
%             mean_percent_random_correlations(subj)=mean_percent_random_correlations(subj)+length(find(random_correlations>0.5));
%             random_correlations_p_value(subj)=random_correlations_p_value(subj)+mean(random_p_values(random_correlations>0.5));
%             
            %print the combination and the correlation coefficients
            disp(strcat([num2str(subj), '. subjects in the ', num2str(window_index),'. window have the biggest absolute significant correlation for axis combination :']))
            disp('x y z')
            disp([axis_names(max_correlation_combination(1)),' ',axis_names(max_correlation_combination(2)),' ',axis_names(max_correlation_combination(3))]) 
            disp(['and baseline parameter ', num2str(max_correlation_baseline_parameter)])
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
            hold on
            plot(window:window_end, infant_torso_x_best,'r')
            title({strcat([num2str(subj), '. subjects in the ', num2str(window_index),'. window ', ' with correlation ',num2str(round(x_correlation(max_correlation_index),2)),' and p value ',num2str(x_p(max_correlation_index))]),' ',' ','infant torso x axis'})
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:2400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([(window-1)/2400:round((window_end+1)/2400)]')))
            legend('infant torso','correlated signal')
            subplot(2,1,2)
            plot(window:window_end, infant_ankle(window:window_end,max_correlation_combination(1)))
            hold on
            plot(window:window_end, infant_ankle_1_best,'r')
            title(strcat(['infant ankle ' ,axis_names(max_correlation_combination(1)),' axis']));
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:2400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([(window-1)/2400:round((window_end+1)/2400)]')))
            legend('infant ankle','correlated signal')
            saveas(gcf,strcat(num2str(subj), '_subject_',num2str(window_index),'_window_x', axis_names(max_correlation_combination(1)),'_baselined.png'))
            
            clf
            subplot(2,1,1)
            plot(window:window_end, infant_torso_y)
            hold on
            plot(window:window_end, infant_torso_y_best,'r')
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:2400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([(window-1)/2400:round((window_end+1)/2400)]')))
            legend('infant torso','correlated signal')
            title({strcat([num2str(subj), '. subjects in the ', num2str(window_index),'. window ', ' with correlation ',num2str(round(y_correlation(max_correlation_index),2)),' and p value ',num2str(y_p(max_correlation_index))]),' ',' ','infant torso y axis'})
            subplot(2,1,2)
            plot(window:window_end, infant_ankle(window:window_end,max_correlation_combination(2)))
            hold on
            plot(window:window_end, infant_ankle_2_best,'r')
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:2400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([(window-1)/2400:round((window_end+1)/2400)]')))
            legend('infant ankle','correlated signal')
            title(strcat(['infant ankle ',axis_names(max_correlation_combination(2)),' axis']));
            saveas(gcf,strcat(num2str(subj), '_subject_',num2str(window_index),'_window_y', axis_names(max_correlation_combination(2)),'_baselined.png'))
            
            clf
            subplot(2,1,1)
            plot(window:window_end, infant_torso_z)
            hold on
            plot(window:window_end, infant_torso_z_best,'r')
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:2400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([(window-1)/2400:round((window_end+1)/2400)]')))
            legend('infant torso','correlated signal')
            title({strcat([num2str(subj), '. subjects in the ', num2str(window_index),'. window with correlation ',num2str(round(z_correlation(max_correlation_index),2)),' and p value ',num2str(z_p(max_correlation_index))]),' ',' ','infant torso z axis'})
            subplot(2,1,2)
            plot(window:window_end, infant_ankle(window:window_end,max_correlation_combination(3)))
            hold on
            plot(window:window_end, infant_ankle_3_best,'r')
            xlabel('minutes')
            ylabel('g')
            set(gca,'XTick',[window:2400:window_end+1]-1);
            set(gca,'XTickLabel',cellstr(num2str([(window-1)/2400:round((window_end+1)/2400)]')))
            legend('infant ankle','correlated signal')
            title(strcat(['infant ankle ',axis_names(max_correlation_combination(3)),' axis']));
            saveas(gcf,strcat(num2str(subj), '_subject_',num2str(window_index),'_window_z', axis_names(max_correlation_combination(3)),'_baselined.png'))
                
            subjects_correlations(subj)=subjects_correlations(subj)+1;
        end
        
        window_index=window_index+1;
        
    end
    mean_percent_random_correlations(subj)=mean_percent_random_correlations(subj)/subjects_correlations(subj);
    random_correlations_p_value(subj)=random_correlations_p_value(subj)/subjects_correlations(subj);
end

disp('correlations overall')

%disp(strcat(num2str(1:28),'. subjects had alltogether::',num2str(subjects_correlations),' significant correlations with mean percent of random significant correlations::', num2str(mean_percent_random_correlations),'% having an overall mean p value::', num2str(random_correlations_p_value)))
disp(strcat([num2str(1:28),'. subjects had alltogether ',num2str(subjects_correlations),' significant correlations']))

