clear
clc
%ncdisp('fielddump.000.000.001.nc')
%size(ql)% 300, 300, 167, 20; %% 320 320 167 240
%% To get varibles in 3-D field with low memory usage in COARDS convention(need to have specific time axes) and can be read by paraview
%% Configure here
%% Save the data just for animation with a loop of 60 time steps with minimum memory usage.
x_pts=240;
y_pts=20;
z_pts=200;
nx=1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
ny=12;
Varname='ql';
aim_dir='/home/jiachen/storage/process/';
expnr='.002';
start_hr=1;
end_hr=40; %  if(ls60/512) 1 and 2
%% End of Configure
for loop=start_hr:end_hr
start_time=(loop-1)*60+1;
end_time=loop*60;
time=ncread([aim_dir 'fielddump.000.000' expnr '.nc'],'time');
time=time(start_time:end_time,1);
Var=zeros(x_pts*nx,y_pts*ny,z_pts,end_time-start_time+1);
nccreate([aim_dir [Varname '_' num2str(loop)] '.nc'],Varname,'Dimensions',{'zt',x_pts,'xm',y_pts*ny,'yt',z_pts,'time',end_time-start_time+1});
for n=1:ny
    if n<11
        nn=['0' num2str(n-1)];
    else
        nn=num2str(n-1);
    end
temp=ncread(['fielddump.000.0' nn expnr  '.nc'],Varname,[1 1 1 start_time],[x_pts y_pts z_pts 60],[1 1 1 1]);
Var(:,(n-1)*y_pts+1:n*y_pts,:,:) = squeeze(temp(:,:,:,:));
clear temp
end
ncwrite([aim_dir [Varname '_' num2str(loop)] '.nc'],Varname,Var)
nccreate([aim_dir [Varname '_' num2str(loop)] '.nc'],'time','Dimensions',{'time',end_time-start_time+1});
ncwrite([aim_dir [Varname '_' num2str(loop)] '.nc'],'time',time)
ncwriteatt([aim_dir [Varname '_' num2str(loop)] '.nc'], 'time', 'units', 'seconds since 2010-11-9 00:00:00 +0:00');
clear Var
end

