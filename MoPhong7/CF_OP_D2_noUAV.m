function OP_D2 = CF_OP_D2_noUAV(rho, lambda_SD2, a1, a2, gamma1_th, gamma2_th)
    % Kiểm tra điều kiện tồn tại giải mã NOMA
    if gamma1_th >= a1/a2
        OP_D2 = 1;
        return;
    end
    
    A = gamma1_th / (rho * (a1 - a2 * gamma1_th));
    B = gamma2_th / (rho * a2);
    M = max(A, B);

    % Số mũ theo kênh truyền trực tiếp Vệ tinh -> D2
    exponent = - M / lambda_SD2;

    % Biểu thức Close-form của OP_D2 khi không có UAV
    OP_D2 = 1 - exp(exponent);
end