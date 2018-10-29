function [ data, I_real, U_real, P_load, P_generate] = Limited_LongestPath_loss(Connect, I_real, U_real, P_load, P_demand,...
            destination, U_rated, source, Capacity_source, Capacity_line, R, P_generate, eff)
    P_load(destination) = P_load(destination) - P_demand; % record the demand %
    P_demand_temp = P_demand;
    Map_temp = Connect;
    I_real_temp1 = I_real;
    I_real_temp2 = I_real;
    U_real_temp1 = U_real;
    U_real_temp2 = U_real;
    source_temp = source;

    flag = true;
    j=1;
    data={};

    while flag
        I0_temp = P_demand_temp/U_rated;
        % modify map
        compare_line = Capacity_line - I_real_temp2;
        [x,y] = find(compare_line == 0);
        for k = 1:1:length(x)
           if x(k)~=y(k)
              Map_temp(x(k), y(k)) = inf;
           end
        end
        [ Map_temp ] = Map_cal_longest( Map_temp, I_real_temp2, I0_temp, R, U_rated, eff ); %
        % modify source
        Status_source_temp2 = zeros(size(Capacity_source));
        for num_source = 1:1:length(source)
            source_point = source(num_source);
            [ p_in, p_out ] = Power_flow( source_point, I_real_temp2, U_real_temp2, U_rated );
            Status_source_temp2(source_point) = p_out/eff - p_in;
%             for k = 1:1:length(I_real_temp2(source_point,:)) %计算流出节点功率
%                 if I_real_temp2(source_point,k)>=0
%                     Status_source_temp2(source_point) = Status_source_temp2(source_point) + I_real_temp2(source_point,k)* U_real_temp2(source_point,k);
%                 else
%                     Status_source_temp2(source_point) = Status_source_temp2(source_point) + I_real_temp2(source_point,k)* U_rated;
%                 end
%             end
        end

%         compare_source = Capacity_source - Status_source_temp2;
%         aa = find(abs(compare_source(source)) <= Capacity_source(source)*0.001);
        aa = find(abs(Status_source_temp2(source)) <= Capacity_source(source)*0.001); %
        source_temp(aa) = -1;
        % find the shortest path
        distance_temp_diffsource = [];
        for t=1:1:length(source_temp)
            if source_temp(t) > 0
                [ distance_temp1, route_temp ] = ShortestPath( Map_temp, source_temp(t), destination );
                data_temp{t}= route_temp;
                distance_temp_diffsource(t) = distance_temp1;
            else
                data_temp{t}= 'null';
                distance_temp_diffsource(t) = inf;
            end
        end
        if min(distance_temp_diffsource) == Inf %没有满足条件的最短路径
            data{j}.capacity_trans = - P_demand_temp; %
            data{j}.distance = inf;
            data{j}.route = 'null';

%             P_present = 0; %%%%%%这段还没考虑
%             for o = 1:1:length(I_real_temp2(:,destination)) %计算流入节点的功率
%                 if I_real_temp2(o,destination)>=0
%                     P_present = P_present + I_real_temp2(o,destination)* U_rated;
%                 else
%                     P_present = P_present + I_real_temp2(o,destination)* U_real_temp2(o,destination);
%                 end
%             end
            [ p_in, p_out ] = Power_flow( destination, I_real_temp2, U_real_temp2, U_rated );
            P_present = p_in *eff - p_out;
            P_load(destination) = P_present;  %%%%%
            
            break;
        end
        tt = find(distance_temp_diffsource==min(distance_temp_diffsource));  %%%%范围扩大一下
        if length(tt)>1 % 超过一条最短路径，判断真实损耗
            for k = 1:1:length(tt)
                route_temp = data_temp{k};
                [ I_real_temp3, U_real_temp3 ] = real_IU_calculate( route_temp, I_real_temp2, U_real_temp2, P_load, U_rated, R, P_generate, eff );
                powerloss_temp(k) = sum(sum((I_real_temp3.^2.*R)));
            end
            index_temp = find(powerloss_temp==min(powerloss_temp));
            if length(index_temp)>1
                index = index_temp(1)
            else
                index = index_temp;
            end
