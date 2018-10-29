route_est = route;
route_temp1 = fliplr(route_est);

for i = 1:1:length(route_temp1)-1
    d1 = route_temp1(i);
    s1 = route_temp1(i+1);
    if i ==1 % 与起点相连的第一段
%         I_temp = P_demand/U_rated;
%         U_temp = I_temp * R(s1,d1)+U_rated;
%         if I_real(s1,d1) == 0 % 判断是否已经有电流在该线路上
%             I_real(s1,d1) = I_temp;
%             I_real(d1,s1) = -I_real(s1,d1);
%             U_real(s1,d1) = U_temp;
%             U_real(d1,s1) = -U_real(s1,d1);
%         else
%             if sign(I_real(s1,d1)) == sign(I_temp) % 判断新增电流与原电流方向是否相同
%                 I_real(s1,d1) = I_real(s1,d1) + P_demand/U_rated;
%                 I_real(d1,s1) = -I_real(s1,d1);
%                 U_real(s1,d1) = I_real(s1,d1)* R(s1,d1)+U_rated;
%                 U_real(d1,s1) = -U_real(s1,d1);
%             else
                P_in=0;
                for k = 1:1:length(I_real(:,d1)) %计算流入节点功率
                    if k ~= s1
                        if I_real(k,d1)>=0
                            P_in = P_in + I_real(k,d1)* U_rated;
                        else
                            P_in = P_in - I_real(k,d1)* U_real(k,d1);
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
%                     s = solve(x^2 * R(d1,s1) + x * U_rated + P_in == 0,x);
%                     I_real(d1,s1) = s(find(s>0));
                    I_real(d1,s1) = (-U_rated+sqrt(U_rated^2+4*P_in*R(d1,s1)))/(2*R(d1,s1));
                    I_real(s1,d1) = -I_real(d1,s1);
                    U_real(d1,s1) = I_real(d1,s1) * R(d1,s1)+U_rated;
                    U_real(s1,d1) = -U_real(d1,s1);
                elseif P_in < 0
                    I_real(s1,d1) = -P_in/U_rated;
                    I_real(d1,s1) = -I_real(s1,d1);
                    U_real(s1,d1) = I_real(s1,d1)* R(s1,d1)+U_rated;
                    U_real(d1,s1) = -U_real(s1,d1);
                end
%             end
%         end
        s2 = s1;
        d2 = d1;
    else
%         I_temp = I_real(s2,d2)*U_real(s2,d2)/U_rated;
%         U_temp = I_temp*R(s1,d1)+U_rated;
%         if I_real(s1,d1) == 0 % 判断是否已经有电流在该线路上
%             I_real(s1,d1) = I_temp;
%             I_real(d1,s1) = -I_real(s1,d1);
%             U_real(s1,d1) = U_temp;
%             U_real(d1,s1) = -U_real(s1,d1);
%         else
%             if sign(I_real(s1,d1)) == sign(I_temp) % 判断新增电流与原电流方向是否相同
%                 P_in=0;
%                 for k = 1:1:length(I_real(:,d1)) %计算流入节点功率,除线路s1,d1
%                     if k ~= s1
%                         if I_real(k,d1)>=0
%                             P_in = P_in + I_real(k,d1)* U_rated;
%                         else
%                             P_in = P_in - I_real(k,d1)* U_real(k,d1);
%                         end
%                     end
%                     P_in = P_in - P_demand(d1);
%                 end
%                 I_real(s1,d1) = -P_in/U_rated;
%                 I_real(d1,s1) = -I_real(s1,d1);
%                 U_real(s1,d1) = I_real(s1,d1)* R(s1,d1)+U_rated;
%                 U_real(d1,s1) = -U_real(s1,d1);
%             else
                P_in=0;
                for k = 1:1:length(I_real(:,d1)) %计算流入节点功率,除线路s1,d1
                    if k ~= s1
                        if I_real(k,d1)>=0
                            P_in = P_in + I_real(k,d1)* U_rated;
                        else
                            P_in = P_in - I_real(k,d1)* U_real(k,d1);
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
%                     s = solve(x^2 * R(d1,s1) + x * U_rated + P_in == 0,x);
%                     I_real(d1,s1) = s(find(s>0));
                    I_real(d1,s1) = (-U_rated+sqrt(U_rated^2+4*P_in*R(d1,s1)))/(2*R(d1,s1));
                    I_real(s1,d1) = -I_real(d1,s1);
                    U_real(d1,s1) = I_real(d1,s1) * R(d1,s1)+U_rated;
                    U_real(s1,d1) = -U_real(d1,s1);
                elseif P_in < 0
                    I_real(s1,d1) = -P_in/U_rated;
                    I_real(d1,s1) = -I_real(s1,d1);
                    U_real(s1,d1) = I_real(s1,d1)* R(s1,d1)+U_rated;
                    U_real(d1,s1) = -U_real(s1,d1);
                end
%             end
%         end
        s2 = s1;
        d2 = d1;
    end
%     if i == 1
%         I_real(s1,d1) = Pdemand/U;
%         U_real(s1,d1) = I_real(s1,d1)*R(s1,d1)+U;
%         s2 = s1;
%         d2 = d1;
%     else
%         I_real(s1,d1) = I_real(s2,d2)*U_real(s2,d2)/U;
%         U_real(s1,d1) = I_real(s1,d1)*R(s1,d1)+U;
%         s2 = s1;
%         d2 = d1;
%     end
end