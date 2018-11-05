clc
clear
%% Matlab code made for input of DALES with prescirbed vertical grid as EUCLIPSE(427)
%% Used to convert the ncdf input to plain text input.
%% Need to be read from ncdf file ://41,427 :/dqtdtls, dthldtls, ug, vg, wfls, 
%%                                ://41     :/ps, qts, thls, timeflux, timels, wtsurf, wqsurf 
%%                                ://427    :/qt, thl, tkes, u, v, zf 
%% Read data from ncdf
dqtdtls=ncread('case_setup.nc','dqtdtls');
dthldtls=ncread('case_setup.nc','dthldtls');
ug=ncread('case_setup.nc','ug');
vg=ncread('case_setup.nc','vg');
wfls=ncread('case_setup.nc','wfls');
%%
press=ncread('case_setup.nc','ps');
qts=ncread('case_setup.nc','qts');
thls=ncread('case_setup.nc','thls');
timeflux=ncread('case_setup.nc','timeflux');
time=ncread('case_setup.nc','timels');
wtsurf=ncread('case_setup.nc','wtsurf');
wqsurf=ncread('case_setup.nc','wqsurf');
%%
qt=ncread('case_setup.nc','qt');
thl=ncread('case_setup.nc','thl');
tke=ncread('case_setup.nc','tkes');
u=ncread('case_setup.nc','u');
v=ncread('case_setup.nc','v');
zf=ncread('case_setup.nc','zf');%% Old non-equidistant grid
start_time=0;
end_time=144000;
time_var=3600;
expnr='002';
%% delete existing inp file
delete *.002
%% Make the grid
grid_count=200;
z=linspace(zf(1),zf(end),grid_count); %% New equidistant grid
%% ------------------------------------------------------------------------Values doesn't vary with height<--->Value need to be found wfls/qt/u/tke/thl-----------------------------------------------------------
for i=1:grid_count
[d,ix]=min(abs(zf-z(i)));
wflscc(i,:)=wfls(ix,:);
qtcc(i,:)=qt(ix,:);
ucc(i,:)=u(ix,:);
tkecc(i,:)=tke(ix,:);
thlcc(i,:)=thl(ix,:);
vcc(i,:)=v(ix,:);
end
%% For older DALES
qts=zeros(end_time/time_var+1,1);
wtsurf=ones(end_time/time_var+1,1)*0.01094';
wqsurf=ones(end_time/time_var+1,1)*1.3e-5';
dqtdx=zeros(length(z),1);
dqtdy=zeros(length(z),1);
dqtdtls=zeros(length(z),1);
thlpcart=zeros(length(z),1);
%% scalar.inp with 2var
sv1=zeros(1,length(z));
sv2=zeros(1,length(z));
head1=(['#ASTEX case using dz = ' '5' 'm, Nlev ='  '427']);
head2=('#height sv1 sv2');
Var=[z;sv1;sv2];
fid=fopen(['scalar.inp.' expnr ],'w');
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,head2);
fprintf(fid,'\r\n');
for i=1:length(z)
fprintf(fid,'%4.1f %1.1f %1.1f\n',Var(:,i));
%fprintf(fid,'\r\n');
end
fclose(fid);
%% ls_fluxsv.inp with 2var
sv1=zeros(1,length(z));
sv2=zeros(1,length(z));
head1=(['ASTEX case using dz = ' '5' 'm, Nlev ='  '427']);
head2=('height sv1 sv2');
head22=('time sv1 sv2');
wsv1_start=0;
wsv2_start=0;
wsv1_end=0;
wsv2_end=0;
Var_start=[z;sv1;sv2];
Var_end=[z;sv1;sv2];
start_state=[start_time;wsv1_start;wsv2_start];
end_state=[end_time;wsv1_end;wsv2_end];
fid=fopen(['ls_fluxsv.inp.' expnr],'w');
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,head22);
fprintf(fid,'\r\n');
fprintf(fid,'%6.0f %1.1f %1.1f\n',start_state);
fprintf(fid,'%6.0f %1.1f %1.1f\n',end_state);
fprintf(fid,head2);
fprintf(fid,'\r\n');
fprintf(fid,'#');
fprintf(fid,' ');
fprintf(fid,'%1.1f\n',start_time);
for i=1:length(z)
fprintf(fid,'%4.1f %1.1f %1.1f\n',Var_start(:,i));
%fprintf(fid,'\r\n');
end
fprintf(fid,head2);
fprintf(fid,'\r\n');
fprintf(fid,'#');
fprintf(fid,' ');
fprintf(fid,'%1.1f\n',end_time);
for i=1:length(z)
fprintf(fid,'%4.1f %1.1f %1.1f\n',Var_end(:,i));
%fprintf(fid,'\r\n');
end
fclose(fid);
%% lscale.inp
Var=[z',ug(1:grid_count,1),vg(1:grid_count,1),wflscc(:,1),dqtdx,dqtdy,dqtdtls,thlpcart];
head1=(['#ASTEX case using dz = ' '5' 'm, Nlev ='  '427']);
head2='#height     ug    vg      wfls    dqtdx    dqtdy    dqtdtls    thlpcart';
fid=fopen(['lscale.inp.' expnr],'w');
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,head2);
fprintf(fid,'\r\n');
for i=1:length(z)
fprintf(fid,'%4.1f %2.0f %2.0f %1.6f %1.6f %3.6f %1.6f %1.6f\n',Var(i,:));
%fprintf(fid,'\r\n');
end
fclose(fid);
%% ls_flux.inp with 6+8var
head1=(['ASTEX case using dz = ' '5' 'm, Nlev ='  '427']);
head2=('height ug vg wfls dqtdx dqtdy dqtdtls thlpcart');
head22=('time wtsurf wqsurf thls qts press');
Var_time=[time,wtsurf,wqsurf,thls,qts,press];
fid=fopen(['ls_flux.inp.' expnr],'w');
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,head22);
fprintf(fid,'\r\n');
for i=1:end_time/time_var+1
fprintf(fid,'%6.0f %1.6f %1.6f %3.6f %1.0f %1.0f\n',Var_time(i,:));
%fprintf(fid,'\r\n');
end
fprintf(fid,'\r\n');
%
dqtdx=zeros(length(z),1);
dqtdy=zeros(length(z),1);
dqtdtls=zeros(length(z),1);
thlpcart=zeros(length(z),1);
for i=1:end_time/time_var+1
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,'# ');
fprintf(fid,'%6.0f',time(i));
fprintf(fid,'\r\n');
Var_height=[z',ug(1:grid_count,i),vg(1:grid_count,i),wflscc(:,i),dqtdx,dqtdy,dqtdtls,thlpcart];
    for j=1:length(z)
        fprintf(fid,'%4.1f %2.0f %2.0f %1.6f %1.0f %1.0f %1.0f %1.0f\n',Var_height(j,:));
    end  
end
fclose(fid);
%% prof.inp with 6var
Var=[z',thlcc,qtcc,ucc,vcc,tkecc];
head1=(['#ASTEX case using dz = ' '5' 'm, Nlev ='  '427']);
head2=('#height       thl       qt              u            v            tke');
fid=fopen(['prof.inp.' expnr],'w');
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,head2);
fprintf(fid,'\r\n');
for i=1:length(z)
fprintf(fid,'%4.1f %3.3f %1.5f %1.5f %2.0f %1.2f\n',Var(i,:));
%fprintf(fid,'\r\n');
end
fclose(fid);