import seaborn as sns
from netCDF4 import Dataset
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats
from matplotlib import animation
from matplotlib import cm
from matplotlib import rc
import pickle
import matplotlib.style
import matplotlib as mpl
rc('font',**{'family':'sans-serif','sans-serif':['Helvetica']}) # To use Latex and set the font
rc('text', usetex=False) # To use LaTex 
mpl.rcParams['lines.linewidth'] = 0.3 # Change the default linewidth


pt=256
prefix="/Users/jiachenlu/Database/NEW/32_60/"
x=np.linspace(0,4480,pt)
y=np.linspace(0,4480,pt)
z = Dataset(prefix + 'profiles.001.nc')
z=z.variables['zt'][:]
xv,zv=np.meshgrid(x,z)
qt = Dataset(prefix + 'qt.nc')
qt = qt.variables['qt'][:,:,:,:]
w = Dataset(prefix + 'w.nc')
w = w.variables['w'][:,:,:,:]

qt_temp=np.reshape(qt[1,26,:,:], pt**2)
w_temp=np.reshape(w[1,26,:,:], pt**2)
qt_avg=np.mean(qt_temp)
w_avg=np.mean(w_temp)
w_temp=w_temp-w_avg
qt_temp=qt_temp-qt_avg
qt_temp=qt_temp*1000




# Plot the PDF for 400m(26),800m(79),1200m(159),1600(239)
plt.subplots(2, 2)
plt.subplot(2, 2, 1)
qt_temp=np.reshape(qt[1,26,:,:], pt**2)
w_temp=np.reshape(w[1,26,:,:], pt**2)
qt_avg=np.mean(qt_temp)
w_avg=np.mean(w_temp)
w_temp=w_temp-w_avg
qt_temp=qt_temp-qt_avg
qt_temp=qt_temp*1000
sns.set_style("white")
ax=sns.kdeplot(qt_temp[:], w_temp[:], gridsize=100, cut=10,cbar=False,shade=False,cmap='tab20',norm=mpl.colors.LogNorm(0.0001,1.20),levels=np.logspace(-3, 1, 14))
#ax.set_cmap=mpl.colors.LogNorm(1, 10)
#ax.set_title('Joint PDF for $q_t$ and w at 400m')
ax.set_ylabel('$w-\overline{w} \ [m \ s^{-1}]$')
ax.set_xlabel('$q_t-\overline{q_t} \ [g \ kg^{-1}]$')
ax.grid(color='k', linestyle=':', linewidth=0.5)
plt.subplot(2, 2, 2)
ax=()
qt_temp=np.reshape(qt[1,79,:,:], pt**2)
w_temp=np.reshape(w[1,79,:,:], pt**2)
qt_avg=np.mean(qt_temp)
w_avg=np.mean(w_temp)
w_temp=w_temp-w_avg
qt_temp=qt_temp-qt_avg
qt_temp=qt_temp*1000
sns.set_style("white")
ax=sns.kdeplot(qt_temp[:], w_temp[:], gridsize=100, cut=10,cbar=False,shade=False,cmap='tab20',norm=mpl.colors.LogNorm(0.0001,1.20),levels=np.logspace(-3, 1, 14))
#ax.set_cmap=mpl.colors.LogNorm(1, 10)
#ax.set_title('Joint PDF for $q_t$ and w at 400m')
ax.set_ylabel('$w-\overline{w} \ [m \ s^{-1}]$')
ax.set_xlabel('$q_t-\overline{q_t} \ [g \ kg^{-1}]$')
ax.grid(color='k', linestyle=':', linewidth=0.5)
#ax.figure.savefig(prefix+'1.eps', format='eps', dpi=1000)
plt.subplot(2, 2, 3)
ax=()
qt_temp=np.reshape(qt[1,159,:,:], pt**2)
w_temp=np.reshape(w[1,159,:,:], pt**2)
qt_avg=np.mean(qt_temp)
w_avg=np.mean(w_temp)
w_temp=w_temp-w_avg
qt_temp=qt_temp-qt_avg
qt_temp=qt_temp*1000
sns.set_style("white")
ax=sns.kdeplot(qt_temp[:], w_temp[:], gridsize=100, cut=10,cbar=False,shade=False,cmap='tab20',norm=mpl.colors.LogNorm(0.0001,5),levels=np.logspace(-3, 1, 14))
#ax.set_cmap=mpl.colors.LogNorm(1, 10)
#ax.set_title('Joint PDF for $q_t$ and w at 400m')
ax.set_ylabel('$w-\overline{w} \ [m \ s^{-1}]$')
ax.set_xlabel('$q_t-\overline{q_t} \ [g \ kg^{-1}]$')
ax.grid(color='k', linestyle=':', linewidth=0.5)
#ax.figure.savefig(prefix+'1.eps', format='eps', dpi=1000)
plt.subplot(2, 2, 4)
ax=()
qt_temp=np.reshape(qt[1,239,:,:], pt**2)
w_temp=np.reshape(w[1,239,:,:], pt**2)
qt_avg=np.mean(qt_temp)
w_avg=np.mean(w_temp)
w_temp=w_temp-w_avg
qt_temp=qt_temp-qt_avg
qt_temp=qt_temp*1000
sns.set_style("white")
ax=sns.kdeplot(qt_temp[:], w_temp[:], gridsize=100, cut=10,cbar=False,shade=False,cmap='tab20',norm=mpl.colors.LogNorm(0.0001,5),levels=np.logspace(-3, 1, 14))
#ax.set_cmap=mpl.colors.LogNorm(1, 10)
#ax.set_title('Joint PDF for $q_t$ and w at 400m')
ax.set_ylabel('$w-\overline{w} \ [m \ s^{-1}]$')
ax.set_xlabel('$q_t-\overline{q_t} \ [g \ kg^{-1}]$')
ax.grid(color='k', linestyle=':', linewidth=0.5)

ax.figure.savefig(prefix+'2.eps', format='eps', dpi=1000)
