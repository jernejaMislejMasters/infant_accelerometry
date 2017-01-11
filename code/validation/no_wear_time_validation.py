import sys
import pandas
import datetime
from dateutil import parser

time_differences=[]
detected_negative=0
diary_negative=0
for subj in range(1,31):
	infant_torso_timestamps_csv=pandas.read_csv(str(subj)+'_infant_torso_no_wear_timestamps.csv', low_memory=False)
	infant_ankle_timestamps_csv=pandas.read_csv(str(subj)+'_infant_ankle_no_wear_timestamps.csv', low_memory=False)
	mother_timestamps_csv=pandas.read_csv(str(subj)+'_mother_no_wear_timestamps.csv', low_memory=False)


	infant_torso_timestamps=[list(infant_torso_timestamps_csv[[0]].values.flatten()), list(infant_torso_timestamps_csv[[1]].values.flatten())]
	infant_ankle_timestamps=[list(infant_ankle_timestamps_csv[[0]].values.flatten()), list(infant_ankle_timestamps_csv[[1]].values.flatten())]
	mother_timestamps=[list(mother_timestamps_csv[[0]].values.flatten()), list(mother_timestamps_csv[[1]].values.flatten())]

	diary=pandas.read_csv('../../data/diaries/'+str(subj)+'_diary.csv', low_memory=False)
	diary.fillna('', inplace=True)

	infant_torso_diary=[[x for x in list(diary[[4]].values.flatten()) if x], [x for x in list(diary[[5]].values.flatten()) if x]]
	infant_ankle_diary=[[x for x in list(diary[[6]].values.flatten()) if x], [x for x in list(diary[[7]].values.flatten()) if x]]
	mother_diary=[[x for x in list(diary[[8]].values.flatten()) if x], [x for x in list(diary[[9]].values.flatten()) if x]]

	if infant_torso_timestamps[0]:

		for entry in range(0,len(infant_torso_timestamps[0])):
			timestamp_start=infant_torso_timestamps[0][entry]
		
			time_diffs=[]
			#find the nearest in the diary
			for diary_entry in range(0,len(infant_torso_diary[0])):
				difference=parser.parse(timestamp_start)-parser.parse(infant_torso_diary[0][diary_entry])
				time_diffs.append(difference.total_seconds())
		
			abs_time_diffs=[abs(x) for x in time_diffs]
			#print out for now for check up
			if time_diffs:
				print "infant torso "+str(entry)+". no wear detected matches with the diary notation of no wear at start for "+str(min(abs_time_diffs))#continue
				time_differences.append(time_diffs[abs_time_diffs.index(min(abs_time_diffs))])
			else:
				print "infant torso "+str(entry)+". no wear detected has no matches with the diary notation of no wear"
				detected_negative+=1
	else:
		diary_negative+=len(infant_torso_diary[0])
