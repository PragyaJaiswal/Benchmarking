import os, sys
import json, csv
# from sympy import pprint as pp
# from sympy.abc import R
import matplotlib.pyplot as plt
from matplotlib import gridspec
import numpy as np
import pylab


data = './data/'
out = './output/'

global dictionary
dictionary = {}


'''
Create the specified directory, if not exists.
'''
def path_to_dir(out):
	if not os.path.exists(out) and not out == '':
		os.makedirs(out)

	if out == '':
		home = os.path.expanduser('~')
		out = './output/'
		os.makedirs(out)

'''
Parse tsv file and get corresponding columns in array.
'''

def parse(out):
	files = os.listdir(data)
	count = 0
	line_num = 0
	for file in files:
		count+=1
		print 'Processing file: ' + str(count) + ' of ' + str(len(files))
		print 'File name: ' + str(file)
		with open(str(data) + file, 'r') as tsv:
			reader = csv.reader(tsv, dialect = 'excel-tab', skipinitialspace = True)
			next(reader, None)
			for line in reader:
				IA = []
				PP = []
				line_num+=1
				# print 'Line Number: ' + str(count)
				# print 'Line: ' + str(line)
				for index, ele in enumerate(line):
					if index >= 5 and index < 13:
						# print 'index: ' + str(index)
						# print 'val: ' + str(line[index])
						stop = int(index+8)
						if ele == '' or ele == None:
							ele = 0.0
						if line[stop] == '' or line[stop] == None:
							line[stop] = 0.0

						IA.append(float(ele))
						PP.append(float(line[stop]))
				save_dict(IA, PP, str(file))
				dictionary = save_dict(IA, PP, str(file))
				# if count == 10:
				# 	break
		plot_stat(dictionary, file, str(out + '/'))


'''
Save data in dictionary format.
'''

def save_dict(IA, PP, file):
	keys = [
		'113',
		'114',
		'115',
		'116',
		'117',
		'118',
		'119',
		'121'
	]

	for index, ele in enumerate(IA):
		if str(keys[index]) not in dictionary:
			dictionary[str(keys[index])] = {}
			if 'x' not in dictionary[str(keys[index])]:
				dictionary[str(keys[index])]['x'] = []
				dictionary[str(keys[index])]['y'] = []
				dictionary[str(keys[index])]['x'].append(ele)
				dictionary[str(keys[index])]['y'].append(PP[index])
			else:
				dictionary[str(keys[index])]['x'].append(ele)
				dictionary[str(keys[index])]['y'].append(PP[index])
		else:
			dictionary[str(keys[index])]['x'].append(ele)
			dictionary[str(keys[index])]['y'].append(PP[index])

	return dictionary
	# jsonify(dictionary, './data/plot_data/')



'''
Scatter plot, linear fit and correlation coefficient.
Display stat details on sub plots.
Save figures.
'''

