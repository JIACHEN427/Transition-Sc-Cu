clear
clc
%% Code used to stitch the field dump from dales model with hourly convention. JCLu UC San Diego 2018.12
%ncdisp('fielddump.000.000.002.nc')
%size(ql)% 300, 300, 167, 20; %% 320 320 167 240
%% Get varibles in 3-D field with low memory usage in COARDS convention(need to have specific time axes).
%% Configure here
%% Save the data for animation in Paraview with a loop of 1hr with minimum memory usage.
x_pts = 240; % points in x direction
y_pts = 20;  % points in y direction
z_pts = 200; % points in z direction
nx = 1; % Number of cores in x direction                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
ny = 12; % Number of cores in y direction
save_interval = 3600/60; 
Varname = 'ql';
aim_dir = '/media/jiachen/DATA/200/';
expnr = '.002';
start_hr = 1;
end_hr = 40; %  if(ls60/512) 1 and 2
%% End of Configure
for loop = start_hr:end_hr
start_time = (loop - 1)*save_interval + 1;
end_time = loop*save_interval;
time=ncread([aim_dir 'fielddump.000.000' expnr '.nc'],'time');
time = time(start_time:end_time,1);
Var = zeros(x_pts*nx,y_pts*ny,z_pts,end_time - start_time + 1);
nccreate([aim_dir [Varname '_' num2str(loop)] '.nc'],Varname,'Dimensions',{'zt',x_pts,'xm',y_pts*ny,'yt',z_pts,'time',end_time-start_time+1});
for n=1:ny % Sweep over the whole domain
nn=num2str(n-1,'%02d');
temp=ncread(['fielddump.000.0' nn expnr  '.nc'],Varname,[1 1 1 start_time],[x_pts y_pts z_pts save_interval],[1 1 1 1]);
Var(:,(n-1)*y_pts+1:n*y_pts,:,:) = squeeze(temp(:,:,:,:));
clear temp
end

ncwrite([aim_dir [Varname '_' num2str(loop)] '.nc'],Varname,Var)
nccreate([aim_dir [Varname '_' num2str(loop)] '.nc'],'time','Dimensions',{'time',end_time-start_time+1});
ncwrite([aim_dir [Varname '_' num2str(loop)] '.nc'],'time',time)
ncwriteatt([aim_dir [Varname '_' num2str(loop)] '.nc'], 'time', 'units', 'seconds since 2000-00-00 00:00:00 +0:00');
clear Var
end
