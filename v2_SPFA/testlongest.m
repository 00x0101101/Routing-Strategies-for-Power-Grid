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

R = ones(size(Connect));

cap_line(1,:)=[zeros(1,1),0,100,0,0,0,0,100,0];
cap_line(2,:)=[zeros(1,2),0,1,0,0,0,0,100];
cap_line(3,:)=[zeros(1,3),100,100,100,0,0,0];
cap_line(4,:)=[zeros(1,4),0,100,0,0,100];
cap_line(5,:)=[zeros(1,5),100,100,0,0];
cap_line(6,:)=[zeros(1,6),0,100,0];
cap_line(7,:)=[zeros(1,7),100,100];
cap_line(8,:)=[zeros(1,8),100];
cap_line(9,:)=[zeros(1,9)];
Capacity_line=cap_line+cap_line';

status=zeros(size(Connect));
Status=status-status'; % upper triangle matrix

demand = 5;

source = [1, 2];
source_Cap = [3, 5];
source_status_before = [0 0];
destination = 5;
[ data, Status_after, status_after, source_status_after ] = SourceLimited_Mapcal( Connect, source, destination, Status, Capacity_line, demand, source_status_before, source_Cap, R );
%%
demand2 = 4;
[ data2, Status_after2, status_after2, source_status_after2 ] = SourceLimited_Mapcal_longest( Connect, source, destination, Status_after, Capacity_line, demand2, source_status_after, source_Cap, R );

Status_up = triu(Status_after2);
powerloss_time= sum(sum((Status_up.^2.*R)));
