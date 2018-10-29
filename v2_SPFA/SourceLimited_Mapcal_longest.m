function [ data, Status_after, status_after, source_status_after ] = SourceLimited_Mapcal_longest( Map, source, destination, Status_before, Capacity, demand, source_status_before, source_Cap, R )
    Map_temp = Map;
    demand_temp = demand;
    Status_temp = Status_before;
    source_status_temp1 = source_status_before;
    source_status_temp2 = source_status_before;
    source_temp = source;
    compare_source = [];
    
    flag = true;
    j=1;
    data={};
    % from Status to status
    status = triu(Status_temp);
    [row,col] = find(status<0);
    for num = 1:1:length(row)
        status(col(num),row(num)) = -status(row(num),col(num));
        status(row(num),col(num)) = 0;
    end
    
    while flag
        % modify map
        compare_positive = Capacity - Status_temp;
        [xp,yp] = find(compare_positive == 0);
        for k=1:1:length(xp)
            if xp(k)<yp(k)
                Map_temp(yp(k),xp(k)) = inf;
            end
        end
        compare_negative = Capacity + Status_temp;
        [xn,yn] = find(compare_negative == 0);
        for k=1:1:length(xn)
            if xn(k)<yn(k)
                Map_temp(xn(k),yn(k)) = inf;
            end
        end
        [ Map_temp ] = Map_cal_longest( Map_temp, Status_temp, demand_temp, R ); %
        
        % modify source
%         compare_source = source_Cap - source_status_temp2;
%         aa = find(compare_source(source,:) == 0);
        aa = find(source_status_temp2(source) == 0); %
        source_temp(aa) = -1;
        % find route
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
        if min(distance_temp_diffsource) == Inf
            flag = false;
            data{j}.capacity_trans = -demand_temp; %
            data{j}.distance = Inf;
            data{j}.route = 'null';
            break;
        end
        tt = find(distance_temp_diffsource==min(distance_temp_diffsource));
        if length(tt)>1
            index = tt(1);
        else
            index = tt;
        end
        distance_temp = distance_temp_diffsource(index);
        route_temp = data_temp{index};
        %judge source limitation
        source_status_temp1 = source_status_temp2;
        sa = find( source_temp == route_temp(1));
        source_status_temp1(source_temp(sa)) = source_status_temp2(source_temp(sa))-demand_temp; %
%         compare_source_status = source_Cap - source_status_temp1;
%         b = source_Cap(sa) - source_status_temp1(sa);
        b = source_status_temp1(source_temp(sa));
        if b>=0
            % judge capacity limitation
            status_temp = status;
            temp=[];
            for i=1:1:length(route_temp)-1
                status_temp(route_temp(i),route_temp(i+1)) = status(route_temp(i),route_temp(i+1))-demand_temp; %
            end
            Status_temp = status_temp - status_temp';
            compare = Capacity - abs(Status_temp);    
            for i=1:1:length(route_temp)-1
                temp = [temp, compare(route_temp(i),route_temp(i+1))];
            end
            a = min(min(temp));
            if a>=0
                data{j}.capacity_trans = -demand_temp;
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;
                for i=1:1:length(route_temp)-1
                    status(route_temp(i),route_temp(i+1)) = status(route_temp(i),route_temp(i+1))- demand_temp; %
                end
                Status_temp = status - status';
                source_status_temp2(route_temp(1)) =  source_status_temp2(route_temp(1)) - demand_temp; %
                flag = false;
            else
                [m,n] = find(compare == a);
                for k=1:1:length(m)
                    if m(k)<n(k)
                        real = demand_temp + compare(m(k),n(k));
                        k=length(m)+1;
                    end
                end
                data{j}.capacity_trans = -real; %
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;
                j=j+1;
                demand_temp = demand_temp - real;
                for i=1:1:length(route_temp)-1
                    status(route_temp(i),route_temp(i+1)) = status(route_temp(i),route_temp(i+1))-real; %
                end
                Status_temp = status - status';
                source_status_temp2(route_temp(1)) =  source_status_temp2(route_temp(1)) - real; %
            end
        else
%             x = find(compare_source_status == b);
%             demand_temp2 = demand_temp + compare_source_status(source_temp(sa));
            demand_temp2 = source_status_temp2(source_temp(sa));
%             demand_temp2 = Status_temp(route_temp(1),route_temp(2));
            % judge capacity limitation
            status_temp = status;
            temp=[];
            for i=1:1:length(route_temp)-1
                status_temp(route_temp(i),route_temp(i+1)) = status(route_temp(i),route_temp(i+1))-demand_temp2; %
            end
            Status_temp = status_temp - status_temp';
            compare = Capacity - abs(Status_temp);    
            for i=1:1:length(route_temp)-1
                temp = [temp, compare(route_temp(i),route_temp(i+1))];
            end
            a = min(min(temp));
            if a>=0
                data{j}.capacity_trans = -demand_temp2;
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;
                for i=1:1:length(route_temp)-1
                    status(route_temp(i),route_temp(i+1)) = status(route_temp(i),route_temp(i+1))-demand_temp2; %
                end
                Status_temp = status - status';
                source_status_temp2(route_temp(1)) =  source_status_temp2(route_temp(1)) - demand_temp2; %
                demand_temp = demand_temp - demand_temp2;
%                 demand_temp = -compare_source_status(source_temp(sa));
                j = j+1;
            else
                [m,n] = find(compare == a);
                for k=1:1:length(m)
                    if m(k)<n(k)
                        real = demand_temp2 + compare(m(k),n(k));
                        k=length(m)+1;
                    end
                end
                data{j}.capacity_trans = -real;
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;
                j=j+1;
                demand_temp = demand_temp - real;
                for i=1:1:length(route_temp)-1
                    status(route_temp(i),route_temp(i+1)) = status(route_temp(i),route_temp(i+1))- real; %
                end
                Status_temp = status - status';
                source_status_temp2(route_temp(1)) =  source_status_temp2(route_temp(1)) - real; %
            end
        end
    end
    
    Status_after = Status_temp;
    status_after = triu(Status_after);
    [row,col] = find(status_after<0);
    for num = 1:1:length(row)
        status_after(col(num),row(num)) = -status_after(row(num),col(num));
        status_after(row(num),col(num)) = 0;
    end
    source_status_after = source_status_temp2;
end