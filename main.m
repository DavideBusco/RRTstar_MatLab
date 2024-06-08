global qStart;
qStart = [30, 125];

global qGoal;
qGoal = [135, 400];

nodes = []; %array dei nodi nx2
nodes = [nodes; qStart];

graph = []; %array dei collegamenti tra nodi [col1 col2] -> col1 nodo di partenza, col2 nodo precedente di col1
graph = [qStart, -Inf, -Inf]

global delta;
delta = 10;
global maxDistanceToGoal;
maxDistanceToGoal = 20;
foundConnectionToGoal = 0;
reversePath = [];

global map;
map = load("image_map.mat").image_map;
global mapDimX;
mapDimX = size(map,1);
global mapDimY;
mapDimY = size(map,2);

%Map Symbols
global Uknown;
Uknown = -1;
global Obstacle;
Obstacle = 0;
global Free;
Free = 1;

nIterations = 3000;
nIterationsToPlot = 20;

global neighRadius;
neighRadius = 15;

%Main
for i=1:nIterations
    qRand = qRandGenerator();
    qNearest = qNearestGenerator(graph, qRand);
    qNew = Steer(qNearest, qRand);
    collisionOnPath = CollisionCheck(qNearest, qNew);

    %% Adding Point to the graph
    if ~collisionOnPath
        %display("NO collisions");
        pointsInNeigh = GetPointsInNeighborhood(qNew, graph);

        %Init qMin
        qMin = qNearest;

        %Init costMin
        costMin = norm(qNew - qNearest) + ComputePathCost(qMin, graph);

        %% Looking for the best path in the neighborood to connect to qNew + Rewiring
        for j = 1:size(pointsInNeigh,1)
            qNear = pointsInNeigh(j,:);
            collisionOnPathNeigh = CollisionCheck(qNear, qNew);
            
            if ~collisionOnPathNeigh
                tempCost = norm(qNew - qNear) + ComputePathCost(qNear, graph);                

                if tempCost < costMin
                    qMin = qNear;
                    costMin = tempCost;
                end
            else
                %display("collision on neighbor");
            end           
        end

        graph = [graph; qNew, qMin];

        %Start Rewiring
        for j = 1:size(pointsInNeigh,1)
            qNear = pointsInNeigh(j,:);
            collisionOnPathNeigh = CollisionCheck(qNear, qNew);
            
            if ~collisionOnPathNeigh
                if norm(qNew - qNear) + ComputePathCost(qNew, graph) < ComputePathCost(qNear, graph)
                    for k = 1:size(graph,1)
                        if isequal(graph(k,1:2), qNear)
                           %fprintf("Rewiring done on %d-%d\n\n",qNear(1), qNear(2));
                           graph(k,3:4) = qNew; %Setting new origin to qNear if minor cost 
                        end
                    end
                end
            else
                %display("collision on neighbor");
            end           
        end
    
        %Check distance to Goal
        tempGoalDist = Inf;
        tempNearestGoal = [Inf, Inf];
        foundConnectionToGoal = 0;

        for g = 1:size(graph, 1)

            dist = norm(graph(g, 1:2) - qGoal);
            if (dist < maxDistanceToGoal) && (dist < tempGoalDist)
                
                if CollisionCheck(graph(g, 1:2), qGoal)
                    tempGoalDist = dist;
                    tempNearestGoal = graph(g, 1:2);
                    foundConnectionToGoal = 1;
                end
            end
        end

        if foundConnectionToGoal == 1
            graph = [graph; qGoal, tempNearestGoal];
        end
    else
        %display("there are collisions");
    end
    
    if mod(i,nIterationsToPlot) == 0
        %Plot Connections
        figure;
        imshow(map);
        hold on;
        for j=2:size(graph,1)
            plot(graph(j,2), graph(j,1), '.');
            line([graph(j,2) graph(j,4)], [graph(j,1) graph(j,3)]);
        end
        
        %Plot Start and Goal Positions
        plot(qStart(2), qStart(1), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
        plot(qGoal(2), qGoal(1), 'go', 'MarkerSize', 10, 'LineWidth', 2);

        if foundConnectionToGoal == 1
            reversePath = [];
            reversePath = [reversePath; qGoal];
            
            graphIndex = size(graph,1);
            actualPoint = graph(graphIndex, 1:2);

            while ~isequal(qStart, actualPoint)
                actualPoint = graph(graphIndex,3:4); 
    
                for l = 1:size(graph,1)
                    if isequal(graph(l,1:2), actualPoint)
                        graphIndex = l;  
                        reversePath = [reversePath; graph(l,1:2)];
                        break;
                    end
                end                
            end

            for m=1:size(reversePath,1)-1
                hold on;
                plot(reversePath(m,2), reversePath(m,1), '.', 'Color', 'r', 'MarkerSize', 2);
                line([reversePath(m,2) reversePath(m+1,2)], [reversePath(m,1) reversePath(m+1,1)], 'Color', 'r', 'LineWidth', 2);
            end
        end
    end

    i
end