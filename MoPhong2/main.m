clear;
clc;
close all;

%% === CẤU HÌNH ĐỒ HỌA MẶC ĐỊNH ===
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 11);
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultTextFontSize', 11);
set(groot, 'defaultLegendFontName', 'Times New Roman');
set(groot, 'defaultLegendFontSize', 9.0);

%% === THAM SỐ CỐ ĐỊNH ===
a1 = 0.75;
a2 = 0.25;

R1 = 0.8;
R2 = 1.5;

Ntrials = 1e6;

%% === THAM SỐ HỆ THỐNG ===
% 1. Ngưỡng SNR
gamma_1th = 2.^(2*R1) - 1;
gamma_2th = 2.^(2*R2) - 1;

% 2. Tham số fading Rayleigh
[lambda_SU, lambda_UD1, lambda_UD2] = calculate_channel_params(0.5);

%% === THAM SỐ KHẢO SÁT ===
N = [1 2 4 6 8 10];
SNR_dB = 0:2:30;
SNR_line = 10.^(SNR_dB/10);

%% === MẢNG CHỨA KẾT QUẢ ===
OP_D1_sim = zeros(length(N), length(SNR_line));
OP_D2_sim = zeros(length(N), length(SNR_line));
OP_D1_cf  = zeros(length(N), length(SNR_line));
OP_D2_cf  = zeros(length(N), length(SNR_line));

%% === MAIN SIMULATION ===
for iN = 1:length(N)
    Nrelay = N(iN);

    for iSNR = 1:length(SNR_dB)
        rho = SNR_line(iSNR);
        
        % Simulation
        [OP_D1_sim(iN, iSNR), OP_D2_sim(iN, iSNR)] = ...
            sim_OP(rho, Nrelay, Ntrials, lambda_SU, lambda_UD1, lambda_UD2, a1, a2, gamma_1th, gamma_2th);
        
        % Closed-form (Lý thuyết)
        OP_D1_cf(iN, iSNR) = CF_OP_D1(rho, Nrelay, lambda_SU, lambda_UD1, a1, a2, gamma_1th);
        OP_D2_cf(iN, iSNR) = CF_OP_D2(rho, Nrelay, lambda_SU, lambda_UD2, a1, a2, gamma_1th, gamma_2th);
    end
end

markers = {'v', 'o', 's', 'd', 'p', '^'};
legendLabels = ['Theory', arrayfun(@(n) sprintf('Simulation (N = %d)', n), N, 'UniformOutput', false)];


%% === HÌNH 4.3a: NGƯỜI DÙNG D1 (fig_2.1.pdf) ===
fig1 = figure('Units', 'centimeters', 'Position', [3, 5, 14, 10.5], 'Color', 'w');
ax1 = gca;
hold(ax1, 'on');

for iN = 1:length(N)
    if iN == 1
        semilogy(SNR_dB, OP_D1_cf(iN,:), 'k-', 'LineWidth', 1.2);
    else
        semilogy(SNR_dB, OP_D1_cf(iN,:), 'k-', 'LineWidth', 1.2, 'HandleVisibility', 'off');
    end
    semilogy(SNR_dB, OP_D1_sim(iN,:), markers{iN}, 'Color', 'k', ...
             'MarkerFaceColor', 'k', 'MarkerSize', 5.5, 'LineStyle', 'none');
end

xlim([14 24]);
ylim([1e-2 1.2]);
xticks(14:2:24);
xlabel('SNR (dB)', 'FontSize', 11, 'FontName', 'Times New Roman');
ylabel('Outage Probability', 'FontSize', 11, 'FontName', 'Times New Roman');

grid on; box on;
set(ax1, 'GridLineStyle', ':', 'GridAlpha', 0.6, ...
         'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'MinorGridLineStyle', ':', 'MinorGridAlpha', 0.3, ...
         'YScale', 'log');

legend(legendLabels, 'Location', 'southwest', 'FontSize', 9.0, 'FontName', 'Times New Roman');


%% === HÌNH 4.3b: NGƯỜI DÙNG D2 (fig_2.2.pdf) ===
fig2 = figure('Units', 'centimeters', 'Position', [18, 5, 14, 10.5], 'Color', 'w');
ax2 = gca;
hold(ax2, 'on');

for iN = 1:length(N)
    if iN == 1
        semilogy(SNR_dB, OP_D2_cf(iN,:), 'k-', 'LineWidth', 1.2);
    else
        semilogy(SNR_dB, OP_D2_cf(iN,:), 'k-', 'LineWidth', 1.2, 'HandleVisibility', 'off');
    end
    semilogy(SNR_dB, OP_D2_sim(iN,:), markers{iN}, 'Color', 'k', ...
             'MarkerFaceColor', 'k', 'MarkerSize', 5.5, 'LineStyle', 'none');
end

xlim([18 30]);
ylim([5e-3 1.2]);
xticks(18:2:30);
xlabel('SNR (dB)', 'FontSize', 11, 'FontName', 'Times New Roman');
ylabel('Outage Probability', 'FontSize', 11, 'FontName', 'Times New Roman');

grid on; box on;
set(ax2, 'GridLineStyle', ':', 'GridAlpha', 0.6, ...
         'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
         'MinorGridLineStyle', ':', 'MinorGridAlpha', 0.3, ...
         'YScale', 'log');

legend(legendLabels, 'Location', 'southwest', 'FontSize', 9.0, 'FontName', 'Times New Roman');

