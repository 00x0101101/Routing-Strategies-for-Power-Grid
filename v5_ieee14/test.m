% [ f ] = F_v1_time_14( [8 8 8 6 8 8 6 6] );
[ f1 ] = F_v2_day_14( 20*ones(1,96));
[ f2 ] = F_v2_day_14( 15*ones(1,96));
[ f3 ] = F_v2_day_14( 10*ones(1,96));
[ f4 ] = F_v2_day_14( 5*ones(1,96));
[ f5 ] = F_v2_day_14( 0*ones(1,96));
%%

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


U_rated = 20;%kv
eff = 0.97;
I_real = zeros(size(Connect));
U_real = zeros(size(Connect));
I_real(4,5) = 0.1;
I_real(5,4) = -I_real(4,5);
I0 = 0.12;
 [ map ] = Map_cal( Connect, I_real, I0, R, U_rated, eff );
 data_I_expect = zeros(size(Connect));
 data_U_expect = zeros(size(Connect));
 P_load = [0 0 0 0 1.94 0 0 0 0 0 0 0 0 0];
 P_demand = 2.4;
 destination = 7;
 source = [1 2 3 4 6 8 10 13];
 source_expect = [10 10 10 10 0 10 0 10 0 10 0 0 10 0];
 P_out = [0 0 0 2.06 0 0 0 0 0 0 0 0 0 0];
 [ data, data_I_expect, data_U_expect, P_load, P_out] = Limited_ShortestPath_loss(Connect,I_real, ...
        data_U_expect, P_load, P_demand, destination, U_rated, source, source_expect, Capacity_line, R, P_out, eff );

    
    
    

% source = find(all(source_expect_all ~=0,2))';
% source_status = zeros(size(source_expect_all));
% data_I_expect = {I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real,I_real};
% data_U_expect = {U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real,U_real};
% P_load = {};
% P_out = {};
% [point, time] = size(load_expect_all);
% 
% sourcenum = 8;
% lowbounds = zeros(1,sourcenum);
% upbounds = 25*ones(1,sourcenum);
% P_before = 1*ones(1,sourcenum);
% cost = zeros(1,time);



