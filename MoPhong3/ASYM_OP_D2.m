function OP_D2_asym = ASYM_OP_D2(rho, lambda_UD2, a1, a2, gamma1_th, gamma2_th)
    
    if gamma1_th >= (a1 / a2)
        OP_D2_asym = ones(size(rho));
        return;
    end

    Theta1 = gamma1_th / (a1 - a2 * gamma1_th);
    Theta2 = gamma2_th / a2;
    Theta_max = max(Theta1, Theta2);

    OP_D2_asym = Theta_max ./ (rho * lambda_UD2);
end