%             capacity_trans_temp = I0_temp;
            distance_temp = distance_temp_diffsource(index);
            route_temp = data_temp{index};
            [ I_real_temp1, U_real_temp1 ] = real_IU_calculate( route_temp, I_real_temp2, U_real_temp2, P_load, U_rated, R, P_generate, eff );
        else
            index = tt;
%             capacity_trans_temp = I0_temp;
            distance_temp = distance_temp_diffsource(index);
            route_temp = data_temp{index};
            [ I_real_temp1, U_real_temp1 ] = real_IU_calculate( route_temp, I_real_temp2, U_real_temp2, P_load, U_rated, R, P_generate, eff );
        end
        % source limitation
        select_source = route_temp(1);
        Status_source_temp1 = zeros(size(Capacity_source));
        for num_source = 1:1:length(source)
            source_point = source(num_source);
            [ p_in, p_out ] = Power_flow( source_point, I_real_temp1, U_real_temp1, U_rated );
            Status_source_temp1(source_point) = p_out/eff-p_in;
%             for k = 1:1:length(I_real_temp1(source_point,:)) %计算流出节点功率
%                 if I_real_temp1(source_point,k)>=0
%                     Status_source_temp1(source_point) = Status_source_temp1(source_point) + I_real_temp1(source_point,k)* U_real_temp1(source_point,k);
%                 else
%                     Status_source_temp1(source_point) = Status_source_temp1(source_point) + I_real_temp1(source_point,k)* U_rated;
%                 end
%             end
        end

%         b = Capacity_source(select_source) - Status_source_temp1(select_source);
        b = Status_source_temp1(select_source); %
        
        if b >= 0 % source
            temp = [];
            compare = Capacity_line - I_real_temp1;
            for i=1:1:length(route_temp)-1
                temp = [temp, compare(route_temp(i),route_temp(i+1))];
            end
            a = min(temp);
            if a >= 0 % line
                I_real_temp2 = I_real_temp1;
                U_real_temp2 = U_real_temp1;
                data{j}.capacity_trans = - P_demand_temp; %
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;
                
%                 P_present = 0;
%                 for k = 1:1:length(I_real_temp2(select_source,:)) %计算流出节点功率
%                     if I_real_temp2(select_source,k)>=0
%                         P_present = P_present + I_real_temp2(select_source,k)* U_real_temp2(select_source,k);
%                     else
%                         P_present = P_present + I_real_temp2(select_source,k)* U_rated;
%                     end
%                 end
                [ p_in, p_out ] = Power_flow( select_source, I_real_temp2, U_real_temp2, U_rated );
                P_present = p_out/eff - p_in;
                P_generate(select_source) = P_present;
                
                flag = false;
            else   %%%%%%加循环判断直到没有超容量的线路为止
                I_real_temp1 = I_real_temp2;
                U_real_temp1 = U_real_temp2;
                [m,n] = find(compare == a);
                [x] = find(route_temp == m);
                [y] = find(route_temp == n);
                x = min(x);
                y = min(y);
                I_real_temp1(route_temp(x),route_temp(y)) = Capacity_line(route_temp(x),route_temp(y));
                I_real_temp1(route_temp(y),route_temp(x)) = -I_real_temp1(route_temp(x),route_temp(y));
                U_real_temp1(route_temp(x),route_temp(y)) = U_rated + I_real_temp1(route_temp(x),route_temp(y)) * R(route_temp(x),route_temp(y));
                U_real_temp1(route_temp(y),route_temp(x)) = U_real_temp1(route_temp(x),route_temp(y));
                route_temp_toStart = [];
                route_temp_toFinish = [];
                route_temp_toStart = route_temp(1:y);
                route_temp_toFinish = route_temp(x:length(route_temp));
                [ I_real_temp1, U_real_temp1 ] = real_IU_calculate_FtoS( route_temp_toStart, I_real_temp1, U_real_temp1, P_load, U_rated, R, P_generate, eff );
                [ I_real_temp1, U_real_temp1 ] = real_IU_calculate_StoF( route_temp_toFinish, I_real_temp1, U_real_temp1, P_load, U_rated, R, P_generate, eff );
                I_real_temp2 = I_real_temp1;
                U_real_temp2 = U_real_temp1;

