clear
clc
%% Configure here
start_time=0;
end_time=144000;
z=ncread('EUCLIPSE.nc','zf');
%% End of configure
sv1=zeros(1,length(z));
sv2=zeros(1,length(z));
head1=(['ASTEX case using dz = ' '5' 'm, Nlev ='  '427']);
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
fid=fopen('ls_fluxsv.inp.002','w');
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