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
cap_line(2,:)=[zeros(1,2),0,100,0,0,0,0,100];
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

expect_load = [0 0 0 0 0 0 0 0 0 0 0 0
               0 0 0 0 0 0 0 0 0 0 0 0
               1 1 1 3 4 5 4 4 6 5 3 1
               2 3 3 5 6 6 6 5 7 7 3 2
               2 2 2 3 3 4 5 6 5 4 3 2
               3 3 4 4 3 4 5 6 5 5 4 3
               2 2 3 4 4 5 5 6 5 4 3 2
               1 1 1 2 2 3 3 3 4 3 3 2
               1 1 2 2 3 3 4 4 5 5 3 1];
expect_source = [7 7 8 20 12 16 16 18 18 16 12 7
                 8 8 10 10 15 16 16 16 20 18 10 8
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0
                 0 0 0 0 0 0 0 0 0 0 0 0];
real_load = [0 0 0 0 0 0 0 0 0 0 0 0
             0 0 0 0 0 0 0 0 0 0 0 0
             1 1 2 3 4 5 4 4 6 5 3 1
             2 3 3 5 6 5 6 5 7 7 3 2
             2 2 2 3 3 4 5 6 5 4 3 2
             3 3 4 4 3 4 5 6 5 5 4 3
             2 2 3 4 4 5 5 6 5 4 3 2
             1 1 1 2 2 3 3 3 4 3 3 2
             1 1 2 2 3 3 4 4 5 5 3 1];
%%
B=[6;6;1;2;2;3;2;1;1;zeros(15,1)];
load('matrix.mat');
solution = A\B;
I = solution(10:24);