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

I_real = zeros(size(Connect));
U_real = zeros(size(Connect));

% load_expect = [ 0 0 2.416752742	4.833505484	1.208376371	3.625129113	6.041881855	5.43769367	0.725025823]'.*10^-3;
% load_expect = [ 0 0 2.42 4.83 1.21 3.63 6.04 5.44 0.73]'.*10^-3;
% load_real = [ 0 0 2.416752742	4.833505484	1.208376371	3.625129113	6.041881855	5.43769367	0.725025823]'.*10^-3;
load_expect = [0 0 3 4 7 5 1 3 5]'; % MW
source_expect = [19.0273169732548,12.0212775693812 0 0 0 0 0 0 0]'; % MW
load_real = [0 0 5 5 7 5 1 3 5]'; %
% source_real = [12 25 0 0 0 0 0 0 0]'; %
source_real = source_expect;

U_rated = 20; % kV
eff = 0.97;

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
lossline_expect = powerloss_line_expect/power_source_expect;
lossrouter_expect = powerloss_router_expect/power_source_expect;
losstotal_expect = powerloss_total_expect/power_source_expect;
a = [665,670];
b = [27.27,27.79];
c = [0.00222,0.00173];
f=0;
if sum(P_load) >= sum(load_expect)
    for t = 1:1:length(index_1)
       f= f+a(t)+b(t)*P_out(index_1(t))+c(t)*P_out(index_1(t))^2;
    end
%     f = f + powerloss_total_expect*300;
else
    f = 10^9;
end
%%
% source difference
data_I_real = data_I_expect;
data_U_real = data_U_expect;
P_load_real = P_load;
P_out_real = P_out;
% compare_source = source_real - source_expect;
% t = find(compare_source~=0);
% for k = 1:1:length(t)
%     if compare_source(t(k))<0
%         P_out_real(t(k)) = source_real(t(k));
%         destination = t(k);
%         P_demand = -compare_source(t(k));
%         [ data, data_I_real, data_U_real, P_load_real, P_out_real] = Limited_ShortestPath_loss(Connect, data_I_real,...
%             data_U_real, P_load_real, P_demand, destination, U_rated, source, source_real, Capacity_line, R,...
%             P_out_real, eff );
%         P_load_real(t(k)) = 0;
%     end
% end
%%
% load difference
tic;
compare_load = load_real - load_expect;
m = find(compare_load<0);
for k = 1:1:length(m)
    destination = m(k);
    P_demand = -compare_load(m(k));
    [ data, data_I_real, data_U_real, P_load_real, P_out_real] = Limited_LongestPath_loss(Connect, data_I_real, data_U_real, P_load_real, P_demand, destination, U_rated, source, source_expect, Capacity_line, R, P_out_real, eff );  
end
n = find(compare_load>0);
for k = 1:1:length(n)
    destination = n(k);
    P_demand = compare_load(n(k));
    [ data, data_I_real, data_U_real, P_load_real, P_out_real] = Limited_ShortestPath_loss(Connect, data_I_real, data_U_real, P_load_real, P_demand, destination, U_rated, source, source_expect, Capacity_line, R, P_out_real, eff ); 
end
toc;
%%
% calculate loss
power_load_real = sum(P_load_real);
power_source_real = sum(P_out_real);
Status_up_real = triu(data_I_real);
powerloss_total_real = power_source_real - power_load_real;
powerloss_line_real = sum(sum((Status_up_real.^2.*R)));
powerloss_router_real = powerloss_total_real - powerloss_line_real;
lossline_real = powerloss_line_real/power_source_real;
lossrouter_real = powerloss_router_real/power_source_real;
losstotal_real = powerloss_total_real/power_source_real;
index_1 = find(source_expect~=0);
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