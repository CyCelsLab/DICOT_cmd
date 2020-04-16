%% 6/3/2013 anushree, iiser pune
%% To find velocity(dx/dy), displacement(dx) and
%% tortuosity(displacement/distance)
%% from particle trajectories generated 
%% by function 'link_cells4.m'.
function [allpertrack,allinst]=objectstats(outfolder, scal_fact, distUnit, timeUnit,outmat,minlenoftrack)
%% INPUT:
%  outfolder= 'd:/DCTT';
%  scal_fact=0.154;
%  distUnit='um';
%  timeUnit='min';
%---------------------------------------------------------------------

%% reading in coords of centroids of tracked objects
% outmat= list of tracks
% (1:obj no., 2: x, 3:y, 4:time, 5: frame, 6: length)
if isempty(outmat)
   errordlg('No tracks detected!', 'Error')
end
%% Number of tracks
%nooftracks= numel(unique(outmat(:,1)));
pertrack=cell(1, max(outmat(:,1)));
instant = pertrack;
arr=pertrack;
%% arranging all objects in separate cells
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
        
        speed=pathlength/waqt;
        invel=disp(:,2)./timestep;
        tortu= dist/pathlength; % start-to-end/pathlength
        if pathlength==0
            tortu=0;
        end
        
        
        pertrack{i}=[i, waqt,pathlength,dist, speed,netvel, tortu,len];  
         % obj no., start-to-end time, pathlength,start-to-end dist, speed,
         % net vel, tortuosity, length 
        instant{i}=[disp(:,1),timestep,disp(:,2),invel];
    % obj no., time, displacement, velocity
    
    
    end
end
allpertrack=cat(1, pertrack{:});
allinst=cat(1, instant{:});
fid =fopen([outfolder, '/StatsPerTrack.txt'], 'w');
fprintf(fid, ['ObjectID    Time (', timeUnit, ')    Pathlength    NetDist    Speed    NetVel    Tortuosity    Length (', distUnit, ')\r\n']);
fclose(fid);
dlmwrite([outfolder, '/StatsPerTrack.txt'],...
    allpertrack,'-append',...
    'delimiter', '\t','newline', 'pc',...
    'precision', '%.3f');


fid =fopen([outfolder, '/InstStats.txt'], 'w');
fprintf(fid, ['ObjectID    Time (', timeUnit, ')    Displacement (',distUnit,')    Velocity\r\n']);
fclose(fid);
dlmwrite([outfolder, '/InstStats.txt'], allinst,...
    '-append', 'delimiter', '\t','newline', 'pc',...
    'precision', '%.3f');
            
        
           