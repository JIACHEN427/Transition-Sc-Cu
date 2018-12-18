%% Matlab code used to create initial profile of the two passive scalars introduced during ASTEX in DALES. Ref. DAVINI(2017)
%% sc.inp
clear
clc
%% Configure here
start_time=0;
end_time=144000; %% ASTEX run for 40hrs 
time_var=3600; %% Time interval
z=ncread('astex_input_v5.nc','zf'); %% non-equidistant grid
%%  End of configure
zi=660; % Initial inversion height
sc1=zeros(1,length(z));
sc2=zeros(1,length(z));
for i=1:size(z,1)
    sc1(i)=z(i)/z(end)*1.5;
    if z(i)>zi
        sc2(i)=1;
    end
end

head1=(['#ASTEX case using dz = ' '5' 'm, Nlev ='  '427']);
head2=('#height sc1 sc2');
Var=[z';sc1;sc2];
fid=fopen('sc.inp.002','w');
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,head2);
fprintf(fid,'\r\n');
for i=1:length(z)
fprintf(fid,'%4.1f %1.1f %1.1f\n',Var(:,i));
%fprintf(fid,'\r\n');
end
fclose(fid);
% %% check the passive scalar concentration
% plot(sc1,z)
% plot(sc2,z)
% %% Do the plot as in DAVINI's 
% plot(diff(z),z(1:end-1))
% xlabel('\Delta z [m]')
% ylabel('Height [m]')
