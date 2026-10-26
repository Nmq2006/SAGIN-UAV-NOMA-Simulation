function [OP_D1, OP_D2] = sim_OP_NOMA(rho, N, Ntrials, lambda_SU, lambda_UD1, lambda_UD2, a1, a2, gamma_1th_NOMA, gamma_2th_NOMA)
    
    count_outage_D1 = 0;
    count_outage_D2 = 0;

    for itrial = 1:Ntrials
        % Sinh kênh fading Rayleigh
        h_SU  = rayleigh_channel(lambda_SU, N);
        h_UD1 = rayleigh_channel(lambda_UD1, N);
        h_UD2 = rayleigh_channel(lambda_UD2, N);

        % SINR chặng S-U
        gamma_x1_SU = gamma_1(rho, a1, a2, h_SU);
        gamma_x2_SU = gamma_2(rho, a2, h_SU);

        % Chọn UAV tối ưu
        [h_SU_best, h_UD1_best, h_UD2_best, ~] = ...
            select_best_uav(h_SU, h_UD1, h_UD2, gamma_x1_SU, gamma_x2_SU);

        % SINR các chặng
        gamma_x1_UD1 = gamma_1(rho, a1, a2, h_UD1_best);
        gamma_x1_UD2 = gamma_1(rho, a1, a2, h_UD2_best);
        gamma_x2_UD2 = gamma_2(rho, a2, h_UD2_best);

        gamma_x1_SU_best = gamma_1(rho, a1, a2, h_SU_best);
        gamma_x2_SU_best = gamma_2(rho, a2, h_SU_best);

        % Kiểm tra Outage D1
        if (gamma_x1_SU_best < gamma_1th_NOMA) || (gamma_x1_UD1 < gamma_1th_NOMA)
            count_outage_D1 = count_outage_D1 + 1;
        end

        % Kiểm tra Outage D2
        if (gamma_x1_SU_best < gamma_1th_NOMA) || (gamma_x2_SU_best < gamma_2th_NOMA) || ...
           (gamma_x1_UD2 < gamma_1th_NOMA)    || (gamma_x2_UD2 < gamma_2th_NOMA)
            count_outage_D2 = count_outage_D2 + 1;
        end
    end

    % Xác suất dừng mô phỏng
    OP_D1 = count_outage_D1 / Ntrials;
    OP_D2 = count_outage_D2 / Ntrials;
end