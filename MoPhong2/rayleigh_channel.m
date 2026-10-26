    function h = rayleigh_channel(lambda, N)
             h = sqrt(lambda/2)*(randn(1,N) + 1j*randn(1,N));
    end