%                 P_present = 0;
%                 for o = 1:1:length(I_real_temp2(:,destination)) %计算流入节点的功率
%                     if I_real_temp2(o,destination)>=0
%                         P_present = P_present + I_real_temp2(o,destination)* U_rated;
%                     else
%                         P_present = P_present + I_real_temp2(o,destination)* U_real_temp2(o,destination);
%                     end
%                 end
                [ p_in, p_out ] = Power_flow( destination, I_real_temp2, U_real_temp2, U_rated );
                P_present = p_in *eff - p_out;

%                 data{j}.capacity_trans = P_demand_temp - (P_demand - P_present);
                data{j}.capacity_trans = - (P_demand_temp - (P_present - P_load(destination)));
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;
%                 P_demand_temp = P_demand - P_present;
                P_demand_temp = P_present - P_load(destination);
                
%                 P_present = 0;
%                 for k = 1:1:length(I_real_temp2(select_source,:)) %计算流出节点功率
%                     if I_real_temp2(select_source,k)>=0
%                         P_present = P_present + I_real_temp2(select_source,k)* U_real_temp2(select_source,k);
%                     else
%                         P_present = P_present + I_real_temp2(select_source,k)* U_rated;
%                     end
%                 end
                [ p_in, p_out ] = Power_flow( select_source, I_real_temp2, U_real_temp2, U_rated );
                P_present = p_out/eff - p_in;
                P_generate(select_source) = P_present;
                
                j = j+1;
            end
        else % source max
            I_real_temp1 = I_real_temp2;
            U_real_temp1 = U_real_temp2;
            %
            P_present = 0;
            p_in = 0;
            p_out = 0;
            for k = 1:1:length(I_real_temp2(:,select_source)) %计算流出节点功率
                if k ~= route_temp(2)
                    if I_real_temp2(k,select_source)>=0
                        p_in = p_in + I_real_temp2(k,select_source)* U_rated;
                    else
                        p_out = p_out - I_real_temp2(k,select_source)* U_real_temp2(k,select_source);
                    end
                end
            end
            P_present = p_out/eff - p_in;
%             for k = 1:1:length(I_real_temp2(select_source,:)) %计算流出节点功率
%                 if k ~= route_temp(2)
%                     if I_real_temp2(source_point,k)>=0
%                         p_in = p_in + I_real_temp2(select_source,k)* U_real_temp2(select_source,k);
%                     else
%                         P_present = P_present + I_real_temp2(select_source,k)* U_rated;
%                     end
%                 end
%             end
%             Capacity_rest = Capacity_source(select_source) - P_present;

%             I0_temp2 = (-U_rated+sqrt(U_rated^2+4*Capacity_rest*R(select_source,route_temp(2))))/(2*R(select_source,route_temp(2)));
%             I_real_temp1(select_source,route_temp(2)) = I0_temp2;
%             I_real_temp1(route_temp(2),select_source) = -I_real_temp1(select_source,route_temp(2));
%             U_real_temp1(select_source,route_temp(2)) = U_rated + I0_temp2 * R(select_source,route_temp(2));
%             U_real_temp1(route_temp(2),select_source) = U_real_temp1(select_source,route_temp(2));
            I0_temp2 = eff*P_present/U_rated; %%
            I_real_temp1(route_temp(2),select_source) = I0_temp2; %
            I_real_temp1(select_source,route_temp(2)) = -I_real_temp1(route_temp(2),select_source); %
            U_real_temp1(select_source,route_temp(2)) = U_rated + I0_temp2 * R(select_source,route_temp(2)); %
            U_real_temp1(route_temp(2),select_source) = U_real_temp1(select_source,route_temp(2)); %
            
            [ I_real_temp1, U_real_temp1 ] = real_IU_calculate_StoF( route_temp, I_real_temp1, U_real_temp1, P_load, U_rated, R, P_generate, eff );

            temp = [];
            compare = Capacity_line - I_real_temp1;
            for i=1:1:length(route_temp)-1
                temp = [temp, compare(route_temp(i),route_temp(i+1))];
            end
            a = min(temp);
            if a >= 0
                I_real_temp2 = I_real_temp1;
                U_real_temp2 = U_real_temp1;
                
%                 P_present = 0;
%                 for o = 1:1:length(I_real_temp2(:,destination)) %计算流入节点的功率
%                     if I_real_temp2(o,destination)>=0
%                         P_present = P_present + I_real_temp2(o,destination)* U_rated;
%                     else
%                         P_present = P_present + I_real_temp2(o,destination)* U_real_temp2(o,destination);
%                     end
%                 end
                [ p_in, p_out ] = Power_flow( destination, I_real_temp2, U_real_temp2, U_rated );
                P_present = p_in *eff - p_out;

