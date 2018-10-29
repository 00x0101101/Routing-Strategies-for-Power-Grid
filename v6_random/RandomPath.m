function [ data, I_real, U_real, P_load, P_generate] = RandomPath(Connect, I_real, U_real, P_load, P_demand, ...
            destination, U_rated, source, Capacity_source, Capacity_line, R, P_generate, eff)
    P_load(destination) = P_load(destination) + P_demand; % record the demand
    P_demand_temp = P_demand;
    Map_temp = Connect;
    I_real_temp1 = I_real;
    I_real_temp2 = I_real;
    U_real_temp1 = U_real;
    U_real_temp2 = U_real;
    source_temp = source;

    bb = find(Capacity_source(source) == 0);  % source停机情况
    source_temp(bb) = -1;
    
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
        [ Map_temp ] = Map_cal( Map_temp, I_real_temp2, I0_temp, R, U_rated, eff );
        
        compare_source = Capacity_source - P_generate';
        aa = find(compare_source(source) <= Capacity_source(source)*0.001);
        source_temp(aa) = -1;
        % find the all path
        allpath = [];
        for t=1:1:length(source_temp)
            if source_temp(t) > 0
                possiablePaths = [];
                possiablePaths = findPath(Map_temp, source_temp(t), destination, 0);
                allpath = [allpath;possiablePaths];
            end
        end
        % 判断路径矩阵是否为空
        if isempty(allpath)
            data{j}.capacity_trans = P_demand_temp;
            data{j}.distance = inf;
            data{j}.route = 'null';
            [ p_in, p_out ] = Power_flow( destination, I_real_temp2, U_real_temp2, U_rated );
            P_present = p_in *eff - p_out;
%             P_load(destination) = P_present;
            P_load(destination) = P_present + P_generate(destination)*eff ;
            break;
        end
        [pathnum,~] = size(allpath);
        indexnum = randi([1,pathnum],1,1);
        
        distance_temp = allpath(indexnum,length(Map_temp)+1);
        route_temp = allpath(indexnum, 1:length(Map_temp));
        route_temp = route_temp(route_temp ~= 0);
        [ I_real_temp1, U_real_temp1 ] = real_IU_calculate( route_temp, I_real_temp2, U_real_temp2, P_load, U_rated, R, P_generate, eff );
        
        select_source = route_temp(1);
        Status_source_temp1 = zeros(size(Capacity_source));
        for num_source = 1:1:length(source)
            source_point = source(num_source);
            [ p_in, p_out ] = Power_flow( source_point, I_real_temp1, U_real_temp1, U_rated );
            Status_source_temp1(source_point) = p_out/eff - p_in;
        end
        
        % limitation, source&line
        if select_source == destination
            b = Capacity_source(select_source) - Status_source_temp1(select_source)- P_load(select_source)/eff;
%             b = Capacity_source(select_source) - Status_source_temp1(select_source)- P_generate(select_source);
            if b>=0
                I_real_temp2 = I_real_temp1;
                U_real_temp2 = U_real_temp1;
                data{j}.capacity_trans = P_demand_temp;
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;
                [ p_in, p_out ] = Power_flow( select_source, I_real_temp2, U_real_temp2, U_rated );
                P_present = p_out/eff - p_in;
                P_generate(select_source) = P_present+P_load(select_source)/eff;
%                 P_generate(select_source) = P_demand_temp;
                flag = false;
            else
                Capacity_rest = Capacity_source(select_source) - Status_source_temp1(select_source);
                data{j}.capacity_trans = Capacity_rest*eff;
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;
                P_generate(select_source) = Capacity_source(select_source);
                [ p_in, p_out ] = Power_flow( destination, I_real_temp2, U_real_temp2, U_rated );
                P_present = p_in *eff - p_out;
                P_demand_temp = P_load(destination) - P_present - P_generate(select_source)*eff;
                j = j+1;
            end
        else
            % source limitation
            b = Capacity_source(select_source) - Status_source_temp1(select_source)- P_load(select_source)/eff;
    %         b = Capacity_source(select_source) - Status_source_temp1(select_source)- P_generate(select_source);
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
                    data{j}.capacity_trans = P_demand_temp;
                    data{j}.distance = distance_temp;
                    data{j}.route = route_temp;
                    [ p_in, p_out ] = Power_flow( select_source, I_real_temp2, U_real_temp2, U_rated );
                    P_present = p_out/eff - p_in;
                    P_generate(select_source) = P_present+P_load(select_source)/eff;
                    flag = false;
                else
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

                    [ p_in, p_out ] = Power_flow( destination, I_real_temp2, U_real_temp2, U_rated );
                    P_present = p_in *eff - p_out;

                    data{j}.capacity_trans = P_demand_temp - (P_load(destination) - P_present);
                    data{j}.distance = distance_temp;
                    data{j}.route = route_temp;
                    P_demand_temp = P_load(destination) - P_present;

                    [ p_in, p_out ] = Power_flow( select_source, I_real_temp2, U_real_temp2, U_rated );
                    P_present = p_out/eff - p_in;
                    P_generate(select_source) = P_present + P_load(select_source)/eff;

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

                Capacity_rest = Capacity_source(select_source) - P_present - P_load(select_source)/eff;
