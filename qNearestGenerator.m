function qNearest = qNearestGenerator(graph, qRand) %Find nearest point of the graph to qRand
    
    distance = Inf;
    qNearest = [Inf, Inf];

    for i= 1:size(graph,1)
        tempDist = norm(qRand - graph(i,1:2));

        if tempDist < distance
            distance = tempDist;
            qNearest = graph(i,1:2);
        end
    end

    if qNearest == [Inf, Inf]
        warning("dind't find a qNearest");
    end
end