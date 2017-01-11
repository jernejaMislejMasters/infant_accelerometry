import sys
import pandas
import numpy as np
import matplotlib.pyplot as ploty
from scipy.signal import medfilt
import matplotlib.lines as mlines
import matplotlib.patches as mpatches

#plot entire signal x and night time
ploty.figure(10)
ploty.plot(range(0,len(x_axis)),x_axis,'b-')
ploty.ylabel('g')
ploty.xlabel('samples')
#ploty.axis([0,len(x_axis),-6,6])
ploty.title('neki'+' x axis')
ploty.xticks(range(0,len(x_axis),10),[str(x)+" h" for x in range(0,10)])
ploty.axvspan(first_night_begin_index, first_night_end_index, facecolor='b', alpha=0.5)
ploty.axvspan(second_night_begin_index, second_night_end_index, facecolor='b', alpha=0.5)
blue_shade = mpatches.Patch(color='blue', alpha=0.5, label='night (21.00:7.00)')
ploty.legend(handles=[blue_shade])
red_mark = mlines.Line2D([], [], color='red', linewidth=1, linestyle='-', label='no wear')
ploty.legend(handles=[red_mark])
ploty.show(block=False)
