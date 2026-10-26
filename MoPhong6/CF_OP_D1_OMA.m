   function OP_D1 = CF_OP_D1_OMA(rho, N, lambda_SU, lambda_UD1, gamma1_th)
        % Tính vế đầu 
        prod = 1;
        for i = 1:N
            exponent_1 = - gamma1_th / (lambda_SU * rho);
            prod = prod * (1 - exp(exponent_1));
        end
        clause_1 = 1 - prod;
    
        % Tính vế sau 
        exponent_2 = - gamma1_th / (lambda_UD1 * rho);
        clause_2 = exp(exponent_2);
    
        % Biểu thức OP_D1
        OP_D1 = 1 - clause_1 * clause_2;
    end
