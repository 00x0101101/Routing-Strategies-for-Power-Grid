function [ f ] = F_daytrans_14( source_cap )
% 全天优化，3*12个输入参数
% load('result0607');
% source_cap = result0607;
% source_cap = 2*ones(1,36);
f = 0;
M = inf;
connect(1,:)=[zeros(1,1),1,M,M,1,M,M,M,M,M,M,M,M,M];
connect(2,:)=[zeros(1,2),1,1,1,M,M,M,M,M,M,M,M,M];
connect(3,:)=[zeros(1,3),1,M,M,M,M,M,M,M,M,M,M];
connect(4,:)=[zeros(1,4),1,M,1,M,1,M,M,M,M,M];
connect(5,:)=[zeros(1,5),1,M,M,M,M,M,M,M,M];
connect(6,:)=[zeros(1,6),M,M,M,M,1,1,1,M];
connect(7,:)=[zeros(1,7),1,1,M,M,M,M,M];
connect(8,:)=[zeros(1,8),M,M,M,M,M,M];
connect(9,:)=[zeros(1,9),1,M,M,M,1];
connect(10,:)=[zeros(1,10),1,M,M,M];
connect(11,:)=[zeros(1,11),M,M,M];
connect(12,:)=[zeros(1,12),1,M];
connect(13,:)=[zeros(1,13),1];
connect(14,:)=[zeros(1,14)];
Connect=connect+connect';

N = 0;
l(1,:)=[zeros(1,1),1,N,N,1,N,N,N,N,N,N,N,N,N];
l(2,:)=[zeros(1,2),3,3.2,1.4,N,N,N,N,N,N,N,N,N];
l(3,:)=[zeros(1,3),1,N,N,N,N,N,N,N,N,N,N];
l(4,:)=[zeros(1,4),2.1,N,0.8,N,1.5,N,N,N,N,N];
l(5,:)=[zeros(1,5),1.8,N,N,N,N,N,N,N,N];
l(6,:)=[zeros(1,6),N,N,N,N,1,1.5,2,N];
l(7,:)=[zeros(1,7),1.2,1,N,N,N,N,N];
l(8,:)=[zeros(1,8),N,N,N,N,N,N];
l(9,:)=[zeros(1,9),1.2,N,N,N,1.5];
l(10,:)=[zeros(1,10),1.4,N,N,N];
l(11,:)=[zeros(1,11),N,N,N];
l(12,:)=[zeros(1,12),1.2,N];
l(13,:)=[zeros(1,13),0.9];
l(14,:)=[zeros(1,14)];
L = l+l';
R = 0.4*L;

Q = 0.25;
W = 0;
cap_line(1,:)=[zeros(1,1),Q,W,W,Q,W,W,W,W,W,W,W,W,W];
cap_line(2,:)=[zeros(1,2),Q,Q,Q,W,W,W,W,W,W,W,W,W];
cap_line(3,:)=[zeros(1,3),Q,W,W,W,W,W,W,W,W,W,W];
cap_line(4,:)=[zeros(1,4),Q,W,Q,W,Q,W,W,W,W,W];
cap_line(5,:)=[zeros(1,5),Q,W,W,W,W,W,W,W,W];
cap_line(6,:)=[zeros(1,6),W,W,W,W,Q,Q,Q,W];
cap_line(7,:)=[zeros(1,7),Q,Q,W,W,W,W,W];
cap_line(8,:)=[zeros(1,8),W,W,W,W,W,W];
cap_line(9,:)=[zeros(1,9),Q,W,W,W,Q];
cap_line(10,:)=[zeros(1,10),Q,W,W,W];
cap_line(11,:)=[zeros(1,11),W,W,W];
cap_line(12,:)=[zeros(1,12),Q,W];
cap_line(13,:)=[zeros(1,13),Q];
cap_line(14,:)=[zeros(1,14)];
Capacity_line=cap_line+cap_line'; %kA

I_real = zeros(size(Connect));
U_real = zeros(size(Connect));

