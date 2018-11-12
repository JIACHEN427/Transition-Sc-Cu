%% Calculate the liqiud water path and show the cloud pic
ql=ncread('ql.nc','ql');
densityAir=1.2754;
z=ncread('profiles.002.nc','zt');
%lwp=zeros(size(ql,1),size(ql,2),size(ql,4));
x=linspace(0,4480,512);
y=linspace(0,4480,512);
for t = 1:size(ql,4)
    for i = 1:size(ql,1)
        for j = 1:size(ql,2)
            lwp(i, j, t) = trapz(z(:),squeeze(ql(i,j,:,t))).*densityAir;
        end
    end
end
for i=1:60
contourf(lwp(:,:,i)); %shading interp
ax = gca;
load('cloud','mycmap')
colormap(ax,mycmap)
colorbar
pause
end
