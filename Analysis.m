classdef Analysis
    methods(Static)
        function plotFlyPath(particles,goal,goalRadius,positionLimit)
            n = length(particles(1).positionHistory);
            
            % Function by
            % Jonathan C. Lansey (2020).
            % Beautiful and distinguishable line colors + colormap
            % (https://www.mathworks.com/matlabcentral/fileexchange/42673-beautiful-and-distinguishable-line-colors-colormap),
            % MATLAB Central File Exchange.
            colors = linspecer(length(particles));
            
            figure(2)
            %Graph Plotting
            hold on
            grid on
            view(42,24)
            xlabel('x')
            ylabel('y')
            zlabel('z')
            
            scatter3(goal(1),goal(2), goal(3),'g.')
            [x,y,z] = sphere;
            % Scale to desire radius.
            x = x * goalRadius + goal(1);
            y = y * goalRadius + goal(2);
            z = z * goalRadius + goal(3);
            surf(x,y,z,'EdgeColor', 'green','FaceColor','g','LineStyle','none', 'FaceAlpha',0.1)
            axis(repmat(positionLimit,1,3));
            
            for i = 1:length(particles)
                particle = particles(i);
                
                xPosition = zeros(1,n);
                yPosition = zeros(1,n);
                zPosition = zeros(1,n);
                for j = 1: n
                    xPosition(j) = particle.positionHistory(j,1);
                    yPosition(j) = particle.positionHistory(j,2);
                    zPosition(j) = particle.positionHistory(j,3);
                end
                
                scatter3(xPosition(1),yPosition(1),zPosition(1),'MarkerEdgeColor',colors(i,:),'marker','x');
                scatter3(xPosition(end),yPosition(end),zPosition(end),'MarkerEdgeColor',colors(i,:),'marker','^');
                
                plot3(xPosition,yPosition,zPosition,'color',colors(i,:))
            end
            hold off
        end
        function plotFlyPathFromFile(filename,row)
            a = load(strcat('rawdata/', filename,'.mat'));
            
            data = a.simulations(row);
            particles = data.particles;
            goal = data.goal;
            goalRadius = data.GOAL_RADIUS;
            positionLimit = data.POSITION_LIMIT;
            
            clf
            Analysis.plotFlyPath(particles,goal,goalRadius,positionLimit);
        end
        function processData(filename)
            rawData = load(strcat('rawdata/', filename, '.mat'));

            simulations = rawData.simulations;
            
            num = length(simulations);
            
            data.collisions = zeros(1,num);
            data.isGoals = zeros(1,num);
            data.iteration = zeros(1,num);
            for i = 1:num
                data.collisions(i) = simulations(i).collisionCounter;
                data.isGoals(i) = simulations(i).isGoal;
                data.iteration(i) = simulations(i).iteration; 
            end
            
            if ~exist('data','dir')
                mkdir data
            end
            
            path = strcat('data/', filename, '.mat');
            save(path, '-struct', 'data');
        end
        function analyseData(filenames,toSave)
            num = length(filenames);
            
            results(1,num) = struct('name','','collisionSum',0,'collisionMean',0,'iterationMean',0);
            for i = 1:num
                data = load(strcat('data/', filenames(i), '.mat'));
                
                names = split(filenames(i),'-');
                results(i).name = names(1);
                
                results(i).collisionSum = sum(data.collisions);
                results(i).collisionMean = mean(data.collisions);
                results(i).iterationMean = mean(data.iteration);
                results(i).goalsReached = sum(data.isGoals(data.isGoals==1))/length(data.isGoals);
            end
            
            disp(struct2table(results))
            if toSave
                if ~exist('result','dir')
                    mkdir result
                end
                
                analysedData = struct('results',results,'filenames',filenames);
                path = strcat('result/', string(datetime('now','Format','ddHHmmss')), '.mat');
                save(path, 'analysedData');
            end
        end
        function plotAnalysis(files)
            x = [2 5 10 30 50];
            
            y1c = zeros(1,5);
            y2c = zeros(1,5);
            y3c = zeros(1,5);
            
            y1i = zeros(1,5);
            y2i = zeros(1,5);
            y3i = zeros(1,5);
            
            y1g = zeros(1,5);
            y2g = zeros(1,5);
            y3g = zeros(1,5);
            for i = 1:length(files)
                data = load(strcat('result/', files(i), '.mat'));
                results = data.analysedData.results;
                
                y1c(i) = round(results(1).collisionMean,2);
                y2c(i) = round(results(2).collisionMean,2);
                y3c(i) = round(results(3).collisionMean,2);
                
                y1i(i) = round(results(1).iterationMean,2);
                y2i(i) = round(results(2).iterationMean,2);
                y3i(i) = round(results(3).iterationMean,2);
                
                y1g(i) = round(results(1).goalsReached,2);
                y2g(i) = round(results(2).goalsReached,2);
                y3g(i) = round(results(3).goalsReached,2);
            end
            
            figure(1)
            plot(x,y1c,'r-o',x,y2c,'g-o',x,y3c,'b-o')
            legend('PSO','NPSO','FFPSO')
            title('Mean Collision Comparison')
            ylabel('Mean Collision');
            xlabel('Swarm Size')
            xticks(x)
            
            figure(2)
            plot(x,y1i,'r-o',x,y2i,'g-o',x,y3i,'b-o')
            legend('PSO','NPSO','FFPSO')
            title('Mean Iteration Comparison')
            ylabel('Mean Iteration');
            xlabel('Swarm Size')
            xticks(x)
            
            figure(3)
            plot(x,y1g,'r-o',x,y2g,'g-o',x,y3g,'b-o')
            legend('PSO','NPSO','FFPSO')
            title('Mean Goal Reached Comparison')
            ylabel('Mean Goal Reached');
            xlabel('Swarm Size')
            xticks(x)
        end
    end
end