 function OP_D2 = CF_OP_D2_OMA(rho, N, lambda_SU, lambda_UD2, gamma2_th)
        % Tính vế đầu 
        prod = 1;
        for i = 1:N
            exponent_1 = - gamma2_th / (lambda_SU * rho);
            prod = prod * (1 - exp(exponent_1));
        end
        clause_1 = 1 - prod;
    
        % Tính vế sau 
        exponent_2 = - gamma2_th / (lambda_UD2 * rho);
        clause_2 = exp(exponent_2);
    
        % Biểu thức OP_D2
        OP_D2 = 1 - clause_1 * clause_2;
    end