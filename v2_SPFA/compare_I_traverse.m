record = zeros(81,9);
k=0;
all={};
for source = 1:1:9
    for destination = 1:1:9
        k = k+1;
        [ powerloss_est, powerloss_min, powerloss_real, route_est, route_min ] = compare_I_fx( source, destination );
        record(k,1) = source;
        record(k,2) = destination;
        record(k,3) = powerloss_est;
        record(k,4) = powerloss_real;
        record(k,5) = powerloss_min;
%         record(k,7) = route_est;
%         record(k,8) = route_min;
        all{k}.source = source;
        all{k}.destination = destination;
        all{k}.powerloss_est =powerloss_est;
        all{k}.powerloss_real =powerloss_real;
        all{k}.powerloss_min =powerloss_min;
        all{k}.route_est = route_est;
        all{k}.route_min = route_min;
        if powerloss_real == powerloss_min
            record(k,6) = 1;
        else
            record(k,6) = 0;
        end

    end
end
find(record(:,6)==0);