function [tracks,objno,outmat] = DICOT_tracking(outfolder, savestats, micron_search_radius, scal_fact, interval, distUnit, timeUnit)
%DICOT_TRACKING tracking code for DICOT, modified version of
% trackfil_dicot
%{
By default function removes all tracks that are less than 3 units in
tracking times
%}
Centroid_coordinates = cat(1, savestats.Centroid);
pixel_search_radius= micron_search_radius;  %/scal_fact;
x = Centroid_coordinates(:,2)';
y = Centroid_coordinates(:,1)';
frame = cat(1,savestats.Frame);
area= cat(1, savestats.Area); 
beadlabel=zeros(size(x)); % vector of bead labels.
i=min(frame); spanA=find(frame==i); % initialize w/ first frame.
beadlabel(1:length(spanA))=1:length(spanA); % refers to absolute indexing of x,y,frame,etc.
lastlabel=length(spanA); % start off with unique bead labels for all the beads in the first frame

w =waitbar(0, 'Tracking objects..');
p=0;
fidx= min(frame):max(frame)-1;
for i= fidx
    p=p+1;
    waitbar(p/numel(fidx));
    spanA= find(frame==i); % ARC 'find'-here, gives positions 
    spanB= find(frame==i+1);
    dx = ones(length(spanA),1)*x(spanB) - x(spanA)'*ones(1,length(spanB));
    dy = ones(length(spanA),1)*y(spanB) - y(spanA)'*ones(1,length(spanB));
    
    dr2 = sqrt(dx.^2 + dy.^2); 
     [from, to, orphan] = beadsorterMod(dr2, pixel_search_radius); 
    from=spanA(from);
    to=spanB(to);
    orphan=spanB(orphan);
    beadlabel(to)= beadlabel(from); 
    % modified ARC 28/5/2016
    if ~isempty(orphan)
        beadlabel(orphan)=lastlabel+(1:length(orphan));
        lastlabel=lastlabel+length(orphan); 
    end
end


emptybead.x=0; emptybead.y=0; emptybead.area=0; emptybead.frame=0;

%% Initialize for purposes of speed and memory management.
ALLtracks=cell(lastlabel,1); % modified ARC 28/5/2016
re=0;

for i=1:lastlabel
    p=p+1;
    waitbar(p/(numel(fidx)+lastlabel));% Y [mod]% reassemble beadlabel into a structured array 'tracks' containing all info
    
    beadi=find(beadlabel==i);
    if  numel(x(beadi))>=3 % ARC minimum no. of data points in a trajectory
    re=re+1;%ARC renumbering
    tracks(re).x=x(beadi);
    tracks(re).y=y(beadi);
    tracks(re).area=area(beadi)*scal_fact;
    tracks(re).frame=frame(beadi);
    % modified ARC 28/5/2016
    ALLtracks{re}= [(re*ones(size(tracks(re).x)))',(tracks(re).frame), (tracks(re).x)', (tracks(re).y)', (tracks(re).area), ((tracks(re).frame))*interval];
    ALLtracks{re}(:,6)=ALLtracks{re}(:,6)-ALLtracks{re}(1,6);
    % object number, frame number, centroid(x,y)(um),...
    % length of skeleton(um), time
    else
        continue
    end
end
%ARC 25/2/2018:
%% write data to file
outmat=cat(1,ALLtracks{:});
objno=re;
if exist(outfolder, 'dir')==0
    mkdir(outfolder)
end

if exist([outfolder, '/trajectories.txt'], 'file') 
    delete([outfolder,'/trajectories.txt']);
end

fid =fopen([outfolder,'/trajectories.txt'], 'w');
fprintf(fid, ['ObjID	Frame	X	Y	Length (',distUnit,')	Time (', timeUnit, ')\r\n']);
dlmwrite([outfolder, '/trajectories.txt'], outmat,'-append',...
    'delimiter', '\t','newline', 'pc', 'precision', '%.2f');
fclose(fid);

delete(w);

end

%%-------------------------------------------------------------------------
function [from,to, orphan]= beadsorterMod(dr2, pixel_search_radius)
% All bead tracking is done here.  Everything else is bookkeeping.  NOT ROBUST.  Look here first for problems!
% find indices of minimum value in each row 
% Get all hits within the search radius 
[i,j]  = min(dr2,[],2); % j is the row index
orphan=find(i > pixel_search_radius); 
ColArray = 1:size(dr2,1);
ColArray(orphan) = [];
j(orphan) = []; 
from = ColArray'; 
to = j; 
orphan=setdiff(1:size(dr2,2),to);

end
