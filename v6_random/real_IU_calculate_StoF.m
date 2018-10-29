function [ I_real, U_real ] = real_IU_calculate_StoF( route, I_real, U_real, P_load, U_rated, R, P_generate,eff )
%     P_load(route(length(route))) = 0;
    for i = 1:1:length(route)-2
%         before = route(i);
        start = route(i+1);
        finish = route(i+2);
        p_in = 0;
        p_out = 0;
        for k = 1:1:length(I_real(:,start)) %计算流入节点功率
            if k ~= finish
                if I_real(k,start)>=0
                    p_in = p_in + I_real(k,start)* U_rated;
                else
                    p_out = p_out + I_real(k,start)* U_real(k,start);
                end
            end
        end
        P_in = eff * (p_in + P_generate(start)) + p_out - P_load(start);
        if P_in ==0 % 判断该节点功率流入流出情况，确定该线路上总电流方向
            I_real(start,finish) = 0;
            I_real(finish,start) = 0;
            U_real(start,finish) = 0;
            U_real(finish,start) = 0;
        elseif P_in > 0
            I_real(start,finish) = (-U_rated+sqrt(U_rated^2+4*P_in*R(finish,start)))/(2*R(finish,start));
            I_real(finish,start) = -I_real(start,finish);
            U_real(start,finish) = I_real(start,finish) * R(start,finish)+U_rated;
            U_real(finish,start) = U_real(start,finish);
        elseif P_in < 0
            I_real(finish,start) = -P_in/(U_rated*eff);
            I_real(start,finish) = -I_real(finish,start);
            U_real(finish,start) = I_real(finish,start)* R(finish,start)+U_rated;
            U_real(start,finish) = U_real(start,finish);
        end
    end
end

