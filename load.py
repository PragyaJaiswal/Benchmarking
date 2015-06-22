import os, sys
import json, csv

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
				save_dict(IA, PP, str(file))
				# if count == 10:
				# 	break


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


def parse_column_wise():
	pass

def skip_header(tsv):
	has_header = csv.Sniffer().has_header(tsv.read())
	return has_header

path_to_dir(out)
path_to_dir(plot_data)
parse(out)