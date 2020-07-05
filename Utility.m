classdef Utility
    methods(Static)
        function bestPosition = selectBestPos(position1, position2, goal)
            if Utility.calculateDistance(position1, goal) > Utility.calculateDistance(position2, goal)
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
        function result = getValueByPrecision(value, precision)
              val = value * (10^precision);
              result = fix(val)/ (10^precision);
        end
        function vector = randomVector()
            if rand() <= 0.5
                vector = 1;
            else
                vector = -1;
            end
        end
        function deleteAllData
            delete 'rawdata/*'
            delete 'data/*'
            delete 'result/*'
        end
    end
end