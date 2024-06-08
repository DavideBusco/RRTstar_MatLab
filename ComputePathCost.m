function totalCost = ComputePathCost(point, graph)
    
    global qStart;
    
    pointIndex = -1;

    for i=1:size(graph,1)
        if isequal(graph(i,1:2), point)
            pointIndex = i;
            break;
        end
    end

    actualPoint = point;
    totalCost = 0;
    graphIndex = pointIndex;

    if ~(pointIndex==-1)
        while ~isequal(qStart, actualPoint)
            totalCost = totalCost + norm(actualPoint - graph(graphIndex, 3:4));
            actualPoint = graph(graphIndex,3:4);

            for i=1:size(graph,1)
                if isequal(graph(i,1:2), actualPoint)
                    graphIndex = i;
                    break;
                end
            end
        end
    else
        warning("didn't find point in graph");
    end
end