function ki = generate_kernel(filter_size, filter_sigma, sens_fact,bw_choice,filter_type)
%GENERATE_KERNEL generates the 2-D kernel
%
%   kernel = GENERATE_KERNEL(SIZE, SIGMA, SENSITIVITY, B/W, TYPE) creates a 2-D selected type of kernel. Possible TYPE are,
%       'SoG' Scaling of Gaussian
%       'LoG' Laplacian of Gaussian
%       'DoG' Difference of Gaussian
%
%   Depending on kernel TYPE, input parameters format vary as following,
%
%   SIZE a scalar number for kernel size
%   SIGMA sigma of gaussian, scalar for SoG and LoG while array of size 2 for DoG
%   SENSITIVITY a scalar indicating strength of filter (applies only for SoG)
%   B/W boolean indication desired detection of White (1) or Black (-1) objects over background
%
% See also DICOT_SEGMENTATION

% DICOT (CyCelS lab, IISER Pune)

filter_choice = lower(filter_type);
bw = bw_choice;
switch filter_choice
    case 'sog'
        ksize = filter_size;
        sigma  = filter_sigma;
        fact= sens_fact; % sensitivity_factor
        kk = fspecial('gaussian',ksize,sigma);
        km = mean(kk(:));
        ki = bw*(kk -km) -fact*km; % SoG
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
