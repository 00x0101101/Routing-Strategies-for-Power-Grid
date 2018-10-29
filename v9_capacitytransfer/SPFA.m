function [ SP, dis, index ] = SPFA( Map,source )
    [m,n] = size(Map);
    bottom=0;
    top=1;
    queue = []; %����
    dis = inf*ones(1,m); %���·��
    book = zeros(1,m); %���ĳ���Ƿ��ڶ�����
    count = zeros(1,m); %��¼ĳ����Ӵ���
    SP = true; %�������·��

    index = source*ones(1,m);

    bottom = bottom+1;
    queue(bottom) = source;
    dis(source) = 0;
    book(source) = 1;
    count(source) = 1;

    while(top<=bottom)
        cur = queue(top); %��ǰ��չ�Ķ���
        for j=1:1:m
            if Map(cur,j)~=inf
                if dis(j)>dis(cur)+Map(cur,j)
                    dis(j) = dis(cur)+Map(cur,j);
                    index(j) = cur;
                    if book(j)== 0
                        count(j) = count(j)+1;
                        if count(j)>n
                            SP = false;
                            break;
                        end
                        bottom = bottom+1;
                        queue(bottom) = j;
                        book(j) = 1;
                    end
                end
            end
        end
        book(cur) = 0;
        top = top+1;
    end
end

