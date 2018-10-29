function ans=SPFA(a,v)
	head=1;
    tail=1;
    n=size(a,2);
    S(head)=v;
    VIS=zeros(1,n);
    VIS(v)=1;
    D=100000*ones(1,n);
    D(v)=0;
    RECORD=zeros(1,n);
    while (head<=tail)
        k=S(head);
        VIS(k)=0;
        for i=1:n
            if (a(k,i)~=-1) && (D(k)+a(k,i)<D(i))
                D(i)=D(k)+a(k,i);
                RECORD(i)=k;
                if (~VIS(i))
                    tail=tail+1;
                    S(tail)=i;
                    VIS(i)=1;
                end
            end
        end
        head=head+1;
    end
    fprintf('The shortest path is: \n');

    for i=1:n
        fprintf('For district%d: ',i);
        path=zeros(1,n);
        m=0;
        while RECORD(i)
            m=m+1;
            path(m)=i;
            i=RECORD(i);
        end
        for j=m:-1:1
            fprintf('%d ',path(j));
        end
        fprintf('\n');
    end
    
    ans=D;
end

