function [allpertrack,allinst]=objectstats(outfolder, scal_fact, distUnit, timeUnit,outmat,minlenoftrack)
%[...] = OBJECTSTATS(OUTFOLDER, SCALING_FACTOR, PIXEL_UNIT, TIME_UNIT, OUTMAT, MIN_TRACK_LENGTH) returns various analysis on tracks data
% ===== AUX Function =====
%   Inputs
%       OUTFOLDER - delta_t
%       SCALING_FACTOR - X coordinates
%       PIXEL_UNIT - Y coordinates
%       TIME_UNIT - color
%       OUTMAT - tracks matrix MATLAB format
%       MIN_TRACK_LENGTH - minimum track length
%
%   ALLINST instantaneous statistics
%   ALLPERTRACK individual statistics

% DICOT (CyCelS lab, IISER Pune)

% reading in coords of centroids of tracked objects
if isempty(outmat)
   errordlg('No tracks detected!', 'Error')
end
pertrack=cell(1, max(outmat(:,1)));
instant = pertrack;
arr=pertrack;
% arranging all objects in separate cells
for i=1: max(outmat(:,1)) %i= each object
    
    [kappa]= find(outmat(:,1)== i);
    if numel(kappa)>=minlenoftrack
        arr{i}= outmat(kappa, 2:6);
        % x coord, y coord, time, frame number, length
        dist=euclDist([arr{i}(1,1:2);arr{i}(end,1:2)])*scal_fact;% start to end
        waqt=arr{i}(end,3)-arr{i}(1,3); % start to end
        netvel=dist/waqt;
        disp=zeros(numel(kappa)-1, 2);
        for j=1:numel(kappa)-1
            disp(j,:)=[i, scal_fact*euclDist([arr{i}(j,1:2);arr{i}(j+1,1:2)])];
        end
        pathlength=sum(disp(:,2));
        len=mean(arr{i}(:,5));
        timestep=arr{i}(2:end, 3)-arr{i}(1:end-1, 3);
        % ===== Speed =====
        speed=pathlength/waqt;
        invel=disp(:,2)./timestep;
        tortu= dist/pathlength; % start-to-end/pathlength
        if pathlength==0
            tortu=0;
        end
        
        pertrack{i}=[i, waqt,pathlength,dist, speed,netvel, tortu,len]; % obj no., start-to-end time, pathlength,start-to-end dist, speed, net vel, tortuosity, length
        % ===== Velocity =====
        instant{i}=[disp(:,1),timestep,disp(:,2),invel]; % obj no., time, displacement, velocity
    end
end

% Individual stats
allpertrack=cat(1, pertrack{:});
allinst=cat(1, instant{:});

% ===== Storing stats =====
fid =fopen([outfolder, '/StatsPerTrack.txt'], 'w');
fprintf(fid, ['ObjectID    Time (', timeUnit, ')    Pathlength    NetDist    Speed    NetVel    Tortuosity    Length (', distUnit, ')\r\n']);
fclose(fid);
dlmwrite([outfolder, '/StatsPerTrack.txt'],...
    allpertrack,'-append',...
    'delimiter', '\t','newline', 'pc',...
    'precision', '%.3f');

% ===== Storing stats =====
fid =fopen([outfolder, '/InstStats.txt'], 'w');
fprintf(fid, ['ObjectID    Time (', timeUnit, ')    Displacement (',distUnit,')    Velocity\r\n']);
fclose(fid);
dlmwrite([outfolder, '/InstStats.txt'], allinst,...
    '-append', 'delimiter', '\t','newline', 'pc',...
    'precision', '%.3f');
    