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

[lambda_SU, lambda_UD1, lambda_UD2] = calculate_channel_params(0.5);

%% === THAM SỐ KHẢO SÁT ===
SNR_dB = 10:2:30;
SNR_line = 10.^(SNR_dB/10);

% Ngưỡng SNR cho NOMA
gamma_1th_NOMA = 2.^(2*R1) - 1;
gamma_2th_NOMA = 2.^(2*R2) - 1;

% Ngưỡng SNR cho OMA
gamma_1th_OMA = 2.^(4*R1) - 1;
gamma_2th_OMA = 2.^(4*R2) - 1;

%% === MẢNG CHỨA KẾT QUẢ ===
% Mô phỏng NOMA
OP_D1_sim_NOMA = zeros(size(SNR_line));
OP_D2_sim_NOMA = zeros(size(SNR_line));
% Lý thuyết NOMA
OP_D1_Theo_NOMA = zeros(size(SNR_line));
OP_D2_Theo_NOMA = zeros(size(SNR_line));

% Mô phỏng OMA
OP_D1_sim_OMA = zeros(size(SNR_line));
OP_D2_sim_OMA = zeros(size(SNR_line));
% Lý thuyết OMA
OP_D1_Theo_OMA = zeros(size(SNR_line));
OP_D2_Theo_OMA = zeros(size(SNR_line));

%% === MAIN SIMULATION ===
for iSNR = 1:length(SNR_line)
    rho = SNR_line(iSNR);
    
    % 1. Simulation NOMA
    [OP_D1_sim_NOMA(iSNR), OP_D2_sim_NOMA(iSNR)] = ...
        sim_OP_NOMA(rho, N, Ntrials, lambda_SU, lambda_UD1, lambda_UD2, a1, a2, gamma_1th_NOMA, gamma_2th_NOMA);
    
    % 2. Simulation OMA
    [OP_D1_sim_OMA(iSNR), OP_D2_sim_OMA(iSNR)] = ...
        sim_OP_OMA(rho, N, Ntrials, lambda_SU, lambda_UD1, lambda_UD2, gamma_1th_OMA, gamma_2th_OMA);

    % 3. Closed-form NOMA
    OP_D1_Theo_NOMA(iSNR) = CF_OP_D1(rho, N, lambda_SU, lambda_UD1, a1, a2, gamma_1th_NOMA);
    OP_D2_Theo_NOMA(iSNR) = CF_OP_D2(rho, N, lambda_SU, lambda_UD2, a1, a2, gamma_1th_NOMA, gamma_2th_NOMA);

    % 4. Closed-form OMA
    OP_D1_Theo_OMA(iSNR)  = CF_OP_D1_OMA(rho, N, lambda_SU, lambda_UD1, gamma_1th_OMA);
    OP_D2_Theo_OMA(iSNR)  = CF_OP_D2_OMA(rho, N, lambda_SU, lambda_UD2, gamma_2th_OMA);
end

%% === VẼ ĐỒ THỊ CHUẨN HÓA (HÌNH 4.7) ===
fig = figure('Units', 'centimeters', 'Position', [5, 5, 14, 10.5], 'Color', 'w');
ax = gca;
hold(ax, 'on');

% --- NOMA: ĐƯỜNG NÉT LIỀN '-' & MARKER TÔ ĐẶC ---
p1 = semilogy(SNR_dB, OP_D1_sim_NOMA, 'ko', 'LineWidth', 1.0, 'MarkerSize', 5.5, ...
              'MarkerFaceColor', 'r');
semilogy(SNR_dB, OP_D1_Theo_NOMA, 'r-', 'LineWidth', 1.2);

p2 = semilogy(SNR_dB, OP_D2_sim_NOMA, 'ks', 'LineWidth', 1.0, 'MarkerSize', 5.5, ...
              'MarkerFaceColor', 'b');
semilogy(SNR_dB, OP_D2_Theo_NOMA, 'b-', 'LineWidth', 1.2);

% --- OMA: ĐƯỜNG NÉT ĐỨT '--' & MARKER RỖNG RUỘT ---
p3 = semilogy(SNR_dB, OP_D1_sim_OMA, 'k^', 'LineWidth', 1.2, 'MarkerSize', 7.5, ...
              'MarkerFaceColor', 'none');
semilogy(SNR_dB, OP_D1_Theo_OMA, 'r--', 'LineWidth', 1.2);

p4 = semilogy(SNR_dB, OP_D2_sim_OMA, 'kd', 'LineWidth', 1.2, 'MarkerSize', 7.5, ...
              'MarkerFaceColor', 'none');
semilogy(SNR_dB, OP_D2_Theo_OMA, 'b--', 'LineWidth', 1.2);

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

% 2. Tạo đường giả (dummy lines) cho phần chú thích quy ước đường nét
h_solid = plot(nan, nan, 'k-',  'LineWidth', 1.2); 
h_dash  = plot(nan, nan, 'k--', 'LineWidth', 1.2); 

% 3. Khung chú thích (Legend)
legend([p1, p2, p3, p4, h_solid, h_dash], ...
       {'D_1 (NOMA, Sim)', ...
        'D_2 (NOMA, Sim)', ...
        'D_1 (OMA, Sim)', ...
        'D_2 (OMA, Sim)', ...
        'NOMA (Theory)', ...
        'OMA (Theory)'}, ...
       'Location', 'southwest', 'FontSize', 9.5, 'FontName', 'Times New Roman');