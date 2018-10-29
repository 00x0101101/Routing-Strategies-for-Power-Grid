%%
% map
M = inf;
% 不对称
Map = [0,1,3,M,2
       3,0,M,4,3
       5,M,0,1,2
       M,2,1,0,M
       1,5,4,M,0];
% 不对称 有负
% Map = [0,-1,3,M,2
%        3,0,M,4,3
%        5,M,0,1,2
%        M,2,1,0,M
%        1,5,4,M,0];
% 带负环
% Map = [0,M,4,-5,M
%        M,0,2,M,5
%        4,2,0,3,M
%        -5,M,3,0,1
%        M,5,M,1,0];
% 点1脱离，无路径
Map = [0,M,M,M,M
       M,0,2,M,5
       M,2,0,3,M
       M,M,3,0,1
       M,5,M,1,0];

% 9节点网络初始
% map(1,:)=[zeros(1,1),M,3,M,M,M,M,4,M];
% map(2,:)=[zeros(1,2),M,3,M,M,M,M,2];
% map(3,:)=[zeros(1,3),5,1,3,M,M,M];
% map(4,:)=[zeros(1,4),M,6,M,M,4];
% map(5,:)=[zeros(1,5),2,2,M,M];
% map(6,:)=[zeros(1,6),M,2,M];
% map(7,:)=[zeros(1,7),6,2];
% map(8,:)=[zeros(1,8),7];
% map(9,:)=[zeros(1,9)];
% Map=map+map';
%%
% limit
% 不对称
% Capacity = [0,100,100,M,100
%             100,0,M,100,100
%             100,M,0,100,100
%             M,100,100,0,M
%             100,100,100,M,0];
% 对称
Capacity = [0,M,100,80,M
            M,0,100,M,100
            100,100,0,100,M
            80,M,100,0,100
            M,100,M,100,0];
% 9节点
% capacity(1,:)=[M,M,200,M,M,M,M,200,M];
% capacity(2,:)=[zeros(1,1),M,M,100,M,M,M,M,200];
% capacity(3,:)=[zeros(1,2),M,140,100,100,M,M,M];
% capacity(4,:)=[zeros(1,3),M,M,120,M,M,80];
% capacity(5,:)=[zeros(1,4),M,100,100,M,M];
% capacity(6,:)=[zeros(1,5),M,M,100,M];
% capacity(7,:)=[zeros(1,6),M,120,80];
% capacity(8,:)=[zeros(1,7),M,120];
% capacity(9,:)=[zeros(1,8),M];
% Capacity=capacity+capacity';
%%
status=zeros(5,5);
% status(3,2)=60;
Status=status-status'; % upper triangle matrix
%%
R = ones(size(Map));
%%
% no limitation, shortest path
source = 1;
destination = 4;
% % [ SP, distance, route ] = SPFA( Map,source );
[ distance, route ] = ShortestPath( Map, source, destination );
%%
% capacity limited
% demand = 400;
% source = 2;
% destination = 3;
% [ data, Status, status ] = CapLimited( Map, source, destination, Status, Capacity, demand);
%%
% multi source
% source = [1,2];
% source_status = zeros(1,2);
% destination = 3;
% demand = 400;
% [ data, Status_after, status_after ] = SourceSelected( Map, source, destination, Status, Capacity, demand );
%%
% source limited
% source = [1,2];
% source_status = zeros(1,2);
% source_Cap = [200,500];
% destination = 3;
% demand = 300;
% [ data, Status_after, status_after, source_status_after ] = SourceLimited( Map, source, destination, Status, Capacity, demand, source_status, source_Cap );
% [ data1, Status_after1, status_after1, source_status_after1 ] = SourceLimited_Mapcal( Map, source, destination, Status, Capacity, demand, source_status, source_Cap, R );