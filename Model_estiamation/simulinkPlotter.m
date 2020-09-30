legendList = strings(4,1);

legendList(1) = "Unregulated response";
legendList(2) = "Ziegler-Nichols tuned PID";
legendList(3) = "MatLAB tuned PID";
legendList(4) = "MatLAB tuned PID with Smith Predictor";

hold on;
%grid on;

plot(unregulated, 'r-');
plot(ZN_tuned, 'g-');
plot(ML_tuned, 'b-');
plot(tuned_system3, 'm-');

legend(legendList, 'Location','southeast','FontSize',20);
title('Speed response with controllers tuned by different methods', 'FontSize',20);

xlabel('Time','FontSize',20);
ylabel('m/s','FontSize',20);
xlim([0 17.5]);
ylim([-0.1 1.5]);
set(gca,'FontSize',20);