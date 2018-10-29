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

% P_load = zeros(1,length(Connect));

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

Status = zeros(size(Connect));
%%
source = [1,2];
Capacity_source = [1,2];
Status_source = [0 0];
destination = 5;
demand = 1.2;
%%
    Map_temp = Connect;
    demand_temp = demand;
    Status_temp = Status;
    source_status_temp1 = Status_source;
    source_status_temp2 = Status_source;
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
        compare_positive = Capacity_line - Status_temp;
        [xp,yp] = find(compare_positive == 0);
        for k=1:1:length(xp)
            if xp(k)<yp(k)
                Map_temp(xp(k),yp(k)) = inf;
            end
        end
        compare_negative = Capacity_line + Status_temp;
        [xn,yn] = find(compare_negative == 0);
        for k=1:1:length(xn)
            if xn(k)<yn(k)
                Map_temp(yn(k),xn(k)) = inf;
            end
        end
        [ Map_temp ] = Map_cal( Map_temp, Status_temp, demand_temp, R );
        
        % modify source
        compare_source = Capacity_source - source_status_temp2;
        aa = find(compare_source(source) == 0);
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
            data{j}.capacity_trans = demand_temp;
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
        source_status_temp1(source_temp(sa)) = source_status_temp2(source_temp(sa))+demand_temp;
        compare_source_status =  Capacity_source - source_status_temp1;
        b =  Capacity_source(source_temp(sa)) - source_status_temp1(source_temp(sa));
        if b>=0
            % judge capacity limitation
            status_temp = status;
            temp=[];
            for i=1:1:length(route_temp)-1
                status_temp(route_temp(i),route_temp(i+1)) = status(route_temp(i),route_temp(i+1))+demand_temp;
            end
            Status_temp = status_temp - status_temp';
            compare = Capacity_line - abs(Status_temp);    
            for i=1:1:length(route_temp)-1
                temp = [temp, compare(route_temp(i),route_temp(i+1))];
            end
            a = min(min(temp));
            if a>=0
                data{j}.capacity_trans = demand_temp;
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;
                for i=1:1:length(route_temp)-1
                    status(route_temp(i),route_temp(i+1)) = status(route_temp(i),route_temp(i+1))+ demand_temp;
                end
                Status_temp = status - status';
                source_status_temp2(route_temp(1)) =  source_status_temp2(route_temp(1)) + demand_temp;
                flag = false;
            else
                [m,n] = find(compare == a);
                for k=1:1:length(m)
                    if m(k)<n(k)
                        real = demand_temp + compare(m(k),n(k));
                        k=length(m)+1;
                    end
                end
                data{j}.capacity_trans = real;
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;
                j=j+1;
                demand_temp = demand_temp - real;
                for i=1:1:length(route_temp)-1
                    status(route_temp(i),route_temp(i+1)) = status(route_temp(i),route_temp(i+1))+real;
                end
                Status_temp = status - status';
                source_status_temp2(route_temp(1)) =  source_status_temp2(route_temp(1)) + real;
            end
        else
%             x = find(compare_source_status == b);
            demand_temp2 = demand_temp + compare_source_status(source_temp(sa));
            % judge capacity limitation
            status_temp = status;
            temp=[];
            for i=1:1:length(route_temp)-1
                status_temp(route_temp(i),route_temp(i+1)) = status(route_temp(i),route_temp(i+1))+demand_temp2;
            end
            Status_temp = status_temp - status_temp';
            compare = Capacity_line - abs(Status_temp);    
            for i=1:1:length(route_temp)-1
                temp = [temp, compare(route_temp(i),route_temp(i+1))];
            end
            a = min(min(temp));
            if a>=0
                data{j}.capacity_trans = demand_temp2;
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;
                for i=1:1:length(route_temp)-1
                    status(route_temp(i),route_temp(i+1)) = status(route_temp(i),route_temp(i+1))+demand_temp2;
                end
                Status_temp = status - status';
                source_status_temp2(route_temp(1)) =  source_status_temp2(route_temp(1)) + demand_temp2;
                demand_temp = -compare_source_status(source_temp(sa));
                j = j+1;
            else
                [m,n] = find(compare == a);
                for k=1:1:length(m)
                    if m(k)<n(k)
                        real = demand_temp2 + compare(m(k),n(k));
                        k=length(m)+1;
                    end
                end
                data{j}.capacity_trans = real;
                data{j}.distance = distance_temp;
                data{j}.route = route_temp;
                j=j+1;
                demand_temp = demand_temp - real;
                for i=1:1:length(route_temp)-1
                    status(route_temp(i),route_temp(i+1)) = status(route_temp(i),route_temp(i+1))+real;
                end
                Status_temp = status - status';
                source_status_temp2(route_temp(1)) =  source_status_temp2(route_temp(1)) + real;
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