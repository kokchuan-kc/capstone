classdef Environment < handle
    properties
        SWARM_SIZE = 10
        CONSTANT = [0.75 0.1 0.1]
        MAX_ITERATION = 100
        %position limit [min,max] for x,y and z
        POSITION_LIMIT = [0,100]

        FORCE_MAGNITUDE = 0.5
        GOAL = zeros(1,3)
        GOAL_THRESHOLD = 0.5
        GOAL_RADIUS = 5
        ZONE = [0.5 1 1.5]
        
        particles = []
        globalBestPosition = 0
    end
    methods
        function position = randInitialPosition(this)
            position = this.POSITION_LIMIT(1) + ...
                       Utility.randRange(this.POSITION_LIMIT(1),this.POSITION_LIMIT(2));
        end
        function isGoal = checkGoal(this)
            inGoalCounter = 0;
            for particle = this.particles
                if Utility.calculateDistance(this.GOAL, particle.position) <= this.GOAL_RADIUS
                    inGoalCounter = inGoalCounter + 1;
                end
            end
            if inGoalCounter >= ceil(this.SWARM_SIZE * this.GOAL_THRESHOLD)
                isGoal = true;
            else
                isGoal = false;
            end
        end
        function initialise(this)
%             this.GOAL = [this.randInitialPosition this.randInitialPosition this.randInitialPosition];
            this.GOAL = [50 30 80];
            for i = 1:this.SWARM_SIZE
                initialPosition = [this.randInitialPosition this.randInitialPosition this.randInitialPosition];
                particle = Particle(initialPosition);
                this.particles = [this.particles particle];
            end
%             for i = 1:this.SWARM_SIZE/2
%                 particle = Particle([20,20,20]);
%                 this.particles = [this.particles particle];
%             end
        end
        function beginSimulation(this)
            iteration = 1;
            this.globalBestPosition = this.particles(1).position;
            xPositions = zeros(1,length(this.particles));
            yPositions = zeros(1,length(this.particles));
            zPositions = zeros(1,length(this.particles));

            figure
            isGoal = false;
            collisionCounter = 0;
            while iteration <= this.MAX_ITERATION && ~isGoal
                clf
                %update personal and global best position
                for i = 1:length(this.particles)
                    particle = this.particles(i);
                    xPositions(i) = particle.position(1);
                    yPositions(i) = particle.position(2);
                    zPositions(i) = particle.position(3);
                    particle.updatePersonalBest(this.GOAL)
                    this.globalBestPosition = Utility.selectBestPos(this.globalBestPosition, particle.position, this.GOAL);
                end
                scatter3(xPositions, yPositions, zPositions, 'b.');
                hold on
                scatter3(this.GOAL(1),this.GOAL(2), this.GOAL(3),'g.')
                [x,y,z] = sphere;
                % Scale to desire radius.
                x = x * this.GOAL_RADIUS + this.GOAL(1);
                y = y * this.GOAL_RADIUS + this.GOAL(2);
                z = z * this.GOAL_RADIUS + this.GOAL(3);
                surf(x,y,z,'EdgeColor', 'green','FaceColor','g','LineStyle','none', 'FaceAlpha',0.1)
                grid on
                axis(repmat(this.POSITION_LIMIT,1,3));
%                 axis([this.GOAL(1)-10 this.GOAL(1)+10 this.GOAL(2)-10 this.GOAL(2)+10 this.GOAL(3)-10 this.GOAL(3)+10]);
                view(42,24)
                title(sprintf('Iteration %d',iteration))
                xlabel('x')
                ylabel('y')
                zlabel('z')
                %update velocity and position
                randoms = [rand() rand()];
                isGoal = this.checkGoal;
                for particle = this.particles
                    force = zeros(1,3);
                    otherParticles = this.particles(this.particles ~= particle);
                    for otherParticle = otherParticles
                        for ax = 1:3
                            d = particle.position(ax) - otherParticle.position(ax);
                            if d <= this.ZONE(1)
                                force(1) = Utility.evaluateForce(force(1),-this.FORCE_MAGNITUDE * d, @min);
                            elseif d <= this.ZONE(2)
                                force(i) = 0;
                            else
                                force(i) = Utility.evaluateForce(force(1),0.2 * this.FORCE_MAGNITUDE * -d, @max);
                            end
                        end
                    end
                    particle.updateVelocity(this.CONSTANT, randoms, this.globalBestPosition, force)
                    particle.updatePosition(this.POSITION_LIMIT)
                    for otherParticle = otherParticles
                        if Utility.getValueByPrecision(particle.position,2) == Utility.getValueByPrecision(otherParticle.position,2)
                            collisionCounter = collisionCounter + 1;
                        end
                    end
                end
                iteration = iteration + 1;
                pause(0.1)
            end
            disp(collisionCounter)
        end
    end
end

