function [d_eff,alpha,predy]= msd_fit_ARCmod(tim,msd)
%[...] = MSD_FIT_ARCMOD(T, MSD) returns MSD fit and fit parameters
% ===== AUX Function =====
%   Inputs
%     T - delta_t 
%     MSD - msd values
%
%   D_EFF Diffusion coefficient
%   ALPHA Anomaly parameter
%   X err

% DICOT (CyCelS lab, IISER Pune)

% _init_
s= fitoptions('Method','NonlinearLeastSquares',...
     'Startpoint',[ 0 0 ],...
    'Algorithm' , 'Levenberg-Marquardt' ); % fit function options   -- You can specify al the fit options else the default is read: Method, Algorithm , lower n upper bounds , startpoints ,

% for 2D MSD function: <r^2> =  4Dt^alpha, here tim = x;
ft3     = fittype( '4.*d.*(x.^a)',...
    'coefficients',{'a','d'},'options',s );
[ cf,s1,~ ] = fit( tim , msd, ft3 )
% returns alpha and effective D values
alpha = cf.a; % Alpha
d_eff = cf.d; % D_eff
predy=cf(tim); % err

end
