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
z=ncread('case_setup.nc','zf');%% non-equidistant grid
start_time=0;
end_time=144000;
time_var=3600;
expnr='001';
%% delete existing inp file
delete *.001
%% For older DALES
%qts=zeros(end_time/time_var+1,1);
%wtsurf=ones(end_time/time_var+1,1)*0.01094';
%wqsurf=ones(end_time/time_var+1,1)*1.3e-5';
%%
%% scalar.inp with 2var
sv1=zeros(1,length(z));
sv2=zeros(1,length(z));
head1=(['#ASTEX case using nonequidistant vertical grid as in EUCLIPSE, Nlev ='  '427']);
head2=('#height sv1 sv2');
Var=[z';sv1;sv2];
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
head1=(['ASTEX case using nonequidistant vertical grid as in EUCLIPSE, Nlev ='  '427']);
head2=('height sv1 sv2');
head22=('time sv1 sv2');
wsv1_start=0;
wsv2_start=0;
wsv1_end=0;
wsv2_end=0;
Var_start=[z';sv1;sv2];
Var_end=[z';sv1;sv2];
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
%% prof.inp with 6var
Var=[z,thl,qt,u,v,tke];
head1=(['#ASTEX case using nonequidistant vertical grid as in EUCLIPSE, Nlev ='  '427']);
head2=('#height       thl       qt              u            v            tke');
fid=fopen(['prof.inp.' expnr],'w');
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,head2);
fprintf(fid,'\r\n');
for i=1:length(z)
fprintf(fid,'%4.1f %3.3f %1.5f %1.5f %2.0f %1.0f\n',Var(i,:));
%fprintf(fid,'\r\n');
end
fclose(fid);
%% ls_flux.inp with 6+8var
head1=(['ASTEX case using nonequidistant vertical grid as in EUCLIPSE, Nlev ='  '427']);
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
Var_height=[z,ug(:,i),vg(:,i),wfls(:,i),dqtdx,dqtdy,dqtdtls,thlpcart];
    for j=1:length(z)
        fprintf(fid,'%4.1f %2.0f %2.0f %1.6f %1.0f %1.0f %1.0f %1.0f\n',Var_height(j,:));
    end  
end
fclose(fid);
%% lscale.inp
Var=[z,ug(:,1),vg(:,1),wfls(:,1),dqtdx,dqtdy,dqtdtls,thlpcart];
head1=(['#ASTEX case using nonequidistant vertical grid as in EUCLIPSE, Nlev ='  '427']);
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
%% Matlab code used to create initial profile of the two passive scalars introduced during ASTEX in DALES. Ref. DAVINI(2017)
%% sc.inp
%%  End of configure
zi=660; % Initial inversion height
sc1=zeros(1,length(z));
sc2=zeros(1,length(z));
for i=1:size(z,1)
    sc1(i)=z(i)/1000;
    if z(i)>zi
        sc2(i)=1;
    end
end
head1=(['#ASTEX case using nonequidistant vertical grid as in EUCLIPSE, Nlev ='  '427']);
head2=('#height sc1 sc2');
Var=[z';sc1;sc2];
fid=fopen(['sc.inp.' expnr],'w');
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,head2);
fprintf(fid,'\r\n');
for i=1:length(z)
fprintf(fid,'%4.1f %1.4f %1.4f\n',Var(:,i));
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
%% ls_fluxsc.inp with 2var. Cannot fix the large scale forcing bug, and large scale forcing here is zero. So I delete the large scale foring subrountine, so no input here.
sc1=zeros(1,length(z));
sc2=zeros(1,length(z));
head1=(['ASTEX case using nonequidistant vertical grid as in EUCLIPSE, Nlev ='  '427']);
head2=('height sc1 sc2');
head22=('time sc1 sc2');
wsc1_start=0; % Surface flux of sc1 at the start
wsc2_start=0;
wsc1_end=0;
wsc2_end=0;
Var_start=[z;sc1';sc2'];
Var_end=[z;sc1';sc2'];
start_state=[start_time;wsc1_start;wsc2_start];
end_state=[end_time;wsc1_end;wsc2_end];
fid=fopen(['ls_fluxsc.inp.' expnr],'w');
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,head22);
fprintf(fid,'\r\n');
fprintf(fid,'%6.0f %1.3f %1.3f\n',start_state);
fprintf(fid,'%6.0f %1.3f %1.3f\n',end_state);
%%
%% check the passive scalar concentration
%sc001=ncread('profiles.001.nc','sc001');
%sc002=ncread('profiles.001.nc','sc002');
subplot(1,3,1)
plot(sc1,z,'LineWidth',1)
hold on 
%plot(sc001(:,240),z)
line([-0.1,3.2],[zi,zi],'Color','r','LineWidth',1)
line([-0.1,3.2],[1850,1850],'Color','r','LineWidth',1,'LineStyle','--')
ylabel('Height [m]','FontSize',20)
xlabel('S_{BL}','FontSize',20)
xlim([-0.1,3.1])
ylim([0,3100])
subplot(1,3,2)
plot(sc2,z,'LineWidth',1)
hold on 
%plot(sc001(:,240),z)
ylabel('Height [m]','FontSize',20)
xlabel('S_{FT}','FontSize',20)
line([-0.1,1.1],[zi,zi],'Color','r','LineWidth',1)
line([-0.1,1.1],[1850,1850],'Color','r','LineWidth',1,'LineStyle','--')
ylim([0,3100])
xlim([-0.1,1.1])
%% Do the plot as in DAVINI's 
subplot(1,3,3)
plot(diff(z),z(1:end-1),'o')
hold on
line([0,50],[zi,zi],'Color','r','LineWidth',1)
line([0,50],[1850,1850],'Color','r','LineWidth',1,'LineStyle','--')
xlabel('\Delta z [m]','FontSize',20)
ylabel('Height [m]','FontSize',20)
ylim([0,3100])
xlim([0,50])