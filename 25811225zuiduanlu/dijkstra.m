function dijkstra(x,s)
% x�Ǿ���Ȩ�ؾ���s�����ʼ�㣬�����������ʼ�㵽���е�����·������̾���
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
        %�ж�j������ǲ�����S��
        panduan=1;
        for z=1:length(S)
            if S(z)==j;
                panduan=0;
            end
        end
        %j�������S�У���ʼ�����µ�T2��j��
        if panduan==0
            if T2(j,1)>(T2(qishi(i),1)+x(qishi(i),j))
                T2(j,1)=T2(qishi(i),1)+x(qishi(i),j);
                T1(j,1)=qishi(i);
            end
        end
    end
  %ȡ�����е���СT2,����¼����Ӧ�ĵ�
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
%��S�е�dianȥ����dian�Ѵ�����
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


%�������m�����·��
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
    fprintf('����%d��������·���������ʾ�� \n',k)
    for d=1:length(B)
        fprintf('%d����',B(d))
    end
    
    lujingchangdu=0;
    for l=1:length(B)-1
        lujingchangdu=lujingchangdu+x(B(l),B(l+1));
    end
    fprintf('\n·������Ϊ%d \n',lujingchangdu);
end




