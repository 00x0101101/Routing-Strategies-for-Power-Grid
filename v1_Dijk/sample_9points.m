%%
% map
M=inf;
map(1,:)=[zeros(1,1),M,3,M,M,M,M,4,M];
map(2,:)=[zeros(1,2),M,3,M,M,M,M,2];
map(3,:)=[zeros(1,3),5,1,3,M,M,M];
map(4,:)=[zeros(1,4),M,6,M,M,4];
map(5,:)=[zeros(1,5),2,2,M,M];
map(6,:)=[zeros(1,6),M,2,M];
map(7,:)=[zeros(1,7),6,2];
map(8,:)=[zeros(1,8),7];
map(9,:)=[zeros(1,9)];
Map=map+map';
% Map(7,9)=inf;
% Map(9,7)=inf;
% [ d,index1,index2 ] = singlesource_multidestination( Map, 2 );
% [ distance_temp, route_temp ] = singlesource_singledestination( Map, 2, 3 );
% [ distance path] = Dijk( Map,2,3 ); 
%%
% limit
N=inf;
capacity(1,:)=[N,N,200,N,N,N,N,200,N];
capacity(2,:)=[zeros(1,1),N,N,100,N,N,N,N,200];
capacity(3,:)=[zeros(1,2),N,140,100,100,N,N,N];
capacity(4,:)=[zeros(1,3),N,N,120,N,N,80];
capacity(5,:)=[zeros(1,4),N,100,100,N,N];
capacity(6,:)=[zeros(1,5),N,N,100,N];
capacity(7,:)=[zeros(1,6),N,120,80];
capacity(8,:)=[zeros(1,7),N,120];
capacity(9,:)=[zeros(1,8),N];
Capacity=capacity+capacity';
%%
status=zeros(9,9);
status(9,7)=80;
Status=status-status'; % upper triangle matrix
%%
source = [1,2,3];
%%
source_Cap = [400,100,100];
source_status = zeros(1,3);
%%
% [ d,index1,index2 ] = singlesource_multidestination( Map, 2 );
% [ distance, route ] = singlesource_singledestination( Map, 2, 3 );
%%
% demand = 180;
% source = 2;
% destination = 3;
% [ data, Status, status ] = singlesource_singledestination_limited( Map, source, destination, Status, Capacity, demand);
%%
demand = 250;
destination = 4;
% [ data, Status, status ] = multisource_singledestination( Map, source, destination, Status, Capacity, demand);
%%
[ data, Status_after, status_after, source_status_after ] = multisource_singledestination_limitedsource( Map, source, destination, Status, Capacity, demand, source_status, source_Cap );