def plot_stat(dictionary, file, location=None):
	fig = pylab.figure(figsize=(7,10))
	# gs = gridspec.GridSpec(4, 2, width_ratios=[.5,.5])
	count = 0
	lis = sorted(dictionary.keys())

	for key in lis:
		count+=1
		axes = dictionary.get(key)

		filename = str(file[:-4]) + '.png'
		
		ax = fig.add_subplot(4, 2, (count), adjustable='box-forced')
		ax.ticklabel_format(style='sci', axis = 'both', scilimits=(0,0), fontsize = 5.5)
		ax.plot(axes.get('x'), axes.get('y'), str(1), color='0.7',
			marker='o', markeredgecolor='0.3', alpha=0.5)
		ax.set_xlabel('iTRAQAnalyzer', fontsize = 5.5)
		ax.set_ylabel('Protein Pilot', fontsize = 5.5)
		pylab.rc('font', size=5.5)

		# z[0] denotes slope, z[1] denotes the intercept
		z = np.polyfit(axes.get('x'), axes.get('y'), 1)
		p = np.poly1d(z)
		coeff = np.corrcoef(axes.get('x'), axes.get('y'))

		ax.plot(axes.get('x'), p(axes.get('x')), "r-", color='0')

		# print "y=%.6fx+(%.6f)"%(z[0],z[1])
		# print coeff[0][1]
		
		if z[1] >= 0:
			ax.annotate("y = %.6fx + %.6f "%(z[0],z[1]), xy=(0.97,0.10), xycoords='axes fraction',
				fontsize=5.5, horizontalalignment='right', verticalalignment='bottom')
		else:
			ax.annotate("y = %.6fx - %.6f "%(z[0],abs(z[1])), xy=(0.97,0.10), xycoords='axes fraction',
				fontsize=5.5, horizontalalignment='right', verticalalignment='bottom')
		
		ax.annotate("$\mathregular{R^2}$" + ': ' + str(round(coeff[0][1], 4)), xy=(0.97,0.04), xycoords='axes fraction',
			fontsize=5.5, horizontalalignment='right', verticalalignment='bottom')
		pylab.title(str(key))
		fig.tight_layout()

		graph = pylab.gcf()
		graph.canvas.set_window_title(str(filename))		
	
	# pylab.show()
	# fig.dpi = 100
	graph.savefig(location + '/' + filename)
	pylab.close()


'''
Scatter plot, linear fit and correlation coefficients.
Does not show equations and correlation coefficients on subplots.
Save figures.
'''

def plot_stat_without_eq(dictionary, file, location=None):
	fig = pylab.figure()
	count = 0
	print(type(dictionary))
	lis = sorted(dictionary.keys())

	for key in lis:
		count+=1
		axes = dictionary.get(key)

		filename = str(file) + '.png'
		
		fig.add_subplot(4, 2, (count))
		pylab.ticklabel_format(style='sci', axis = 'both', scilimits=(0,0))
		pylab.plot(axes.get('x'), axes.get('y'), str(1), color='0.4', marker='o', markeredgecolor='0.4')
		pylab.xlabel('iTRAQAnalyzer')
		pylab.ylabel('Protein Pilot')
		pylab.rc('font', size=5.5)

		# z[0] denotes slope, z[1] denotes the intercept
		z = np.polyfit(axes.get('x'), axes.get('y'), 1)
		p = np.poly1d(z)
		coeff = np.corrcoef(axes.get('x'), axes.get('y'))

		pylab.plot(axes.get('x'), p(axes.get('x')), "r-", color='0')
		print "y=%.6fx+(%.6f)"%(z[0],z[1])
		# pylab.text(0.1, 0.3, "y=%.6fx+(%.6f)"%(z[0],z[1]))
		print str(coeff[0][1])
		pylab.title(str(key))
		pylab.tight_layout()

		graph = pylab.gcf()
		graph.canvas.set_window_title(str(filename))

	# pylab.show()
	graph.savefig(location + '/' + filename)
	pylab.close()


'''
Scatter plot and save figures
'''

def plot(dictionary, file, location=None):
	# print(dictionary.keys())
	for key in dictionary:
		axes = dictionary.get(key)
		# print axes
		print len(axes.get('y'))
		print len(axes.get('x'))
		
		fig = plt.figure()
		ax = fig.add_subplot(1, 1, 1)

		# ax.scatter(axes.get('x'), axes.get('y'), c='r', marker='o')
		ax.scatter(axes.get('x'), axes.get('y'))
		ax.set_xlabel('IA')
		ax.set_ylabel('PP')

		filename = str(file) + '--' + str(key) + '.png'
		fig.canvas.set_window_title(str(filename))
		graph = plt.gcf()
		plt.show()
		# plt.draw()

		graph.savefig(location + '/' + filename)
		plt.close()


def parse_column_wise():
	pass

def skip_header(tsv):
	has_header = csv.Sniffer().has_header(tsv.read())
	return has_header

path_to_dir(out)
parse(out)