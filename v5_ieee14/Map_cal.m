%%
function [ map ] = Map_cal( Connect, I_real, I0, R, U_rated, eff ) 
    Demand = I0*ones(size(I_real));
    map  = zeros(size(I_real));
%     map = (I_real + Demand).^2-I_real.^2 + (1-eff)*U_rated*Demand;
    map = (I_real + Demand).^2-I_real.^2 + (1-eff)*U_rated * (abs(I_real + Demand) - abs(I_real));
    map = map.*R;
    [a,b] = find(Connect == 0);
    for i = 1:1:length(a)
        map(a(i),b(i)) = 0;
    end
    [c,d] = find(Connect == inf);
    for i = 1:1:length(c)
        map(c(i),d(i)) = inf;
    end
    
end