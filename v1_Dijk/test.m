M=inf;
map(1,:)=[zeros(1,1),M,3,M,M,M,M,4,M];
map(2,:)=[zeros(1,2),M,3,M,M,M,M,2];
map(3,:)=[zeros(1,3),5,1,3,M,M,M];
map(4,:)=[zeros(1,4),M,6,M,M,4];
map(5,:)=[zeros(1,5),2,2,M,M];
map(6,:)=[zeros(1,6),M,2,M];
map(7,:)=[zeros(1,7),6,2];
map(8,:)=[zeros(1,8),7];
map(9,:)=[zeros(1,9)];
map=map+map';
map(9,7)=inf;
source = 2;
pb(1:length(map))=0; pb(source)=1;index1=source;index2=source*ones(1,length(map));
d(1:length(map))=inf;d(source)=0;temp=source;
while sum(pb)<length(map)
    tb=find(pb==0);
    d(tb)=min(d(tb),d(temp)+map(temp,tb));
    tmpb=find(d(tb)==min(d(tb)));
    temp=tb(tmpb(1));
    pb(temp)=1;
    index1=[index1,temp];
%     index=index1(find(d(index1)==d(temp)-map(temp,index1)));
    index = [];
    for j=1:1:length(index1)
        if d(index1(j))==d(temp)-map(index1(j),temp)
            index = [index,index1(j)];
        end
    end
    if length(index)>=2
        index=index(1);
    end
    index2(temp)=index;
end