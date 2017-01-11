import sys
import pandas
import numpy as np
from scipy.signal import medfilt
import matplotlib.pyplot as ploty
import matplotlib.lines as mlines

#read minutes for the window of no wear detection or set the default
if len(sys.argv)>1:
	no_wear_minutes=int(sys.argv[1])
else:
	no_wear_minutes=30

#read limit of std for no wear detection or set the default
if len(sys.argv)>2:
        no_wear_std=float(sys.argv[2])
else:
        no_wear_std=0.0026

#read limit of span for no wear detection or set the default
if len(sys.argv)>3:
        no_wear_span=float(sys.argv[3])
else:
        no_wear_span=0.015

#read how much data to proccess
if len(sys.argv)>4:
        hours=int(sys.argv[4])
else:
        hours=48

#prepare window and how much data points to proccess according to hours
data_points=hours*60*60*40 # hours*minutes*seconds*samples per second #minimum 1h=144000 points
window_points=no_wear_minutes*60*40
#stats_nr=data_points/window_points

for seq in range(1,29):
	infant_torso=pandas.read_csv(str(seq)+'_infant_torso_timed.csv', low_memory=False, header=None, nrows=data_points)
	infant_ankle=pandas.read_csv(str(seq)+'_infant_ankle_timed.csv', low_memory=False, header=None, nrows=data_points)
	mother=pandas.read_csv(str(seq)+'_mother_timed.csv', low_memory=False, header=None, nrows=data_points)

	x_axis_infant_torso=medfilt(list(infant_torso[[1]].values.flatten()),5)
	y_axis_infant_torso=medfilt(list(infant_torso[[2]].values.flatten()),5)
	z_axis_infant_torso=medfilt(list(infant_torso[[3]].values.flatten()),5)

	x_axis_infant_ankle=medfilt(list(infant_ankle[[1]].values.flatten()),5)
	y_axis_infant_ankle=medfilt(list(infant_ankle[[2]].values.flatten()),5)
	z_axis_infant_ankle=medfilt(list(infant_ankle[[3]].values.flatten()),5)

	x_axis_mother=medfilt(list(mother[[1]].values.flatten()),5)
	y_axis_mother=medfilt(list(mother[[2]].values.flatten()),5)
	z_axis_mother=medfilt(list(mother[[3]].values.flatten()),5)

	#prepare arrays of no wear
	no_wear_infant_torso=[]
	no_wear_infant_ankle=[]
	no_wear_mother=[]	

	#visualize
	fig, ((ax1, ax2, ax3), (ax4, ax5, ax6), (ax7, ax8, ax9)) = ploty.subplots( nrows=3, ncols=3, sharex='col', sharey='row', figsize=(50,25))
	ploty.ylabel('g')
	ploty.xlabel('samples')
	red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear infant ankle')
	yellow_mark = mlines.Line2D([], [], color='yellow', linewidth=1, linestyle='-', label='no wear infant torso')
	black_mark = mlines.Line2D([], [], color='black', linewidth=1, linestyle='-', label='no wear mother')
	ploty.legend(handles=([red_mark, yellow_mark, black_mark]))
	#infant torso
	ax1.set_title(str(seq)+' x axis infant torso')
	ax1.plot(range(0,len(x_axis_infant_torso)),x_axis_infant_torso,'b-')
	ax1.set_xticks(range(0,len(x_axis_infant_torso),288000))
	ax1.set_xticklabels([str(x)+" h" for x in range(0,50,2)])
	
	ax2.set_title(str(seq)+' y axis infant torso')
	ax2.plot(range(0,len(y_axis_infant_torso)),y_axis_infant_torso,'b-')
	ax2.set_xticks(range(0,len(y_axis_infant_torso),288000))
	ax2.set_xticklabels([str(x)+" h" for x in range(0,50,2)])

	ax3.set_title(str(seq)+' z axis infant torso')
	ax3.plot(range(0,len(z_axis_infant_torso)),z_axis_infant_torso,'b-')
	ax3.set_xticks(range(0,len(z_axis_infant_torso),288000))
	ax3.set_xticklabels([str(x)+" h" for x in range(0,50,2)])

	#infant ankle
	ax4.set_title(str(seq)+' x axis infant ankle')
	ax4.plot(range(0,len(x_axis_infant_ankle)),x_axis_infant_ankle,'b-')
	ax4.set_xticks(range(0,len(x_axis_infant_ankle),288000))
	ax4.set_xticklabels([str(x)+" h" for x in range(0,50,2)])

	ax5.set_title(str(seq)+' y axis infant ankle')
	ax5.plot(range(0,len(y_axis_infant_ankle)),y_axis_infant_ankle,'b-')
	ax5.set_xticks(range(0,len(y_axis_infant_ankle),288000))
	ax5.set_xticklabels([str(x)+" h" for x in range(0,50,2)])

	ax6.set_title(str(seq)+' z axis infant ankle')
	ax6.plot(range(0,len(z_axis_infant_ankle)),z_axis_infant_ankle,'b-')
	ax6.set_xticks(range(0,len(z_axis_infant_ankle),288000))
	ax6.set_xticklabels([str(x)+" h" for x in range(0,50,2)])

	#mother
	ax7.set_title(str(seq)+' x axis mother')
	ax7.plot(range(0,len(x_axis_mother)),x_axis_mother,'b-')
	ax7.set_xticks(range(0,len(x_axis_mother),288000))
	ax7.set_xticklabels([str(x)+" h" for x in range(0,50,2)])

	ax8.set_title(str(seq)+' y axis mother')
	ax8.plot(range(0,len(y_axis_mother)),y_axis_mother,'b-')
	ax8.set_xticks(range(0,len(y_axis_mother),288000))
	ax8.set_xticklabels([str(x)+" h" for x in range(0,50,2)])

	ax9.set_title(str(seq)+' z axis mother')
	ax9.plot(range(0,len(z_axis_mother)),z_axis_mother,'b-')
	ax9.set_xticks(range(0,len(z_axis_mother),288000))
	ax9.set_xticklabels([str(x)+" h" for x in range(0,50,2)])
	'''
	#plot entire signal y_infant_torso

	ploty.figure(num=2, figsize=(20,20))
	ploty.plot(range(0,len(y_axis_infant_torso)),y_axis_infant_torso,'b-')
	ploty.ylabel('g')
	ploty.xlabel('samples')
	ploty.title(str(seq)+' y axis infant torso')
	ploty.xticks(range(0,len(y_axis_infant_torso),288000),[str(x)+" h" for x in range(0,48,2)])
	red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear')
	ploty.legend(handles=([red_mark]))
	ploty.show(block=False)

	#plot entire signal z_infant_torso
	ploty.figure(num=3, figsize=(20,20))
	ploty.plot(range(0,len(z_axis_infant_torso)),z_axis_infant_torso,'b-')
	ploty.ylabel('g')
	ploty.xlabel('samples')
	ploty.title(str(seq)+' z axis infant torso')
	ploty.xticks(range(0,len(z_axis_infant_torso),288000),[str(x)+" h" for x in range(0,48,2)])
	red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear')
	ploty.legend(handles=([red_mark]))
	ploty.show(block=False)

	#infant ankle
	#plot entire signal x_infant_ankle
	ploty.figure(num=4, figsize=(20,20))
	ploty.plot(range(0,len(x_axis_infant_ankle)),x_axis_infant_ankle,'b-')
	ploty.ylabel('g')
	ploty.xlabel('samples')
	ploty.title(str(seq)+' x axis infant ankle')
	ploty.xticks(range(0,len(x_axis_infant_ankle),288000),[str(x)+" h" for x in range(0,48,2)])
	red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear')
	ploty.legend(handles=([red_mark]))
	ploty.show(block=False)

	#plot entire signal y_infant_ankle
	ploty.figure(num=5, figsize=(20,20))
	ploty.plot(range(0,len(y_axis_infant_ankle)),y_axis_infant_ankle,'b-')
	ploty.ylabel('g')
	ploty.xlabel('samples')
	ploty.title(str(seq)+' y axis infant ankle')
	ploty.xticks(range(0,len(y_axis_infant_ankle),288000),[str(x)+" h" for x in range(0,48,2)])
	red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear')
	ploty.legend(handles=([red_mark]))
	ploty.show(block=False)

	#plot entire signal z_infant_ankle
	ploty.figure(num=6, figsize=(20,20))
	ploty.plot(range(0,len(z_axis_infant_ankle)),z_axis_infant_ankle,'b-')
	ploty.ylabel('g')
	ploty.xlabel('samples')
	ploty.title(str(seq)+' z axis infant ankle')
	ploty.xticks(range(0,len(z_axis_infant_ankle),288000),[str(x)+" h" for x in range(0,48,2)])
	red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear')
	ploty.legend(handles=([red_mark]))
	ploty.show(block=False)

	#mother
	#plot entire signal x_mother
	ploty.figure(num=7, figsize=(20,20))
	ploty.plot(range(0,len(x_axis_mother)),x_axis_mother,'b-')
	ploty.ylabel('g')
	ploty.xlabel('samples')
	ploty.title(str(seq)+' x axis mother')
	ploty.xticks(range(0,len(x_axis_mother),288000),[str(x)+" h" for x in range(0,48,2)])
	red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear')
	ploty.legend(handles=([red_mark]))
	ploty.show(block=False)

	#plot entire signal y_mother
	ploty.figure(num=8, figsize=(20,20))
	ploty.plot(range(0,len(y_axis_mother)),y_axis_mother,'b-')
	ploty.ylabel('g')
	ploty.xlabel('samples')
	ploty.title(str(seq)+' y axis mother')
	ploty.xticks(range(0,len(y_axis_mother),288000),[str(x)+" h" for x in range(0,48,2)])
	red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear')
	ploty.legend(handles=([red_mark]))
	ploty.show(block=False)

	#plot entire signal z_mother
	ploty.figure(num=9, figsize=(20,20))
	ploty.plot(range(0,len(z_axis_mother)),z_axis_mother,'b-')
	ploty.ylabel('g')
	ploty.xlabel('samples')
	ploty.title(str(seq)+' z axis mother')
	ploty.xticks(range(0,len(z_axis_mother),288000),[str(x)+" h" for x in range(0,48,2)])
	red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear')
	ploty.legend(handles=([red_mark]))
	ploty.show(block=False)
	'''
	#extract windowed statistics
	for window in range(0,max(len(x_axis_infant_torso), len(x_axis_infant_ankle), len(x_axis_mother)),window_points):

		#cumulative arrays
		cumulative_array_x_infant_torso=x_axis_infant_torso[window:window+window_points]
		cumulative_array_y_infant_torso=y_axis_infant_torso[window:window+window_points]
		cumulative_array_z_infant_torso=z_axis_infant_torso[window:window+window_points]

		cumulative_array_x_infant_ankle=x_axis_infant_ankle[window:window+window_points]
		cumulative_array_y_infant_ankle=y_axis_infant_ankle[window:window+window_points]
		cumulative_array_z_infant_ankle=z_axis_infant_ankle[window:window+window_points]

		cumulative_array_x_mother=x_axis_mother[window:window+window_points]
		cumulative_array_y_mother=y_axis_mother[window:window+window_points]
		cumulative_array_z_mother=z_axis_mother[window:window+window_points]

		if len(cumulative_array_x_infant_torso)>0:

			#avarages
			avg_x_infant_torso=sum(cumulative_array_x_infant_torso)/len(cumulative_array_x_infant_torso)
			avg_y_infant_torso=sum(cumulative_array_y_infant_torso)/len(cumulative_array_y_infant_torso)
			avg_z_infant_torso=sum(cumulative_array_z_infant_torso)/len(cumulative_array_z_infant_torso)

			#stds
			std_x_infant_torso=round((sum([(element-avg_x_infant_torso)**2 for element in cumulative_array_x_infant_torso])/len(cumulative_array_x_infant_torso))**(0.5),5)
			std_y_infant_torso=round((sum([(element-avg_y_infant_torso)**2 for element in cumulative_array_y_infant_torso])/len(cumulative_array_y_infant_torso))**(0.5),5)
			std_z_infant_torso=round((sum([(element-avg_z_infant_torso)**2 for element in cumulative_array_z_infant_torso])/len(cumulative_array_z_infant_torso))**(0.5),5)

			#spans

			span_x_infant_torso=abs(min(cumulative_array_x_infant_torso)-max(cumulative_array_x_infant_torso))
			span_y_infant_torso=abs(min(cumulative_array_y_infant_torso)-max(cumulative_array_y_infant_torso))
			span_z_infant_torso=abs(min(cumulative_array_z_infant_torso)-max(cumulative_array_z_infant_torso))

			#get a fitted line to estimate slop, no wear should have (close to) zero slope

			line_fit_x_infant_torso=np.polyfit(range(window,window+len(cumulative_array_x_infant_torso)), cumulative_array_x_infant_torso, 1)
			line_fit_y_infant_torso=np.polyfit(range(window,window+len(cumulative_array_y_infant_torso)), cumulative_array_y_infant_torso, 1)
			line_fit_z_infant_torso=np.polyfit(range(window,window+len(cumulative_array_z_infant_torso)), cumulative_array_z_infant_torso, 1)

			#check for conditions of wear time and save into arrays

			if (std_x_infant_torso<=no_wear_std and std_y_infant_torso<=no_wear_std and std_z_infant_torso<=no_wear_std) or (span_x_infant_torso<=no_wear_span and span_y_infant_torso<=no_wear_span and span_z_infant_torso<=no_wear_span):

				print 'std x: '+str(std_x_infant_torso)+' std y: '+str(std_y_infant_torso)+' std z: '+str(std_z_infant_torso)
				print 'span x: '+str(span_x_infant_torso)+' span y: '+str(span_y_infant_torso)+' span z: '+str(span_z_infant_torso)
				#add extra condition regarding baseline drift, in no-wear, there should be none, at least two of the axis need to have near to zero slope
				if ( abs(line_fit_x_infant_torso[0])<float('1e-07') and  abs(line_fit_y_infant_torso[0])<float('1e-07') and abs(line_fit_z_infant_torso[0])<float('1e-07')):
					no_wear_infant_torso.append(1)
					print 'slope x: '+str(line_fit_x_infant_torso[0])+' slope y: '+str(line_fit_y_infant_torso[0])+' slope z: '+str(line_fit_z_infant_torso[0])
				else:
					no_wear_infant_torso.append(0)
			else:
				no_wear_infant_torso.append(0)

		if len(cumulative_array_x_infant_ankle)>0:

			#avarages
			avg_x_infant_ankle=sum(cumulative_array_x_infant_ankle)/len(cumulative_array_x_infant_ankle)
			avg_y_infant_ankle=sum(cumulative_array_y_infant_ankle)/len(cumulative_array_y_infant_ankle)
			avg_z_infant_ankle=sum(cumulative_array_z_infant_ankle)/len(cumulative_array_z_infant_ankle)

			#stds
			std_x_infant_ankle=round((sum([(element-avg_x_infant_ankle)**2 for element in cumulative_array_x_infant_ankle])/len(cumulative_array_x_infant_ankle))**(0.5),5)
			std_y_infant_ankle=round((sum([(element-avg_y_infant_ankle)**2 for element in cumulative_array_y_infant_ankle])/len(cumulative_array_y_infant_ankle))**(0.5),5)
			std_z_infant_ankle=round((sum([(element-avg_z_infant_ankle)**2 for element in cumulative_array_z_infant_ankle])/len(cumulative_array_z_infant_ankle))**(0.5),5)

			#spans

			span_x_infant_ankle=abs(min(cumulative_array_x_infant_ankle)-max(cumulative_array_x_infant_ankle))
			span_y_infant_ankle=abs(min(cumulative_array_y_infant_ankle)-max(cumulative_array_y_infant_ankle))
			span_z_infant_ankle=abs(min(cumulative_array_z_infant_ankle)-max(cumulative_array_z_infant_ankle))

			#get a fitted line to estimate slop, no wear should have (close to) zero slope

			line_fit_x_infant_ankle=np.polyfit(range(window,window+len(cumulative_array_x_infant_ankle)), cumulative_array_x_infant_ankle, 1)
			line_fit_y_infant_ankle=np.polyfit(range(window,window+len(cumulative_array_y_infant_ankle)), cumulative_array_y_infant_ankle, 1)
			line_fit_z_infant_ankle=np.polyfit(range(window,window+len(cumulative_array_z_infant_ankle)), cumulative_array_z_infant_ankle, 1)

			#check for conditions of wear time and save into arrays

			if (std_x_infant_ankle<=no_wear_std and std_y_infant_ankle<=no_wear_std and std_z_infant_ankle<=no_wear_std) or (span_x_infant_ankle<=no_wear_span and span_y_infant_ankle<=no_wear_span and span_z_infant_ankle<=no_wear_span):

				print 'std x: '+str(std_x_infant_ankle)+' std y: '+str(std_y_infant_ankle)+' std z: '+str(std_z_infant_ankle)
				print 'span x: '+str(span_x_infant_ankle)+' span y: '+str(span_y_infant_ankle)+' span z: '+str(span_z_infant_ankle)
				#add extra condition regarding baseline drift, in no-wear, there should be none, at least two of the axis need to have near to zero slope
				if ( abs(line_fit_x_infant_ankle[0])<float('1e-07') and  abs(line_fit_y_infant_ankle[0])<float('1e-07') and abs(line_fit_z_infant_ankle[0])<float('1e-07')):
					no_wear_infant_ankle.append(1)
					print 'slope x: '+str(line_fit_x_infant_ankle[0])+' slope y: '+str(line_fit_y_infant_ankle[0])+' slope z: '+str(line_fit_z_infant_ankle[0])
				else:
					no_wear_infant_ankle.append(0)
			else:
				no_wear_infant_ankle.append(0)

		if len(cumulative_array_x_mother)>0:

			#avarages
			avg_x_mother=sum(cumulative_array_x_mother)/len(cumulative_array_x_mother)
			avg_y_mother=sum(cumulative_array_y_mother)/len(cumulative_array_y_mother)
			avg_z_mother=sum(cumulative_array_z_mother)/len(cumulative_array_z_mother)

			#stds
			std_x_mother=round((sum([(element-avg_x_mother)**2 for element in cumulative_array_x_mother])/len(cumulative_array_x_mother))**(0.5),5)
			std_y_mother=round((sum([(element-avg_y_mother)**2 for element in cumulative_array_y_mother])/len(cumulative_array_y_mother))**(0.5),5)
			std_z_mother=round((sum([(element-avg_z_mother)**2 for element in cumulative_array_z_mother])/len(cumulative_array_z_mother))**(0.5),5)

			#spans
			span_x_mother=abs(min(cumulative_array_x_mother)-max(cumulative_array_x_mother))
			span_y_mother=abs(min(cumulative_array_y_mother)-max(cumulative_array_y_mother))
			span_z_mother=abs(min(cumulative_array_z_mother)-max(cumulative_array_z_mother))

			#get a fitted line to estimate slop, no wear should have (close to) zero slope

			line_fit_x_mother=np.polyfit(range(window,window+len(cumulative_array_x_mother)), cumulative_array_x_mother, 1)
			line_fit_y_mother=np.polyfit(range(window,window+len(cumulative_array_y_mother)), cumulative_array_y_mother, 1)
			line_fit_z_mother=np.polyfit(range(window,window+len(cumulative_array_z_mother)), cumulative_array_z_mother, 1)

			#check for conditions of wear time and save into arrays

			if (std_x_mother<=no_wear_std and std_y_mother<=no_wear_std and std_z_mother<=no_wear_std) or (span_x_mother<=no_wear_span and span_y_mother<=no_wear_span and span_z_mother<=no_wear_span):

				print 'std x: '+str(std_x_mother)+' std y: '+str(std_y_mother)+' std z: '+str(std_z_mother)
				print 'span x: '+str(span_x_mother)+' span y: '+str(span_y_mother)+' span z: '+str(span_z_mother)
				#add extra condition regarding baseline drift, in no-wear, there should be none, at least two of the axis need to have near to zero slope
				if ( abs(line_fit_x_mother[0])<float('1e-07') and  abs(line_fit_y_mother[0])<float('1e-07') and abs(line_fit_z_mother[0])<float('1e-07')):
					no_wear_mother.append(1)
					print 'slope x: '+str(line_fit_x_mother[0])+' slope y: '+str(line_fit_y_mother[0])+' slope z: '+str(line_fit_z_mother[0])
				else:
					no_wear_mother.append(0)
			else:
				no_wear_mother.append(0)


	#go over the border blocks more thoroughly to get the best start and end of no wear block, check for in between blocks
	#wear indexes
	x_axis_infant_torso_wear_indexes=[1]*len(x_axis_infant_torso)
	y_axis_infant_torso_wear_indexes=[1]*len(y_axis_infant_torso)
	z_axis_infant_torso_wear_indexes=[1]*len(z_axis_infant_torso)

	x_axis_infant_ankle_wear_indexes=[1]*len(x_axis_infant_ankle)
	y_axis_infant_ankle_wear_indexes=[1]*len(y_axis_infant_ankle)
	z_axis_infant_ankle_wear_indexes=[1]*len(z_axis_infant_ankle)

	x_axis_mother_wear_indexes=[1]*len(x_axis_mother)
	y_axis_mother_wear_indexes=[1]*len(y_axis_mother)
	z_axis_mother_wear_indexes=[1]*len(z_axis_mother)
	
	# infant torso
	for no_wear_index in range(0,len(no_wear_infant_torso)):
		if no_wear_index!=(len(no_wear_infant_torso)-1) and no_wear_infant_torso[no_wear_index]==0 and no_wear_infant_torso[max(0,no_wear_index-1)]==1 and no_wear_infant_torso[min(no_wear_index+1,len(no_wear_infant_torso)-1)]!=1 and no_wear_infant_torso[min(no_wear_index+2,len(no_wear_infant_torso)-1)]!=1: #end of no-wear block
			#examine this block more closely over 5minutes windows(5*60*40=12000 data points)
			#beginning_window=no_wear_index*window_points+window_points
			for window in range(no_wear_index*window_points,no_wear_index*window_points+window_points,12000):
				cumulative_array_x=x_axis_infant_torso[window:window+12000]
				cumulative_array_y=y_axis_infant_torso[window:window+12000]
				cumulative_array_z=z_axis_infant_torso[window:window+12000]

				avg_x=sum(cumulative_array_x)/len(cumulative_array_x)
				avg_y=sum(cumulative_array_y)/len(cumulative_array_y)
				avg_z=sum(cumulative_array_z)/len(cumulative_array_z)

				std_x=round((sum([(element-avg_x)**2 for element in cumulative_array_x])/len(cumulative_array_x))**(0.5),5)
				std_y=round((sum([(element-avg_y)**2 for element in cumulative_array_y])/len(cumulative_array_y))**(0.5),5)
				std_z=round((sum([(element-avg_z)**2 for element in cumulative_array_z])/len(cumulative_array_z))**(0.5),5)

				span_x=abs(min(cumulative_array_x)-max(cumulative_array_x))
				span_y=abs(min(cumulative_array_y)-max(cumulative_array_y))
				span_z=abs(min(cumulative_array_z)-max(cumulative_array_z))
		
				#check for conditions of wear time
				if (std_x<=no_wear_std and std_y<=no_wear_std and std_z<=no_wear_std) or (span_x<=no_wear_span and span_y<=no_wear_span and span_z<=no_wear_span):
					x_axis_infant_torso_wear_indexes[window:window+12000]=[0]*len(x_axis_infant_torso_wear_indexes[window:window+12000])
					y_axis_infant_torso_wear_indexes[window:window+12000]=[0]*len(y_axis_infant_torso_wear_indexes[window:window+12000])
					z_axis_infant_torso_wear_indexes[window:window+12000]=[0]*len(z_axis_infant_torso_wear_indexes[window:window+12000])

					x_axis_infant_ankle_wear_indexes[window:window+12000]=[0]*len(x_axis_infant_ankle_wear_indexes[window:window+12000])
					y_axis_infant_ankle_wear_indexes[window:window+12000]=[0]*len(y_axis_infant_ankle_wear_indexes[window:window+12000])
					z_axis_infant_ankle_wear_indexes[window:window+12000]=[0]*len(z_axis_infant_ankle_wear_indexes[window:window+12000])

					x_axis_mother_wear_indexes[window:window+12000]=[0]*len(x_axis_mother_wear_indexes[window:window+12000])
					y_axis_mother_wear_indexes[window:window+12000]=[0]*len(y_axis_mother_wear_indexes[window:window+12000])
					z_axis_mother_wear_indexes[window:window+12000]=[0]*len(z_axis_mother_wear_indexes[window:window+12000])

					#ploty.figure(1)
					ax1.plot(range(window,window+len(x_axis_infant_torso[window:window+12000])),x_axis_infant_torso[window:window+12000],'y-')
					#ploty.draw()
					#ploty.figure(2)
					ax2.plot(range(window,window+len(y_axis_infant_torso[window:window+12000])),y_axis_infant_torso[window:window+12000],'y-')
					#ploty.draw()
					#ploty.figure(3)
					ax3.plot(range(window,window+len(z_axis_infant_torso[window:window+12000])),z_axis_infant_torso[window:window+12000],'y-')
					#ploty.draw()

					#ploty.figure(4)
					ax4.plot(range(window,window+len(x_axis_infant_ankle[window:window+12000])),x_axis_infant_ankle[window:window+12000],'y-')
					#ploty.draw()
					#ploty.figure(5)
					ax5.plot(range(window,window+len(y_axis_infant_ankle[window:window+12000])),y_axis_infant_ankle[window:window+12000],'y-')
					#ploty.draw()
					#ploty.figure(6)
					ax6.plot(range(window,window+len(z_axis_infant_ankle[window:window+12000])),z_axis_infant_ankle[window:window+12000],'y-')
					#ploty.draw()

					#ploty.figure(7)
					ax7.plot(range(window,window+len(x_axis_mother[window:window+12000])),x_axis_mother[window:window+12000],'y-')
					#ploty.draw()
					#ploty.figure(8)
					ax8.plot(range(window,window+len(y_axis_mother[window:window+12000])),y_axis_mother[window:window+12000],'y-')
					#ploty.draw()
					#ploty.figure(9)
					ax9.plot(range(window,window+len(z_axis_mother[window:window+12000])),z_axis_mother[window:window+12000],'y-')
					#ploty.draw()

				else:
					#reached end, save block index and break
					#beginning_window=window
					break
		
		elif no_wear_index!=0 and no_wear_infant_torso[no_wear_index]==0 and no_wear_infant_torso[min(no_wear_index+1,len(no_wear_infant_torso)-1)]==1 and no_wear_infant_torso[max(0,no_wear_index-1)]!=1 and no_wear_infant_torso[max(0,no_wear_index-2)]!=1:#beginning of no-wear block
			#examine this block more closely over 5minutes windows(5*60*40=12000 data points)
			end_window=no_wear_index*window_points
			for window in range(no_wear_index*window_points+window_points,no_wear_index*window_points,-12000):#looking from the back
				cumulative_array_x=x_axis_infant_torso[window-12000:window]
				cumulative_array_y=y_axis_infant_torso[window-12000:window]
				cumulative_array_z=z_axis_infant_torso[window-12000:window]

				avg_x=sum(cumulative_array_x)/len(cumulative_array_x)
				avg_y=sum(cumulative_array_y)/len(cumulative_array_y)
				avg_z=sum(cumulative_array_z)/len(cumulative_array_z)

				std_x=round((sum([(element-avg_x)**2 for element in cumulative_array_x])/len(cumulative_array_x))**(0.5),5)
				std_y=round((sum([(element-avg_y)**2 for element in cumulative_array_y])/len(cumulative_array_y))**(0.5),5)
				std_z=round((sum([(element-avg_z)**2 for element in cumulative_array_z])/len(cumulative_array_z))**(0.5),5)

				span_x=abs(min(cumulative_array_x)-max(cumulative_array_x))
				span_y=abs(min(cumulative_array_y)-max(cumulative_array_y))
				span_z=abs(min(cumulative_array_z)-max(cumulative_array_z))
		
				#check for conditions of wear time
				if (std_x<=no_wear_std and std_y<=no_wear_std and std_z<=no_wear_std) or (span_x<=no_wear_span and span_y<=no_wear_span and span_z<=no_wear_span):
					x_axis_infant_torso_wear_indexes[window-12000:window]=[0]*len(x_axis_infant_torso_wear_indexes[window-12000:window])
					y_axis_infant_torso_wear_indexes[window-12000:window]=[0]*len(y_axis_infant_torso_wear_indexes[window-12000:window])
					z_axis_infant_torso_wear_indexes[window-12000:window]=[0]*len(z_axis_infant_torso_wear_indexes[window-12000:window])

					x_axis_infant_ankle_wear_indexes[window-12000:window]=[0]*len(x_axis_infant_ankle_wear_indexes[window-12000:window])
					y_axis_infant_ankle_wear_indexes[window-12000:window]=[0]*len(y_axis_infant_ankle_wear_indexes[window-12000:window])
					z_axis_infant_ankle_wear_indexes[window-12000:window]=[0]*len(z_axis_infant_ankle_wear_indexes[window-12000:window])

					x_axis_mother_wear_indexes[window-12000:window]=[0]*len(x_axis_mother_wear_indexes[window-12000:window])
					y_axis_mother_wear_indexes[window-12000:window]=[0]*len(y_axis_mother_wear_indexes[window-12000:window])
					z_axis_mother_wear_indexes[window-12000:window]=[0]*len(z_axis_mother_wear_indexes[window-12000:window])

					#ploty.figure(1)
					ax1.plot(range(window-len(x_axis_infant_torso[window-12000:window]),window),x_axis_infant_torso[window-12000:window],'y-')
					#ploty.draw()
					#ploty.figure(2)
					ax2.plot(range(window-len(y_axis_infant_torso[window-12000:window]),window),y_axis_infant_torso[window-12000:window],'y-')
					#ploty.draw()
					#ploty.figure(3)
					ax3.plot(range(window-len(z_axis_infant_torso[window-12000:window]),window),z_axis_infant_torso[window-12000:window],'y-')
					#ploty.draw()

					#ploty.figure(4)
					ax4.plot(range(window-len(x_axis_infant_ankle[window-12000:window]),window),x_axis_infant_ankle[window-12000:window],'y-')
					#ploty.draw()
					#ploty.figure(5)
					ax5.plot(range(window-len(y_axis_infant_ankle[window-12000:window]),window),y_axis_infant_ankle[window-12000:window],'y-')
					#ploty.draw()
					#ploty.figure(6)
					ax6.plot(range(window-len(z_axis_infant_ankle[window-12000:window]),window),z_axis_infant_ankle[window-12000:window],'y-')
					#ploty.draw()

					#ploty.figure(7)
					ax7.plot(range(window-len(x_axis_mother[window-12000:window]),window),x_axis_mother[window-12000:window],'y-')
					#ploty.draw()
					#ploty.figure(8)
					ax8.plot(range(window-len(y_axis_mother[window-12000:window]),window),y_axis_mother[window-12000:window],'y-')
					#ploty.draw()
					#ploty.figure(9)
					ax9.plot(range(window-len(z_axis_mother[window-12000:window]),window),z_axis_mother[window-12000:window],'y-')
					#ploty.draw()

				else:
					#reached end, save block index and break
					end_window=window
					break

		elif no_wear_infant_torso[no_wear_index]==0 and ( ( (no_wear_infant_torso[min(no_wear_index+1,len(no_wear_infant_torso)-1)]==1 or no_wear_infant_torso[min(no_wear_index+2,len(no_wear_infant_torso)-1)]==1) and (no_wear_infant_torso[max(0,no_wear_index-1)]==1 or no_wear_infant_torso[max(0,no_wear_index-2)]==1) ) or ( (no_wear_infant_torso[1]==1 or no_wear_infant_torso[2]==1) and no_wear_index==0 ) or ( (no_wear_index==(len(no_wear_infant_torso)-1) or no_wear_index==(len(no_wear_infant_torso)-2)) and (no_wear_infant_torso[len(no_wear_infant_torso)-2]==1 or no_wear_infant_torso[len(no_wear_infant_torso)-3]==1) ) ): #up to three blocks of wear between two blocks of no-wear, are most probably no-wear, include beginning and end also
			no_wear_infant_torso[no_wear_index]=1
			x_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(x_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(y_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(z_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])

			x_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(x_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(y_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(z_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])

			x_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(x_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(y_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(z_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])

			#ploty.figure(1)
			ax1.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()
			#ploty.figure(2)
			ax2.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()
			#ploty.figure(3)
			ax3.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()

			#ploty.figure(4)
			ax4.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()
			#ploty.figure(5)
			ax5.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()
			#ploty.figure(6)
			ax6.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()

			#ploty.figure(7)
			ax7.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()
			#ploty.figure(8)
			ax8.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()
			#ploty.figure(9)
			ax9.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()

		elif no_wear_infant_torso[no_wear_index]==1:
	
			x_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(x_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(y_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(z_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])

			x_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(x_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(y_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(z_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])

			x_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(x_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(y_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(z_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])

			#ploty.figure(1)
			ax1.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()
			#ploty.figure(2)
			ax2.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()
			#ploty.figure(3)
			ax3.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()

			#ploty.figure(4)
			ax4.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()
			#ploty.figure(5)
			ax5.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()
			#ploty.figure(6)
			ax6.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()

			#ploty.figure(7)
			ax7.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()
			#ploty.figure(8)
			ax8.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()
			#ploty.figure(9)
			ax9.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'y-')
			#ploty.draw()


	#infant ankle
	for no_wear_index in range(0,len(no_wear_infant_ankle)):
		if no_wear_index!=(len(no_wear_infant_ankle)-1) and no_wear_infant_ankle[no_wear_index]==0 and no_wear_infant_ankle[max(0,no_wear_index-1)]==1 and no_wear_infant_ankle[min(no_wear_index+1,len(no_wear_infant_ankle)-1)]!=1 and no_wear_infant_ankle[min(no_wear_index+2,len(no_wear_infant_ankle)-1)]!=1: #end of no-wear block
			#examine this block more closely over 5minutes windows(5*60*40=12000 data points)
			#beginning_window=no_wear_index*window_points+window_points
			for window in range(no_wear_index*window_points,no_wear_index*window_points+window_points,12000):
				cumulative_array_x=x_axis_infant_ankle[window:window+12000]
				cumulative_array_y=y_axis_infant_ankle[window:window+12000]
				cumulative_array_z=z_axis_infant_ankle[window:window+12000]

				avg_x=sum(cumulative_array_x)/len(cumulative_array_x)
				avg_y=sum(cumulative_array_y)/len(cumulative_array_y)
				avg_z=sum(cumulative_array_z)/len(cumulative_array_z)

				std_x=round((sum([(element-avg_x)**2 for element in cumulative_array_x])/len(cumulative_array_x))**(0.5),5)
				std_y=round((sum([(element-avg_y)**2 for element in cumulative_array_y])/len(cumulative_array_y))**(0.5),5)
				std_z=round((sum([(element-avg_z)**2 for element in cumulative_array_z])/len(cumulative_array_z))**(0.5),5)

				span_x=abs(min(cumulative_array_x)-max(cumulative_array_x))
				span_y=abs(min(cumulative_array_y)-max(cumulative_array_y))
				span_z=abs(min(cumulative_array_z)-max(cumulative_array_z))
		
				#check for conditions of wear time
				if (std_x<=no_wear_std and std_y<=no_wear_std and std_z<=no_wear_std) or (span_x<=no_wear_span and span_y<=no_wear_span and span_z<=no_wear_span):
					x_axis_infant_torso_wear_indexes[window:window+12000]=[0]*len(x_axis_infant_torso_wear_indexes[window:window+12000])
					y_axis_infant_torso_wear_indexes[window:window+12000]=[0]*len(y_axis_infant_torso_wear_indexes[window:window+12000])
					z_axis_infant_torso_wear_indexes[window:window+12000]=[0]*len(z_axis_infant_torso_wear_indexes[window:window+12000])

					x_axis_infant_ankle_wear_indexes[window:window+12000]=[0]*len(x_axis_infant_ankle_wear_indexes[window:window+12000])
					y_axis_infant_ankle_wear_indexes[window:window+12000]=[0]*len(y_axis_infant_ankle_wear_indexes[window:window+12000])
					z_axis_infant_ankle_wear_indexes[window:window+12000]=[0]*len(z_axis_infant_ankle_wear_indexes[window:window+12000])

					x_axis_mother_wear_indexes[window:window+12000]=[0]*len(x_axis_mother_wear_indexes[window:window+12000])
					y_axis_mother_wear_indexes[window:window+12000]=[0]*len(y_axis_mother_wear_indexes[window:window+12000])
					z_axis_mother_wear_indexes[window:window+12000]=[0]*len(z_axis_mother_wear_indexes[window:window+12000])

					#ploty.figure(1)
					ax1.plot(range(window,window+len(x_axis_infant_torso[window:window+12000])),x_axis_infant_torso[window:window+12000],'r-')
					#ploty.draw()
					#ploty.figure(2)
					ax2.plot(range(window,window+len(y_axis_infant_torso[window:window+12000])),y_axis_infant_torso[window:window+12000],'r-')
					#ploty.draw()
					#ploty.figure(3)
					ax3.plot(range(window,window+len(z_axis_infant_torso[window:window+12000])),z_axis_infant_torso[window:window+12000],'r-')
					#ploty.draw()

					#ploty.figure(4)
					ax4.plot(range(window,window+len(x_axis_infant_ankle[window:window+12000])),x_axis_infant_ankle[window:window+12000],'r-')
					#ploty.draw()
					#ploty.figure(5)
					ax5.plot(range(window,window+len(y_axis_infant_ankle[window:window+12000])),y_axis_infant_ankle[window:window+12000],'r-')
					#ploty.draw()
					#ploty.figure(6)
					ax6.plot(range(window,window+len(z_axis_infant_ankle[window:window+12000])),z_axis_infant_ankle[window:window+12000],'r-')
					#ploty.draw()

					#ploty.figure(7)
					ax7.plot(range(window,window+len(x_axis_mother[window:window+12000])),x_axis_mother[window:window+12000],'r-')
					#ploty.draw()
					#ploty.figure(8)
					ax8.plot(range(window,window+len(y_axis_mother[window:window+12000])),y_axis_mother[window:window+12000],'r-')
					#ploty.draw()
					#ploty.figure(9)
					ax9.plot(range(window,window+len(z_axis_mother[window:window+12000])),z_axis_mother[window:window+12000],'r-')
					#ploty.draw()
				else:
					#reached end, save block index and break
					#beginning_window=window
					break
		
		elif no_wear_index!=0 and no_wear_infant_ankle[no_wear_index]==0 and no_wear_infant_ankle[min(no_wear_index+1,len(no_wear_infant_ankle)-1)]==1 and no_wear_infant_ankle[max(0,no_wear_index-1)]!=1 and no_wear_infant_ankle[max(0,no_wear_index-2)]!=1:#beginning of no-wear block
			#examine this block more closely over 5minutes windows(5*60*40=12000 data points)
			end_window=no_wear_index*window_points
			for window in range(no_wear_index*window_points+window_points,no_wear_index*window_points,-12000):#looking from the back
				cumulative_array_x=x_axis_infant_ankle[window-12000:window]
				cumulative_array_y=y_axis_infant_ankle[window-12000:window]
				cumulative_array_z=z_axis_infant_ankle[window-12000:window]

				avg_x=sum(cumulative_array_x)/len(cumulative_array_x)
				avg_y=sum(cumulative_array_y)/len(cumulative_array_y)
				avg_z=sum(cumulative_array_z)/len(cumulative_array_z)

				std_x=round((sum([(element-avg_x)**2 for element in cumulative_array_x])/len(cumulative_array_x))**(0.5),5)
				std_y=round((sum([(element-avg_y)**2 for element in cumulative_array_y])/len(cumulative_array_y))**(0.5),5)
				std_z=round((sum([(element-avg_z)**2 for element in cumulative_array_z])/len(cumulative_array_z))**(0.5),5)

				span_x=abs(min(cumulative_array_x)-max(cumulative_array_x))
				span_y=abs(min(cumulative_array_y)-max(cumulative_array_y))
				span_z=abs(min(cumulative_array_z)-max(cumulative_array_z))
		
				#check for conditions of wear time
				if (std_x<=no_wear_std and std_y<=no_wear_std and std_z<=no_wear_std) or (span_x<=no_wear_span and span_y<=no_wear_span and span_z<=no_wear_span):
					x_axis_infant_torso_wear_indexes[window-12000:window]=[0]*len(x_axis_infant_torso_wear_indexes[window-12000:window])
					y_axis_infant_torso_wear_indexes[window-12000:window]=[0]*len(y_axis_infant_torso_wear_indexes[window-12000:window])
					z_axis_infant_torso_wear_indexes[window-12000:window]=[0]*len(z_axis_infant_torso_wear_indexes[window-12000:window])

					x_axis_infant_ankle_wear_indexes[window-12000:window]=[0]*len(x_axis_infant_ankle_wear_indexes[window-12000:window])
					y_axis_infant_ankle_wear_indexes[window-12000:window]=[0]*len(y_axis_infant_ankle_wear_indexes[window-12000:window])
					z_axis_infant_ankle_wear_indexes[window-12000:window]=[0]*len(z_axis_infant_ankle_wear_indexes[window-12000:window])

					x_axis_mother_wear_indexes[window-12000:window]=[0]*len(x_axis_mother_wear_indexes[window-12000:window])
					y_axis_mother_wear_indexes[window-12000:window]=[0]*len(y_axis_mother_wear_indexes[window-12000:window])
					z_axis_mother_wear_indexes[window-12000:window]=[0]*len(z_axis_mother_wear_indexes[window-12000:window])

					#ploty.figure(1)
					ax1.plot(range(window-len(x_axis_infant_torso[window-12000:window]),window),x_axis_infant_torso[window-12000:window],'r-')
					#ploty.draw()
					#ploty.figure(2)
					ax2.plot(range(window-len(y_axis_infant_torso[window-12000:window]),window),y_axis_infant_torso[window-12000:window],'r-')
					#ploty.draw()
					#ploty.figure(3)
					ax3.plot(range(window-len(z_axis_infant_torso[window-12000:window]),window),z_axis_infant_torso[window-12000:window],'r-')
					#ploty.draw()

					#ploty.figure(4)
					ax4.plot(range(window-len(x_axis_infant_ankle[window-12000:window]),window),x_axis_infant_ankle[window-12000:window],'r-')
					#ploty.draw()
					#ploty.figure(5)
					ax5.plot(range(window-len(y_axis_infant_ankle[window-12000:window]),window),y_axis_infant_ankle[window-12000:window],'r-')
					#ploty.draw()
					#ploty.figure(6)
					ax6.plot(range(window-len(z_axis_infant_ankle[window-12000:window]),window),z_axis_infant_ankle[window-12000:window],'r-')
					#ploty.draw()

					#ploty.figure(7)
					ax7.plot(range(window-len(x_axis_mother[window-12000:window]),window),x_axis_mother[window-12000:window],'r-')
					#ploty.draw()
					#ploty.figure(8)
					ax8.plot(range(window-len(y_axis_mother[window-12000:window]),window),y_axis_mother[window-12000:window],'r-')
					#ploty.draw()
					#ploty.figure(9)
					ax9.plot(range(window-len(z_axis_mother[window-12000:window]),window),z_axis_mother[window-12000:window],'r-')
					#ploty.draw()
				else:
					#reached end, save block index and break
					end_window=window
					break

		elif no_wear_infant_ankle[no_wear_index]==0 and ( ( (no_wear_infant_ankle[min(no_wear_index+1,len(no_wear_infant_ankle)-1)]==1 or no_wear_infant_ankle[min(no_wear_index+2,len(no_wear_infant_ankle)-1)]==1) and (no_wear_infant_ankle[max(0,no_wear_index-1)]==1 or no_wear_infant_ankle[max(0,no_wear_index-2)]==1) ) or ( (no_wear_infant_ankle[1]==1 or no_wear_infant_ankle[2]==1) and no_wear_index==0 ) or ( (no_wear_index==(len(no_wear_infant_ankle)-1) or no_wear_index==(len(no_wear_infant_ankle)-2)) and (no_wear_infant_ankle[len(no_wear_infant_ankle)-2]==1 or no_wear_infant_ankle[len(no_wear_infant_ankle)-3]==1) ) ): #up to three blocks of wear between two blocks of no-wear, are most probably no-wear, include beginning and end also
			no_wear_infant_ankle[no_wear_index]=1
			x_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(x_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(y_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(z_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])

			x_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(x_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(y_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(z_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])

			x_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(x_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(y_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(z_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])

			#ploty.figure(1)
			ax1.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()
			#ploty.figure(2)
			ax2.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()
			#ploty.figure(3)
			ax3.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()

			#ploty.figure(4)
			ax4.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()
			#ploty.figure(5)
			ax5.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()
			#ploty.figure(6)
			ax6.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()

			#ploty.figure(7)
			ax7.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()
			#ploty.figure(8)
			ax8.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()
			#ploty.figure(9)
			ax9.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()

		elif no_wear_infant_ankle[no_wear_index]==1:
	
			x_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(x_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(y_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(z_axis_infant_torso_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])

			x_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(x_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(y_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(z_axis_infant_ankle_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])

			x_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(x_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(y_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points]=[0]*len(z_axis_mother_wear_indexes[no_wear_index*window_points:no_wear_index*window_points+window_points])

			#ploty.figure(1)
			ax1.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()
			#ploty.figure(2)
			ax2.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()
			#ploty.figure(3)
			ax3.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_infant_torso[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()

			#ploty.figure(4)
			ax4.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()
			#ploty.figure(5)
			ax5.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()
			#ploty.figure(6)
			ax6.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_infant_ankle[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()

			#ploty.figure(7)
			ax7.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()
			#ploty.figure(8)
			ax8.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()
			#ploty.figure(9)
			ax9.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'r-')
			#ploty.draw()


	#remove no wear from all
	print 'before removal torso: ' + str(len(x_axis_infant_torso))+','+str(len(y_axis_infant_torso))+','+str(len(z_axis_infant_torso))
	x_axis_infant_torso_wear=list(np.array(x_axis_infant_torso)[np.array(x_axis_infant_torso_wear_indexes)==1])
	y_axis_infant_torso_wear=list(np.array(y_axis_infant_torso)[np.array(y_axis_infant_torso_wear_indexes)==1])
	z_axis_infant_torso_wear=list(np.array(z_axis_infant_torso)[np.array(z_axis_infant_torso_wear_indexes)==1])
	print 'after removal torso: ' + str(len(x_axis_infant_torso_wear))+','+str(len(y_axis_infant_torso_wear))+','+str(len(z_axis_infant_torso_wear))

	print 'before removal ankle: ' + str(len(x_axis_infant_ankle))+','+str(len(y_axis_infant_ankle))+','+str(len(z_axis_infant_ankle))
	x_axis_infant_ankle_wear=list(np.array(x_axis_infant_ankle)[np.array(x_axis_infant_ankle_wear_indexes)==1])
	y_axis_infant_ankle_wear=list(np.array(y_axis_infant_ankle)[np.array(y_axis_infant_ankle_wear_indexes)==1])
	z_axis_infant_ankle_wear=list(np.array(z_axis_infant_ankle)[np.array(z_axis_infant_ankle_wear_indexes)==1])
	print 'after removal ankle: ' + str(len(x_axis_infant_ankle_wear))+','+str(len(y_axis_infant_ankle_wear))+','+str(len(z_axis_infant_ankle_wear))

	print 'before removal mother: ' + str(len(x_axis_mother))+','+str(len(y_axis_mother))+','+str(len(z_axis_mother))
	x_axis_mother_wear=list(np.array(x_axis_mother)[np.array(x_axis_mother_wear_indexes)==1])
	y_axis_mother_wear=list(np.array(y_axis_mother)[np.array(y_axis_mother_wear_indexes)==1])
	z_axis_mother_wear=list(np.array(z_axis_mother)[np.array(z_axis_mother_wear_indexes)==1])
	print 'after removal torso: ' + str(len(x_axis_mother_wear))+','+str(len(y_axis_mother_wear))+','+str(len(z_axis_mother_wear))

	#set NaN only for mothers
	for no_wear_index in range(0,len(no_wear_mother)):
		if no_wear_index!=(len(no_wear_mother)-1) and no_wear_mother[no_wear_index]==0 and no_wear_mother[max(0,no_wear_index-1)]==1 and no_wear_mother[min(no_wear_index+1,len(no_wear_mother)-1)]!=1 and no_wear_mother[min(no_wear_index+2,len(no_wear_mother)-1)]!=1: #end of no-wear block
			#examine this block more closely over 5minutes windows(5*60*40=12000 data points)
			#beginning_window=no_wear_index*window_points+window_points
			for window in range(no_wear_index*window_points,no_wear_index*window_points+window_points,12000):
				cumulative_array_x=x_axis_mother[window:window+12000]
				cumulative_array_y=y_axis_mother[window:window+12000]
				cumulative_array_z=z_axis_mother[window:window+12000]

				avg_x=sum(cumulative_array_x)/len(cumulative_array_x)
				avg_y=sum(cumulative_array_y)/len(cumulative_array_y)
				avg_z=sum(cumulative_array_z)/len(cumulative_array_z)

				std_x=round((sum([(element-avg_x)**2 for element in cumulative_array_x])/len(cumulative_array_x))**(0.5),5)
				std_y=round((sum([(element-avg_y)**2 for element in cumulative_array_y])/len(cumulative_array_y))**(0.5),5)
				std_z=round((sum([(element-avg_z)**2 for element in cumulative_array_z])/len(cumulative_array_z))**(0.5),5)

				span_x=abs(min(cumulative_array_x)-max(cumulative_array_x))
				span_y=abs(min(cumulative_array_y)-max(cumulative_array_y))
				span_z=abs(min(cumulative_array_z)-max(cumulative_array_z))
		
				#check for conditions of wear time
				if (std_x<=no_wear_std and std_y<=no_wear_std and std_z<=no_wear_std) or (span_x<=no_wear_span and span_y<=no_wear_span and span_z<=no_wear_span):

					x_axis_mother_wear[window:window+12000]=['NaN']*len(x_axis_mother_wear[window:window+12000])
					y_axis_mother_wear[window:window+12000]=['NaN']*len(y_axis_mother_wear[window:window+12000])
					z_axis_mother_wear[window:window+12000]=['NaN']*len(z_axis_mother_wear[window:window+12000])

					print "mother plotting no wear (extended)"
					#ploty.figure(7)
					ax7.plot(range(window,window+len(x_axis_mother[window:window+12000])),x_axis_mother[window:window+12000],'k-')
					#ploty.draw()
					#ploty.figure(8)
					ax8.plot(range(window,window+len(y_axis_mother[window:window+12000])),y_axis_mother[window:window+12000],'k-')
					#ploty.draw()
					#ploty.figure(9)
					ax9.plot(range(window,window+len(z_axis_mother[window:window+12000])),z_axis_mother[window:window+12000],'k-')
					#ploty.draw()
				else:
					#reached end, save block index and break
					#beginning_window=window
					break
		
		elif no_wear_index!=0 and no_wear_mother[no_wear_index]==0 and no_wear_mother[min(no_wear_index+1,len(no_wear_mother)-1)]==1 and no_wear_mother[max(0,no_wear_index-1)]!=1 and no_wear_mother[max(0,no_wear_index-2)]!=1:#beginning of no-wear block
			#examine this block more closely over 5minutes windows(5*60*40=12000 data points)
			end_window=no_wear_index*window_points
			for window in range(no_wear_index*window_points+window_points,no_wear_index*window_points,-12000):#looking from the back
				cumulative_array_x=x_axis_mother[window-12000:window]
				cumulative_array_y=y_axis_mother[window-12000:window]
				cumulative_array_z=z_axis_mother[window-12000:window]

				avg_x=sum(cumulative_array_x)/len(cumulative_array_x)
				avg_y=sum(cumulative_array_y)/len(cumulative_array_y)
				avg_z=sum(cumulative_array_z)/len(cumulative_array_z)

				std_x=round((sum([(element-avg_x)**2 for element in cumulative_array_x])/len(cumulative_array_x))**(0.5),5)
				std_y=round((sum([(element-avg_y)**2 for element in cumulative_array_y])/len(cumulative_array_y))**(0.5),5)
				std_z=round((sum([(element-avg_z)**2 for element in cumulative_array_z])/len(cumulative_array_z))**(0.5),5)

				span_x=abs(min(cumulative_array_x)-max(cumulative_array_x))
				span_y=abs(min(cumulative_array_y)-max(cumulative_array_y))
				span_z=abs(min(cumulative_array_z)-max(cumulative_array_z))
		
				#check for conditions of wear time
				if (std_x<=no_wear_std and std_y<=no_wear_std and std_z<=no_wear_std) or (span_x<=no_wear_span and span_y<=no_wear_span and span_z<=no_wear_span):

					x_axis_mother_wear[window-12000:window]=['NaN']*len(x_axis_mother_wear[window-12000:window])
					y_axis_mother_wear[window-12000:window]=['NaN']*len(y_axis_mother_wear[window-12000:window])
					z_axis_mother_wear[window-12000:window]=['NaN']*len(z_axis_mother_wear[window-12000:window])
					
					print "mother plotting no wear (extended)"
					#ploty.figure(7)
					ax7.plot(range(window-len(x_axis_mother[window-12000:window]),window),x_axis_mother[window-12000:window],'k-')
					#ploty.draw()
					#ploty.figure(8)
					ax8.plot(range(window-len(y_axis_mother[window-12000:window]),window),y_axis_mother[window-12000:window],'k-')
					#ploty.draw()
					#ploty.figure(9)
					ax9.plot(range(window-len(z_axis_mother[window-12000:window]),window),z_axis_mother[window-12000:window],'k-')
					#ploty.draw()
				else:
					#reached end, save block index and break
					end_window=window
					break

		elif no_wear_mother[no_wear_index]==0 and ( ( (no_wear_mother[min(no_wear_index+1,len(no_wear_mother)-1)]==1 or no_wear_mother[min(no_wear_index+2,len(no_wear_mother)-1)]==1) and (no_wear_mother[max(0,no_wear_index-1)]==1 or no_wear_mother[max(0,no_wear_index-2)]==1) ) or ( (no_wear_mother[1]==1 or no_wear_mother[2]==1) and no_wear_index==0 ) or ( (no_wear_index==(len(no_wear_mother)-1) or no_wear_index==(len(no_wear_mother)-2)) and (no_wear_mother[len(no_wear_mother)-2]==1 or no_wear_mother[len(no_wear_mother)-3]==1) ) ): #up to three blocks of wear between two blocks of no-wear, are most probably no-wear, include beginning and end also
			no_wear_mother[no_wear_index]=1

			x_axis_mother_wear[no_wear_index*window_points:no_wear_index*window_points+window_points]=['NaN']*len(x_axis_mother_wear[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_mother_wear[no_wear_index*window_points:no_wear_index*window_points+window_points]=['NaN']*len(y_axis_mother_wear[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_mother_wear[no_wear_index*window_points:no_wear_index*window_points+window_points]=['NaN']*len(z_axis_mother_wear[no_wear_index*window_points:no_wear_index*window_points+window_points])
			
			print "mother plotting no wear (in between)"
			#ploty.figure(7)
			ax7.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'k-')
			#ploty.draw()
			#ploty.figure(8)
			ax8.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'k-')
			#ploty.draw()
			#ploty.figure(9)
			ax9.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'k-')
			#ploty.draw()

		elif no_wear_mother[no_wear_index]==1:

			x_axis_mother_wear[no_wear_index*window_points:no_wear_index*window_points+window_points]=['NaN']*len(x_axis_mother_wear[no_wear_index*window_points:no_wear_index*window_points+window_points])
			y_axis_mother_wear[no_wear_index*window_points:no_wear_index*window_points+window_points]=['NaN']*len(y_axis_mother_wear[no_wear_index*window_points:no_wear_index*window_points+window_points])
			z_axis_mother_wear[no_wear_index*window_points:no_wear_index*window_points+window_points]=['NaN']*len(z_axis_mother_wear[no_wear_index*window_points:no_wear_index*window_points+window_points])

			print "mother plotting no wear"
			#ploty.figure(7)
			ax7.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(x_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),x_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'k-')
			#ploty.draw()
			#ploty.figure(8)
			ax8.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(y_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),y_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'k-')
			#ploty.draw()
			#ploty.figure(9)
			ax9.plot(range(no_wear_index*window_points,no_wear_index*window_points+len(z_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points])),z_axis_mother[no_wear_index*window_points:no_wear_index*window_points+window_points],'k-')
			#ploty.draw()


	#create csv and save

	#infant torso
	csv_rows_infant_torso = zip(x_axis_infant_torso_wear,y_axis_infant_torso_wear,z_axis_infant_torso_wear)
	df_infant_torso = pandas.DataFrame(csv_rows_infant_torso)
	print df_infant_torso.to_csv(str(seq)+'_infant_torso_timed_wear.csv', index=False, header=False)

	#infant ankle
	csv_rows_infant_ankle = zip(x_axis_infant_ankle_wear,y_axis_infant_ankle_wear,z_axis_infant_ankle_wear)
	df_infant_ankle = pandas.DataFrame(csv_rows_infant_ankle)
	print df_infant_ankle.to_csv(str(seq)+'_infant_ankle_timed_wear.csv', index=False, header=False)

	#mother
	csv_rows_mother = zip(x_axis_mother_wear,y_axis_mother_wear,z_axis_mother_wear)
	df_mother = pandas.DataFrame(csv_rows_mother)
	print df_mother.to_csv(str(seq)+'_mother_timed_wear.csv', index=False, header=False)		

	
	#save plots to png
	fig.savefig(str(seq)+'_no_wear_time_labeled.png')   # save the figure to file
	ploty.close(fig)
	'''
	ploty.figure(1)
	ploty.show(block=False)
	ploty.savefig(str(seq)+'_infant_torso_timed_wear_x_axis.png')
	ploty.figure(2)
	ploty.show(block=False)
	ploty.savefig(str(seq)+'_infant_torso_timed_wear_y_axis.png')
	ploty.figure(3)
	ploty.show(block=False)
	ploty.savefig(str(seq)+'_infant_torso_timed_wear_z_axis.png')

	ploty.figure(4)
	ploty.show(block=False)
	ploty.savefig(str(seq)+'_infant_ankle_timed_wear_x_axis.png')
	ploty.figure(5)
	ploty.show(block=False)	
	ploty.savefig(str(seq)+'_infant_ankle_timed_wear_y_axis.png')
	ploty.figure(6)
	ploty.show(block=False)
	ploty.savefig(str(seq)+'_infant_ankle_timed_wear_z_axis.png')

	ploty.figure(7)
	ploty.show(block=False)
	ploty.savefig(str(seq)+'_mother_timed_wear_x_axis.png')
	ploty.figure(8)
	ploty.show(block=False)
	ploty.savefig(str(seq)+'_mother_timed_wear_y_axis.png')
	ploty.figure(9)
	ploty.show(block=False)
	ploty.savefig(str(seq)+'_mother_timed_wear_z_axis.png')

	ploty.close('all')
	'''