%                 Capacity_rest = Capacity_source(select_source) - P_present - P_generate(select_source);%%%改过
                if Capacity_rest>=0
                    I0_temp2 = (-U_rated+sqrt(U_rated^2+4*Capacity_rest*eff*R(select_source,route_temp(2))))/(2*R(select_source,route_temp(2)));
                    I_real_temp1(select_source,route_temp(2)) = I0_temp2;
                    I_real_temp1(route_temp(2),select_source) = -I_real_temp1(select_source,route_temp(2));
                    U_real_temp1(select_source,route_temp(2)) = U_rated + I0_temp2 * R(select_source,route_temp(2));
                    U_real_temp1(route_temp(2),select_source) = U_real_temp1(select_source,route_temp(2));
                    [ I_real_temp1, U_real_temp1 ] = real_IU_calculate_StoF( route_temp, I_real_temp1, U_real_temp1, P_load, U_rated, R, P_generate, eff );
                else
                    I0_temp2 = Capacity_rest*eff/U_rated;
                    I_real_temp1(select_source,route_temp(2)) = I0_temp2;
                    I_real_temp1(route_temp(2),select_source) = -I_real_temp1(select_source,route_temp(2));
                    U_real_temp1(select_source,route_temp(2)) = U_rated - I0_temp2 * R(select_source,route_temp(2));
                    U_real_temp1(route_temp(2),select_source) = U_real_temp1(select_source,route_temp(2));
                    [ I_real_temp1, U_real_temp1 ] = real_IU_calculate_StoF( route_temp, I_real_temp1, U_real_temp1, P_load, U_rated, R, P_generate, eff );
                end
                temp = [];
                compare = Capacity_line - I_real_temp1;
                for i=1:1:length(route_temp)-1
                    temp = [temp, compare(route_temp(i),route_temp(i+1))];
                end
                a = min(temp);
                if a >= 0
                    I_real_temp2 = I_real_temp1;
                    U_real_temp2 = U_real_temp1;

                    [ p_in, p_out ] = Power_flow( destination, I_real_temp2, U_real_temp2, U_rated );
                    P_present = p_in *eff - p_out;

                    data{j}.capacity_trans = P_demand_temp - (P_load(destination) - P_present);
                    data{j}.distance = distance_temp;
                    data{j}.route = route_temp;

                    P_demand_temp = P_load(destination) - P_present;

                    [ p_in, p_out ] = Power_flow( select_source, I_real_temp2, U_real_temp2, U_rated );
                    P_present = p_out/eff - p_in;
                    P_generate(select_source) = P_present + P_load(select_source)/eff;

                    j = j+1; %P_demand
                else
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

                    [ p_in, p_out ] = Power_flow( destination, I_real_temp2, U_real_temp2, U_rated );
                    P_present = p_in *eff - p_out;

                    data{j}.capacity_trans = P_demand_temp - (P_load(destination) - P_present);
                    data{j}.distance = distance_temp;
                    data{j}.route = route_temp;
                    P_demand_temp = P_load(destination) - P_present;

                    [ p_in, p_out ] = Power_flow( select_source, I_real_temp2, U_real_temp2, U_rated );
                    P_present = p_out/eff - p_in;
                    P_generate(select_source) = P_present + P_load(select_source)/eff;

                    j = j+1;
                end
            end
        end
    end
    I_real = I_real_temp2;
    U_real = U_real_temp2;
end

