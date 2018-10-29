% 1 source to  1 destination
% input: source, destination
% output: distance, route
function [ distance, route ] = singlesource_singledestination( map, source, destination )
    route = [destination];
    [ d, index1, index2 ] = singlesource_multidestination( map, source );
    distance = d(destination);
    temp = destination;
    while index2(temp)~= source
        route = [route,index2(temp)];
        temp = index2(temp);
    end
    route = [route, source];
    route = fliplr(route);
end

