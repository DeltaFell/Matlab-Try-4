clear all;
cd 'E:\Williams Lab\Turbines\AOA Estimation Research\Calculation Data'
run('NameProcessing')
C = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0]};
%ha = tight_subplot(1, 1, 800, [1 0.7], 1, [65 20], [85 20], 'pixels');
%ha = tightPlots(1, 1, 800, [1 0.7], 1, [65 20], [85 20], 'pixels');
tiledlayout("flow")
l = 1;
for i = 1:2
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        if i == 1 || i == 3
                legendinfo{l} = ['$TA\ Circle$']; 
        else
                legendinfo{l} = ['$PA\ Circle$'];
        end
        hold on
    end
    l = l+1;
end
for i = 5:6
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        if i == 1 || i == 3 || i == 5 || i == 7
                legendinfo{l} = ['$TA\ Blade$']; 
        else
                legendinfo{l} = ['$PA\ Blade$'];
        end
        hold on
    end
    l = l+1;
end
for i = 13
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
        legendinfo{l} = ['$PA\ Reference\ Points$'];
        hold on
    end
    l = l+1;
end

for i = 15
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    for k = 1 : height(diff_dia_rel)
        h(l) = plot(theta, diff_dia_aoa(k,:), 'color', C{l});
        h(l).Color(4) = 0.2 * k;
        legendinfo{l} = ['$PA\ Rectangle$'];
        hold on
    end
    l = l+1;
end
h(l) = plot(theta,nominal_aoa,'--k','LineWidth',2);
legendinfo{l} = ['$Nominal\ AOA$'];
legend(h, legendinfo, 'location', 'best', 'FontSize', 10)
xlim([0 360])
ylim([-180 180])
set(gca,'xtick',[0:60:360])
set(gca, 'ytick', [-180:60:180])
grid on
xlabel('$\theta$','Interpreter','latex')
ylabel('$\alpha$','Interpreter','latex')
hold off