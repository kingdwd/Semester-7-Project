hold on;

%speedDataRefineFunction('speed/speed_0-1/speed_0-1_001.bag');

dataList = {};
timeList = {};
dderivList = {};
shortestData = 1000;
%shortestTime = 1000;

%legendList = strings(13,1);
%legendList = strings(10,1);
legendList = strings(4,1);

for i = 1:9
    fileName = strcat('speed/speed_0-2/speed_0-2_00', num2str(i));
    fileName = strcat(fileName, '.bag');
    
    [dataList{i}, timeList{i}, dderivList{i}] = accDataRefineFunction(fileName);
    
    if shortestData >= length(dataList{i})
        shortestData = length(dataList{i}) - 1;
    end
    
    %legendList(i) = strcat("Acceleration, 0 to 2, #", num2str(i));
end

for i = 1:9
    dataList{i} = dataList{i}(1:shortestData);
    timeList{i} = timeList{i}(1:shortestData);
    dderivList{i} = dderivList{i}(1:shortestData);
end

avgDataList = zeros(length(dataList{1}), 1);
avgTimeList = zeros(length(timeList{1}), 1);

for i = 1:9
    avgDataList = avgDataList + dataList{i};
    avgTimeList = avgTimeList + timeList{i};
end

avgDataList = avgDataList / 9;
avgTimeList = avgTimeList / 9;

deriv = [];
deriv(1) = 0;

for i = 2:(length(avgDataList))
    deriv(i) = (avgDataList(i) - avgDataList(i - 1)) / (avgTimeList(i) - avgTimeList(i - 1));
end

deriv = transpose(deriv);
smoothDeriv = smooth(deriv, 0.125, 'rloess');

avgDderiv = zeros(length(deriv), 1);

% dderiv = [];
% dderiv(1) = 0;

% for j = 1:9
%     for i = 2:(length(timeList{j}))
%         dderiv(j,i) = (smoothDeriv(i) - smoothDeriv(i - 1)) / (timeList{j}(i) - timeList{j}(i - 1));
%     end
% end

%dderiv = transpose(dderiv);

for i = 1:9
    avgDderiv = avgDderiv + dderivList{i};
end

avgDderiv = avgDderiv / 9;
smoothDderiv = smooth(avgDderiv, 0.125, 'rloess');

plot(avgTimeList, avgDderiv, 'r-', 'LineWidth', 1.5);
%plot(avgTimeList, smoothDderiv, 'b-.');

options = stepDataOptions('StepAmplitude', 2.2);

step(Gorder1, options);
step(Gorder11, options);

[pl2, pl2Time] = step(Gorder11, options);
limAcc2 = limiter(pl2, 0, 700);
plot(pl2Time, limAcc2, 'b-');

%step(G, options, 'b-');
%step(G2, options, 'g-.');
%step(G3, options, 'm-.');
%step(T1, 'y-');
%step(T2, 'g-');

legendList(1) = 'Average acceleration';
legendList(2) = '1st order system';
legendList(3) = '1st order system with a zero';
legendList(4) = '1st order system with a zero, limited between 0 and 700';

legend(legendList, 'Location','southeast','FontSize',20);
title('Acceleration, input: 0 to 2 Volt','FontSize',20);

xlabel('Time','FontSize',20);
ylabel('Ticks per second^2','FontSize',20);
xlim([0 12]);
ylim([-750 1550]);
set(gca,'FontSize',20);

