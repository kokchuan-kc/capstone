
clear
close all

x = [2 5 10 30 50];

%AIC 1
%Mean Collision
% y1 = [1.18 21.5 95.43 253.52 240.04];
% y2 = [0.07 0.28 1.03 34.41 45.94];
% y3 = [0.1 0.39 1.56 6.6 7.22];


%Mean Iteration
% y1 = [14.96 18.01 15.67 10.6 9.55];
% y2 = [60.98 26.47 17.11 10.59 9.91];
% y3 = [63.31 45.83 19.57 11.11 9.88];

%Mean Goal
y1 = [0.02 0.22 0.53 0.91 0.97];
y2 = [0.83 0.96 0.99 1 1];
y3 = [0.02 0.99 1 1 1];


figure
plot(x,y1,'r-o',x,y2,'g-o',x,y3,'b-o')
legend('PSO','NPSO','FFPSO')

% title('Mean Collision Comparison')
% ylabel('Mean Collision');

% title('Mean Iteration Comparison')
% ylabel('Mean Iteration');

title('Mean Goal Reached Comparison')
ylabel('Mean Goal Reached');

xlabel('Swarm Size')
xticks(x)
