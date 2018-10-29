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
% 
% N=0;
% l(1,:)=[zeros(1,1),N,4,N,N,N,N,4,N];
% l(2,:)=[zeros(1,2),N,4,N,N,N,N,4];
% l(3,:)=[zeros(1,3),5,3,3,N,N,N];
% l(4,:)=[zeros(1,4),N,6,N,N,5];
% l(5,:)=[zeros(1,5),2,3,N,N];
% l(6,:)=[zeros(1,6),N,3,N];
% l(7,:)=[zeros(1,7),6,4];
% l(8,:)=[zeros(1,8),6];
% l(9,:)=[zeros(1,9)];
% L = (l+l'); % km
% R = 0.12*L; % ohm

N = 0;
r(1,:)=[zeros(1,1),0.01938,N,N,0.05403,N,N,N,N,N,N,N,N,N];
r(2,:)=[zeros(1,2),0.04699,0.05811,0.05695,N,N,N,N,N,N,N,N,N];
r(3,:)=[zeros(1,3),0.06701,N,N,N,N,N,N,N,N,N,N];
r(4,:)=[zeros(1,4),0.01335,N,10e-6,N,10e-6,N,N,N,N,N];
r(5,:)=[zeros(1,5),10e-6,N,N,N,N,N,N,N,N];
r(6,:)=[zeros(1,6),N,N,N,N,0.09498,0.12291,0.06615,N];
r(7,:)=[zeros(1,7),10e-6,10e-6,N,N,N,N,N];
r(8,:)=[zeros(1,8),N,N,N,N,N,N];
r(9,:)=[zeros(1,9),0.03181,N,N,N,0.12711];
r(10,:)=[zeros(1,10),0.08205,N,N,N];
r(11,:)=[zeros(1,11),N,N,N];
r(12,:)=[zeros(1,12),0.22092,N];
r(13,:)=[zeros(1,13),0.17093];
r(14,:)=[zeros(1,14)];
R=r+r';

Q = 0.7;
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

expect_load = [0 0 0 2 7 0 3 0 1 3 4 2 3 3]'; % MW
expect_source = [10 10 10 6 0 10 0 6 0 6 0 0 6 0]'; % MW
% real_load = [0 0 5 4 7 5 1 3 5]'; %
U_rated = 20; % kV
eff = 0.97;

source = find(all(expect_source ~=0,2))';
source_status = zeros(size(expect_source));
data_I_expect = I_real;
data_U_expect = U_real;

[point, time] = size(expect_load);
% 
P_load = zeros(1,length(Connect));
P_out = zeros(1,length(Connect));
[content,index] = sort(expect_load,'descend');
for j = 1:1:point
    destination = index(j);
    P_demand = content(j);
    if P_demand > 0
    [ data, data_I_expect, data_U_expect, P_load, P_out] = Limited_ShortestPath_loss(Connect, data_I_expect, data_U_expect,...
        P_load, P_demand, destination, U_rated, source, expect_source, Capacity_line, R, P_out, eff );
    end
end

data_I_real = data_I_expect;
data_U_real = data_U_expect;
P_load_real = P_load;
P_out_real = P_out;

% compare_load = real_load - expect_load;
% m = find(compare_load~=0);
% for k = 1:1:length(m)
%     if compare_load(m(k))>0
%         destination = m(k);
%         P_demand = compare_load(m(k));
%         [ data, data_I_real, data_U_real, P_load_real, P_out_real] = Limited_ShortestPath_loss(Connect, data_I_real, data_U_real, P_load_real, P_demand, destination, U_rated, source, expect_source, Capacity_line, R, P_out_real, eff );
%     elseif compare_load(m(k))<0
%         destination = m(k);
%         P_demand = -compare_load(m(k));
%         [ data, data_I_real, data_U_real, P_load_real, P_out_real] = Limited_LongestPath_loss(Connect, data_I_real, data_U_real, P_load_real, P_demand, destination, U_rated, source, expect_source, Capacity_line, R, P_out_real, eff );
%     end  
% end
% % calculate loss
% power_load_real = sum(P_load_real);
% power_source_real = sum(P_out_real);
% Status_up_real = triu(data_I_real);
% powerloss_line_real = sum(sum((Status_up_real.^2.*R)));
% powerloss_router_real = power_source_real - power_load_real - powerloss_line_real;
% lossline_real = powerloss_line_real/power_source_real;
% lossrouter_real = powerloss_router_real/power_source_real;
% losstotal_real = (power_source_real - power_load_real)/power_source_real;
% %%
% expect_load = [0 0 5 4 7 5 1 3 5]'; %
% source = find(all(expect_source ~=0,2))';
% source_status = zeros(size(expect_source));
% data_I_expect = zeros(size(Connect));
% data_U_expect = zeros(size(Connect));
% 
% [point, time] = size(expect_load);
% % 
% P_load = zeros(1,length(Connect));
% P_out = zeros(1,length(Connect));
% [content,index] = sort(expect_load,'descend');
% for j = 1:1:point
%     destination = index(j);
%     P_demand = content(j);
%     if P_demand > 0
%     [ data, data_I_expect, data_U_expect, P_load, P_out] = Limited_ShortestPath_loss(Connect, data_I_expect, data_U_expect,...
%         P_load, P_demand, destination, U_rated, source, expect_source, Capacity_line, R, P_out, eff );
%     end
% end
% power_load = sum(P_load);
% power_source = sum(P_out);
% Status_up = triu(data_I_expect);
% powerloss_line_expect = sum(sum((Status_up.^2.*R)));
% powerloss_router_expect = power_source - power_load - powerloss_line_expect;
% lossline_expect = powerloss_line_expect/power_source;
% lossrouter_expect = powerloss_router_expect/power_source;
% losstotal_expect = (power_source - power_load)/power_source;