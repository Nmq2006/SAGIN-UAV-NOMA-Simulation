    function OP_D1 = CF_OP_D1(rho, N, lambda_SU, lambda_UD1, a1, a2, gamma_1th)
           if gamma_1th >= a1/a2
              OP_D1 = 1;
              return
           end
           % tính vế đầu
           prod = 1;
           for i = 1:N
               exponent_1 = - gamma_1th ./ (lambda_SU .* rho .* (a1 - a2.*gamma_1th));
               prod = prod .* ( 1 - exp(exponent_1));
           end
           clause_1 = 1 - prod;
           % tính vế sau
           exponent_2 = - gamma_1th ./ (lambda_UD1 .* rho .* (a1 - a2.*gamma_1th));
           clause_2  = exp(exponent_2);

           % biểu thức OP_D1
           OP_D1 = 1 - clause_1 .* clause_2;
    end