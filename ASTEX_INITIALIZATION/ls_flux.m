clear
clc
%% Configure here
start_time=0;
end_time=144000; %% ASTEX run for 40hrs 
time_var=3600; %% Time interval
z=ncread('EUCLIPSE.nc','zf');
%% End of configure
head1=(['ASTEX case using dz = ' '5' 'm, Nlev ='  '427']);
head2=('height ug vg wfls dqtdx dqtdy dqtdtls thlpcart');
head22=('time wtsurf wqsurf thls qts press');
%% time var for first part from EUCLIPSE
time=0:time_var:end_time;

wtsurf=ones(1,end_time/time_var+1)*0.01094*0; %% Constant, can't find value for liquid water potential temperature flux at the surface
wqsurf=ones(1,end_time/time_var+1)*1.3e-5*0; %% Constant, can't find value for flux of humidity at surface  

thls=[290.355010986328;290.428009033203;290.544006347656;290.660003662109;290.792999267578;290.988006591797;291.252014160156;291.554992675781;291.861999511719;292.225006103516;292.507995605469;292.700012207031;292.885009765625;293.044006347656;293.186004638672;293.325012207031;293.472991943359;293.625000000000;293.776000976563;293.912994384766;294.026000976563;294.114990234375;294.183990478516;294.233001708984;294.269012451172;294.291992187500;294.307006835938;294.316009521484;294.321990966797;294.326995849609;294.334991455078;294.347991943359;294.369995117188;294.403015136719;294.450012207031;294.480010986328;294.510009765625;294.540008544922;294.570007324219;294.600006103516;294.630004882813]';
press=ones(1,end_time/time_var+1)*102900; 
qts=zeros(1,end_time/time_var+1);
%% large scale forcings terms 
ug=ones(1,length(z))*-2;
vg=ones(1,length(z))*-10;
wfls=z*-6.26e-5/10; %% large scale subsidence constant for now
dqtdx=zeros(1,length(z));
dqtdy=zeros(1,length(z));
dqtdtls=zeros(1,length(z));
thlpcart=zeros(1,length(z));
%%
Var_time=[time;wtsurf;wqsurf;thls;qts;press];
fid=fopen('ls_flux.inp.002','w');
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,head22);
fprintf(fid,'\r\n');
for i=1:end_time/time_var+1
fprintf(fid,'%6.0f %1.6f %1.6f %3.6f %1.0f %1.0f\n',Var_time(:,i));
%fprintf(fid,'\r\n');
end
fprintf(fid,'\r\n');
Var_height=[z';ug;vg;wfls';dqtdx;dqtdy;dqtdtls;thlpcart];
for i=1:end_time/time_var+1
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,'# ');
fprintf(fid,'%6.0f',time(i));
fprintf(fid,'\r\n');
    for j=1:length(z)
        fprintf(fid,'%4.1f %2.0f %2.0f %1.6f %1.0f %1.0f %1.0f %1.0f\n',Var_height(:,j));
    end  
end
fclose(fid);