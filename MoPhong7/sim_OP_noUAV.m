function [OP_D1, OP_D2] = sim_OP_noUAV(rho, Ntrials, lambda_SD1, lambda_SD2, a1, a2, gamma_1th_noUAV, gamma_2th_noUAV)
    
    count_outage_D1 = 0;
    count_outage_D2 = 0;

    for itrial = 1:Ntrials
        % Sinh kênh fading Rayleigh trực tiếp từ Vệ tinh (S) tới D1 và D2 (N = 1)
        h_SD1 = rayleigh_channel(lambda_SD1, 1);
        h_SD2 = rayleigh_channel(lambda_SD2, 1);

        % SINR tại D1 (giải mã x1, coi x2 là nhiễu)
        gamma_x1_SD1 = gamma_1(rho, a1, a2, h_SD1);

        % SINR/SNR tại D2 (giải mã tuần tự SIC)
        gamma_x1_SD2 = gamma_1(rho, a1, a2, h_SD2);  % Bước 1: D2 giải mã x1
        gamma_x2_SD2 = gamma_2(rho, a2, h_SD2);      % Bước 2: D2 giải mã x2 sau khi khử x1

        % Kiểm tra Outage D1
        if (gamma_x1_SD1 < gamma_1th_noUAV)
            count_outage_D1 = count_outage_D1 + 1;
        end

        % Kiểm tra Outage D2 (dừng nếu bước giải x1 hoặc bước giải x2 bị lỗi)
        if (gamma_x1_SD2 < gamma_1th_noUAV) || (gamma_x2_SD2 < gamma_2th_noUAV)
            count_outage_D2 = count_outage_D2 + 1;
        end
    end

    % Xác suất dừng mô phỏng
    OP_D1 = count_outage_D1 / Ntrials;
    OP_D2 = count_outage_D2 / Ntrials;
end