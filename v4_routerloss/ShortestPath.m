%singlesource-singledestination
function [ distance, route ] = ShortestPath( Map, source, destination )
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
        [ SP, dis, index ] = SPFA( Map,source );
        if SP == 1
            route = [destination];
            distance = dis(destination);
            temp = destination;
            while index(temp)~= source
                route = [route,index(temp)];
                temp = index(temp);
            end
            route = [route, source];
            route = fliplr(route);
        else
            [distance, route] = DFS_ShortestPath(Map, source, destination);
        end
%     end
end

