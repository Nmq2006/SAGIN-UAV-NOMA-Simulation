clear;
clc;
close all;

%% === CẤU HÌNH ĐỒ HỌA MẶC ĐỊNH ===
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 11);
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultTextFontSize', 11);
set(groot, 'defaultLegendFontName', 'Times New Roman');
set(groot, 'defaultLegendFontSize', 8.5);

%% === THAM SỐ CỐ ĐỊNH ===
a1 = 0.75;
a2 = 0.25;

R1 = 0.8;
R2 = 1.5;

%% === TỔ HỢP KHẢO SÁT ===
N_list = [4 6];
SNR_list_dB = [22.5 25];
SNR_line = 10.^(SNR_list_dB ./ 10);

%% === THAM SỐ HỆ THỐNG ===
% 1. Ngưỡng SNR
gamma_1th = 2.^(2*R1) - 1;
gamma_2th = 2.^(2*R2) - 1;

% 2. Khoảng cách quỹ đạo UAV (d)
d = 0:0.05:1;

%% === MẢNG CHỨA KẾT QUẢ 3 CHIỀU: (N, SNR, d) ===
OP_D1 = zeros(length(N_list), length(SNR_list_dB), length(d));
OP_D2 = zeros(length(N_list), length(SNR_list_dB), length(d));

%% === MAIN SIMULATION ===
for iN = 1:length(N_list)
    N = N_list(iN);
    for iSNR = 1:length(SNR_list_dB)
        rho = SNR_line(iSNR);
        
        for k = 1:length(d)
            if gamma_1th < a1/a2
                % Tính tham số kênh truyền theo vị trí d
                [lambda_SU, lambda_UD1, lambda_UD2] = calculate_channel_params(d(k));
                
                OP_D1(iN, iSNR, k) = CF_OP_D1(rho, N, lambda_SU, lambda_UD1, a1, a2, gamma_1th);
                OP_D2(iN, iSNR, k) = CF_OP_D2(rho, N, lambda_SU, lambda_UD2, a1, a2, gamma_1th, gamma_2th);
            else
                OP_D1(iN, iSNR, k) = 1;
                OP_D2(iN, iSNR, k) = 1;
            end
        end
    end
end

%% === VẼ ĐỒ THỊ CHUẨN HÓA (HÌNH 4.6) ===
fig = figure('Units', 'centimeters', 'Position', [5, 5, 14, 10.5], 'Color', 'w');
ax = gca;
hold(ax, 'on');

% 4 kiểu đường/marker cho 4 tổ hợp (N, SNR)
lineStyles = {'o-', 's-', '*-', '^-'};   

color_blue   = [0, 0.4470, 0.7410];       % D2 (User 2)
color_orange = [0.8500, 0.3250, 0.0980]; % D1 (User 1)

idx = 1;
for iN = 1:length(N_list)
    for iSNR = 1:length(SNR_list_dB)
        % Đường của D1 (Màu cam)
        plot(d, squeeze(OP_D1(iN, iSNR, :)), lineStyles{idx}, ...
            'Color', color_orange, 'LineWidth', 1.2, 'MarkerSize', 5.5, ...
            'HandleVisibility', 'off');

        % Đường của D2 (Màu xanh)
        plot(d, squeeze(OP_D2(iN, iSNR, :)), lineStyles{idx}, ...
            'Color', color_blue, 'LineWidth', 1.2, 'MarkerSize', 5.5, ...
            'HandleVisibility', 'off');

        idx = idx + 1;
    end
end

% Cấu hình trục tọa độ
xlim([0 1]);
xticks(0:0.1:1);
ylim([2e-3 0.5]);
xlabel('$d$', 'Interpreter', 'latex', 'FontSize', 11);
ylabel('Outage Probability', 'FontSize', 11, 'FontName', 'Times New Roman');

grid on; box on;
set(ax, 'GridLineStyle', ':', 'GridAlpha', 0.6, ...
        'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
        'MinorGridLineStyle', ':', 'MinorGridAlpha', 0.3, ...
        'YScale', 'log');

%% === TẠO CÁC MẪU CHÚ THÍCH CHO LEGEND ===
% 1. Chú thích 2 người dùng theo màu sắc:
h_D1 = plot(NaN, NaN, '-',  'Color', color_orange, 'LineWidth', 1.5, 'DisplayName', '$D_1$ (User 1)');
h_D2 = plot(NaN, NaN, '-',  'Color', color_blue,   'LineWidth', 1.5, 'DisplayName', '$D_2$ (User 2)');

% 2. Chú thích 4 cấu hình bằng ĐƯỜNG MÀU ĐEN:
h_c1 = plot(NaN, NaN, 'o-',  'Color', 'k', 'LineWidth', 1.2, 'MarkerSize', 5.5, 'DisplayName', '$N = 4, \,\mathrm{SNR} = 22.5\,\mathrm{dB}$');
h_c2 = plot(NaN, NaN, 's-',  'Color', 'k', 'LineWidth', 1.2, 'MarkerSize', 5.5, 'DisplayName', '$N = 4, \,\mathrm{SNR} = 25\,\mathrm{dB}$');
h_c3 = plot(NaN, NaN, '*-', 'Color', 'k', 'LineWidth', 1.2, 'MarkerSize', 5.5, 'DisplayName', '$N = 6, \,\mathrm{SNR} = 22.5\,\mathrm{dB}$');
h_c4 = plot(NaN, NaN, '^-', 'Color', 'k', 'LineWidth', 1.2, 'MarkerSize', 5.5, 'DisplayName', '$N = 6, \,\mathrm{SNR} = 25\,\mathrm{dB}$');

% Hiển thị khung chú thích gọn gàng
legend([h_D1, h_D2, h_c1, h_c2, h_c3, h_c4], ...
    'Interpreter', 'latex', ...
    'FontSize', 8.5, ...
    'Box', 'on', ...
    'EdgeColor', [0.7 0.7 0.7], ...
    'Location', 'southwest');