load_expect_day = 0.1*[0 2.07 4.14 1.03 2.07 3.10 1.55 5.17 4.65 0.62 1.03 1.03 1.03 2.17
                       0 1.53 2.67 0.66 1.03 2.00 1.00 3.34 3.01 0.40 0.66 0.76 0.56 1.40
                       0 1.15 2.30 0.57 1.15 1.72 0.86 2.57 2.58 0.34 0.57 0.67 0.77 1.20
                       0 1.49 2.98 0.74 1.29 2.24 1.02 3.83 3.36 0.44 0.74 0.74 0.94 1.56
                       0 2.41 4.83 1.32 2.41 3.62 1.81 6.04 5.43 0.72 1.20 1.08 1.20 2.53
                       0 2.04 4.08 1.53 2.04 3.06 1.02 5.10 4.59 1.02 0.61 1.02 1.02 2.14
                       0 2.46 4.93 1.23 2.46 3.70 1.85 5.55 6.17 0.74 1.23 1.23 2.59 1.23
                       0 1.93 3.87 0.96 1.93 2.90 1.45 4.84 3.35 0.58 1.96 0.96 0.96 2.03
                       0 2.07 4.14 1.03 2.07 3.10 1.55 5.17 4.65 1.03 0.62 1.03 1.03 2.17
                       0 2.60 5.20 1.30 1.95 3.90 2.60 6.50 5.85 0.78 1.30 1.30 1.30 2.73
                       0 2.68 5.36 1.34 2.68 4.02 2.01 6.71 6.03 1.34 0.80 1.34  1.34 2.81
                       0 2.64 3.28 2.32 2.64 3.96 1.98 6.60 5.94 1.79 1.32 1.32 1.32 2.77]';
source_expect_day = 0.1*[30 0 6 0 0 30 0 30 0 0 0 0 0 0
                         30 0 6 0 0 30 0 30 0 0 0 0 0 0
                         30 0 6 0 0 30 0 30 0 0 0 0 0 0
                         30 2 5 0 0 30 0 30 0 0 0 0 0 0
                         30 6 6 0 0 30 0 30 0 0 0 0 0 0
                         30 7 3 0 0 30 0 30 0 0 0 0 0 0
                         30 8 3 0 0 30 0 30 0 0 0 0 0 0
                         30 8 2 0 0 30 0 30 0 0 0 0 0 0
                         30 5 3 0 0 30 0 30 0 0 0 0 0 0
                         30 4 5 0 0 30 0 30 0 0 0 0 0 0
                         30 0 6 0 0 30 0 30 0 0 0 0 0 0
                         30 0 7 0 0 30 0 30 0 0 0 0 0 0]';

U_rated = 1.5;
eff = 0.97;

source = find(all(source_expect_day ~=0,2))';
source_status = zeros(size(source_expect_day));
data_I_expect = {I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real};
data_U_expect = {U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real};
P_load = {};
P_out = {};
[point, time] = size(load_expect_day);

f_time = zeros(1,time);

source_cap_new = reshape(source_cap, time, 3)';
changeable = [1,6,8];
for k = 1:1:length(changeable)
    source_expect_day(changeable(k),:) = source_cap_new(k,:);
end

% P_out_initial = [0 0 0 0 0 0 0 0 0];
P_out_initial = zeros(1,14);

i = 12;
for i = 1:1:time
    modify = source_expect_day(:,i) - load_expect_day(:,i);
    modify_index_load = find(modify > 0);
    modify_index_source = find(modify < 0);
    source_expect = modify;
    source_expect(modify_index_source) = 0;
    load_expect = modify;
    load_expect(modify_index_load) = 0;
    load_expect = abs(load_expect);
    
    priority = [2,3];
    P_load{i} = zeros(1,length(Connect));
    P_out{i} = zeros(1,length(Connect));
    [content,index] = sort(load_expect,'descend');
    for j = 1:1:point
        destination = index(j);
        P_demand = content(j);
        if P_demand > 0
            [ data, data_I_expect{i}, data_U_expect{i}, P_load{i}, P_out{i}] = Limited_ShortestPath_loss_Priority(Connect, data_I_expect{i}, ...
                data_U_expect{i}, P_load{i}, P_demand, destination, U_rated, source, source_expect, Capacity_line, R, P_out{i}, eff, priority );

