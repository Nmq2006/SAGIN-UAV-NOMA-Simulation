clear;
clc;
close all;

%% === CẤU HÌNH ĐỒ HỌA MẶC ĐỊNH ===
set(groot, 'defaultAxesFontName', 'Times New Roman');
set(groot, 'defaultAxesFontSize', 11);
set(groot, 'defaultTextFontName', 'Times New Roman');
set(groot, 'defaultTextFontSize', 11);

%% === THAM SỐ CỐ ĐỊNH ===
R1 = 0.8;
R2 = 1.5;

Ntrials = 1e6;

SNR_dB = 25;
SNR_line = 10.^(SNR_dB/10);

%% === THAM SỐ HỆ THỐNG ===
% 1. Ngưỡng SNR
gamma_1th = 2.^(2*R1) - 1;
gamma_2th = 2.^(2*R2) - 1;

% 2. Tham số fading Rayleigh
[lambda_SU, lambda_UD1, lambda_UD2] = calculate_channel_params(0.5);

%% === THAM SỐ KHẢO SÁT ===
N_list = [1 2 4];

a_ratio = 0.01:0.005:10;
alpha2 = 1 ./ (1 + a_ratio);
alpha1 = a_ratio .* alpha2;

%% === MẢNG CHỨA KẾT QUẢ ===
OP_D1 = zeros(length(N_list), length(a_ratio));
OP_D2 = zeros(length(N_list), length(a_ratio));

%% === MAIN SIMULATION ===
for iN = 1:length(N_list)
    N = N_list(iN);

    for k = 1:length(a_ratio)
        a1 = alpha1(k);
        a2 = alpha2(k);
        
        if gamma_1th < a1/a2
            OP_D1(iN, k) = CF_OP_D1(SNR_line, N, lambda_SU, lambda_UD1, a1, a2, gamma_1th);
            OP_D2(iN, k) = CF_OP_D2(SNR_line, N, lambda_SU, lambda_UD2, a1, a2, gamma_1th, gamma_2th);
        else
            OP_D1(iN, k) = 1;
            OP_D2(iN, k) = 1;
        end
    end
end

%% === VẼ ĐỒ THỊ CHUẨN HÓA (HÌNH 4.5) ===
fig = figure('Units', 'centimeters', 'Position', [5, 5, 14, 10.5], 'Color', 'w');
ax = gca;
hold(ax, 'on');

lineStyles = {':', '--', '-'};

for iN = 1:length(N_list)
    % Đường D1
    semilogy(a_ratio, OP_D1(iN, :), lineStyles{iN}, ...
        'Color', 'k', 'LineWidth', 1.2, 'HandleVisibility', 'off');
    
    % Đường D2
    semilogy(a_ratio, OP_D2(iN, :), lineStyles{iN}, ...
        'Color', 'k', 'LineWidth', 1.2, 'HandleVisibility', 'off');
end

% Định dạng nhãn và giới hạn trục
xlim([0 7]);
ylim([5e-3 1.0]);
xlabel('$\alpha_1 / \alpha_2$', 'Interpreter', 'latex', 'FontSize', 12); 
ylabel('Outage Probability', 'FontSize', 11, 'FontName', 'Times New Roman');

grid on; box on;
set(ax, 'GridLineStyle', ':', 'GridAlpha', 0.6, ...
        'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
        'MinorGridLineStyle', ':', 'MinorGridAlpha', 0.3, ...
        'YScale', 'log');

%% === CHÚ THÍCH TRỰC TIẾP TRÊN TỪNG ĐƯỜNG CONG ===

% --- Nhóm đường D2 ---
text(4.0, 0.60, '$D_2\ (N = 1)$', 'Interpreter', 'latex', ...
    'FontSize', 10, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'center');

text(4.0, 0.38, '$D_2\ (N = 2)$', 'Interpreter', 'latex', ...
    'FontSize', 10, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'center');

text(5.0, 0.20, '$D_2\ (N = 4)$', 'Interpreter', 'latex', ...
    'FontSize', 10, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'center');

% --- Nhóm đường D1 ---
text(6.0, 0.065, '$D_1\ (N = 1)$', 'Interpreter', 'latex', ...
    'FontSize', 9.5, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'center');

text(6.0, 0.020, '$D_1\ (N = 2)$', 'Interpreter', 'latex', ...
    'FontSize', 9.5, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'center');

text(6.0, 0.008, '$D_1\ (N = 4)$', 'Interpreter', 'latex', ...
    'FontSize', 9.5, 'FontName', 'Times New Roman', 'HorizontalAlignment', 'center');