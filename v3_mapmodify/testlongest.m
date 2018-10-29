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
R = 0.4*L;
I_real = zeros(size(Connect));
U_real = zeros(size(Connect));

cap_line(1,:)=[zeros(1,1),0,100,0,0,0,0,100,0];
cap_line(2,:)=[zeros(1,2),0,100,0,0,0,0,100];
cap_line(3,:)=[zeros(1,3),100,100,100,0,0,0];
cap_line(4,:)=[zeros(1,4),0,100,0,0,100];
cap_line(5,:)=[zeros(1,5),100,100,0,0];
cap_line(6,:)=[zeros(1,6),0,100,0];
cap_line(7,:)=[zeros(1,7),100,100];
cap_line(8,:)=[zeros(1,8),100];
cap_line(9,:)=[zeros(1,9)];
Capacity_line=cap_line+cap_line';

P_load = zeros(1,length(Connect));
P_out = zeros(1,length(Connect));

U_rated = 10;

P_demand = 5;
source = [1, 2];
Capacity_source = [3, 5];

destination = 5;

[ data, I_real, U_real, P_load, P_out] = ...
  Limited_ShortestPath_loss(Connect, I_real, U_real, P_load, P_demand, destination, U_rated, source,... 
    Capacity_source, Capacity_line, R, P_out);

P_demand2 = 1;

[ data2, I_real2, U_real2, P_load2, P_out2] = ...
    Limited_LongestPath_loss(Connect, I_real, U_real, P_load, P_demand2, destination, U_rated, source,...
    Capacity_source, Capacity_line, R, P_out);
