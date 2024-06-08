function qRand = qRandGenerator()

    global mapDimX;
    global mapDimY;

    qRand = [randi(mapDimX), randi(mapDimY)];
end