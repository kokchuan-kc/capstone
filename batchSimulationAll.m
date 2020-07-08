clear
close all

disp('Running Batch Simulation for ALL')
start = tic;
algoList = ["PSO","NPSO","FFPSO"];
num = 500;
simulations(1,num) = Environment();
filenames = ["" "" ""];
for i = 1:length(algoList)
    algo = algoList(i);

    parfor j = 1:num
        tic
        simulation = Environment();
        simulation.initialise
        simulation.algoType = algo;
        simulation.withPlot = false;
        simulation.beginSimulation
        simulation.timeTaken = toc;
        simulations(j) = simulation
    end
    
    if ~exist('rawdata','dir')
        mkdir rawdata
    end
    filename = strcat(algo, '-', string(datetime('now','Format','ddHHmmss')));
    path = strcat('rawdata/',filename,'.mat');
    save(path, 'simulations')
    
    Analysis.processData(filename);
    filenames(i) = filename;
end
Analysis.analyseData(filenames,true);

stop = toc(start);
disp('Batch Simulation Ended')
disp(strcat('Time taken: ', string(stop)))