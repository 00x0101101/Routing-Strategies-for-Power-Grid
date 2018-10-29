function [ f ] = F_v2_day_9( source_cap )
% 算不动。。。。
% 全天优化，2*12个输入参数
% source_cap = X_temp;
f = 0;
M = inf;
connect(1,:)=[zeros(1,1),M,1,M,M,M,M,1,M];
connect(2,:)=[zeros(1,2),M,1,M,M,M,M,1];
connect(3,:)=[zeros(1,3),1,1,1,M,M,M];
connect(4,:)=[zeros(1,4),M,1,M,M,1];
connect(5,:)=[zeros(1,5),1,1,M,M];
connect(6,:)=[zeros(1,6),M,1,M];
connect(7,:)=[zeros(1,7),1,1];
connect(8,:)=[zeros(1,8),1];
connect(9,:)=[zeros(1,9)];
Connect=connect+connect';

N=0;
l(1,:)=[zeros(1,1),N,4,N,N,N,N,4,N];
l(2,:)=[zeros(1,2),N,4,N,N,N,N,4];
l(3,:)=[zeros(1,3),5,3,3,N,N,N];
l(4,:)=[zeros(1,4),N,6,N,N,5];
l(5,:)=[zeros(1,5),2,3,N,N];
l(6,:)=[zeros(1,6),N,3,N];
l(7,:)=[zeros(1,7),6,4];
l(8,:)=[zeros(1,8),6];
l(9,:)=[zeros(1,9)];
L = (l+l');
% R = L.*R0.*1000;
R = 0.12*L;
I_real = zeros(size(Connect));
U_real = zeros(size(Connect));

W = 0.7;
cap_line(1,:)=[zeros(1,1),0,W,0,0,0,0,W,0];
cap_line(2,:)=[zeros(1,2),0,W,0,0,0,0,W];
cap_line(3,:)=[zeros(1,3),W,W,W,0,0,0];
cap_line(4,:)=[zeros(1,4),0,W,0,0,W];
cap_line(5,:)=[zeros(1,5),W,W,0,0];
cap_line(6,:)=[zeros(1,6),0,W,0];
cap_line(7,:)=[zeros(1,7),W,W];
cap_line(8,:)=[zeros(1,8),W];
cap_line(9,:)=[zeros(1,9)];
Capacity_line=cap_line+cap_line'; %kA

load_expect = [
               0 0 0 0 0 0 0 0 0 0 0 0
               0 0 0 0 0 0 0 0 0 0 0 0
               1 1 1 3 4 5 4 4 6 5 3 1
               2 3 3 5 6 6 6 5 7 7 3 2
%                0 0 0 0 0 0 0 0 0 0 0 0
%                0 0 0 0 0 0 0 0 0 0 0 0
               2 2 2 3 3 4 5 6 5 4 3 2
               3 3 4 4 3 4 5 6 5 5 4 3
               2 2 3 4 4 5 5 6 5 4 3 2
               1 1 1 2 2 3 3 3 4 3 3 2
               1 1 2 2 3 3 4 4 5 5 3 1];
source_expect = [
                 7 7 8 20 12 16 16 18 18 16 12 7
                 8 8 10 10 15 16 16 16 20 18 10 8
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0
%                  7 7 8 20 12 16 16 18 18 16 12 7
%                  8 8 10 10 15 16 16 16 20 18 10 8
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0];

U_rated = 20;
eff = 0.97;

source = find(all(source_expect ~=0,2))';
source_status = zeros(size(source_expect));
data_I_expect = {I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real};
data_U_expect = {U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real};
P_load = {};
P_out = {};
[point, time] = size(load_expect);

f_time = zeros(1,time);

if time*length(source) == length(source_cap)
    source_cap_new = reshape(source_cap, time, length(source))';
else
    error = 1
end

for k = 1:1:length(source)
    source_expect(source(k),:) = source_cap_new(k,:);
end

P_out_initial = [0 0 0 0 0 0 0 0 0];

for i = 1:1:time
    
    P_load{i} = zeros(1,length(Connect));
    P_out{i} = zeros(1,length(Connect));
    [content,index] = sort(load_expect(:,i),'descend');
    for j = 1:1:point
        destination = index(j);
        P_demand = content(j);
        if P_demand > 0
        [ data, data_I_expect{i}, data_U_expect{i}, P_load{i}, P_out{i}] = Limited_ShortestPath_loss(Connect, data_I_expect{i}, data_U_expect{i},...
            P_load{i}, P_demand, destination, U_rated, source, source_expect(:,i), Capacity_line, R, P_out{i}, eff );
        end
    end
    
power_load_expect(i) = sum(P_load{i});
power_source_expect(i) = sum(P_out{i});
Status_up = triu(data_I_expect{i});
powerloss_total_expect(i) = power_source_expect(i) - power_load_expect(i);
powerloss_line_expect(i) = sum(sum((Status_up.^2.*R)));
powerloss_router_expect(i) = powerloss_total_expect(i) - powerloss_line_expect(i);
lossline_expect(i) = powerloss_line_expect(i)/power_source_expect(i);
lossrouter_expect(i) = powerloss_router_expect(i)/power_source_expect(i);
losstotal_expect(i) = powerloss_total_expect(i)/power_source_expect(i);
    
    a = [665,670];
    b = [27.27,27.79];
    c = [0.00222,0.00173];
    startup = [60 60];
    
    if sum(P_load{i}) >= sum(load_expect(:,i))
        for t = 1:1:length(source)
           f_time(i)= f_time(i)+a(t)+b(t)*P_out{i}(source(t))+c(t)*P_out{i}(source(t))^2;
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
            if P_out{i-1}(source(t)) == 0
                f_time(i) = f_time(i)+ startup(t);
            end
        end
    end    
end
f = sum(f_time);

end

