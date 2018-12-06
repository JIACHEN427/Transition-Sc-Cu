%% Find entrainment veloicty with method in Ghonima et al. 2017 and calculate other variables as in Handa's with output 3D field data, profile and time statistics
%% Make sure first profile and time statistics interval are of the same size
clear
clc
%% Constant here
flag=linspace(1,24,24)*10; % pick index
g=9.81;
cp_dry =1006;
R=287;
lambda=2.5*10^6;
T=275.49;
%thl=ncread('thl.nc','thl');
%ncdisp('profiles.nc');
%ncdisp('tmser.nc');
%% Load time statistics 
time=ncread('tmser.nc','time');
ustar=ncread('tmser.nc','ustar');
zi=ncread('tmser.nc','zi');
tsrf=ncread('tmser.nc','thlskin');
zb=ncread('tmser.nc','zb');
we=ncread('tmser.nc','we');
we=we(flag);
zi_position=zi(flag);
zi=zi(flag);
ustar=ustar(flag);
tsrf=tsrf(flag);
time=time(flag);
zb=zb(flag);
zi_position=round(zi_position/25);
zb_position=round(zb/25);
%% Load profile
thv=ncread('profiles.nc','thv');
thv_0=squeeze(thv(1,:));
zt=ncread('profiles.nc','zt');
wthlt=ncread('profiles.nc','wthlt');
p=ncread('profiles.nc','presh');
thl=ncread('profiles.nc','thl');
wqtt=ncread('profiles.nc','wqtt'); % Total moisture flux
wthvt=ncread('profiles.nc','wthvt'); % Total moisture flux
lwu=ncread('profiles.nc','lwu'); % longwave upward
lwd=ncread('profiles.nc','lwd'); % longwave downward
swu=ncread('profiles.nc','swu'); % shortwave upward
swd=ncread('profiles.nc','swd'); % shortwave downward
qt=ncread('profiles.nc','qt');
swt=swu+swd; % total short wave heating
lwt=lwu+lwd; % total long wave cooling
%% End of load

%% Find entrainment flux with model in Lilly 1968
% Entrainment flux of total water mixing ratio
for i=1:length(time)
    delta_qt(i)=(qt(zi_position(i),i)-qt(zi_position(i)+1,i))/25;
    delta_thv(i)=(thv(zi_position(i),i)-thv(zi_position(i)+1,i))/25; %% Virtual potential temperature inversion jump 25 is dz near the inversion height, will be fixed later
    qtent=we(i)*delta_qt(i);
end
% Entrainment  of buoyancy flux thl3d (320 320 167 61)
thl3d=ncread('thl.nc','thl');
b=zeros(size(thl3d));
for i=1:size(thl3d,1)
    for j=1:size(thl3d,2)
        for k=1:size(thl3d,3)
            for l=1:size(thl3d,4)
                b(i,j,k,l)=g*(thl3d(i,j,k,l)-thl(k,l))/thl(k,l);
            end
        end
    end
end






%%
for i=1:length(time)
wstar=(g./T.*zi*wthlt(1,i)).^(1/3) ;
end



%% 

wdown=


%%
dthv=(thv(zi_position)-thv(zi_position+1))./25 ; 

for i=1:length(time)
we_h(i)=-thv_0(i)/(g*delta_thv(i)*zi(i))*(0.15*(wstar(i)^3+5*ustar(i)^3)+0.35*wstar_rad(1,i)^3);
end









%% Rho(t) time statistics
rho=zeros(1,length(time));
for i=1:length(time)
rho(i) =p(i,1) ./ (R .* tsrf(i) );
end
F_0=zeros(1,length(time));
for i=1:length(time)
F_0(i)=lwt(zi_position(i),i)-lwt(zb_position(i),i);  %%?radiative cooling per unit surface of the cloud
end
B_0=zeros(1,length(time));
for i=1:length(time)
B_0(i)=F_0(i)*g/(rho(i)*cp_dry*T); % ?reference buoyancy flux given by radiation && How to calculate thl_cld(thl in the inversion height?)  
end
%%  q_t,exec(t,z) wstar(t,z) --> profile
wstar_rad=zeros(length(zt),length(time));
for i=1:length(zt)
    for j=1:length(time)
    wstar_rad(i,j)=g*zi(j)*F_0(j)/(rho(j)*cp_dry*thl(i,j));
    end
end

%% Wdown holtslag 1993

