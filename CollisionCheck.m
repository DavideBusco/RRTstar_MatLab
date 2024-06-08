function collisionOnPath = CollisionCheck(q1,q2)

    global mapDimX;
    global mapDimY;
    global delta;
    global map;
    global Obstacle;

    %Angle of the segment connecting qNear and qRand
    distance = norm(q2-q1);
    angle = real(asin((q2(2)-q1(2))/(distance)));
    %fprintf('-----Angle: %d', angle);

    collisionOnPath = 0;

    %Given The angle I can split the segment in order to check the collision on the segment connecting qNear and qNew
    for n=0:delta  %Split the segment in delta parts
        qxActual = q1(1) + round(cos(angle)*(delta-n));
        qyActual = q1(2) + round(sin(angle)*(delta-n));
        %fprintf('\n-----qActual: x.%d - y.%d\n', qxActual, qyActual);

        if (qxActual > 0) && (qyActual > 0) && (qxActual<mapDimX) && (qyActual<mapDimY)
            if map(qxActual, qyActual) == Obstacle
                collisionOnPath = 1;
            end
        else
            collisionOnPath = 1; %Gestisco un punto fuori mappa come se fosse una collision
        end  
    end
end