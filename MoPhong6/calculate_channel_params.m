function [lambda_SU, lambda_UD1, lambda_UD2, lambda_SD1, lambda_SD2] = calculate_channel_params(d)
    hS = 3;          % Nguồn S ở tầng trên cao (chuẩn hóa)
    hU = 0.4;          % UAV ở tầng giữa
    D1D2 = 0.2;
    xD2 = 1.0;
    xD1 = 1.0 + D1D2;

    nu_SU = 2.0;
    nu_UD = 3.0;
    nu_SD = 3.5;

    d_SU  = sqrt(d.^2 + (hS - hU)^2);
    d_UD1 = sqrt((xD1 - d).^2 + hU^2);
    d_UD2 = sqrt((xD2 - d).^2 + hU^2);
    d_SD1 = sqrt(xD1^2 + hS^2);
    d_SD2 = sqrt(xD2^2 + hS^2);

    lambda_SU  = d_SU.^(-nu_SU);
    lambda_UD1 = d_UD1.^(-nu_UD);
    lambda_UD2 = d_UD2.^(-nu_UD);
    lambda_SD1 = d_SD1.^(-nu_SD);
    lambda_SD2 = d_SD2.^(-nu_SD);
end