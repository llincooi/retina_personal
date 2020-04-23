#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sun Sep 23 07:58:45 2018

@author: nghdavid
"""
import os
movie_list = ['spon']#Movies we played

r = open('real_play_list.txt','r')#Today arrangement
f = open('all_list.txt','a')


#Read file
for line in r:
    l = line.split(' ')
    l = '\n' + l[0][:-4]
    
    movie_list.append(l)#Get file name
    #f.write(l[0][:-4])
    #f.write('\n')
f.writelines(movie_list)
    



