    function gamma = gamma_1(SNR, a1, a2, h)
             gamma = (SNR*a1*abs(h).^2)./(a2*SNR*abs(h).^2 + 1);
    end