clear
clc
% Old matlab code to do the quadrant analysis as in Handa's thesis with
% field result stitched from 3D output of the DALES 4.1
w=ncread('w.nc','w');
thl=ncread('thl.nc','thl');
qt=ncread('qt.nc','qt');
ql=ncread('ql.nc','ql');
%% Fix the unit
w=w*1e-3;
thl=thl*1e-2+300;
ql=ql*1e-5;
qt=qt*1e-5;
%ncdisp('w.nc')
%horizontal,horizontal,vetical,time
%% Configure here
time_point=60;
vertical_point=167;
point=320;
aim_height=3000;
point_count=point*point;
%% End of configure
    x=linspace(1,point,point);
    y=linspace(1,point,point);
    z=linspace(1,aim_height,vertical_point); %% equidistant grid
size_w=size(w);
size_thl=size(thl);
avg_w=zeros(vertical_point,time_point);
avg_thl=zeros(vertical_point,time_point);
avg_ql=zeros(vertical_point,time_point);
avg_qt=zeros(vertical_point,time_point);
wP=zeros(size(w));
thlP=zeros(size(thl));
qua=zeros(size(thl));
for height_index=1:vertical_point
    for time_index=1:time_point
        avg_w(height_index,time_index)=nanmean(nanmean(squeeze(w(:,:,height_index,time_index))));
        avg_thl(height_index,time_index)=nanmean(nanmean(squeeze(thl(:,:,height_index,time_index))));
        avg_qt(height_index,time_index)=nanmean(nanmean(squeeze(qt(:,:,height_index,time_index))));
        avg_ql(height_index,time_index)=nanmean(nanmean(squeeze(ql(:,:,height_index,time_index))));
    end
end
%% Find w' and thetal'
for height_index=1:vertical_point
    for time_index=1:time_point
        for i=1:point
            for j=1:point
                wP(i,j,height_index,time_index)=w(i,j,height_index,time_index)-avg_w(height_index,time_index);
                thlP(i,j,height_index,time_index)=thl(i,j,height_index,time_index)-avg_thl(height_index,time_index);
            end
        end
    end
end
%% Find quadrant 
for height_index=1:vertical_point
    for time_index=1:time_point
        for i=1:point
            for j=1:point
if wP(i,j,height_index,time_index) >0 && thlP(i,j,height_index,time_index) >0 %% Rising updraft --> Warm stuff up
        qua(i,j,height_index,time_index)=1;
    
elseif wP(i,j,height_index,time_index) >0 && thlP(i,j,height_index,time_index) <0 %% Ascending cold shell --> Cold stuff up
        qua(i,j,height_index,time_index)=2;
        
elseif wP(i,j,height_index,time_index) <0 && thlP(i,j,height_index,time_index) >0 %% Entrainment event --> Warm stuff down
        qua(i,j,height_index,time_index)=3;
        
elseif wP(i,j,height_index,time_index) <0 && thlP(i,j,height_index,time_index) <0 %% Descending downdraft --> Cold stuff down 
        qua(i,j,height_index,time_index)=4;
        
end
            end
        end
    end
end
%% Find the distribution of every quadrant for every slice of the domain
ent=zeros(vertical_point,time_point);
cold=zeros(vertical_point,time_point);
updraft=zeros(vertical_point,time_point);
downdraft=zeros(vertical_point,time_point);
for i=1:vertical_point
    for j=1:time_point
    updraft(i,j)=size(find(qua(:,:,i,j)==1),1)/point_count;
    cold(i,j)=size(find(qua(:,:,i,j)==2),1)/point_count;
    ent(i,j)=size(find(qua(:,:,i,j)==3),1)/point_count;
    downdraft(i,j)=size(find(qua(:,:,i,j)==4),1)/point_count;
    end
end

