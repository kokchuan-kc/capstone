classdef Analysis
    methods(Static)
        function plotFlyPath(particles,goal,goalRadius,positionLimit)
            n = length(particles(1).positionHistory);
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
                analysedData = struct('results',results,'filenames',filenames);
                path = strcat('result/', string(datetime('now','Format','ddHHmmss')), '.mat');
                save(path, 'analysedData');
            end
        end
    end
end