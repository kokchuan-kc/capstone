
clear
close all


algoList = ["PSO","NPSO","FFPSO"];
algo = algoList(2);
num = 500;
simulations(1,num) = Environment();
start = tic;

disp(strcat("Running Batch Simulation for ", algo))
parfor i = 1:num
    tic
    simulation = Environment();
    simulation.initialise
    simulation.algoType = algo;
    simulation.withPlot = false;
    simulation.beginSimulation
    simulation.timeTaken = toc;
    simulations(i) = simulation
end


filename = strcat(algo, '-', string(datetime('now','Format','ddHHmmss')));
path = strcat('rawdata/',filename,'.mat');
save(path, 'simulations')

Analysis.processData(filename);
Analysis.analyseData([filename],false);

stop = toc(start);
disp('Batch Simulation Ended')
disp(strcat('Time taken: ',string(stop)))
