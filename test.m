files = ["03020029","03020101","03020126","03020219","03022921"];

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
% plot(x,y1c,'r-o',x,y2c,'g-o',x,y3c,'b-o')
plot(x,y2c,'g-o',x,y3c,'b-o')
legend('NPSO','FFPSO')
% legend('PSO','NPSO','FFPSO')
title('Mean Collision Comparison')
ylabel('Mean Collision');
xlabel('Swarm Size')
xticks(x)
ylim([0 20])

figure(2)
% plot(x,y1i,'r-o',x,y2i,'g-o',x,y3i,'b-o')
% legend('PSO','NPSO','FFPSO')
plot(x,y2i,'g-o',x,y3i,'b-o')
legend('NPSO','FFPSO')
title('Mean Iteration Comparison')
ylabel('Mean Iteration');
xlabel('Swarm Size')
xticks(x)
ylim([10 30])

figure(3)
% plot(x,y1g,'r-o',x,y2g,'g-o',x,y3g,'b-o')
% legend('PSO','NPSO','FFPSO')
plot(x,y2g,'g-o',x,y3g,'b-o')
legend('NPSO','FFPSO')
title('Mean Goal Reached Comparison')
ylabel('Mean Goal Reached');
xlabel('Swarm Size')
xticks(x)
ylim([0.9 1.1])