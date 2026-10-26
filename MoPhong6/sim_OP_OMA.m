function [OP_D1, OP_D2] = sim_OP_OMA(rho, N, Ntrials, lambda_SU, lambda_UD1, lambda_UD2, gamma_1th_OMA, gamma_2th_OMA)
    
    count_outage_D1_OMA = 0;
    count_outage_D2_OMA = 0;

    for itrial = 1:Ntrials
        % Sinh kênh fading Rayleigh
        h_SU  = rayleigh_channel(lambda_SU, N);
        h_UD1 = rayleigh_channel(lambda_UD1, N);
        h_UD2 = rayleigh_channel(lambda_UD2, N);

        % SNR chặng S-U cho OMA
        gamma_SU_OMA = gamma_OMA(rho, h_SU);

        % Chọn UAV tối ưu cho OMA
        [h_SU_best_OMA, h_UD1_best_OMA, h_UD2_best_OMA, ~] = ...
            select_best_uav_OMA(h_SU, h_UD1, h_UD2, gamma_SU_OMA);

        % SNR các chặng
        gamma_SU_best = gamma_OMA(rho, h_SU_best_OMA);
        gamma_UD1     = gamma_OMA(rho, h_UD1_best_OMA);
        gamma_UD2     = gamma_OMA(rho, h_UD2_best_OMA);

        % Kiểm tra Outage D1 OMA
        if (gamma_SU_best < gamma_1th_OMA) || (gamma_UD1 < gamma_1th_OMA)
            count_outage_D1_OMA = count_outage_D1_OMA + 1;
        end

        % Kiểm tra Outage D2 OMA
        if (gamma_SU_best < gamma_2th_OMA) || (gamma_UD2 < gamma_2th_OMA)
            count_outage_D2_OMA = count_outage_D2_OMA + 1;
        end
    end

    % Xác suất dừng mô phỏng OMA
    OP_D1 = count_outage_D1_OMA / Ntrials;
    OP_D2 = count_outage_D2_OMA / Ntrials;
end