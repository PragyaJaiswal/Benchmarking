import os, sys
import json, csv
<<<<<<< HEAD
=======
import matplotlib.pyplot as plt
import numpy as np
import pylab
>>>>>>> 11926d5... Made aesthetic modifications to plots. Added subplots.

data = './data/'
plot_data = './data/plot_data/'
out = './output/'

global dictionary
dictionary = {}

def path_to_dir(out):
	if not os.path.exists(out) and not out == '':
		os.makedirs(out)

	if out == '':
		home = os.path.expanduser('~')
		out = './output/'
		os.makedirs(out)


def parse(out):
	files = os.listdir(data)
	count = 0
	for file in files:
		print file
		with open(str(data) + file, 'r') as tsv:
			reader = csv.reader(tsv, dialect = 'excel-tab', skipinitialspace = True)
			next(reader, None)
			for line in reader:
				IA = []
				PP = []
				count+=1
				print 'Line Number: ' + str(count)
				print 'Line: ' + str(line)
				for index, ele in enumerate(line):
					if index >= 5 and index < 13:
						print 'index: ' + str(index)
						print 'val: ' + str(line[index])
						stop = int(index+8)
						IA.append(ele)
						PP.append(line[stop])
						# if index == stop:
						# 	break
<<<<<<< HEAD
				save_dict(IA, PP, str(file))
=======
				dictionary = save_dict(IA, PP, str(file))
>>>>>>> 11926d5... Made aesthetic modifications to plots. Added subplots.
				# if count == 10:
				# 	break
		plot_stat(dictionary, file, str(out + file + '/'))


def save_dict(IA, PP, file):
	print IA
	print PP
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
		# dictionary.setdefault(keys[index], {}).append('x')
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

	jsonify(dictionary)
	# jsonify(dictionary, './data/plot_data/')


# def jsonify(dict):
# 	d = json.dumps(dict, sort_keys=True, indent=4, separators=(',', ':'))
# 	# print d
# 	with open('./data/plot_data/IAvsPP.json', 'w') as outfile:
# 		outfile.write(d)


def jsonify(dict, location=None):
	a = json.dumps(dict, sort_keys=True, indent=4, separators=(',', ': '))
	with open('./data/plot_data/IAvsPP' + '.json', 'a') as outfile:
		outfile.write(a)
	with open('./data/plot_data/IAvsPP' + '.py', 'a') as outfile:
		outfile.write('plot_data = ')
		outfile.write(a)


<<<<<<< HEAD
=======
# Scatter plot, linear fit and correlation coefficient. Save figures..
def plot_stat(dictionary, file, location=None):
	fig = pylab.figure()
	count = 0
	lis = sorted(dictionary.keys())

	for key in lis:
		count+=1
		axes = dictionary.get(key)

		# fig = pylab.figure()
		filename = str(file) + '.png'
		
		fig.add_subplot(4, 2, (count))
		pylab.ticklabel_format(style='sci', axis = 'both', scilimits=(0,0))
		pylab.plot(axes.get('x'), axes.get('y'), str(1), color='0.4', marker='o', markeredgecolor='0.4')
		pylab.xlabel('iTRAQanalyzer')
		pylab.ylabel('Protein Pilot')
		pylab.rc('font', size=5.5)

		# z[0] denotes slope, z[1] denotes the intercept
		z = np.polyfit(axes.get('x'), axes.get('y'), 1)
		p = np.poly1d(z)
		coeff = np.corrcoef(axes.get('x'), axes.get('y'))

		pylab.plot(axes.get('x'), p(axes.get('x')), "r-", color='0')
		# print "y=%.6fx+(%.6f)"%(z[0],z[1])
		print "y=%.6fx+(%.6f)"%(z[0],z[1])
		pylab.text(0.1, 0.3, "y=%.6fx+(%.6f)"%(z[0],z[1]))
		print str(coeff[0][1])
		pylab.text(1, 0.6, "Coeff of corr: " + str(coeff[0][1]))
		pylab.title(str(key))
		pylab.tight_layout()

		graph = pylab.gcf()
		graph.canvas.set_window_title(str(filename))		
	
	pylab.show()
	graph.savefig(location + '/' + filename)
	pylab.close()


# Scatter plot and save figures
def plot(dictionary, file, location=None):
	# print(dictionary.keys())
	for key in dictionary:
		axes = dictionary.get(key)
		# break
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


>>>>>>> 11926d5... Made aesthetic modifications to plots. Added subplots.
def parse_column_wise():
	pass

def skip_header(tsv):
	has_header = csv.Sniffer().has_header(tsv.read())
	return has_header

path_to_dir(out)
path_to_dir(plot_data)
parse(out)