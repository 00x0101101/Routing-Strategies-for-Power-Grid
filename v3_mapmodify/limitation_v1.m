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
P_out = zeros(1,length(Connect));
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

source = [1,2];
Capacity_source = [10,20];
% Status_source = [0 0];
destination = 5;
P_demand = 10;
U_rated = 10;
% I0 = P_demand/U_rated;
[ data, I_real, U_real, P_load, P_out] = Limited_ShortestPath_loss(Connect, I_real, U_real, P_load, P_demand, destination, U_rated, source, Capacity_source, Capacity_line, R, P_out );
%%
% P_load(destination) = P_demand; % record the demand
% P_demand_temp = P_demand;
% Map_temp = Connect;
% % I0_temp = I0;
% % I_real_temp = I_real;
% I_real_temp1 = I_real;
% I_real_temp2 = I_real;
% U_real_temp1 = U_real;
% U_real_temp2 = U_real;
% source_temp = source;
% % Status_source_temp1 = Status_source;
% % Status_source_temp2 = Status_source;
% 
% flag = true;
% j=1;
% data={};
% 
% while flag
%     %%
%     I0_temp = P_demand_temp/U_rated;
%     % modify map
%     compare_line = Capacity_line - I_real_temp2;
%     [x,y] = find(compare_line == 0);
%     for k = 1:1:length(x)
%        if x(k)~=y(k)
%           Map_temp(x(k), y(k)) = inf;
%        end
%     end
%     [ Map_temp ] = Map_cal( Map_temp, I_real_temp2, I0_temp, R );
%     % modify source
%     Status_source_temp2 = zeros(size(Capacity_source));
%     for num_source = 1:1:length(source)
%         source_point = source(num_source);
%         for k = 1:1:length(I_real_temp2(source_point,:)) %计算流出节点功率
%             if I_real_temp2(source_point,k)>=0
%                 Status_source_temp2(source_point) = Status_source_temp2(source_point) + I_real_temp2(source_point,k)* U_real_temp2(source_point,k);
%             else
%                 Status_source_temp2(source_point) = Status_source_temp2(source_point) + I_real_temp2(source_point,k)* U_rated;
%             end
%         end
%     end
%     
%     compare_source = Capacity_source - Status_source_temp2;  % 修改
%     aa = find(abs(compare_source(source)) <= Capacity_source(source)*0.001);
%     source_temp(aa) = -1;
%     % find the shortest path
%     distance_temp_diffsource = [];
%     for t=1:1:length(source_temp)
%         if source_temp(t) > 0
%             [ distance_temp1, route_temp ] = ShortestPath( Map_temp, source_temp(t), destination );
%             data_temp{t}= route_temp;
%             distance_temp_diffsource(t) = distance_temp1;
%         else
%             data_temp{t}= 'null';
%             distance_temp_diffsource(t) = inf;
%         end
%     end
%     if min(distance_temp_diffsource) == Inf %没有满足条件的最短路径
%         data{j}.capacity_trans = P_demand_temp;
%         data{j}.distance = inf;
%         data{j}.route = 'null';
%         
%         P_present = 0;
%         for o = 1:1:length(I_real_temp2(:,destination)) %计算流入节点的功率
%             if I_real_temp2(o,destination)>=0
%                 P_present = P_present + I_real_temp2(o,destination)* U_rated;
%             else
%                 P_present = P_present + I_real_temp2(o,destination)* U_real_temp2(o,destination);
%             end
%         end
%         
%         P_load(destination) = P_present;
%         break;
%     end
%     tt = find(distance_temp_diffsource==min(distance_temp_diffsource));
%     if length(tt)>1 % 超过一条最短路径，判断真实损耗
%         for k = 1:1:length(tt)
%             route_temp = data_temp{k};
%             [ I_real_temp3, U_real_temp3 ] = real_IU_calculate( route_temp, I_real_temp2, U_real_temp2, P_load, U_rated, R );
%             powerloss_temp(k) = sum(sum((I_real_temp3.^2.*R)));
%         end
%         index_temp = find(powerloss_temp==min(powerloss_temp));
%         if length(index_temp)>1
%             index = index_temp(1)
%         else
%             index = index_temp;
%         end
%         capacity_trans_temp = I0_temp;
%         distance_temp = distance_temp_diffsource(index);
%         route_temp = data_temp{index};
%         [ I_real_temp1, U_real_temp1 ] = real_IU_calculate( route_temp, I_real_temp2, U_real_temp2, P_load, U_rated, R );
%     else
%         index = tt;
%         capacity_trans_temp = I0_temp;
%         distance_temp = distance_temp_diffsource(index);
%         route_temp = data_temp{index};
%         [ I_real_temp1, U_real_temp1 ] = real_IU_calculate( route_temp, I_real_temp2, U_real_temp2, P_load, U_rated, R );
%     end
%     %%
%     % source limitation
%     select_source = route_temp(1);
%     Status_source_temp1 = zeros(size(Capacity_source));
%     for num_source = 1:1:length(source)
%         source_point = source(num_source);
%         for k = 1:1:length(I_real_temp1(source_point,:)) %计算流出节点功率
%             if I_real_temp1(source_point,k)>=0
%                 Status_source_temp1(source_point) = Status_source_temp1(source_point) + I_real_temp1(source_point,k)* U_real_temp1(source_point,k);
%             else
%                 Status_source_temp1(source_point) = Status_source_temp1(source_point) + I_real_temp1(source_point,k)* U_rated;
%             end
%         end
%     end
%     
%     b = Capacity_source(select_source) - Status_source_temp1(select_source);
%     if b >= 0 % source
%         temp = [];
%         compare = Capacity_line - I_real_temp1;
%         for i=1:1:length(route_temp)-1
%             temp = [temp, compare(route_temp(i),route_temp(i+1))];
%         end
%         a = min(temp);
%         if a >= 0 % line
%             I_real_temp2 = I_real_temp1;
%             U_real_temp2 = U_real_temp1;
%             data{j}.capacity_trans = P_demand_temp;
%             data{j}.distance = distance_temp;
%             data{j}.route = route_temp;
%             flag = false;
%         else
%             I_real_temp1 = I_real_temp2;
%             U_real_temp1 = U_real_temp2;
%             [m,n] = find(compare == a);
%             [x] = find(route_temp == m);
%             [y] = find(route_temp == n);
%             x = min(x);
%             y = min(y);
%             I_real_temp1(route_temp(x),route_temp(y)) = Capacity_line(route_temp(x),route_temp(y));
%             I_real_temp1(route_temp(y),route_temp(x)) = -I_real_temp1(route_temp(x),route_temp(y));
%             U_real_temp1(route_temp(x),route_temp(y)) = U_rated + I_real_temp1(route_temp(x),route_temp(y)) * R(route_temp(x),route_temp(y));
%             U_real_temp1(route_temp(y),route_temp(x)) = U_real_temp1(route_temp(x),route_temp(y));
%             route_temp_toStart = [];
%             route_temp_toFinish = [];
%             route_temp_toStart = route_temp(1:y);
%             route_temp_toFinish = route_temp(x:length(route_temp));
%             [ I_real_temp1, U_real_temp1 ] = real_IU_calculate_FtoS( route_temp_toStart, I_real_temp1, U_real_temp1, P_load, U_rated, R);
%             [ I_real_temp1, U_real_temp1 ] = real_IU_calculate_StoF( route_temp_toFinish, I_real_temp1, U_real_temp1, P_load, U_rated, R);
%             I_real_temp2 = I_real_temp1;
%             U_real_temp2 = U_real_temp1;
% 
%             P_present = 0;
%             for o = 1:1:length(I_real_temp2(:,destination)) %计算流入节点的功率
%                 if I_real_temp2(o,destination)>=0
%                     P_present = P_present + I_real_temp2(o,destination)* U_rated;
%                 else
%                     P_present = P_present + I_real_temp2(o,destination)* U_real_temp2(o,destination);
%                 end
%             end
% 
%             data{j}.capacity_trans = P_demand_temp - P_present ;
%             data{j}.distance = distance_temp;
%             data{j}.route = route_temp;
%             P_demand_temp = P_demand - P_present;
%             j = j+1;
%         end
%     else % source max
%         I_real_temp1 = I_real_temp2;
%         U_real_temp1 = U_real_temp2;
%         %
%         P_present = 0;
%         for k = 1:1:length(I_real_temp2(select_source,:)) %计算流出节点功率
%             if k ~= route_temp(2)
%                 if I_real_temp2(source_point,k)>=0
%                     P_present = P_present + I_real_temp2(select_source,k)* U_real_temp2(select_source,k);
%                 else
%                     P_present = P_present + I_real_temp2(select_source,k)* U_rated;
%                 end
%             end
%         end
%         Capacity_rest = Capacity_source(select_source) - P_present;
%         
%         I0_temp2 = (-U_rated+sqrt(U_rated^2+4*Capacity_rest*R(select_source,route_temp(2))))/(2*R(select_source,route_temp(2)));
%         I_real_temp1(select_source,route_temp(2)) = I0_temp2;
%         I_real_temp1(route_temp(2),select_source) = -I_real_temp1(select_source,route_temp(2));
%         U_real_temp1(select_source,route_temp(2)) = U_rated + I0_temp2 * R(select_source,route_temp(2));
%         U_real_temp1(route_temp(2),select_source) = U_real_temp1(select_source,route_temp(2));
%         [ I_real_temp1, U_real_temp1 ] = real_IU_calculate_StoF( route_temp, I_real_temp1, U_real_temp1, P_load, U_rated, R );
%         
%         temp = [];
%         compare = Capacity_line - I_real_temp1;
%         for i=1:1:length(route_temp)-1
%             temp = [temp, compare(route_temp(i),route_temp(i+1))];
%         end
%         a = min(temp);
%         if a >= 0
%             I_real_temp2 = I_real_temp1;
%             U_real_temp2 = U_real_temp1;
%             P_present = 0;
%             for o = 1:1:length(I_real_temp2(:,destination)) %计算流入节点的功率
%                 if I_real_temp2(o,destination)>=0
%                     P_present = P_present + I_real_temp2(o,destination)* U_rated;
%                 else
%                     P_present = P_present + I_real_temp2(o,destination)* U_real_temp2(o,destination);
%                 end
%             end
%             
%             data{j}.capacity_trans = P_demand_temp - P_present;
%             data{j}.distance = distance_temp;
%             data{j}.route = route_temp;
%             
%             P_demand_temp = P_demand - P_present;
%             j = j+1; %P_demand
%         else
%             I_real_temp1 = I_real_temp2;
%             U_real_temp1 = U_real_temp2;
%             [m,n] = find(compare == a);
%             [x] = find(route_temp == m);
%             [y] = find(route_temp == n);
%             x = min(x);
%             y = min(y);
%             I_real_temp1(route_temp(x),route_temp(y)) = Capacity_line(route_temp(x),route_temp(y));
%             I_real_temp1(route_temp(y),route_temp(x)) = -I_real_temp1(route_temp(x),route_temp(y));
%             U_real_temp1(route_temp(x),route_temp(y)) = U_rated + I_real_temp1(route_temp(x),route_temp(y)) * R(route_temp(x),route_temp(y));
%             U_real_temp1(route_temp(y),route_temp(x)) = U_real_temp1(route_temp(x),route_temp(y));
%             route_temp_toStart = [];
%             route_temp_toFinish = [];
%             route_temp_toStart = route_temp(1:y);
%             route_temp_toFinish = route_temp(x:length(route_temp));
%             [ I_real_temp1, U_real_temp1 ] = real_IU_calculate_FtoS( route_temp_toStart, I_real_temp1, U_real_temp1, P_load, U_rated, R);
%             [ I_real_temp1, U_real_temp1 ] = real_IU_calculate_StoF( route_temp_toFinish, I_real_temp1, U_real_temp1, P_load, U_rated, R);
% 
%             I_real_temp2 = I_real_temp1;
%             U_real_temp2 = U_real_temp1;
% 
%             P_present = 0;
%             for o = 1:1:length(I_real_temp2(:,destination)) %计算流入节点的功率
%                 if I_real_temp2(o,destination)>=0
%                     P_present = P_present + I_real_temp2(o,destination)* U_rated;
%                 else
%                     P_present = P_present + I_real_temp2(o,destination)* U_real_temp2(o,destination);
%                 end
%             end
% 
%             data{j}.capacity_trans = P_demand_temp - P_present;
%             data{j}.distance = distance_temp;
%             data{j}.route = route_temp;
%             P_demand_temp = P_demand - P_present;
%             j = j+1;
%         end
%     end
% end