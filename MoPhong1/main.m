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

%% === THAM SỐ HỆ THỐNG ===
% 1. Ngưỡng SNR
gamma_1th = 2.^(2*R1) - 1;
gamma_2th = 2.^(2*R2) - 1;

% 2. Tham số fading Rayleigh
[lambda_SU, lambda_UD1, lambda_UD2] = calculate_channel_params(0.5);

%% === THAM SỐ KHẢO SÁT ===
N = [1 2 4 8];
SNR_dB = 0:2:40;
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

%% === VẼ ĐỒ THỊ CHUẨN HÓA (HÌNH 4.2) ===
% Kích thước chuẩn: rộng 14cm x cao 10.5cm
fig = figure('Units', 'centimeters', 'Position', [5, 5, 14, 10.5], 'Color', 'w');
ax = gca;
hold(ax, 'on');

markers = {'v', 'o', 's', 'd'};  

for iN = 1:length(N)
    % 1. Đường lý thuyết D1 (nét liền đen)
    semilogy(SNR_dB, OP_D1_cf(iN,:), 'k-', 'LineWidth', 1.2, 'HandleVisibility', 'off');

    % 2. Marker D1 (ký hiệu đen tô đặc)
    semilogy(SNR_dB, OP_D1_sim(iN,:), markers{iN}, 'Color', 'k', ...
             'MarkerFaceColor', 'k', 'MarkerSize', 5.5, 'LineStyle', 'none', ...
             'HandleVisibility', 'off');

    % 3. Đường lý thuyết D2 (nét đứt đen)
    semilogy(SNR_dB, OP_D2_cf(iN,:), 'k--', 'LineWidth', 1.2, 'HandleVisibility', 'off');

    % 4. Marker D2 (ký hiệu viền đen rỗng ruột)
    semilogy(SNR_dB, OP_D2_sim(iN,:), markers{iN}, 'Color', 'k', ...
             'MarkerFaceColor', 'w', 'MarkerSize', 5.5, 'LineWidth', 1.0, ...
             'LineStyle', 'none', 'HandleVisibility', 'off');
end

% Dummy objects phục vụ tạo Legend rõ ràng
h_th1 = plot(nan, nan, 'k-',  'LineWidth', 1.2);
h_th2 = plot(nan, nan, 'k--', 'LineWidth', 1.2);

h_N = gobjects(1, length(N));
for iN = 1:length(N)
    h_N(iN) = plot(nan, nan, markers{iN}, 'Color', 'k', 'MarkerFaceColor', 'k', ...
                   'MarkerSize', 5.5, 'LineStyle', 'none');
end

% Cấu hình trục và lưới
xlim([5 40]);
ylim([1e-3 1e0]);
xlabel('SNR (dB)', 'FontSize', 11, 'FontName', 'Times New Roman');
ylabel('Outage Probability', 'FontSize', 11, 'FontName', 'Times New Roman');

grid on; box on;
set(ax, 'GridLineStyle', ':', 'GridAlpha', 0.6, ...
        'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
        'MinorGridLineStyle', ':', 'MinorGridAlpha', 0.3, ...
        'YScale', 'log');

% Khung chú thích (Legend)
legend_handles = [h_th1, h_th2, h_N];
legend_labels  = [{'Theory D_1', 'Theory D_2'}, ...
                  arrayfun(@(n) sprintf('N = %d', n), N, 'UniformOutput', false)];

legend(legend_handles, legend_labels, 'Location', 'southwest', ...
       'NumColumns', 2, 'FontSize', 9.5, 'FontName', 'Times New Roman');