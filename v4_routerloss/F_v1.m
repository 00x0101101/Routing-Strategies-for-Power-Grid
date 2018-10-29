function [ f ] = F_v1( source_cap )
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
L = (l+l'); % km
R = 0.12*L; % ohm

W = 0.7;
cap_line(1,:)=[zeros(1,1),0,0.3,0,0,0,0,W,0];
cap_line(2,:)=[zeros(1,2),0,W,0,0,0,0,W];
cap_line(3,:)=[zeros(1,3),W,W,W,0,0,0];
cap_line(4,:)=[zeros(1,4),0,W,0,0,W];
cap_line(5,:)=[zeros(1,5),W,W,0,0];
cap_line(6,:)=[zeros(1,6),0,W,0];
cap_line(7,:)=[zeros(1,7),W,W];
cap_line(8,:)=[zeros(1,8),W];
cap_line(9,:)=[zeros(1,9)];
Capacity_line=cap_line+cap_line'; %kA

I_real = zeros(size(Connect));
U_real = zeros(size(Connect));

load_expect = [0 0 5 5 7 5 1 3 5]'; % MW
source_expect = [15 25 0 0 0 0 0 0 0]'; % MW
U_rated = 20; % kV
eff = 0.97;
% source_cap 改变
index_1 = find(source_expect~=0);   %加入可再生后要改
if length(index_1) == length(source_cap)
    for k = 1:1:length(index_1)
        source_expect(index_1(k)) = source_cap(k);
    end
else
    error = 1;
end


source = find(all(source_expect ~=0,2))';
source_status = zeros(size(source_expect));
data_I_expect = I_real;
data_U_expect = U_real;
[point, time] = size(load_expect);
% 

P_load = zeros(1,length(Connect));
P_out = zeros(1,length(Connect));
[content,index] = sort(load_expect,'descend');
for j = 1:1:point
    destination = index(j);
    P_demand = content(j);
    if P_demand > 0
    [ data, data_I_expect, data_U_expect, P_load, P_out] = Limited_ShortestPath_loss(Connect, data_I_expect, ...
        data_U_expect, P_load, P_demand, destination, U_rated, source, source_expect, Capacity_line, R, P_out, eff );
    end
end

power_load_expect = sum(P_load);
power_source_expect = sum(P_out);
Status_up = triu(data_I_expect);
powerloss_total_expect = power_source_expect - power_load_expect;
powerloss_line_expect = sum(sum((Status_up.^2.*R)));
powerloss_router_expect = powerloss_total_expect - powerloss_line_expect;

a = [665,670];
b = [27.27,27.79];
c = [0.00222,0.00173];
if sum(P_load) >= sum(load_expect)
    for t = 1:1:length(index_1)
       f= f+a(t)+b(t)*P_out(index_1(t))+c(t)*P_out(index_1(t))^2;
    end
%     f = f + powerloss_total_expect*300;
else
    f = 10^9;
end

end

