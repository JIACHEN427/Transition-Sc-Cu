clear
clc
%ncdisp('fielddump.000.000.001.nc')
%ncread('fielddump.000.000.001.nc','ql')
%size(ql)% 300, 300, 167, 20; %% 320 320 167 240
%% To get varibles in 3-D field with low memory usage in COARDS convention(need to have specific time axes) so it can be read by paraview
%% To fix the NaN value in the 3D field
%% Configure here
x_pts=256;
y_pts=8;
z_pts=427;
nx=1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
ny=32;
start_time=1;
end_time=60;
Varname='qr'; %% thl for liquid water potential temperature [K], qt for total water mixing ratio [g/kg], ql for liquid water mixing ratio [g/kg], w for vertical velocity [m/s]
aim_dir='/Users/jiachenlu/Database/NEW/';
expnr='.001';
%% End of Configure
time=ncread(['fielddump.000.000' expnr '.nc'],'time');
time=time(start_time:end_time,1);
Var=zeros(x_pts*nx,y_pts*ny,z_pts,end_time-start_time+1);
for n=1:ny
    if n<11
        nn=['0' num2str(n-1)];
    else
        nn=num2str(n-1);
    end
temp=ncread(['fielddump.000.0' nn expnr  '.nc'],Varname);
Var(:,(n-1)*y_pts+1:n*y_pts,:,:) = squeeze(temp(:,:,:,start_time:end_time));
clear temp
end
%% Fix the weird unit arrangement in DALES
if isequal(Varname,'thl')
    Var=Var*1e-2+300;
elseif isequal(Varname,'w')
    Var=Var*1e-3;
else
    Var=Var*1e-5;
end
%% Fix the nan value in 3D field
avg_var=zeros(z_pts,size(time,1));
for i=1:z_pts
    for j=1:size(time,1)
        avg_var(i,j)=nanmean(nanmean(squeeze(Var(:,:,i,j))));
    end
end
for i=1:z_pts
    for j=1:size(time,1)
        temp_var=squeeze(Var(:,:,i,j));
         for n=1:x_pts
            for m=1:x_pts
                if isnan(temp_var(m,n)) == 1
                    Var(m,n,i,j)=avg_var(i,j);
                end
            end
         end
    end
end
%% Write data in netcdf form and add a time axis so it can be read by paraview
nccreate([aim_dir Varname '.nc'],Varname,'Dimensions',{'zt',x_pts,'xm',y_pts*ny,'yt',z_pts,'time',end_time-start_time+1});
ncwrite([aim_dir Varname '.nc'],Varname,Var)
nccreate([aim_dir Varname '.nc'],'time','Dimensions',{'time',end_time-start_time+1});
ncwrite([aim_dir Varname '.nc'],'time',time)
ncwriteatt([aim_dir Varname '.nc'], 'time', 'units', 'seconds since 2010-11-9 00:00:00 +0:00');


