function [ p_in, p_out ] = Power_flow( point, I_real, U_real, U_rated )
    % 计算流入、流出节点的功率
    p_in = 0;
    p_out = 0;
    for i = 1:1:length(I_real(:,point)) %计算流入节点的功率
        if I_real(i,point)>=0
            p_in = p_in + I_real(i,point)* U_rated;
        else
            p_out = p_out - I_real(i,point)* U_real(i,point);
        end
    end
%     P_present = p_in *eff + p_out;
end

