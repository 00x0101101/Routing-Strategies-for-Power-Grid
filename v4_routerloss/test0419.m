%全天优化，输入参数24个，9节点，2个电源
fun = @(source_cap) F_v2_day_9(source_cap);
options = gaoptimset('InitialPopulation',20*ones(1,24));
[X_temp,cost_temp] = ga(fun, 24,[],[],[],[],0*ones(1,24),22*ones(1,24),[],options);