%%
% *R needed!
function [ map ] = Map_cal( connect, Status, demand, R ) 
    Demand = demand*ones(size(Status));
    map  = zeros(size(Status));
    map = map + triu((Status + Demand).^2-Status.^2) + tril(((Status - Demand).^2-Status.^2)');
    [a,b] = find(connect == 0);
    for i = 1:1:length(a)
        map(a(i),b(i)) = 0;
    end
    [c,d] = find(connect == inf);
    for i = 1:1:length(c)
        map(c(i),d(i)) = inf;
    end
    map = map.*R;
end