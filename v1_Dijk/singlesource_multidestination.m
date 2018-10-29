% 1 source to multi destination
% input: source, map
% output: distance, the order of the point, route index
function [ d,index1,index2 ] = singlesource_multidestination( map, source )
    pb(1:length(map))=0; pb(source)=1;index1=source;index2=source*ones(1,length(map));
    d(1:length(map))=inf;d(source)=0;temp=source;
    while sum(pb)<length(map)
        tb=find(pb==0);
        d(tb)=min(d(tb),d(temp)+map(temp,tb));
        tmpb=find(d(tb)==min(d(tb)));
        temp=tb(tmpb(1));
        pb(temp)=1;
        index1=[index1,temp];
%         index=index1(find(d(index1)==d(temp)-map(temp,index1)));
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
end

