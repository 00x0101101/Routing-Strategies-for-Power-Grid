%ȫ���Ż����������24����9�ڵ㣬2����Դ
fun = @(source_cap) F_v2_day_9(source_cap);
options = gaoptimset('InitialPopulation',20*ones(1,24));
[X_temp,cost_temp] = ga(fun, 24,[],[],[],[],0*ones(1,24),22*ones(1,24),[],options);