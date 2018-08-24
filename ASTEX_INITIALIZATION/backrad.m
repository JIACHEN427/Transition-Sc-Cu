clear
clc

%%
lev=ncread('input.nc','lev');
o3=ncread('input.nc','o3mmr');
T=ncread('input.nc','T');
q=ncread('input.nc','qv');


nccreate(['/Users/jiachenlu/Database/Preprocess/' 'backrad.inp.002.nc'],'lev','Dimensions',{'lev',length(lev)});
nccreate(['/Users/jiachenlu/Database/Preprocess/' 'backrad.inp.002.nc'],'o3','Dimensions',{'lev',length(lev)});
nccreate(['/Users/jiachenlu/Database/Preprocess/' 'backrad.inp.002.nc'],'T','Dimensions',{'lev',length(lev)});
nccreate(['/Users/jiachenlu/Database/Preprocess/' 'backrad.inp.002.nc'],'q','Dimensions',{'lev',length(lev)});

ncwrite(['/Users/jiachenlu/Database/Preprocess/' 'backrad.inp.002.nc'],'lev',lev);
ncwrite(['/Users/jiachenlu/Database/Preprocess/' 'backrad.inp.002.nc'],'o3',o3);
ncwrite(['/Users/jiachenlu/Database/Preprocess/' 'backrad.inp.002.nc'],'T',T);
ncwrite(['/Users/jiachenlu/Database/Preprocess/' 'backrad.inp.002.nc'],'q',q);
