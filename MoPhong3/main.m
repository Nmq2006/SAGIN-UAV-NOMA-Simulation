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

%% === THAM SỐ HỆ THỐNG ===
% 1. Ngưỡng SNR
gamma_1th = 2.^(2*R1) - 1;
gamma_2th = 2.^(2*R2) - 1;

% 2. Tham số fading Rayleigh
[lambda_SU, lambda_UD1, lambda_UD2] = calculate_channel_params(0.5);

%% === THAM SỐ KHẢO SÁT ===
SNR_dB = 10:2:40;
SNR_line = 10.^(SNR_dB/10);

%% === MẢNG CHỨA KẾT QUẢ ===
% Mô phỏng
OP_D1_sim = zeros(size(SNR_line));
OP_D2_sim = zeros(size(SNR_line));
% Lý thuyết chính xác
OP_D1_Theo = zeros(size(SNR_line));
OP_D2_Theo = zeros(size(SNR_line));
% Phân tích tiệm cận
OP_D1_asym = zeros(size(SNR_line));
OP_D2_asym = zeros(size(SNR_line));

%% === MAIN SIMULATION ===
for iSNR = 1:length(SNR_line)
    rho = SNR_line(iSNR);
    
    % Simulation
    [OP_D1_sim(iSNR), OP_D2_sim(iSNR)] = ...
        sim_OP(rho, N, Ntrials, lambda_SU, lambda_UD1, lambda_UD2, a1, a2, gamma_1th, gamma_2th);
      
    % Closed-form (Lý thuyết)
    OP_D1_Theo(iSNR) = CF_OP_D1(rho, N, lambda_SU, lambda_UD1, a1, a2, gamma_1th);
    OP_D2_Theo(iSNR) = CF_OP_D2(rho, N, lambda_SU, lambda_UD2, a1, a2, gamma_1th, gamma_2th);
    
    % Asymptotic (Tiệm cận)
    OP_D1_asym(iSNR) = ASYM_OP_D1(rho, lambda_UD1, a1, a2, gamma_1th);
    OP_D2_asym(iSNR) = ASYM_OP_D2(rho, lambda_UD2, a1, a2, gamma_1th, gamma_2th);
end

%% === VẼ ĐỒ THỊ CHUẨN HÓA (HÌNH 4.4) ===
fig = figure('Units', 'centimeters', 'Position', [5, 5, 14, 10.5], 'Color', 'w');
ax = gca;
hold(ax, 'on');

% === Vẽ các đường của D1 ===
semilogy(SNR_dB, OP_D1_Theo, 'k-',  'LineWidth', 1.2, 'DisplayName', 'Theory');
semilogy(SNR_dB, OP_D1_asym,  'k--', 'LineWidth', 1.2, 'DisplayName', 'Asymptotic');
semilogy(SNR_dB, OP_D1_sim,   'ko',  'MarkerSize', 5.5, 'MarkerFaceColor', 'k', 'DisplayName', 'Simulation');

% === Vẽ các đường của D2 ===
semilogy(SNR_dB, OP_D2_Theo, 'k-',  'LineWidth', 1.2, 'HandleVisibility', 'off');
semilogy(SNR_dB, OP_D2_asym,  'k--', 'LineWidth', 1.2, 'HandleVisibility', 'off');
semilogy(SNR_dB, OP_D2_sim,   'ko',  'MarkerSize', 5.5, 'MarkerFaceColor', 'k', 'HandleVisibility', 'off');

% === Định dạng nhãn và giới hạn trục ===
xlim([16 40]); 
ylim([4e-4 0.12]);
xlabel('SNR (dB)', 'FontSize', 11, 'FontName', 'Times New Roman');
ylabel('Outage Probability', 'FontSize', 11, 'FontName', 'Times New Roman');

grid on; box on;
set(ax, 'GridLineStyle', ':', 'GridAlpha', 0.6, ...
        'XMinorGrid', 'on', 'YMinorGrid', 'on', ...
        'MinorGridLineStyle', ':', 'MinorGridAlpha', 0.3, ...
        'YScale', 'log');

% Hộp chú thích (Legend)
legend('Location', 'northeast', 'FontSize', 9.5, 'FontName', 'Times New Roman');

%% === VẼ 2 ELIP KHOANH VÙNG ĐIỂM HỘI TỤ (THEORY & ASYMPTOTIC) ===
theta_ellipse = linspace(0, 2*pi, 300);

% --- 1. Nhóm D1: Khớp tại SNR ≈ 26 dB ---
x0_D1 = 26.0;               
y0_D1 = 0.01178;             
log_y0_D1 = log10(y0_D1);   
a_D1 = 0.55;                
b_D1_log = 0.16;            
phi_D1 = 0;                 
x_el_D1 = x0_D1 + a_D1*cos(theta_ellipse)*cos(phi_D1) - b_D1_log*sin(theta_ellipse)*sin(phi_D1);
log_y_el_D1 = log_y0_D1 + a_D1*cos(theta_ellipse)*sin(phi_D1) + b_D1_log*sin(theta_ellipse)*cos(phi_D1);
y_el_D1 = 10.^(log_y_el_D1);

plot(x_el_D1, y_el_D1, 'k-', 'LineWidth', 1.0, 'HandleVisibility', 'off');
text(x0_D1 + 0.75, y0_D1, '$D_1$', 'Interpreter', 'latex', ...
     'FontSize', 11, 'FontName', 'Times New Roman', ...
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');

% --- 2. Nhóm D2: Khớp tại SNR ≈ 32 dB ---
x0_D2 = 32.0;               
y0_D2 = 0.00486;             
log_y0_D2 = log10(y0_D2);   
a_D2 = 0.55;                
b_D2_log = 0.16;            
phi_D2 = 0;                 
x_el_D2 = x0_D2 + a_D2*cos(theta_ellipse)*cos(phi_D2) - b_D2_log*sin(theta_ellipse)*sin(phi_D2);
log_y_el_D2 = log_y0_D2 + a_D2*cos(theta_ellipse)*sin(phi_D2) + b_D2_log*sin(theta_ellipse)*cos(phi_D2);
y_el_D2 = 10.^(log_y_el_D2);

plot(x_el_D2, y_el_D2, 'k-', 'LineWidth', 1.0, 'HandleVisibility', 'off');
text(x0_D2 + 0.75, y0_D2, '$D_2$', 'Interpreter', 'latex', ...
     'FontSize', 11, 'FontName', 'Times New Roman', ...
     'HorizontalAlignment', 'left', 'VerticalAlignment', 'middle');
