function [ I_real, U_real ] = real_IU_calculate( route, I_real, U_real, P_load, U_rated, R )
    route_est = route;
    route_temp1 = fliplr(route_est);
    for i = 1:1:length(route_temp1)-1
        d1 = route_temp1(i);
        s1 = route_temp1(i+1);
%         if i ==1 % 与起点相连的第一段
            P_in=0;
            for k = 1:1:length(I_real(:,d1)) %计算流入节点功率
                if k ~= s1
                    if I_real(k,d1)>=0
                        P_in = P_in + I_real(k,d1)* U_rated;
                    else
%                         P_in = P_in - I_real(k,d1)* U_real(k,d1);
                        P_in = P_in + I_real(k,d1)* U_real(k,d1);
                    end
                end
            end
            P_in = P_in - P_load(d1);
            if P_in ==0 % 判断该节点功率流入流出情况，确定该线路上总电流方向
                I_real(s1,d1) = 0;
                I_real(d1,s1) = 0;
                U_real(s1,d1) = 0;
                U_real(d1,s1) = 0;
            elseif P_in > 0
                I_real(d1,s1) = (-U_rated+sqrt(U_rated^2+4*P_in*R(d1,s1)))/(2*R(d1,s1));
                I_real(s1,d1) = -I_real(d1,s1);
                U_real(d1,s1) = I_real(d1,s1) * R(d1,s1)+U_rated;
%                 U_real(s1,d1) = -U_real(d1,s1);
                U_real(s1,d1) = U_real(d1,s1);
            elseif P_in < 0
                I_real(s1,d1) = -P_in/U_rated;
                I_real(d1,s1) = -I_real(s1,d1);
                U_real(s1,d1) = I_real(s1,d1)* R(s1,d1)+U_rated;
%                 U_real(d1,s1) = -U_real(s1,d1);
                U_real(d1,s1) = U_real(s1,d1);
            end
%         else
%             P_in=0;
%             for k = 1:1:length(I_real(:,d1)) %计算流入节点功率,除线路s1,d1
%                 if k ~= s1
%                     if I_real(k,d1)>=0
%                         P_in = P_in + I_real(k,d1)* U_rated;
%                     else
% %                         P_in = P_in - I_real(k,d1)* U_real(k,d1);
%                         P_in = P_in + I_real(k,d1)* U_real(k,d1);
%                     end
%                 end
%             end
%             P_in = P_in - P_load(d1);
%             if P_in ==0 % 判断该节点功率流入流出情况，确定该线路上总电流方向
%                 I_real(s1,d1) = 0;
%                 I_real(d1,s1) = 0;
%                 U_real(s1,d1) = 0;
%                 U_real(d1,s1) = 0;
%             elseif P_in > 0
%                 I_real(d1,s1) = (-U_rated+sqrt(U_rated^2+4*P_in*R(d1,s1)))/(2*R(d1,s1));
%                 I_real(s1,d1) = -I_real(d1,s1);
%                 U_real(d1,s1) = I_real(d1,s1) * R(d1,s1)+U_rated;
% %                 U_real(s1,d1) = -U_real(d1,s1);
%                 U_real(s1,d1) = U_real(d1,s1);
%             elseif P_in < 0
%                 I_real(s1,d1) = -P_in/U_rated;
%                 I_real(d1,s1) = -I_real(s1,d1);
%                 U_real(s1,d1) = I_real(s1,d1)* R(s1,d1)+U_rated;
% %                 U_real(d1,s1) = -U_real(s1,d1);
%                 U_real(d1,s1) = U_real(s1,d1);
%             end
%         end
    end
end

