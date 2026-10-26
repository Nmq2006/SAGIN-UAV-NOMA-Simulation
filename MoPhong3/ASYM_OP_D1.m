function OP_D1_asym = ASYM_OP_D1(rho, lambda_UD1, a1, a2, gamma1_th)

    % Kiểm tra điều kiện ngưỡng
    if gamma1_th >= (a1 / a2)
        OP_D1_asym = ones(size(rho));
        return;
    end

    Theta = gamma1_th / (a1 - a2 * gamma1_th);

    OP_D1_asym = Theta ./ (rho * lambda_UD1);
end