function OP_D1 = CF_OP_D1_noUAV(rho, lambda_SD1, a1, a2, gamma1_th)
    % Kiểm tra điều kiện tồn tại giải mã NOMA
    if gamma1_th >= a1/a2
        OP_D1 = 1;
        return;
    end

    % Số mũ theo kênh truyền trực tiếp Vệ tinh -> D1
    exponent = - gamma1_th / (lambda_SD1 * rho * (a1 - a2 * gamma1_th));

    % Biểu thức Close-form của OP_D1 khi không có UAV
    OP_D1 = 1 - exp(exponent);
end