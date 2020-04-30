classdef Particle < handle
    properties
        position = []
        velocity = zeros(1,3)
        bestPosition = zeros(1,3)
    end
    methods
        function this = Particle(initialPosition)
            this.position = initialPosition;
        end
        function updatePersonalBest(this, goal)
            %minimize distance between particle and goal point
            this.bestPosition = Utility.selectBestPos(this.position, this.bestPosition, goal);
        end
        function updateVelocity(this, constants, randoms, globalBestPosition, force)
            for i = 1:length(this.velocity)
                this.velocity(i) = constants(1) * this.velocity(i) + ...
                                   (constants(2) * randoms(1) * (this.bestPosition(i) - this.position(i))) + ...
                                   (constants(3) * randoms(2) * (globalBestPosition(i) - this.position(i))) + ...
                                   force(i);
            end
        end
        function updatePosition(this, positionLimit)
            for i = 1:length(this.position)
                newPosition = this.position(i) + this.velocity(i);
                if newPosition < positionLimit(1)
                    this.position(i) = positionLimit(1);
                elseif newPosition > positionLimit(2)
                    this.position(i) = positionLimit(2);
                else
                    this.position(i) = newPosition;
                end
            end
        end
    end
end
