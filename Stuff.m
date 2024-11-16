%% STD vs STDA
close all;
cd 'C:\Users\Michael\MATLAB Drive\AOA Estimation Research\Calculation Data'
run('NameProcessing')

C = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0]};  
l = 1;
clear 'range' 'STD' 'rangeA' 'STDA'
for i = 1:4
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    normalize_rel_mag = sqrt(relative_velocity(1,:).^2+relative_velocity(2,:).^2) / Uinf;
    for k = 1 : length(diff_dia_rel)
        range(k) = (max(diff_dia_rel(:,k))- min(diff_dia_rel(:,k))) / Uinf; 
        STD(k) = std(diff_dia_rel(:,k)/Uinf)./ median(diff_dia_rel(:,k)/Uinf);
        rangeA(k) = max(diff_dia_aoa(:,k))- min(diff_dia_aoa(:,k)); 
        STDA(k) = std(diff_dia_aoa(:,k))./ median(diff_dia_aoa(:,k));
    end
    if i == 1 || i == 3
%                 h(l) = scatter(normalize_rel_mag, range);
                h(l) = scatter(STD, STDA);
                legendinfo{l} = ['Averaged \lambda = ', num2str(lambda)];
                l = l+1;
                hold on
    else
%                 h(l) = scatter(normalize_rel_mag, range);
                h(l) = scatter(STD, STDA);
                legendinfo{l} = ['Phased \lambda = ', num2str(lambda)];
                l = l+1;
                hold on
    end

end
legend(h,legendinfo,'FontSize',8, 'location', 'best')
% xlim([0 360])
% set(gca,'xtick', [0:60:360])
grid on
xlabel('STD of U_r_e_l')
% ylabel('Range U_r_e_l/U_I_n_f')
ylabel('STD of AOA')
set(gcf,'position',[540,450,800,500])
title('STD v.s. STDA')
clear 'legendInfo';
cd 'C:\Users\Michael\MATLAB Drive\AOA Estimation Research'

%% AOA STD
close all;
cd 'C:\Users\Michael\MATLAB Drive\AOA Estimation Research\Calculation Data'
run('NameProcessing')

C = {[0 0.4470 0.7410],[0.9290 0.6940 0.1250],[0.4660 0.6740 0.1880],[0.3010 0.7450 0.9330],[0.4940 0.1840 0.5560],[0.8500 0.3250 0.0980],[0.6350 0.0780 0.1840],[1 0 1],[0 0 1],[1 1 0]};  
l = 1;
clear 'range' 'STD' 'rangeA' 'STDA'
for i = 1:4
    for j = 1:length(variable_name(i).name)
        name = (variable_name(i).name(j));
        load(name.name)
    end
    normalize_rel_mag = sqrt(relative_velocity(1,:).^2+relative_velocity(2,:).^2) / Uinf;
    for k = 1 : length(diff_dia_rel)
        range(k) = (max(diff_dia_rel(:,k))- min(diff_dia_rel(:,k))) / Uinf; 
        STD(k) = std(diff_dia_rel(:,k)/Uinf)./ median(diff_dia_rel(:,k)/Uinf);
        rangeA(k) = max(diff_dia_aoa(:,k))- min(diff_dia_aoa(:,k)); 
        STDA(k) = std(diff_dia_aoa(:,k))./ median(diff_dia_aoa(:,k));
    end
    if i == 1 || i == 3
%                 h(l) = scatter(normalize_rel_mag, range);
                h(l) = scatter(aoa, range);
                legendinfo{l} = ['Averaged \lambda = ', num2str(lambda)];
                l = l+1;
                hold on
    else
%                 h(l) = scatter(normalize_rel_mag, range);
                h(l) = scatter(aoa, range);
                legendinfo{l} = ['Phased \lambda = ', num2str(lambda)];
                l = l+1;
                hold on
    end

end
legend(h,legendinfo,'FontSize',8, 'location', 'best')
% xlim([0 360])
% set(gca,'xtick', [0:60:360])
grid on
xlabel('AOA')
% ylabel('Range U_r_e_l/U_I_n_f')
ylabel('Range of U_r_e_l')
set(gcf,'position',[540,450,800,500])
title('Range of U_r_e_l with Circle Size v.s. AOA')
clear 'legendInfo';
cd 'C:\Users\Michael\MATLAB Drive\AOA Estimation Research'
