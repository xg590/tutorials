# pip install basemap basemap-data basemap-data-hires 

from mpl_toolkits.basemap import Basemap
import matplotlib.pyplot as plt, pandas as pd, numpy as np
from matplotlib.patches import Polygon 

display(pd.read_csv('cn_map/CHN_adm1.csv',index_col=0).head(3))

#Basemap API : https://matplotlib.org/basemap/api/basemap_api.html

fig, ax = plt.subplots(figsize=(3,3))

myMap = Basemap(llcrnrlon=80, 
              llcrnrlat=0, 
              urcrnrlon=160, 
              urcrnrlat=56,
              resolution='c', # 'c','l','i','h' or 'f'
              projection='cass', 
              lat_0 = 45,
              lon_0=115,
              ax=ax)

#myMap.shadedrelief()   

shp_info = myMap.readshapefile("cn_map/CHN_adm1",'xyz123', drawbounds=True)  

for info, shp in zip(myMap.xyz123_info, myMap.xyz123):
    proid = info['NAME_1']   
    if proid == 'Guangdong': 
        poly = Polygon(shp, facecolor='g', edgecolor='c', lw=3)  
        ax.add_patch(poly)

myMap.drawparallels(np.arange(0.,90,10.), labels=[1,0,0,0], fontsize=10) 
myMap.drawmeridians(np.arange(80.,140.,20.), labels=[0,0,0,1], fontsize=10) 


myMap.drawcoastlines()   
myMap.drawcountries()    
plt.show() 
