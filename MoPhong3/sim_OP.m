function [OP_D1, OP_D2] = sim_OP(rho, Nrelay, Ntrials, lambda_SU,...
         lambda_UD1, lambda_UD2, a1, a2, gamma_1th, gamma_2th)

    count_outage_D1 = 0;
    count_outage_D2 = 0;

    for itrial = 1:Ntrials
        % 1. Sinh kênh
        h_SU  = rayleigh_channel(lambda_SU, Nrelay);
        h_UD1 = rayleigh_channel(lambda_UD1, Nrelay);
        h_UD2 = rayleigh_channel(lambda_UD2, Nrelay);

        % 2. SINR tại chặng S-U
        gamma_x1_SU = gamma_1(rho, a1, a2, h_SU);
        gamma_x2_SU = gamma_2(rho, a2, h_SU);

        % 3. Chọn best UAV
        [h_SU_best, h_UD1_best, h_UD2_best, ~] = ...
            select_best_uav(h_SU, h_UD1, h_UD2, gamma_x1_SU, gamma_x2_SU);

        % 4. SINR tại chặng U-D1 và U-D2
        gamma_x1_UD1 = gamma_1(rho, a1, a2, h_UD1_best);
        gamma_x1_UD2 = gamma_1(rho, a1, a2, h_UD2_best);
        gamma_x2_UD2 = gamma_2(rho, a2, h_UD2_best);

        gamma_x1_SU_best = gamma_1(rho, a1, a2, h_SU_best);
        gamma_x2_SU_best = gamma_2(rho, a2, h_SU_best);

        % 5. Outage D1
        if (gamma_x1_SU_best < gamma_1th) || (gamma_x1_UD1 < gamma_1th)
            count_outage_D1 = count_outage_D1 + 1;
        end

        % 6. Outage D2
        if (gamma_x1_SU_best < gamma_1th) || (gamma_x2_SU_best < gamma_2th) || ...
           (gamma_x1_UD2 < gamma_1th)    || (gamma_x2_UD2 < gamma_2th)
            count_outage_D2 = count_outage_D2 + 1;
        end
    end

    OP_D1 = count_outage_D1 / Ntrials;
    OP_D2 = count_outage_D2 / Ntrials;
end