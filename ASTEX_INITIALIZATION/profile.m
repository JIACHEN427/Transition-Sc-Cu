clear
clc
%% Note for myself:
% Vertical point is the center cell instead of the edge
%% Configure here
z=ncread('EUCLIPSE.nc','zf');

Inversion_height=660;   %% at 51 point
Inversion_position=51;
Inversion_thickness=60; %% 12 point
Inversion_end=Inversion_position+12;

%% End of configure

thl=zeros(1,length(z));
qt=zeros(1,length(z));
u=zeros(1,length(z));
v=zeros(1,length(z));
tke=zeros(1,length(z));

%% Fill in values below the inversion height
tke(1:Inversion_position)=1; % Tke only exists below the inversion height initially
thl(1:Inversion_position)=288;   %%0.006K/m above inversion & 0.1K/m for inversion       This value is estimated from initial files from EUCLIPSE 
qt(1:Inversion_position)=0.0102; %%0.0028e-3/m above inversion & 0.02e-3/m for inversion This value is estimated from initial files from EUCLIPSE 
u(1:Inversion_position)=-0.7; 
v(1,:)=-10;
%% Fill in values from inversion height to end of inversion
for i=Inversion_position:Inversion_end
   thl(i)= thl(i-1)+0.1*5;
   qt(i)= qt(i-1)-0.02e-3*5;
   u(i)= u(i-1)-0.02363636364*5;
end
%% Fill in values from end of inversion to the whole domain height 
for i=Inversion_end:length(z)
   thl(i)= thl(i-1)+0.006*5;
   qt(i)= qt(i-1)-0.0028e-3*5;
   u(i)= u(i-1);
end
%% Write values to profile file
Var=[z';thl;qt;u;v;tke];
head1=(['#ASTEX case using dz = ' '5' 'm, Nlev ='  '427']);
head2=('#height       thl       qt              u            v            tke');
fid=fopen('prof.inp.002','w');
fprintf(fid,head1);
fprintf(fid,'\r\n');
fprintf(fid,head2);
fprintf(fid,'\r\n');
for i=1:length(z)
fprintf(fid,'%4.1f %3.3f %1.5f %1.5f %2.0f %1.0f\n',Var(:,i));
%fprintf(fid,'\r\n');
end
fclose(fid);