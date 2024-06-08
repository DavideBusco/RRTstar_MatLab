function pointsInNeigh = GetPointsInNeighborhood(qNew, graph)
    
    global neighRadius;

    pointsInNeigh = [];
    for i=1:size(graph,1)
        qNear = graph(i,1:2);
        if (norm(qNew - qNear)) < neighRadius
            pointsInNeigh = [pointsInNeigh; qNear];
        end
    end
end