z=linspace(0,aim_height,vertical_point);
plot(updraft(:,end),z,'linewidth',1.5)
hold on
plot(ent(:,end),z,'linewidth',1.5)
plot(downdraft(:,end),z,'linewidth',1.5)
plot(cold(:,end),z,'linewidth',1.5)
legend('updraft', 'entrainment', 'downdraft', 'cold shell','avg')
line([0.25 0.25],[0 aim_height],'linestyle','--','LineWidth',2,'color','k');
%% aa=size(find(qua==1)); examine the distribution

%% Find top 5% and bottom 5% of vertical velocity
five_percent_point=round(point_count*0.05);
r_max=zeros(vertical_point,time_point,five_percent_point); %% Row and column index for the min and max value in w
r_min=zeros(vertical_point,time_point,five_percent_point);
c_max=zeros(vertical_point,time_point,five_percent_point);
c_min=zeros(vertical_point,time_point,five_percent_point);
for i=1:vertical_point
    for j=1:time_point     
    temp_w=squeeze(w(:,:,i,j));
    [As,ind]=sort(temp_w(:));
    
    
    [r_max(i,j,:),c_max(i,j,:)]=ind2sub(size(temp_w),ind(end-five_percent_point:end-1));
    [r_min(i,j,:),c_min(i,j,:)]=ind2sub(size(temp_w),ind(1:five_percent_point));
    end
end
%% Validation
for v=1:4500
    aaa(v)=temp_w(r_max(i,j,v),c_max(i,j,v));
end
for v=1:4500
    bbb(v)=temp_w(r_min(i,j,v),c_min(i,j,v));
end
%% End of validation 
%% Only consider quadrant 4 and quadrant 1
thl_max=zeros(vertical_point,time_point);
thl_min=zeros(vertical_point,time_point);
qt_max=zeros(vertical_point,time_point);
qt_min=zeros(vertical_point,time_point);
ql_max=zeros(vertical_point,time_point);
ql_min=zeros(vertical_point,time_point);
w_max=zeros(vertical_point,time_point);
w_min=zeros(vertical_point,time_point);
max_count=zeros(vertical_point,time_point);
min_count=zeros(vertical_point,time_point);
for i=1:vertical_point
    for j=1:time_point
        for m=1:five_percent_point  
            if qua(r_max(i,j,m),c_max(i,j,m),i,j) == 1
            thl_max(i,j)=thl_max(i,j)+thl(r_max(i,j,m),c_max(i,j,m),i,j);
            qt_max(i,j)=qt_max(i,j)+qt(r_max(i,j,m),c_max(i,j,m),i,j);
            ql_max(i,j)=ql_max(i,j)+ql(r_max(i,j,m),c_max(i,j,m),i,j);
            w_max(i,j)=w_max(i,j)+w(r_max(i,j,m),c_max(i,j,m),i,j);
            max_count(i,j)=max_count(i,j)+1;
            end
            if qua(r_min(i,j,m),c_min(i,j,m),i,j) == 4
            thl_min(i,j)=thl_min(i,j)+thl(r_min(i,j,m),c_min(i,j,m),i,j);
            qt_min(i,j)=qt_min(i,j)+qt(r_min(i,j,m),c_min(i,j,m),i,j);
            ql_min(i,j)=ql_min(i,j)+ql(r_min(i,j,m),c_min(i,j,m),i,j);
            w_min(i,j)=w_min(i,j)+w(r_min(i,j,m),c_min(i,j,m),i,j);
            min_count(i,j)=min_count(i,j)+1;
            end
        end
thl_max(i,j)=thl_max(i,j)/max_count(i,j);
thl_min(i,j)=thl_min(i,j)/min_count(i,j);
ql_max(i,j)=ql_max(i,j)/max_count(i,j);
ql_min(i,j)=ql_min(i,j)/min_count(i,j);
qt_max(i,j)=qt_max(i,j)/max_count(i,j);
qt_min(i,j)=qt_min(i,j)/min_count(i,j);
w_max(i,j)=w_max(i,j)/max_count(i,j);
w_min(i,j)=w_min(i,j)/min_count(i,j);
    end
end




%%


z=linspace(0,aim_height,vertical_point);
lim_y=1500;

