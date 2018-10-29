%%
function [ map ] = Map_cal_longest( Connect, I_real, I0, R ) 
    Demand = - I0*ones(size(I_real));
    map  = zeros(size(I_real));
    map = (I_real + Demand).^2-I_real.^2;
    [a,b] = find(Connect == 0);
    for i = 1:1:length(a)
        map(a(i),b(i)) = 0;
    end
    [c,d] = find(Connect == inf);
    for i = 1:1:length(c)
        map(c(i),d(i)) = inf;
    end
    map = map.*R;
end