
clear

algoList = ["PSO","NPSO","FFPSOGRAV"];
algo = algoList(2);

disp(strcat("Running Simulation for ", algo))

for i = 1:1
    close all
    
    tic
    simulation = Environment();
    simulation.initialise
    simulation.algoType = algo;
    simulation.beginSimulation
    simulation.timeTaken = toc;
    result.iteration = i;
    result.iterationTaken = simulation.iteration;
    result.collisionCounter = simulation.collisionCounter;
    disp(result);
end

disp("Simulation Ended")