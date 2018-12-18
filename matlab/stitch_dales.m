clear
clc
%% Code used to stitch the field dump from dales with hourly or whole convention JCLu UC San Diego 2018.12
%ncdisp('fielddump.000.000.001.nc')
%size(ql)% 300, 300, 167, 20; %% 320 320 167 240
%% To get varibles in 3-D field with low memory usage in COARDS convention(need to have specific time axes) and can be read by paraview
%% Configure here
%% Save the data for animation with a loop of 60 time steps with minimum memory usage.
x_pts=128;
y_pts=16;
z_pts=200;
nx=1;                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           
ny=8;
Varname='sc001';
aim_dir='/Users/jiachenlu/Desktop/send/1/pa/';
expnr='.002';
start_hr=1;
end_hr=5; %  if(ls60/512) 1 and 2
save_hourly=false; % Switch to save the output hourly
%% End of Configure
if (save_hourly)
for loop=start_hr:end_hr
start_time=(loop-1)*60+1;
end_time=loop*60;
time=ncread([aim_dir 'fielddump.000.000' expnr '.nc'],'time');
time=time(start_time:end_time,1);
Var=zeros(x_pts*nx,y_pts*ny,z_pts,end_time-start_time+1);
nccreate([aim_dir [Varname '_' num2str(loop)] '.nc'],Varname,'Dimensions',{'zt',x_pts,'xm',y_pts*ny,'yt',z_pts,'time',end_time-start_time+1});
for n=1:ny % Sweep over the whole domain
nn=num2str(n-1,'%02d');
temp=ncread(['fielddump.000.0' nn expnr  '.nc'],Varname,[1 1 1 start_time],[x_pts y_pts z_pts 60],[1 1 1 1]);
Var(:,(n-1)*y_pts+1:n*y_pts,:,:) = squeeze(temp(:,:,:,:));
clear temp
end
avg_var=zeros(z_pts,size(time,1));
for i=1:z_pts
    for j=1:size(time,1)
        avg_var(i,j)=nanmean(nanmean(squeeze(Var(:,:,i,j))));%% Calculate the slab average  f(z,t)
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
ncwrite([aim_dir [Varname '_' num2str(loop)] '.nc'],Varname,Var)
nccreate([aim_dir [Varname '_' num2str(loop)] '.nc'],'time','Dimensions',{'time',end_time-start_time+1});
ncwrite([aim_dir [Varname '_' num2str(loop)] '.nc'],'time',time)
ncwriteatt([aim_dir [Varname '_' num2str(loop)] '.nc'], 'time', 'units', 'seconds since 2000-00-00 00:00:00 +0:00');
clear Var
end
else % Save the ouput in one file
start_time=(start_hr-1)*60+1;
end_time=(end_hr-1)*60;
time=ncread(['fielddump.000.000' expnr '.nc'],'time');
time=time(start_time:end_time,1);
Var=zeros(x_pts*nx,y_pts*ny,z_pts,end_time-start_time+1);
for n=1:ny
nn=num2str(n-1,'%02d');
temp=ncread(['fielddump.000.0' nn expnr  '.nc'],Varname,[1 1 1 start_time],[x_pts y_pts z_pts 60],[1 1 1 1]);
Var(:,(n-1)*y_pts+1:n*y_pts,:,:) = squeeze(temp(:,:,:,start_time:end_time));
clear temp
end
%% Fix the unit arrangement in DALES
% if isequal(Varname,'thl')
%     Var=Var*1e-2+300;
% elseif isequal(Varname,'w') && isequal(Varname,'u') && isequal(Varname,'v')
%     Var=Var*1e-3;
% elseif isequal(Varname,'qt') && isequal(Varname,'ql')
%     Var=Var*1e-5;
% end
%% Fix the nan value in 3D field(Use the average value to replace it)
avg_var=zeros(z_pts,size(time,1));
for i=1:z_pts
    for j=1:size(time,1)
        avg_var(i,j)=nanmean(nanmean(squeeze(Var(:,:,i,j))));%% Calculate the slab average  f(z,t)
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
nccreate([aim_dir Varname '.nc'],Varname,'Dimensions',{'zt',x_pts,'xm',y_pts*ny,'yt',z_pts,'time',end_time-start_time+1});
ncwrite([aim_dir Varname '.nc'],Varname,Var)
nccreate([aim_dir Varname '.nc'],'time','Dimensions',{'time',end_time-start_time+1});
ncwrite([aim_dir Varname '.nc'],'time',time)
ncwriteatt([aim_dir Varname '.nc'], 'time', 'units', 'seconds since 2000-00-00 00:00:00 +0:00');
end
