% x0 = [20*ones(13,1);0;ones(20,1)];  % Make a starting guess at the solution  
x0 = [1.5*ones(13,1);0;ones(20,1)];  
% options = optimoptions('fsolve','Display','iter'); % Option to display output
options = optimset('TolFun',1e-10);
[x,fval] = fsolve(@(x)s3_r2_v1_tra_fun(x,a,a),x0,options); % Call solver
%%
b=a;
flag = true;
while(flag)
    x0 = [1.5*ones(13,1);0;ones(20,1)];  
    options = optimset('TolFun',1e-10);
    [x,fval] = fsolve(@(x)s3_r2_v1_tra_fun(x,b,a),x0,options); % Call solver
    I = x(15:34);
    overload = find(abs(I)>=0.25);
%     if length(overload)==0
%         b = b+0.001;
%     elseif length(overload) >0
%         flag = false;b= b-0.001;
%     else
%         b= b+0.001;
%     end
    if length(overload)==0
        flag = false;
    elseif length(overload) > 0 && x(14) >0
        b= b-0.001;
    else
        b= b-0.001;
    end
end
%%
U = x(1:14);
diff_natural = (U - 1.5*ones(length(U)))./1.5;
bb = max(max(diff_natural));
%%
% N = 0;
% r(1,:)=[zeros(1,1),0.01938,N,N,0.05403,N,N,N,N,N,N,N,N,N];
% r(2,:)=[zeros(1,2),0.04699,0.05811,0.05695,N,N,N,N,N,N,N,N,N];
% r(3,:)=[zeros(1,3),0.06701,N,N,N,N,N,N,N,N,N,N];
% r(4,:)=[zeros(1,4),0.01335,N,10e-6,N,10e-6,N,N,N,N,N];
% r(5,:)=[zeros(1,5),10e-6,N,N,N,N,N,N,N,N];
% r(6,:)=[zeros(1,6),N,N,N,N,0.09498,0.12291,0.06615,N];
% r(7,:)=[zeros(1,7),10e-6,10e-6,N,N,N,N,N];
% r(8,:)=[zeros(1,8),N,N,N,N,N,N];
% r(9,:)=[zeros(1,9),0.03181,N,N,N,0.12711];
% r(10,:)=[zeros(1,10),0.08205,N,N,N];
% r(11,:)=[zeros(1,11),N,N,N];
% r(12,:)=[zeros(1,12),0.22092,N];
% r(13,:)=[zeros(1,13),0.17093];
% r(14,:)=[zeros(1,14)];
% r(1,:)=[zeros(1,1),0.5,N,N,0.5,N,N,N,N,N,N,N,N,N];
% r(2,:)=[zeros(1,2),1.5,1.6,0.7,N,N,N,N,N,N,N,N,N];
% r(3,:)=[zeros(1,3),0.5,N,N,N,N,N,N,N,N,N,N];
% r(4,:)=[zeros(1,4),1.05,N,0.4,N,0.75,N,N,N,N,N];
% r(5,:)=[zeros(1,5),0.9,N,N,N,N,N,N,N,N];
% r(6,:)=[zeros(1,6),N,N,N,N,0.5,0.75,1,N];
% r(7,:)=[zeros(1,7),0.6,0.5,N,N,N,N,N];
% r(8,:)=[zeros(1,8),N,N,N,N,N,N];
% r(9,:)=[zeros(1,9),0.6,N,N,N,0.75];
% r(10,:)=[zeros(1,10),0.7,N,N,N];
% r(11,:)=[zeros(1,11),N,N,N];
% r(12,:)=[zeros(1,12),0.6,N];
% r(13,:)=[zeros(1,13),0.9];
% r(14,:)=[zeros(1,14)];
% R=r+r';
% 
% 
% I = x(15:34);
% R_new = reshape(r',14^2,1);
% R_new(find(R_new==0))=[];
% 
% loss = sum(I.^2.*R_new);



