function [dis, route] = DFS_ShortestPath(Map, source, destination)
% findPath����������������п��ܵĴ�partialPath������destination��·������Щ·���в�������·
% Map: ·��ͼ���������0��ʾ���ڵ�֮��ֱ����ͨ������ֵ��Ϊ·��Ȩֵ
% source: ������·�������partialPath��һ��������ʾ���������ʼ��
% destination: Ŀ��ڵ�
    lastNode = source; %�õ����һ���ڵ�
    nextNodes = find(Map(lastNode,:)<inf); %����Graphͼ�õ����һ���ڵ����һ���ڵ�
    GLength = length(Map);
    record = [];
    if lastNode == destination
        % ���lastNode��Ŀ��ڵ���ȣ���˵��partialPath���Ǵ��������Ŀ��ڵ��·�������ֻ����һ����ֱ�ӷ���
        record = source;
%         GLength = 1;
        record(GLength+1) = 0;
        dis = record(GLength+1);
        route = [source,destination];
        return;
    elseif ~isempty( find( source == destination, 1 ) )
        return;
    end
    %nextNodes�е���һ������0,����Ϊ����nextNodes(i)ȥ�����Ƚ��丳ֵΪ0
    for i=1:length(nextNodes)
        if destination == nextNodes(i)
            %���·��
            tmpPath = cat(2, source, destination);      %���ӳ�һ��������·��
            tmpPath(GLength+1) = Map(lastNode, destination); %�ӳ����鳤����GLength+1, ���һ��Ԫ�����ڴ�Ÿ�·������·��
            record( length(record)+1 , : ) = tmpPath;
            nextNodes(i) = 0;
        elseif ~isempty( find( source == nextNodes(i), 1 ) )
            nextNodes(i) = 0;
        end
    end
    nextNodes = nextNodes(nextNodes ~= 0); %��nextNodes��Ϊ0��ֵȥ������Ϊ��һ���ڵ�����Ѿ�����������������Ŀ��ڵ�
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