%         [ data, data_I_expect{i}, data_U_expect{i}, P_load{i}, P_out{i}] = Limited_ShortestPath_loss(Connect, data_I_expect{i}, data_U_expect{i},...
%             P_load{i}, P_demand, destination, U_rated, source, source_expect(:,i), Capacity_line, R, P_out{i}, eff );
        end
    end
    
    power_demand(i) = sum(load_expect_day(:,i));
    P_out{i} = P_out{i} + (source_expect_day(:,i)'-source_expect');
    P_load{i} = P_load{i} + (source_expect_day(:,i)'-source_expect');
    
    power_load_expect(i) = sum(P_load{i});
    power_source_expect(i) = sum(P_out{i});
    Status_up = triu(data_I_expect{i});
    powerloss_total_expect(i) = power_source_expect(i) - power_load_expect(i);
    powerloss_line_expect(i) = sum(sum((Status_up.^2.*R)));
    powerloss_router_expect(i) = powerloss_total_expect(i) - powerloss_line_expect(i);
    lossline_expect(i) = powerloss_line_expect(i)/power_load_expect(i);
    lossrouter_expect(i) = powerloss_router_expect(i)/power_load_expect(i);
    losstotal_expect(i) = powerloss_total_expect(i)/power_load_expect(i);
    
    a = [118.9083  0 0 118.4576 228.9083];
    b = [37.9637 0 0 37.777 37.9637];
    c = [0.01561 0 0 0.01359 0.01161];
    startup = [30 0 0 30 30];%要改
    
    if power_demand(i) - power_load_expect(i) <= 10e-6
        for t = 1:1:length(source)
           f_time(i)= f_time(i)+2*(a(t)+b(t)*P_out{i}(source(t))+c(t)*P_out{i}(source(t))^2);
        end
    else
        f_time(i) = 10^9;
    end
    
    if i == 1
        for t = 1:1:length(source)
            if P_out_initial(t) == 0
                f_time(i) = f_time(i)+ startup(t);
            end
        end
    else
        for t = 1:1:length(source)
            if P_out{i-1}(source(t)) == 0 && P_out{i}(source(t)) ~= 0
                f_time(i) = f_time(i)+ startup(t);
            end
        end
    end    
end
f = sum(f_time);
end
%%
loss_total = sum(powerloss_total_expect)/sum(sum(load_expect_day));
loss_line = sum(powerloss_line_expect)/sum(sum(load_expect_day));
loss_router = sum(powerloss_router_expect)/sum(sum(load_expect_day));

% end
source=[1 2 3 6 8];
for k = 1:1:5
    for t = 1:1:12
        line(k,t) = P_out{t}(source(k));
    end
end

t = 0:2:22;
figure(1);
plot(t,line(1,:),'-+b','LineWidth',1);hold on
plot(t,line(2,:),'--or','LineWidth',1);hold on
plot(t,line(3,:),'--sk','LineWidth',1);hold on
plot(t,line(4,:),'-xm','LineWidth',1);hold on
plot(t,line(5,:),'-^g','LineWidth',1);hold on
axis([0 22 0 2.5]);
set(gca,'XTick',0:2:22);
set(gca,'YTick',0:0.5:2.5);
grid on;
xlabel('时刻');ylabel('功率/MW');
set(get(gca,'XLabel'),'FontSize',20);
set(get(gca,'YLabel'),'FontSize',20);
legend('电源1','电源2','电源3','电源6','电源8');
set(get(gca,'legend'),'FontSize',15);
% set(gca,'FontSize',14)
figure(2);
plot(t,power_load_expect,'-sb','LineWidth',1);hold on;
plot(t,power_source_expect,'-or','LineWidth',1);hold on;
axis([0 22 0 5]);
set(gca,'XTick',0:2:22);
set(gca,'YTick',0:0.5:5);
grid on;
xlabel('时刻');ylabel('功率/MW');
set(get(gca,'XLabel'),'FontSize',20);%图上文字为8 point或小5号
set(get(gca,'YLabel'),'FontSize',20);
legend('总负荷','总出力');
set(get(gca,'legend'),'FontSize',15);