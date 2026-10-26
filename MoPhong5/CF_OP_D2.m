    function OP_D2 = CF_OP_D2(rho, N, lambda_SU, lambda_UD2, a1, a2, gamma_1th, gamma_2th)
             
             A = gamma_1th / (rho * (a1 - a2*gamma_1th));
             B = gamma_2th / (rho * a2);
             M = max(A,B);

             % tính vế đầu 
             prod = 1;
             for i = 1:N
             exponent_1 = - M / lambda_SU;
             prod = prod * (1 - exp(exponent_1));
             end
             clause_1 = 1 - prod;
            
             % tính vế sau
             exponent_2 = - M / lambda_UD2;
             clause_2 = exp(exponent_2);

             % tính OP_D2
             OP_D2 = 1 - clause_1 * clause_2;
    end