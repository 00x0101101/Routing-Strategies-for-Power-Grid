function [ I_real, U_real ] = real_IU_calculate( route, I_real, U_real, P_load, U_rated, R, P_generate, eff )
    route_est = route;
    route_temp1 = fliplr(route_est);
    for i = 1:1:length(route_temp1)-1
        finish = route_temp1(i);
        start = route_temp1(i+1);
        P_in=0;
        p_in = 0;
        p_out = 0;
        for k = 1:1:length(I_real(:,finish)) %计算流入节点功率
            if k ~= start
                if I_real(k,finish)>=0
                    p_in = p_in + I_real(k,finish)* U_rated;
                else
                    p_out = p_out + I_real(k,finish)* U_real(k,finish);
                end
            end
        end
        P_in = eff * (p_in + P_generate(finish)) + p_out - P_load(finish);
        if P_in ==0 % 判断该节点功率流入流出情况，确定该线路上总电流方向
            I_real(start,finish) = 0;
            I_real(finish,start) = 0;
            U_real(start,finish) = 0;
            U_real(finish,start) = 0;
        elseif P_in > 0
            I_real(finish,start) = (-U_rated+sqrt(U_rated^2+4*P_in*R(finish,start)))/(2*R(finish,start));
            I_real(start,finish) = -I_real(finish,start);
            U_real(finish,start) = I_real(finish,start) * R(finish,start)+U_rated;
            U_real(start,finish) = U_real(finish,start);
        elseif P_in < 0
            I_real(start,finish) = -P_in/(U_rated*eff);
            I_real(finish,start) = -I_real(start,finish);
            U_real(start,finish) = I_real(start,finish)* R(start,finish)+U_rated;
            U_real(finish,start) = U_real(start,finish);
        end
    end
end

