% USAGE: [dt,rr]=msd(data,deltaT)
%       where, data: simulation output file, deltaT= simulation steptime
% Two functions are incorporated here: msdisplacement and polyfitZero

% modified on 29 Aughtst 2015, cytosim: for dn based on segregation and
% time truncation at chromatin

function [dt,rr]=msdisplacement_ARCmod( t , xx , yy,hue)
%[...] = MSDDISPLACEMENT_ARCMOD(T, X, Y, C) returns MSD values
% ===== AUX Function =====
%   Inputs
%       T - delta_t
%       X - X coordinates
%       Y - Y coordinates
%       C - color
%
%   DT time axis values
%   RR msd values

% DICOT (CyCelS lab, IISER Pune)

u=1:1:round(3*length(t)/4); % fit 75% average tracks length for MSD
sqD1=cell(1,numel(u)); % preallocating
msqD1= sqD1; % preallocating
for dT = round(u) % slow [Y] _implement_matrix_operations

	sqD1{dT}=zeros(numel(1:1:length(t)-dT),1); % altered
    for n=1:1:length(t)-dT
        sqD1{dT}(n,:)=((xx(n)-xx(n+dT)).^2)+((yy(n)-yy(n+dT)).^2); %altered    
    end
    
	% For a given dT, from multiple sqD1 values, finding the mean of it
    if size(t,1)>dT % condition added
    msqD1{dT} = [ t(dT+1), mean( sqD1{dT}(:) ) ];
    else
        continue % add more function
    end
end

catmsqD1=cat(1,msqD1{:}); % reformat
% For each dt, return the rr
dt    = [0;catmsqD1(:,1)]; % time X-axis
rr    = [0;catmsqD1(:,2)]; % MSD Y-axis
figure(gcf), % plot MSD plot
hold on,
plot(dt,rr,'-','Color', hue, 'Linewidth', 1)

end