for i=1:time_point
    subplot(141)
    plot(avg_thl(:,i),z,'linewidth',1.5)
    hold on
    plot(thl_max(:,i),z,'linewidth',1.5)
    plot(thl_min(:,i),z,'linewidth',1.5)
    hold off
    xlabel('\theta_l [K]','FontSize',20)
    ylabel('z [m]','FontSize',20)
    ylim([0 lim_y])
    legend('environment','updraft','downdraft')
    legend boxoff   
    subplot(143)
    plot(avg_ql(:,i),z,'linewidth',1.5)
    hold on
    plot(ql_max(:,i),z,'linewidth',1.5)
    plot(ql_min(:,i),z,'linewidth',1.5)
    hold off
    xlabel('ql [g/kg]','FontSize',20)
    ylabel('z [m]','FontSize',20)
    ylim([0 lim_y])
    legend('environment','updraft','downdraft')
    legend boxoff 
   subplot(142)
   plot(avg_qt(:,i),z,'linewidth',1.5)
   hold on
   plot(qt_max(:,i),z,'linewidth',1.5)
   plot(qt_min(:,i),z,'linewidth',1.5)
   hold off
   xlabel('qt [g/kg]','FontSize',20)
   ylabel('z [m]','FontSize',20)
   ylim([0 lim_y])
    legend('environment','updraft','downdraft')
    legend boxoff 
    subplot(144)
    plot(avg_w(:,i),z,'linewidth',1.5)
    hold on
    plot(w_max(:,i),z,'linewidth',1.5)
    plot(w_min(:,i),z,'linewidth',1.5)
    hold off
    xlabel('w [m/s]','FontSize',20)
    ylabel('z [m]','FontSize',20)
    legend('environment','updraft','uowndraft')
    legend boxoff 
    ylim([0 lim_y])
    drawnow
    pause
end

%% Average over the whole time span
lim_y=3000;
avgthl=nanmean(avg_thl,2);
thlmax=nanmean(thl_max,2);
thlmin=nanmean(thl_min,2);

avgql=nanmean(avg_ql,2);
qlmax=nanmean(ql_max,2);
qlmin=nanmean(ql_min,2);

avgqt=nanmean(avg_qt,2);
qtmax=nanmean(qt_max,2);
qtmin=nanmean(qt_min,2);

avgw=nanmean(avg_w,2);
wmax=nanmean(w_max,2);
wmin=nanmean(w_min,2);

subplot(141)
plot(avgthl,z,'linewidth',1.5)
hold on
plot(thlmax,z,'linewidth',1.5)
plot(thlmin,z,'linewidth',1.5)
hold off
xlabel('\theta_l [K]','FontSize',20)
ylabel('z [m]','FontSize',20)
ylim([0 lim_y])
legend('environment','updraft','downdraft')
legend boxoff

subplot(143)
plot(avgql,z,'linewidth',1.5)
hold on
plot(qlmax,z,'linewidth',1.5)
plot(qlmin,z,'linewidth',1.5)
hold off
xlabel('ql [g/kg]','FontSize',20)
ylabel('z [m]','FontSize',20)
ylim([0 lim_y])
legend('environment','updraft','downdraft')
legend boxoff 

subplot(142)
plot(avgqt,z,'linewidth',1.5)
hold on
plot(qtmax,z,'linewidth',1.5)
plot(qtmin,z,'linewidth',1.5)
hold off
xlabel('qt [g/kg]','FontSize',20)
ylabel('z [m]','FontSize',20)
ylim([0 lim_y])
legend('environment','updraft','downdraft')
legend boxoff 

subplot(144)
plot(avgw,z,'linewidth',1.5)
hold on
plot(wmax,z,'linewidth',1.5)
plot(wmin,z,'linewidth',1.5)
hold off
xlabel('w [m/s]','FontSize',20)
ylabel('z [m]','FontSize',20)
legend('environment','updraft','uowndraft')
legend boxoff 
ylim([0 lim_y])

%% Hourly average







