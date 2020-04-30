classdef Utility
    methods(Static)
        function fitness = calculateFitness(position, goal)
            fitness = Utility.calculateDistance(position,goal);
        end
        function bestPosition = selectBestPos(position1, position2, goal)
            if Utility.calculateFitness(position1, goal) > Utility.calculateFitness(position2, goal)
                bestPosition = position2;
            else
                bestPosition = position1;
            end
        end
        function distance = calculateDistance(position1, position2)
            difference = position2 - position1;
            distance = sqrt(difference(1)^2 + difference(2)^2 + difference(3)^2);
        end
        function value = randRange(min, max)
            value = rand() * abs(max - min);
        end
        function force = evaluateForce(currentForce, newForce, callback)
            if currentForce ~= 0
               force = callback(currentForce, newForce);
            else
                force = currentForce;
            end
        end
        function result = getValueByPrecision(value, precision)
            result = round(value,precision) - round((round(value,precision) - value),precision);
        end
    end
end