clear
clc
%% Configure here
z=ncread('EUCLIPSE.nc','zf');%% non-equidistant grid
%% End of Configure
wfls=z*-6.26e-5/10; %% large scale subsidence according to dales_manual.pdf in ~/dales/utils/doc/input/
ug=ones(1,length(z))*-2; %% geostrophic wind
vg=ones(1,length(z))*-10; %% geostrophic wind
dqtdx=zeros(1,length(z)); 
dqtdy=zeros(1,length(z));
dqtdtls=zeros(1,length(z));
thlpcart=zeros(1,length(z));
%% Write values to lsclae file
Var=[z';ug;vg;wfls';dqtdx;dqtdy;dqtdtls;thlpcart];
head1=(['#ASTEX case using dz = ' '5' 'm, Nlev ='  '427']);
head2='#height     ug    vg      wfls    dqtdx    dqtdy    dqtdtls    thlpcart';
fid=fopen('lscale.inp.002','w');
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,head2);
fprintf(fid,'\r\n');
for i=1:length(z)
fprintf(fid,'%4.1f %2.0f %2.0f %1.6f %1.6f %3.6f %1.6f %1.6f\n',Var(:,i));
%fprintf(fid,'\r\n');
end
fclose(fid);





