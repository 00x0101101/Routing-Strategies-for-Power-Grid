function [ powerloss_est, powerloss_min, powerloss_real, route_est, route_min ] = compare_I_fx( source, destination )
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
    Capacity_line=Capacity_line.*(0.7*10^(-2));

    status=zeros(size(Connect));
    Status=status-status'; % upper triangle matrix

%     R0 = 2.83*10^(-2)/200;
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
%     R = L.*R0.*1000;
    R = 0.4*L;

    % source = [1,2];
    % source_Cap = [200,500];
    % source_status = [0,0];
%     source = 2;
%     source_Cap = [0 1 0 0 0 0 0 0 0];
    source_Cap = zeros(1,9);
    source_Cap(source) = 1;
    source_status = [0 0 0 0 0 0 0 0 0];
%     destination = 4;
    Pdemand = 5;
    U = 10;
    demand = Pdemand/U;
    %%
    [ data, Status_after, status_after, source_status_after ] = SourceLimited_Mapcal( Connect, source, destination, Status, Capacity_line, demand, source_status, source_Cap, R );
    Status_up = triu(Status_after);
    powerloss_est = sum(sum((Status_up.^2.*R)));
    %%
    route_est = data{1}.route;
    route_temp1 = fliplr(route_est);
    I_real = zeros(size(Connect));
    U_real = zeros(size(Connect));
    for i = 1:1:length(route_temp1)-1
        d1 = route_temp1(i);
        s1 = route_temp1(i+1);
        if i == 1
            I_real(s1,d1) = Pdemand/U;
            U_real(s1,d1) = I_real(s1,d1)*R(s1,d1)+U;
            s2 = s1;
            d2 = d1;
        else
            I_real(s1,d1) = I_real(s2,d2)*U_real(s2,d2)/U;
            U_real(s1,d1) = I_real(s1,d1)*R(s1,d1)+U;
            s2 = s1;
            d2 = d1;
        end
    end
    powerloss_real = sum(sum((I_real.^2.*R)));
    % percent = (powerloss_real - powerloss_est)/ powerloss_real;
    %%
    [record] = DFS_AllPath(Connect, source, destination);
    [a,b] = size(record);
    % all_route = record(:,1:b-1);
    for j = 1:1:a
        route_temp2 = fliplr(record(j,1:record(j,b)+1));
        I_real = zeros(size(Connect));
        U_real = zeros(size(Connect));
        for i = 1:1:length(route_temp2)-1
            d1 = route_temp2(i);
            s1 = route_temp2(i+1);
            if i == 1
                I_real(s1,d1) = Pdemand/U;
                U_real(s1,d1) = I_real(s1,d1)*R(s1,d1)+U;
                s2 = s1;
                d2 = d1;
            else
                I_real(s1,d1) = I_real(s2,d2)*U_real(s2,d2)/U;
                U_real(s1,d1) = I_real(s1,d1)*R(s1,d1)+U;
                s2 = s1;
                d2 = d1;
            end
        end
        record(j,b) = sum(sum((I_real.^2.*R)));
    end
    min_index = find(record(:,b) == min(record(:,b)));
    powerloss_min = record(min_index(1), b);
    route_min = record(min_index(1), 1:b-1);
    route_min = route_min(route_min ~= 0);
end

