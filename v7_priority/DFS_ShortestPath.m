function [dis, route] = DFS_ShortestPath(Map, source, destination)
% findPath按深度优先搜索所有可能的从partialPath出发到destination的路径，这些路径中不包含环路
% Map: 路网图，非无穷或0表示两节点之间直接连通，矩阵值就为路网权值
% source: 出发的路径，如果partialPath就一个数，表示这个就是起始点
% destination: 目标节点
    lastNode = source; %得到最后一个节点
    nextNodes = find(Map(lastNode,:)<inf); %根据Graph图得到最后一个节点的下一个节点
    GLength = length(Map);
    record = [];
    if lastNode == destination
        % 如果lastNode与目标节点相等，则说明partialPath就是从其出发到目标节点的路径，结果只有这一个，直接返回
        record = source;
%         GLength = 1;
        record(GLength+1) = 0;
        dis = record(GLength+1);
        route = [source,destination];
        return;
    elseif ~isempty( find( source == destination, 1 ) )
        return;
    end
    %nextNodes中的数一定大于0,所以为了让nextNodes(i)去掉，先将其赋值为0
    for i=1:length(nextNodes)
        if destination == nextNodes(i)
            %输出路径
            tmpPath = cat(2, source, destination);      %串接成一条完整的路径
            tmpPath(GLength+1) = Map(lastNode, destination); %延长数组长度至GLength+1, 最后一个元素用于存放该路径的总路阻
            record( length(record)+1 , : ) = tmpPath;
            nextNodes(i) = 0;
        elseif ~isempty( find( source == nextNodes(i), 1 ) )
            nextNodes(i) = 0;
        end
    end
    nextNodes = nextNodes(nextNodes ~= 0); %将nextNodes中为0的值去掉，因为下一个节点可能已经遍历过或者它就是目标节点
    for i=1:length(nextNodes)
        tmpPath = cat(2, source, nextNodes(i));
        tmpPsbPaths = findPath(Map, tmpPath, destination, Map(lastNode, nextNodes(i)));
        record = cat(1, record, tmpPsbPaths);
    end
    
    min_index = find(record(:,GLength+1) == min(record(:,GLength+1)));
    dis = record(min_index(1), GLength+1);
    route = record(min_index(1), 1:GLength);
    route = route(route ~= 0);
end
