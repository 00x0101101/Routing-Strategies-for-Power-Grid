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

cap_line(1,:)=[zeros(1,1),0,1,0,0,0,0,100,0];
cap_line(2,:)=[zeros(1,2),0,100,0,0,0,0,100];
cap_line(3,:)=[zeros(1,3),100,100,100,0,0,0];
cap_line(4,:)=[zeros(1,4),0,100,0,0,100];
cap_line(5,:)=[zeros(1,5),100,100,0,0];
cap_line(6,:)=[zeros(1,6),0,100,0];
cap_line(7,:)=[zeros(1,7),100,100];
cap_line(8,:)=[zeros(1,8),100];
cap_line(9,:)=[zeros(1,9)];
Capacity_line=cap_line+cap_line';

route = [1,3,4];
I_real(1,3) = 2;
% I_real(3,4) = 1;

U_rated = 10;

%%
[ I_real, U_real ] = real_IU_calculate_StoF( route, I_real, U_real, P_load, U_rated, R );
%%
% P_load(route(length(route))) = 0;
% % route_est = route;
% % route_temp1 = fliplr(route_est);
% for i = 1:1:length(route)-2
% %     d1 = route_temp1(i);
% %     s1 = route_temp1(i+1);
%     before = route(i);
%     start = route(i+1);
%     finish = route(i+2);
%     P_in=0;
%     for k = 1:1:length(I_real(:,start)) %计算流入节点功率
%         if k ~= finish
%             if I_real(k,start)>=0
%                 P_in = P_in + I_real(k,start)* U_rated;
%             else
%                 P_in = P_in + I_real(k,start)* U_real(k,start);
%             end
%         end
%     end
%     P_in = P_in - P_load(start);
%     if P_in ==0 % 判断该节点功率流入流出情况，确定该线路上总电流方向
%         I_real(start,finish) = 0;
%         I_real(finish,start) = 0;
%         U_real(start,finish) = 0;
%         U_real(finish,start) = 0;
%     elseif P_in > 0
%         I_real(start,finish) = (-U_rated+sqrt(U_rated^2+4*P_in*R(finish,start)))/(2*R(finish,start));
%         I_real(finish,start) = -I_real(start,finish);
%         U_real(start,finish) = I_real(start,finish) * R(start,finish)+U_rated;
%         U_real(finish,start) = U_real(start,finish);
%     elseif P_in < 0
%         I_real(finish,start) = -P_in/U_rated;
%         I_real(start,finish) = -I_real(finish,start);
%         U_real(finish,start) = I_real(finish,start)* R(finish,start)+U_rated;
%         U_real(start,finish) = U_real(start,finish);
%     end
% end
