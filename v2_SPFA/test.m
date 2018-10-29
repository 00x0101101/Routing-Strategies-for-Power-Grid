%%
% map
M = inf;
% Map = [0,1,3,M,2
%        3,0,M,4,3
%        5,M,0,1,2
%        M,2,1,0,M
%        1,5,4,M,0];

Map = [0,M,4,-5,M
       4,0,2,M,5
       M,2,0,3,M
       -5,M,3,0,1
       M,5,M,1,0];

% map(1,:)=[zeros(1,1),M,3,M,M,M,M,4,M];
% map(2,:)=[zeros(1,2),M,3,M,M,M,M,2];
% map(3,:)=[zeros(1,3),5,1,3,M,M,M];
% map(4,:)=[zeros(1,4),M,6,M,M,4];
% map(5,:)=[zeros(1,5),2,2,M,M];
% map(6,:)=[zeros(1,6),M,2,M];
% map(7,:)=[zeros(1,7),6,2];
% map(8,:)=[zeros(1,8),7];
% map(9,:)=[zeros(1,9)];
% Map=map+map';

%%
%SPFA 
% source = 2; %起点
% [m,n] = size(Map);
% 
% bottom=0;
% top=1;
% queue = []; %队列
% dis = inf*ones(1,m); %最短路径
% book = zeros(1,m); %标记某点是否在队列中
% count = zeros(1,m); %记录某点入队次数
% SP = true; %存在最短路径
% 
% route = source*ones(1,m);
% 
% bottom = bottom+1;
% queue(bottom) = source;
% dis(source) = 0;
% book(source) = 1;
% count(source) = 1;
% 
% while(top<=bottom)
%     cur = queue(top); %当前拓展的顶点
%     for j=1:1:m
%         if Map(cur,j)~=inf
%             if dis(j)>dis(cur)+Map(cur,j)
%                 dis(j) = dis(cur)+Map(cur,j);
%                 route(j) = cur;
%                 if book(j)== 0
%                     count(j) = count(j)+1;
%                     if count(j)>n
%                         SP = false;
%                         break;
%                     end
%                     bottom = bottom+1;
%                     queue(bottom) = j;
%                     book(j) = 1;
%                 end
%             end
%         end
%     end
%     book(cur) = 0;
%     top = top+1;
% end
%%
% path = findPath(Map, 1, 2, 0);
% [dis, route] = DFS_ShortestPath(Map, 1, 2);
% Graph = Map;
% partialPath = 1;
% destination = 5;
% partialWeight = 0;
%     pathLength = length(partialPath);
%     lastNode = partialPath(pathLength); %得到最后一个节点
% %     nextNodes = find(0<Graph(lastNode,:) & Graph(lastNode,:)<inf); %根据Graph图得到最后一个节点的下一个节点
%     nextNodes = find(Graph(lastNode,:)<inf); %根据Graph图得到最后一个节点的下一个节点
%     GLength = length(Graph);
%     possiablePaths = [];
%     if lastNode == destination
%         % 如果lastNode与目标节点相等，则说明partialPath就是从其出发到目标节点的路径，结果只有这一个，直接返回
%         possiablePaths = partialPath;
%         possiablePaths(GLength + 1) = partialWeight;
%         return;
%     elseif length( find( partialPath == destination ) ) ~= 0
%         return;
%     end
%     %nextNodes中的数一定大于0,所以为了让nextNodes(i)去掉，先将其赋值为0
%     for i=1:length(nextNodes)
%         if destination == nextNodes(i)
%             %输出路径
%             tmpPath = cat(2, partialPath, destination);      %串接成一条完整的路径
%             tmpPath(GLength + 1) = partialWeight + Graph(lastNode, destination); %延长数组长度至GLength+1, 最后一个元素用于存放该路径的总路阻
%             possiablePaths( length(possiablePaths) + 1 , : ) = tmpPath;
%             nextNodes(i) = 0;
%         elseif length( find( partialPath == nextNodes(i) ) ) ~= 0
%             nextNodes(i) = 0;
%         end
%     end
%     nextNodes = nextNodes(nextNodes ~= 0); %将nextNodes中为0的值去掉，因为下一个节点可能已经遍历过或者它就是目标节点
%     for i=1:length(nextNodes)
%         tmpPath = cat(2, partialPath, nextNodes(i));
%         tmpPsbPaths = findPath(Graph, tmpPath, destination, partialWeight + Graph(lastNode, nextNodes(i)));
%         possiablePaths = cat(1, possiablePaths, tmpPsbPaths);
%     end
%%
% source = 1; destination = 3;
%     if all(Map>=0)
%         route = [destination];
%         [ d,index1,index2 ] = Dijk( Map, source );
%         distance = d(destination);
%         temp = destination;
%         while index2(temp)~= source
%             route = [route,index2(temp)];
%             temp = index2(temp);
%         end
%         route = [route, source];
%         route = fliplr(route);
%     else
%         [ SP, dis, index ] = SPFA( Map,source );
%         if SP == 1
%             distance = dis(destination);
%             temp = destination;
%             while index(temp)~= source
%                 route = [route,index(temp)];
%                 temp = index(temp);
%             end
%             route = [route, source];
%             route = fliplr(route);
%         else
%             [distance, route] = DFS_ShortestPath(Map, source, destination);
%         end
%     end
%%
