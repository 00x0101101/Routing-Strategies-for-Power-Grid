function dijkstra(x,s)
% x是距离权重矩阵，s代表初始点，函数会输出初始点到所有点的最短路径和最短距离
m=length(x);
for i=1:m-1
    S(i)=i+1;
end


T2=ones(m,1)*inf;
T2(1,1)=0;
T1(1,1)=1;
qishi(1)=s;

for i=1:m
    for j=1:m
        %判断j这个点是不是在S中
        panduan=1;
        for z=1:length(S)
            if S(z)==j;
                panduan=0;
            end
        end
        %j这个点在S中，则开始产生新的T2（j）
        if panduan==0
            if T2(j,1)>(T2(qishi(i),1)+x(qishi(i),j))
                T2(j,1)=T2(qishi(i),1)+x(qishi(i),j);
                T1(j,1)=qishi(i);
            end
        end
    end
  %取本次中的最小T2,并记录所对应的点
    zuiduan=T2(S(1),1);
    dian=S(1);
    Szhong=1;
    for k=1:length(S)
        if T2(S(k),1)<zuiduan
            zuiduan=T2(S(k),1);
            dian=S(k);
            Szhong=k;
        end
    end
%把S中的dian去掉，dian已达最优
    t=1;
    for w=1:length(S)
        if S(w)~=dian
            S1(t)=S(w);
            t=1+t;
        end
    end
    S=S1;
    qishi(i+1)=dian;
end


%输出到第m个点的路径
for k=2:m
    A(1)=k;
    a=k;
    p=2;
    while a~=1
        A(p)=T1(A(p-1));
        a=A(p);
        p=p+1;
    end
    
    for d=1:length(A)
        B(d)=A(length(A)-d+1);
    end
    fprintf('到第%d个点的最短路情况如下所示： \n',k)
    for d=1:length(B)
        fprintf('%d——',B(d))
    end
    
    lujingchangdu=0;
    for l=1:length(B)-1
        lujingchangdu=lujingchangdu+x(B(l),B(l+1));
    end
    fprintf('\n路径长度为%d \n',lujingchangdu);
end




