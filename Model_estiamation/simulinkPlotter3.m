hold on;
grid on;

legendList = strings(2,1);

legendList(1) = "Input to the model from the relay";
legendList(2) = "Model output";

plot(input, 'r-');
plot(output, 'b-');

legend(legendList, 'Location','southeast','FontSize',20);
title('Response of the model with a relay', 'FontSize',20);

alldatacursors = findall(gcf,'type','hggroup')
set(alldatacursors,'FontSize',20)

xlabel('Time','FontSize',20);
ylabel('m/s','FontSize',20);
xlim([0 50]);
ylim([-0.1 1.5]);
set(gca,'FontSize',20);