%                 data{j}.capacity_trans = P_demand_temp - (P_demand - P_present);
                data{j}.capacity_trans = -(P_demand_temp - (P_present - P_load(destination)));
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;

%                 P_demand_temp = P_demand - P_present;
                P_demand_temp = P_present - P_load(destination);
%                 P_present = 0;
%                 for k = 1:1:length(I_real_temp2(select_source,:)) %计算流出节点功率
%                     if I_real_temp2(select_source,k)>=0
%                         P_present = P_present + I_real_temp2(select_source,k)* U_real_temp2(select_source,k);
%                     else
%                         P_present = P_present + I_real_temp2(select_source,k)* U_rated;
%                     end
%                 end
                [ p_in, p_out ] = Power_flow( select_source, I_real_temp2, U_real_temp2, U_rated );
                P_present = p_out/eff - p_in;
                P_generate(select_source) = P_present;
                
                j = j+1; %P_demand
            else  %%%%%%加循环判断直到没有超容量的线路为止
                I_real_temp1 = I_real_temp2;
                U_real_temp1 = U_real_temp2;
                [m,n] = find(compare == a);
                [x] = find(route_temp == m);
                [y] = find(route_temp == n);
                x = min(x);
                y = min(y);
                I_real_temp1(route_temp(x),route_temp(y)) = Capacity_line(route_temp(x),route_temp(y));
                I_real_temp1(route_temp(y),route_temp(x)) = -I_real_temp1(route_temp(x),route_temp(y));
                U_real_temp1(route_temp(x),route_temp(y)) = U_rated + I_real_temp1(route_temp(x),route_temp(y)) * R(route_temp(x),route_temp(y));
                U_real_temp1(route_temp(y),route_temp(x)) = U_real_temp1(route_temp(x),route_temp(y));
                route_temp_toStart = [];
                route_temp_toFinish = [];
                route_temp_toStart = route_temp(1:y);
                route_temp_toFinish = route_temp(x:length(route_temp));
                [ I_real_temp1, U_real_temp1 ] = real_IU_calculate_FtoS( route_temp_toStart, I_real_temp1, U_real_temp1, P_load, U_rated, R, P_generate, eff);
                [ I_real_temp1, U_real_temp1 ] = real_IU_calculate_StoF( route_temp_toFinish, I_real_temp1, U_real_temp1, P_load, U_rated, R, P_generate, eff);

                I_real_temp2 = I_real_temp1;
                U_real_temp2 = U_real_temp1;

%                 P_present = 0;
%                 for o = 1:1:length(I_real_temp2(:,destination)) %计算流入节点的功率
%                     if I_real_temp2(o,destination)>=0
%                         P_present = P_present + I_real_temp2(o,destination)* U_rated;
%                     else
%                         P_present = P_present + I_real_temp2(o,destination)* U_real_temp2(o,destination);
%                     end
%                 end
                [ p_in, p_out ] = Power_flow( destination, I_real_temp2, U_real_temp2, U_rated );
                P_present = p_in *eff - p_out;

%                 data{j}.capacity_trans = P_demand_temp - (P_demand - P_present);
                data{j}.capacity_trans = P_demand_temp - (P_present - P_load(destination));
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;
%                 P_demand_temp = P_demand - P_present;
                P_demand_temp = P_present - P_load(destination);
                
%                 P_present = 0;
%                 for k = 1:1:length(I_real_temp2(select_source,:)) %计算流出节点功率
%                     if I_real_temp2(select_source,k)>=0
%                         P_present = P_present + I_real_temp2(select_source,k)* U_real_temp2(select_source,k);
%                     else
%                         P_present = P_present + I_real_temp2(select_source,k)* U_rated;
%                     end
%                 end
                [ p_in, p_out ] = Power_flow( select_source, I_real_temp2, U_real_temp2, U_rated );
                P_present = p_out/eff - p_in;
                P_generate(select_source) = P_present;
                
                j = j+1;
            end
        end
    end
    
    I_real = I_real_temp2;
    U_real = U_real_temp2;
end

