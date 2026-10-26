clear;
clc;
close all;

%% === CẤU HÌNH ĐỒ HỌA MẶC ĐỊNH ===
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 11);
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultTextFontSize', 11);
set(groot, 'defaultLegendFontName', 'Times New Roman');
set(groot, 'defaultLegendFontSize', 9.5);

%% === THAM SỐ CỐ ĐỊNH ===
a1 = 0.75;
a2 = 0.25;
R1 = 0.8;
R2 = 1.5;

Ntrials = 1e6;
N = 4;

[lambda_SU, lambda_UD1, lambda_UD2, lambda_SD1, lambda_SD2] = calculate_channel_params(0.5);

%% === THAM SỐ KHẢO SÁT ===
SNR_dB = 10:2:30;
SNR_line = 10.^(SNR_dB/10);

% Ngưỡng SNR có UAV (truyền 2 khe thời gian)
gamma_1th_UAV = 2.^(2*R1) - 1;
gamma_2th_UAV = 2.^(2*R2) - 1;

% Ngưỡng SNR truyền thẳng trực tiếp (truyền 1 khe thời gian)
gamma_1th_Dir = 2.^(R1) - 1;
gamma_2th_Dir = 2.^(R2) - 1;

%% === MẢNG CHỨA KẾT QUẢ ===
% Có UAV
OP_D1_sim_UAV  = zeros(size(SNR_line));
OP_D2_sim_UAV  = zeros(size(SNR_line));
OP_D1_Theo_UAV = zeros(size(SNR_line));
OP_D2_Theo_UAV = zeros(size(SNR_line));

% Không có UAV (Truyền thẳng)
OP_D1_sim_noUAV  = zeros(size(SNR_line));
OP_D2_sim_noUAV  = zeros(size(SNR_line));
OP_D1_Theo_noUAV = zeros(size(SNR_line));
OP_D2_Theo_noUAV = zeros(size(SNR_line));

%% === MAIN SIMULATION ===
for iSNR = 1:length(SNR_line)
    rho = SNR_line(iSNR);
    
    % 1. Simulation Có UAV
    [OP_D1_sim_UAV(iSNR), OP_D2_sim_UAV(iSNR)] = ...
        sim_OP_NOMA(rho, N, Ntrials, lambda_SU, lambda_UD1, lambda_UD2, a1, a2, gamma_1th_UAV, gamma_2th_UAV);
    
    % 2. Simulation Không có UAV (Truyền thẳng)
    [OP_D1_sim_noUAV(iSNR), OP_D2_sim_noUAV(iSNR)] = ...
        sim_OP_noUAV(rho, Ntrials, lambda_SD1, lambda_SD2, a1, a2, gamma_1th_Dir, gamma_2th_Dir);

    % 3. Closed-form Có UAV
    OP_D1_Theo_UAV(iSNR) = CF_OP_D1(rho, N, lambda_SU, lambda_UD1, a1, a2, gamma_1th_UAV);
    OP_D2_Theo_UAV(iSNR) = CF_OP_D2(rho, N, lambda_SU, lambda_UD2, a1, a2, gamma_1th_UAV, gamma_2th_UAV);

    % 4. Closed-form Không có UAV
    OP_D1_Theo_noUAV(iSNR) = CF_OP_D1_noUAV(rho, lambda_SD1, a1, a2, gamma_1th_Dir);
    OP_D2_Theo_noUAV(iSNR) = CF_OP_D2_noUAV(rho, lambda_SD2, a1, a2, gamma_1th_Dir, gamma_2th_Dir);
end

%% === VẼ ĐỒ THỊ CHUẨN HÓA (HÌNH 4.8) ===
fig = figure('Units', 'centimeters', 'Position', [5, 5, 14, 10.5], 'Color', 'w');
ax = gca;
hold(ax, 'on');

% --- CÓ UAV: ĐƯỜNG NÉT LIỀN '-' & MARKER TÔ ĐẶC ---
p1 = semilogy(SNR_dB, OP_D1_sim_UAV, 'ko', 'LineWidth', 1.0, 'MarkerSize', 5.5, ...
              'MarkerFaceColor', 'r');
semilogy(SNR_dB, OP_D1_Theo_UAV, 'r-', 'LineWidth', 1.2);

p2 = semilogy(SNR_dB, OP_D2_sim_UAV, 'ks', 'LineWidth', 1.0, 'MarkerSize', 5.5, ...
              'MarkerFaceColor', 'b');
semilogy(SNR_dB, OP_D2_Theo_UAV, 'b-', 'LineWidth', 1.2);

% --- KHÔNG CÓ UAV: ĐƯỜNG NÉT ĐỨT '--' & MARKER RỖNG RUỘT ---
p3 = semilogy(SNR_dB, OP_D1_sim_noUAV, 'k^', 'LineWidth', 1.2, 'MarkerSize', 7.5, ...
              'MarkerFaceColor', 'none');
semilogy(SNR_dB, OP_D1_Theo_noUAV, 'r--', 'LineWidth', 1.2);

p4 = semilogy(SNR_dB, OP_D2_sim_noUAV, 'kd', 'LineWidth', 1.2, 'MarkerSize', 7.5, ...
              'MarkerFaceColor', 'none');
semilogy(SNR_dB, OP_D2_Theo_noUAV, 'b--', 'LineWidth', 1.2);

% Định dạng trục và lưới
xlim([10 30]);
ylim([5e-3 1.2]);
xlabel('SNR (dB)', 'FontSize', 11, 'FontName', 'Times New Roman');
ylabel('Outage Probability', 'FontSize', 11, 'FontName', 'Times New Roman');

grid on; box on;
set(ax, 'GridLineStyle', ':', 'GridAlpha', 0.6, ...
        'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
        'MinorGridLineStyle', ':', 'MinorGridAlpha', 0.3, ...
        'YScale', 'log');

% Đường giả tạo Legend cho quy ước nét vẽ
h_solid = plot(nan, nan, 'k-',  'LineWidth', 1.2); 
h_dash  = plot(nan, nan, 'k--', 'LineWidth', 1.2); 

% Khung chú thích (Legend)
legend([p1, p2, p3, p4, h_solid, h_dash], ...
       {'D_1 (With UAV, Sim)', ...
        'D_2 (With UAV, Sim)', ...
        'D_1 (Without UAV, Sim)', ...
        'D_2 (Without UAV, Sim)', ...
        'With UAV (Theory)', ...
        'Without UAV (Theory)'}, ...
       'Location', 'southwest', 'FontSize', 9.5, 'FontName', 'Times New Roman');