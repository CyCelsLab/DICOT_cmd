%% Modified Anushree 24/2/2018
% Neha Khetan, SOCM lab , Autumn 2012, 25 June 2015 
% Code last modified in October 2013 (compared with CA code) & adapted to MATLAB from Octave


% USAGE: [dt,rr]=msd(data,deltaT)
%       where, data: simulation output file, deltaT= simulation steptime
% Two functions are incorporated here: msdisplacement and polyfitZero

% modified on 29 Aughtst 2015, cytosim: for dn based on segregation and
% time truncation at chromatin

function [dt,rr]=msdisplacement_ARCmod( t , xx , yy,hue)

%for different start points

% choosing the sliding window range i.e.
% for given 10 points, range of sliding window would be say from.. 1,2......7
% Now, picking each sliding windown length and then going over the track

u=1:1:round(3*length(t)/4); %ARC
sqD1=cell(1,numel(u)); %ARC preallocating
msqD1= sqD1; %ARC preallocating
for dT = round(u)    

	sqD1{dT}=zeros(numel(1:1:length(t)-dT),1); %ARC altered
    for n=1:1:length(t)-dT
        sqD1{dT}(n,:)=((xx(n)-xx(n+dT)).^2)+((yy(n)-yy(n+dT)).^2); %ARC  altered    
    end
    
	% For a given dT, from multiple sqD1 values, finding the mean of it
    if size(t,1)>dT % condition added 29/6/2018 ARC
    msqD1{dT} = [ t(dT+1), mean( sqD1{dT}(:) ) ];
    else
        continue
    end
end

catmsqD1=cat(1,msqD1{:}); %ARC
% For each dt, return the rr
dt    = [0;catmsqD1(:,1)]; %ARC
rr    = [0;catmsqD1(:,2)]; %ARC
figure(gcf),
hold on,
plot(dt,rr,'-','Color', hue, 'Linewidth', 1)

end
