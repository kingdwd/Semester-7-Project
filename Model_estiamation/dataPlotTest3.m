hold on;
box on;

convConst = 1.385/400;

%speedDataRefineFunction('speed/speed_0-1/speed_0-1_001.bag');

dataList = {};
timeList = {};
shortestData = 1000;
%shortestTime = 1000;

%legendList = strings(11,1);
%legendList = strings(10,1);
legendList = strings(2,1);
%legendList = strings(6,1);

for i = 1:9
    fileName = strcat('speed/speed_0-1/speed_0-1_00', num2str(i));
    fileName = strcat(fileName, '.bag');
    
    [dataList{i}, timeList{i}] = speedDataRefineFunction(fileName);
    
    if shortestData >= length(dataList{i})
        shortestData = length(dataList{i}) - 1;
    end
    
    %legendList(i) = strcat("Speed, 0 to 1, #", num2str(i));
end

for i = 1:9
    dataList{i} = dataList{i}(1:shortestData);
    timeList{i} = timeList{i}(1:shortestData);
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
%smoothDeriv = smooth(deriv, 0.17, 'rloess');
smoothDeriv = smooth(deriv, 0.15, 'rloess');

delayVector = zeros(2, 1);
smoothDeriv = cat(1, delayVector, smoothDeriv);

avgTimeList = cat(1, delayVector, avgTimeList);
for i = 1:length(delayVector)
    avgTimeList(i) = (i - 1) * 0.1 + avgTimeList(i);
end

for i = (length(delayVector) + 1):length(avgTimeList)
    avgTimeList(i) = length(delayVector) * 0.1 + avgTimeList(i);
end

%plot(avgTimeList, deriv, 'm-');
plot(avgTimeList, smoothDeriv * convConst, 'r-', 'LineWidth', 2.0);

options = stepDataOptions('StepAmplitude', 1.0);

%legendList(1) = 'Speed measurements, 0V to 1V';
legendList(1) = 'Average speed measurements, 0V to 1V';
legendList(2) = '2nd order model with delay';
%legendList(3) = '2nd order model, no delay';

[y,t] = step(G_total_delay, options, 'b-');
%step(G, options, 'g-')

plot(t, squeeze(y) * convConst, 'b-', 'LineWidth', 2);

% for i = 1:length(Glist)
%     step(Glist(i), options);
%     legendList(i + 1) = strcat("OmegaN", num2str(i));
% end

legend(legendList, 'Location','southeast','FontSize',30);
title('Speed', 'FontSize',30);

xlabel('Time [s]','FontSize',30);
ylabel('Speed [m/s]','FontSize',30);
xlim([0 10]);
ylim([-0.05 1.4]);
set(gca,'FontSize',30);

%Plotting the steering transfer function with delay
% figure('Name', 'Step Response for the Steering Transfer Function')
% hold on
% step(tf_with_delay,'r')
% legend({'G(s): Steering Transfer Function with delay'})
% ax = gca;
% ax.FontSize = 20;
% title('Step Response for the Steering Transfer Function', 'FontSize',20)
% xlabel('Time','FontSize',20)
% ylabel('Amplitude','FontSize',20)

%step(G2, options, 'g-.');
%step(G3, options, 'm-.');
%step(T1, 'y-');
%step(T2, 'g-');
