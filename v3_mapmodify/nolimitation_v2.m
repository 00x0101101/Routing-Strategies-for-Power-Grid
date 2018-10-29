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
P_load = zeros(1,length(Connect));
%%
source = [1];
destination = 4;
P_demand = 5;
U_rated = 10;
I0 = P_demand/U_rated;
% record the demand
P_load(destination) = P_demand;

% calculate weight map
[ Map_temp ] = Map_cal( Connect, I_real, I0, R );
% find the shortest path
distance_temp_diffsource = [];
for t=1:1:length(source)
    [ distance_temp1, route_temp ] = ShortestPath( Map_temp, source(t), destination );
    data_temp{t}= route_temp;
    distance_temp_diffsource(t) = distance_temp1;
end
if min(distance_temp_diffsource) == Inf
    capacity_trans = I0;
    distance = Inf;
    route = 'null';
end

tt = find(distance_temp_diffsource==min(distance_temp_diffsource));
if length(tt)>1
    %index = tt(1);
    for k = 1:1:length(tt)
        route = data_temp{k};
        [ I_real_temp, U_real_temp ] = real_IU_calculate( route, I_real, U_real, P_load, U_rated, R );
        powerloss_temp(k) = sum(sum((I_real_temp.^2.*R)));
    end
    index_temp = find(powerloss_temp==min(powerloss_temp));
    if length(index_temp)>1
        index = index_temp(1)
    else
        index = index_temp;
    end
    capacity_trans = I0;
    distance = distance_temp_diffsource(index);
    route = data_temp{index};
    [ I_real, U_real ] = real_IU_calculate( route, I_real, U_real, P_load, U_rated, R );
else
    index = tt;
    capacity_trans = I0;
    distance = distance_temp_diffsource(index);
    route = data_temp{index};
    [ I_real, U_real ] = real_IU_calculate( route, I_real, U_real, P_load, U_rated, R );
end

%%
[ I_real, U_real ] = real_IU_calculate( route, I_real, U_real, P_load, U_rated, R );
%%
% 计算实际的电流与电压
route_est = route;
route_temp1 = fliplr(route_est);
for i = 1:1:length(route_temp1)-1
    d1 = route_temp1(i);
    s1 = route_temp1(i+1);
    if i ==1 % 与起点相连的第一段
        P_in=0;
        for k = 1:1:length(I_real(:,d1)) %计算流入节点功率
            if k ~= s1
                if I_real(k,d1)>=0
                    P_in = P_in + I_real(k,d1)* U_rated;
                else
                    P_in = P_in - I_real(k,d1)* U_real(k,d1);
                end
            end
        end
        P_in = P_in - P_load(d1);
        if P_in ==0 % 判断该节点功率流入流出情况，确定该线路上总电流方向
            I_real(s1,d1) = 0;
            I_real(d1,s1) = 0;
            U_real(s1,d1) = 0;
            U_real(d1,s1) = 0;
        elseif P_in > 0
            I_real(d1,s1) = (-U_rated+sqrt(U_rated^2+4*P_in*R(d1,s1)))/(2*R(d1,s1));
            I_real(s1,d1) = -I_real(d1,s1);
            U_real(d1,s1) = I_real(d1,s1) * R(d1,s1)+U_rated;
            U_real(s1,d1) = -U_real(d1,s1);
        elseif P_in < 0
            I_real(s1,d1) = -P_in/U_rated;
            I_real(d1,s1) = -I_real(s1,d1);
            U_real(s1,d1) = I_real(s1,d1)* R(s1,d1)+U_rated;
            U_real(d1,s1) = -U_real(s1,d1);
        end
    else
        P_in=0;
        for k = 1:1:length(I_real(:,d1)) %计算流入节点功率,除线路s1,d1
            if k ~= s1
                if I_real(k,d1)>=0
                    P_in = P_in + I_real(k,d1)* U_rated;
                else
                    P_in = P_in - I_real(k,d1)* U_real(k,d1);
                end
            end
        end
        P_in = P_in - P_load(d1);
        if P_in ==0 % 判断该节点功率流入流出情况，确定该线路上总电流方向
            I_real(s1,d1) = 0;
            I_real(d1,s1) = 0;
            U_real(s1,d1) = 0;
            U_real(d1,s1) = 0;
        elseif P_in > 0
            I_real(d1,s1) = (-U_rated+sqrt(U_rated^2+4*P_in*R(d1,s1)))/(2*R(d1,s1));
            I_real(s1,d1) = -I_real(d1,s1);
            U_real(d1,s1) = I_real(d1,s1) * R(d1,s1)+U_rated;
            U_real(s1,d1) = -U_real(d1,s1);
        elseif P_in < 0
            I_real(s1,d1) = -P_in/U_rated;
            I_real(d1,s1) = -I_real(s1,d1);
            U_real(s1,d1) = I_real(s1,d1)* R(s1,d1)+U_rated;
            U_real(d1,s1) = -U_real(s1,d1);
        end
    end
end