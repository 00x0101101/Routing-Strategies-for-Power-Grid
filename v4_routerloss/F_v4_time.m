function [ f ] =F_v4_time( source_cap, i, P_before, source )
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
R = 0.12*L;

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


load_expect_all = [
%                0 0 0 0 0 0 0 0 0 0 0 0
%                0 0 0 0 0 0 0 0 0 0 0 0
               1 1 1 3 4 5 4 4 6 5 3 1
               2 3 3 5 6 6 6 5 7 7 3 2
               0 0 0 0 0 0 0 0 0 0 0 0
               0 0 0 0 0 0 0 0 0 0 0 0
               2 2 2 3 3 4 5 6 5 4 3 2
               3 3 4 4 3 4 5 6 5 5 4 3
               2 2 3 4 4 5 5 6 5 4 3 2
               1 1 1 2 2 3 3 3 4 3 3 2
               1 1 2 2 3 3 4 4 5 5 3 1];
% source_expect_all = [
% %                  7 7 8 20 12 16 16 18 18 16 12 7
% %                  8 8 10 10 15 16 16 16 20 18 10 8
%                  0 0 0 0 0 0 0 0 0 0 0 0
%                  0 0 0 0 0 0 0 0 0 0 0 0
%                  7 7 8 20 12 16 16 18 18 16 12 7
%                  8 8 10 10 15 16 16 16 20 18 10 8
%                  0 0 0 0 0 0 0 0 0 0 0 0
%                  0 0 0 0 0 0 0 0 0 0 0 0
%                  0 0 0 0 0 0 0 0 0 0 0 0
%                  0 0 0 0 0 0 0 0 0 0 0 0
%                  0 0 0 0 0 0 0 0 0 0 0 0];

U_rated = 20;
eff = 0.97;

load_expect = load_expect_all(:,i);
source_expect = zeros(size(load_expect));

%加入可再生后要改
if length(source) == length(source_cap)
    for k = 1:1:length(source)
        source_expect(source(k)) = source_cap(k);
    end
else
    error = 1
end

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

a = [665,670];
b = [27.27,27.79];
c = [0.00222,0.00173];
startup = [60000 60000];
if sum(P_load) >= sum(load_expect)
    for t = 1:1:length(source)
       f= f+a(t)+b(t)*P_out(source(t))+c(t)*P_out(source(t))^2;
    end
else
    f = 10^9;
end

for t = 1:1:length(source)
    if (P_before(t) == 0) && (P_out(source(t))>0)
        f = f+ startup(t);
    end
end


end

