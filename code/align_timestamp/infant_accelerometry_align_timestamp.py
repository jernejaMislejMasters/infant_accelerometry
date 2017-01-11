import pandas
import os
from dateutil import parser

for seq in range(1,29):
	infant_torso=pandas.read_csv(str(seq)+'_infant_torso.csv', low_memory=False, nrows=15+48*60*60*40)
	infant_ankle=pandas.read_csv(str(seq)+'_infant_ankle.csv', low_memory=False, nrows=15+48*60*60*40)
	mother=pandas.read_csv(str(seq)+'_mother.csv', low_memory=False, nrows=15+48*60*60*40)
	
	first_timestamp_infant_torso=parser.parse(infant_torso['t'][15])
	first_timestamp_infant_ankle=parser.parse(infant_ankle['t'][15])
	first_timestamp_mother=parser.parse(mother['t'][15])

	latest_start=max(first_timestamp_infant_torso, first_timestamp_infant_ankle, first_timestamp_mother)

	latest_start_string=latest_start.strftime('%Y-%m-%d %H:%M:%S.%f')[:-2]

	df_it = pandas.DataFrame(infant_torso[infant_torso['t'][infant_torso['t']==latest_start_string].index[0]:])
	print df_it.to_csv(str(seq)+'_infant_torso_timed.csv', index=False, header=False)

	df_ia = pandas.DataFrame(infant_ankle[infant_ankle['t'][infant_ankle['t']==latest_start_string].index[0]:])
	print df_ia.to_csv(str(seq)+'_infant_ankle_timed.csv', index=False, header=False)

	df_m = pandas.DataFrame(mother[mother['t'][mother['t']==latest_start_string].index[0]:])
	print df_m.to_csv(str(seq)+'_mother_timed.csv', index=False, header=False)


