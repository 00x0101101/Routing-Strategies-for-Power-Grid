%%
times = 1;
% for times = 1:1:12
    b=aa(times);
    flag = true;
    x0 = [1.5*ones(13,1);0;ones(20,1)];  
    options = optimset('TolFun',1e-10);
    [x,fval] = fsolve(@(x)daytrans_fun(x,b,aa(times),load_expect_day(:,times),P_out_recoed(times,:)),x0,options); % Call solver
    I = x(15:34);
    overload = find(abs(I)>=0.25);
    if length(overload)==0
        c = 1;
    else
        c = 2;
    end
    while(flag)
        x0 = [1.5*ones(13,1);0;ones(20,1)];  
        options = optimset('TolFun',1e-10);
        [x,fval] = fsolve(@(x)daytrans_fun(x,b,aa(times),load_expect_day(:,times),P_out_recoed(times,:)),x0,options); % Call solver
        I = x(15:34);
        overload = find(abs(I)>=0.25);
        if c == 1
            if length(overload)==0
                b = b+0.001;
            elseif length(overload) >0
                flag = false;b= b-0.001;bb(times) = b;
            else
                b= b+0.001;
            end              
        elseif c == 2;
            if length(overload)==0
                flag = false;bb(times) = b;
            elseif length(overload) > 0 && x(14) >0
                b= b-0.001;
            else
                b= b-0.001;
            end            
        end
        if b <0
            bb(times) = 0;U_bb(times) =0;
            break;
        end
        U = x(1:14);
        diff_natural = (U - 1.5*ones(length(U)))./1.5;
        U_bb(times) = max(max(diff_natural));

    end
% end
%%
