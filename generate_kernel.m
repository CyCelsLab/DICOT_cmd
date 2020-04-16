function ki = generate_kernel(filter_size, filter_sigma, sens_fact,bw_choice,filter_type)
filter_choice = lower(filter_type);
bw = bw_choice;
switch filter_choice
    case 'sog'
        ksize = filter_size;
        sigma  = filter_sigma;
        fact= sens_fact;
        kk = fspecial('gaussian',ksize,sigma);
        km = mean(kk(:));
        ki = bw*(kk -km) -fact*km;
    case 'log'
        ksizel =filter_size;
        sigmal = filter_sigma;
        ki = fspecial('log', ksizel, sigmal);
        ki  = -bw*ki;
    case 'dog'
        Gauss_1 = fspecial('gaussian', filter_size, max(filter_sigma));
        Gauss_2 = fspecial('gaussian', filter_size, min(filter_sigma));
        ki = -Gauss_1 + Gauss_2;
        ki =ki*bw;
end
end