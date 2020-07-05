classdef Environment < handle
    properties
        %position limit [min,max] for x,y and z
        POSITION_LIMIT = [0,100]
        
        %Adjustable Parameter
        %==============================================
        %Termination Condition
        MAX_ITERATION = 200
        GOAL_THRESHOLD = 1
        GOAL_RADIUS = 5
        
        %swarm parameter
        SWARM_SIZE = 10
        CONSTANTS = [0.5 0.5 0.5 1]
    
        %force field size
        ZONE = [1 2 5]
        %==============================================

        withPlot = true
        algoType = ''
            
        goal = zeros(1,3)
        iteration = 1
        particles = []
        globalBestPosition = zeros(1,3)
        globalBestPositionHistory = []
        collisionCounter = 0
        timeTaken = 0
        isGoal = false
    end
    methods
        function position = randInitialPosition(this)
            position = this.POSITION_LIMIT(1) + ...
                       Utility.randRange(this.POSITION_LIMIT(1),this.POSITION_LIMIT(2));
        end
        function isGoal = checkGoal(this)
            inGoalCounter = 0;
            for particle = this.particles
                if Utility.calculateDistance(this.goal, particle.position) <= this.GOAL_RADIUS
                    inGoalCounter = inGoalCounter + 1;
                end
            end
            if inGoalCounter >= ceil(this.SWARM_SIZE * this.GOAL_THRESHOLD)
                isGoal = true;
            else
                isGoal = false;
            end
        end
        function hasChange = checkChange(this)
            num = length(this.particles);
            prevPosition = zeros(1,num);
            currPosition = zeros(1,num);
            
            for i = 1:num
                prevPosition(i) = Utility.getValueByPrecision(this.particles(i).positionHistory(end-1),1);
                currPosition(i) = Utility.getValueByPrecision(this.particles(i).positionHistory(end),1);
            end
            
            if prevPosition == currPosition
                hasChange = false;
            else
                hasChange = true;
            end
        end
        function force = calculateForce(this,d)
            d(d==0) = Utility.randomVector * 0.1;
            dAbsolute = abs(d);
            dRepulsion = d(dAbsolute < this.ZONE(1));
            dAttraction = d(dAbsolute > this.ZONE(2) & dAbsolute < this.ZONE(3));
            
            if strcmp(this.algoType,"PSO")
                %PSO
                force = 0;
            elseif strcmp(this.algoType,"NPSO")
                %NPSO
                %AIC 1
%                 if ~isempty(dRepulsion)
%                     dAbsolute = abs(dRepulsion);
%                     distance = min(dAbsolute);
%                     index = find(dAbsolute==distance,1);
%                     force = dRepulsion(index);
%                 elseif ~isempty(dAttraction)
%                     dAbsolute = abs(dAttraction);
%                     distance = min(dAbsolute);
%                     index = find(dAbsolute==distance,1);
%                     force = -dAttraction(index);
%                 else
%                     force = 0;
%                 end
                %===========================================================
                %AIC 2
