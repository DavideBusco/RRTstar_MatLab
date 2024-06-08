function qNew = Steer(qNearest, qRand)
    
    global delta;

    distance = norm(qRand-qNearest);

    %Angle of the segment connecting qNear and qRand
    angle = real(asin((qRand(2)-qNearest(2))/(distance)));
    %fprintf('-----Angle: %d', angle);

    %Given The Angle I can Compute the point at a distance delta on that segment
    qxNew = qNearest(1) + round(cos(angle)*delta);
    qyNew = qNearest(2) + round(sin(angle)*delta);
    %fprintf('\n-----qNew: x.%d - y.%d\n', qxNew, qyNew);

    qNew = [qxNew, qyNew];
end