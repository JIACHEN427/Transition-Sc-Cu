%% MATLAB code used to make contourf plot for the vertical velocity/liquid water mixing ratio/SBL/SFT
clear
clc
%ncdisp('fielddump.000.000.002.nc') 128*16*200*124
ql=ncread('fielddump.000.000.002.nc','ql');
w=ncread('fielddump.000.000.002.nc','w');
SBL=ncread('fielddump.000.000.002.nc','sc001');
SFT=ncread('fielddump.000.000.002.nc','sc002');
zt=ncread('fielddump.000.000.002.nc','zt');

for i=1:196
    subplot(2,2,1)
    pcolor(squeeze(ql(:,1,:,i))')
    xlabel('Liquid water mixing ratio [g/kg]')
    shading(gca,'interp')
    colormap
    subplot(2,2,2)
    pcolor(squeeze(w(:,1,:,i))')
    xlabel('Vertical velocity [m/s]')
    shading(gca,'interp')
    colormap
    subplot(2,2,3)
    pcolor(squeeze(SBL(:,1,:,i))')
    xlabel('S_{BL} [-]' )
    shading(gca,'interp')
    colormap
    subplot(2,2,4)
    pcolor(squeeze(SFT(:,1,:,i))')
    xlabel(num2str(i))
    shading(gca,'interp')
    colormap
    pause
end
i=101;
    subplot(2,2,1)
    pcolor(squeeze(ql(:,1,:,i))')
    title('Liquid water mixing ratio [g/kg]','FontSize',20)
    shading(gca,'interp')
    load('cloud','mycmap')
    colormap(mycmap)
    colorbar
    subplot(2,2,2)
    pcolor(squeeze(w(:,1,:,i))')
    title('Vertical velocity [m/s]','FontSize',20)
    shading(gca,'interp')
    colorbar
    subplot(2,2,3)
    pcolor(squeeze(SBL(:,1,:,i))')
    title('S_{BL} [-]' ,'FontSize',20)
    shading(gca,'interp')
    colorbar
    subplot(2,2,4)
    pcolor(squeeze(SFT(:,1,:,i))')
    title('S_{FT} [-]','FontSize',20)
    shading(gca,'interp')
    colorbar
