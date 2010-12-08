#!/bin/sh

tmp_file=`mktemp`

/usr/bin/env python 2>$tmp_file >$tmp_file << EOF

import os
import sys

ContextMap = {'apps' : 'Applications',
              'stock': 'Stock',
              'stock_deprecated': 'Stock',
              'stock_evolution': 'Stock',
              'devices' : 'Devices',
              'filesystems' : 'FileSystems',
              'mimetypes' : 'MimeTypes',
              'emblems' : 'Emblems' }
##########

index_file = open('index.theme', 'w')

header_file = open('header')
for line in header_file.readlines():
	index_file.write(line)



##########

dirs = os.listdir('./')

theme_dirs = []

for dir in dirs:
	if dir == '.' or dir == '..':
		continue
	if not os.path.isdir(dir):
		continue
	
	dirproperties = {}
	if dir == 'large':
		dirproperties['Size'] = 128
		dirproperties['Type'] = 'Scalable'
		dirproperties['MinSize'] = '80' #whatever
	elif dir == 'normal':
		dirproperties['Size'] = 60
		dirproperties['Type'] = 'Scalable'
	elif dir == 'gnome-spinner':
		dirproperties['Size'] = 30
		dirproperties['Type'] = 'Scalable'
	elif dir == 'small':
		dirproperties['Size'] = 22
		dirproperties['Type'] = 'Scalable'
	elif dir == 'x-small':
		dirproperties['Size'] = 16
		dirproperties['Type'] = 'Scalable'
		dirproperties['MaxSize'] = 16
	else:
		continue #does not exist. jump directory
	
	subdirs = os.listdir(dir)
	
	for subdir in subdirs:
		if subdir == '.' or subdir == '..':
			continue
		if not os.path.isdir(dir+'/'+subdir):
			continue
		
		subdirproperties = dirproperties.copy()
		
		subdirproperties['Path'] = dir+'/'+subdir
		
		subdirproperties['Context'] = ContextMap[subdir]
		
		theme_dirs += [subdirproperties]
		
		if subdir == 'emblems':
			#the following is a hack, to decrease the size of the emblems
			if subdirproperties['Size'] == 22:
				subdirproperties['Size'] = 44
			elif subdirproperties['Size'] == 60:
				subdirproperties['Size'] = 120
			else:
				print 'Emblems in large?'
				
			if 'MaxSize' in subdirproperties:
				subdirproperties.pop('MaxSize')

index_file.write('Directories=')

#first normal, after that small and large
#ie. prefere small/large
def sort_func(key1, key2):
	if key1['Size'] == key2['Size']:
		return 0
	
	if key1['Size'] == 60:
		return -1
	if key2['Size'] == 60:
		return 1
	return 0
	
#	if key1['Size'] < key2['Size']:
#		return -1
#	elif key1['Size'] > key2['Size']:
#		return 1
#	else:	return 0

theme_dirs.sort(sort_func)

first = True
for dir in theme_dirs:
	if first:
		first = False
	else:
		index_file.write(',')
	
	index_file.write(dir['Path'])
	
index_file.write('\n\n\n\n')

for dir in theme_dirs:
	index_file.write('['+dir['Path']+']\n')
	for (key, value) in dir.items():
		if key != 'Path':
			index_file.write(key+'='+str(value)+'\n')
			
	index_file.write('\n')

EOF

if [ "`cat $tmp_file`" != "" ]; then
	cat $tmp_file | zenity --text-info --title "ERROR while creating theme.index"
fi;

rm -f $tmp_file