%                 if ~isempty(dRepulsion)
%                     dAbsolute = abs(dRepulsion);
%                     distance = min(dAbsolute);
%                     index = find(dAbsolute==distance,1);
%                     force = 0.1 /  dRepulsion(index) * 0.1 * this.ZONE(1);
%                 elseif ~isempty(dAttraction)
%                     dAbsolute = abs(dAttraction);
%                     distance = min(dAbsolute);
%                     index = find(dAbsolute==distance,1);
%                     force = -dAttraction(index);
%                 else
%                     force = 0;
%                 end
                %===========================================================
                %AIC 3
                if ~isempty(dRepulsion)
                    dAbsolute = abs(dRepulsion);
                    distance = min(dAbsolute);
                    index = find(dAbsolute==distance,1);
                    
                    dValue = dRepulsion(index);
                    vector = dValue/abs(dValue);
                    force = (this.ZONE(1) - abs(dValue)) * vector;
                elseif ~isempty(dAttraction)
                    dAbsolute = abs(dAttraction);
                    distance = min(dAbsolute);
                    index = find(dAbsolute==distance,1);
                    
                    dValue = dAttraction(index);
                    vector = dValue/abs(dValue);
                    force = -(abs(dValue) - this.ZONE(1)) * vector;
                else
                    force = 0;
                end
            else 
                %FFPSO
                if ~isempty(dRepulsion)
                    dAbsolute = abs(dRepulsion);
                    distance = min(dAbsolute);
                    index = find(dAbsolute==distance,1);
                    dValue = dRepulsion(index);
                    
                    force = dValue/abs(dValue) * (this.ZONE(1) - abs(dValue));
                else
                    force = 0;
                end
            end
        end
        function initialise(this)
            this.goal = [this.randInitialPosition this.randInitialPosition this.randInitialPosition];
            for i = 1:this.SWARM_SIZE
                initialPosition = [this.randInitialPosition this.randInitialPosition this.randInitialPosition];
                particle = Particle(initialPosition);
                this.particles = [this.particles particle];
            end
        end
        function plot(this, xPositions, yPositions, zPositions)
            clf
            %Graph Plotting
            scatter3(xPositions, yPositions, zPositions, 'b.');
            hold on
            scatter3(this.goal(1),this.goal(2), this.goal(3),'g.')
            [x,y,z] = sphere;
            % Scale to desire radius.
            x = x * this.GOAL_RADIUS + this.goal(1);
            y = y * this.GOAL_RADIUS + this.goal(2);
            z = z * this.GOAL_RADIUS + this.goal(3);
            surf(x,y,z,'EdgeColor', 'green','FaceColor','g','LineStyle','none', 'FaceAlpha',0.1)
            grid on
            axis(repmat(this.POSITION_LIMIT,1,3));
            view(42,24)
            title(sprintf('Iteration %d',this.iteration))
            xlabel('x')
            ylabel('y')
            zlabel('z')
            hold off
            pause(0.1)
        end
        function beginSimulation(this)
            xPositions = zeros(1,length(this.particles));
            yPositions = zeros(1,length(this.particles));
            zPositions = zeros(1,length(this.particles));

            if this.withPlot
                figure(1)
            end
            hasChange = true;
            while this.iteration <= this.MAX_ITERATION && ~this.isGoal && hasChange
                
                %update personal and global best position
                for i = 1:length(this.particles)
                    particle = this.particles(i);
                    xPositions(i) = particle.position(1);
                    yPositions(i) = particle.position(2);
                    zPositions(i) = particle.position(3);
                    particle.updatePersonalBest(this.goal)
                    this.globalBestPosition = Utility.selectBestPos(this.globalBestPosition, particle.position, this.goal);
                end
                this.globalBestPositionHistory = [this.globalBestPositionHistory;this.globalBestPosition];
                
                if this.withPlot
                    this.plot(xPositions, yPositions, zPositions);
                end
                
                %Calculate force
                force = zeros(1,3);
                for particle = this.particles
                    otherParticles = this.particles(this.particles ~= particle);
                    d_x = zeros(1,length(otherParticles));
                    d_y = zeros(1,length(otherParticles));
                    d_z = zeros(1,length(otherParticles));
                    for i = 1:length(otherParticles)
                        d_x(i) = particle.position(1) - otherParticles(i).position(1);
                        d_y(i) = particle.position(2) - otherParticles(i).position(2);
                        d_z(i) = particle.position(3) - otherParticles(i).position(3);
                    end
                    force = [this.calculateForce(d_x),this.calculateForce(d_y),this.calculateForce(d_z)];
                    particle.updateForce(force);
                end
                
                %update velocity and position
                randoms = [rand() rand()];
                for particle = this.particles
                    particle.updateVelocity(this.CONSTANTS, randoms, this.globalBestPosition)
                    particle.updatePosition(this.POSITION_LIMIT)
                end

                %Calculate collision that occured
                for particle = this.particles
                    otherParticles = this.particles(this.particles ~= particle);
                    for otherParticle = otherParticles
                        if Utility.getValueByPrecision(particle.position,1) == Utility.getValueByPrecision(otherParticle.position,1)
                            this.collisionCounter = this.collisionCounter + 1;
                        end
                    end
                end
                
                this.isGoal = this.checkGoal;
                hasChange = this.checkChange;
                this.iteration = this.iteration + 1;
            end
            
            this.iteration = this.iteration - 1;
            for i = 1:length(this.particles)
                particle = this.particles(i);
                xPositions(i) = particle.position(1);
                yPositions(i) = particle.position(2);
                zPositions(i) = particle.position(3);
            end
            
            if this.withPlot
                this.plot(xPositions, yPositions, zPositions);
                Analysis.plotFlyPath(this.particles, this.goal, this.GOAL_RADIUS, this.POSITION_LIMIT);
            end
        end
    end
end

