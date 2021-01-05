#!/usr/bin/env python
# coding: utf-8


#necessary imports
import PySimpleGUI as sg 
import clingo
import matplotlib.pyplot as plt
import numpy as np
import cartopy.crs as ccrs
import cartopy.feature as cfeature
import cartopy
from time import sleep
import matplotlib
from IPython import get_ipython
import sys

#read all destinations which are given in the _base_instance.lp-file
content_base = open('_base_instance.lp', 'r').read()
split_1 = content_base.split('\n')

keys = []
vals = []
#zip the destinations into a dictionary
for e in split_1[3:-1]:
    new_str = e.replace("dest(","").replace(").","").replace('Ã©','e').replace('"','').replace(',','+').replace('+ ','+')
    split_ = new_str.split('+')
    keys.append(split_[2])
    vals.append((split_[0],split_[1],split_[3]))
    
to_dict = dict(zip(keys,vals))

#create the elements for the first gui using the dictionary zipped before to display a selection of starting points
layout = [[sg.Text('Weeks')],
          [sg.InputText('3')], 
          [sg.Text('Money - US-$')],
          [sg.InputText('4000')],
          [sg.Text('Choose a Starting Point:')],
          [sg.Listbox(values=keys, size=(35, 3),default_values='Berlin',enable_events=True)],
                 [sg.Button('submit'), sg.Button('Exit')]]        

window = sg.Window('ASP Travel Planning Tool', layout)    

while True:            
    #read the input values
    event, values = window.Read()
    
    
    if event is None or event == 'Exit':
        break
    if event == 'submit':
        #components for progress window
        layout_progress_window = [[sg.Text('Calculating route...')],[sg.ProgressBar(max_value=10, orientation='h', size=(20, 20), key='progress')]]
        window_progress = sg.Window('Route Design Progress', layout_progress_window, finalize=True)
        progress_bar = window_progress['progress']
        
        #read the values from the initial gui and create a lp-file holding a "traveler profile"
        weeks = values[0]
        money = values[1]
        start = values[2][0]  
        f= open("traveler.lp","w+")
        f.write('money("'+money+'").weeks("'+weeks+'").start_at("'+to_dict[start][0]+'","'+to_dict[start][1]+'","'+start+'","'+to_dict[start][2]+'").')
        f.close()

        progress_bar.update_bar(1)         
        
        #instantiate clingo object and load necessary files, including the traveler profile created before

        ctl = clingo.Control()
        ctl.load("_base_instance.lp")

        #load one of the three preference files 
        ctl.load("preference_001.lp")        
        ctl.load("solution.lp")

        #load the traveler.lp created before
        ctl.load("traveler.lp")

        #ground and solve       
        ctl.ground([("base", [])])
        ctl.configuration.solve.models="1"
        models = []
        with ctl.solve(yield_=True) as handle:
            for model in handle:
                #collect the stable models (i.e. "solutions")
                models.append(str(model))

        if len(models)==0:
            print('Result: "unsatisfiable"')
            print('Unfortunately you did not enter numbers or you do not have enough money for the time you want to travel.')
            raise SystemExit("exit the script!")

        
        #take the first resulting stable model,
        geo_data_content = models[0] 
        #cleaning and splitting of the result string 
        geo_split = geo_data_content.replace("geo_data(", "").replace(")",",").replace('"','').replace('â”œÂ®','e').replace("\' ","").split(",")

        
        progress_bar.update_bar(4)         
        
        i=0
        singles = []
        #get the traveled destinations as singles
        while i<len(geo_split)-4:
            singles.append([geo_split[i],geo_split[i+1],geo_split[i+2],geo_split[i+3]])
            i+=4
        
        progress_bar.update_bar(5)         
        pairwise =[]
        i =0
        #obtain pairwise connection
        while i<len(singles):
            pairwise.append([singles[i],singles[i+1]])
            i+=2
        
        progress_bar.update_bar(6)         

        #create the figure to plot the result route in
        plt.figure(figsize=(12,8))
        ax = plt.axes(projection=ccrs.Robinson())
        ax.stock_img()
        i=0
        
        progress_bar.update_bar(7)       

        for elem in pairwise:
            lons= []
            lons.append(float(elem[0][2]))
            lons.append(float(elem[1][2]))

            lats = []
            lats.append(float(elem[0][3]))
            lats.append(float(elem[1][3]))

            #draw lines and dots to show the destinations and the connections:
            ax.plot(lons, lats, transform=ccrs.Geodetic(), color='purple',lw=2.0,ls='--')
            ax.plot(lons, lats, markersize=13,marker='.',linestyle = '', color = 'black',transform=ccrs.Geodetic())
            ax.text(float(elem[0][2]),float(elem[0][3]),elem[0][0],horizontalalignment='right',verticalalignment='top',fontsize=18,transform=ccrs.Geodetic())
            i+=1
         
        progress_bar.update_bar(8)         
        
        ax.coastlines()
        ax.set_global()
        plt.savefig('result_maps/result.png')

        progress_bar.update_bar(9)        
        window_progress.close()

        layout_res_ =[[sg.Image('result_maps/result.png', key='key1', size=(990, 550))]]
        window_res_ = sg.Window('Route Suggestion: ', layout_res_,size=(1000,570)) 
        event_r_ = window_res_.read()
        
        window_res_.close()
        
    
#####
window.close()
quit()









