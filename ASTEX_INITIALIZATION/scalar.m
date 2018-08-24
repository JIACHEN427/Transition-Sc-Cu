clear
clc
z=ncread('EUCLIPSE.nc','zf');%% non-equidistant grid
sv1=zeros(1,length(z));
sv2=zeros(1,length(z));
head1=(['#ASTEX case using dz = ' '5' 'm, Nlev ='  '427']);
head2=('#height sv1 sv2');
Var=[z';sv1;sv2];
fid=fopen('scalar.inp.002','w');
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,head2);
fprintf(fid,'\r\n');
for i=1:length(z)
fprintf(fid,'%4.1f %1.1f %1.1f\n',Var(:,i));
%fprintf(fid,'\r\n');
end
fclose(fid);