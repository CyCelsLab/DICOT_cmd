function makemovie_DICOT(infolder, Findex,imagename)
%MAKE_DICOT returns tracked movie of the image time-series
%
%   MAKEMOVIE_DICOT(INFOLDER, INDEX, FILENAME) generates a movie with tracked objects overlayed on the image time-series
%
%   INFOLDER folder to store movie
%   INDEX frame index [start : end] in time-series
%   FILENAME image filename
%
% See also DICOT_SEGMENTATION

% DICOT (CyCelS lab, IISER Pune)

% _init_
outfile=[infolder,'/trackingmovie.tif'];
if exist(outfile, 'file')
    delete(outfile);
end

if exist([infolder, '/trajectories.txt'], 'file')
    ALLtrackstemp=importdata([infolder, '/trajectories.txt'],'\t', 1);
    ALLtracks=ALLtrackstemp.data; % ALLtracks | obj no, x, y, time, frame, length 
else
    errordlg('Please track objects before making a movie.', 'Error');
end

% NULL Track cleaning
Null_Alltracks = [ALLtracks(:,1) ALLtracks(:,4) ALLtracks(:,3),...
    ALLtracks(:,6), ALLtracks(:,2)];
ALLtracks = Null_Alltracks; 
objno=unique(ALLtracks(:,1));
objwise=cell(1, max(objno));
frmwise=cell(1,Findex(end));

% ===== Generating movie =====
p=0;
w =waitbar(0, 'Saving movie..');
for j=Findex
    p=p+1;
    waitbar(p/numel(Findex));
    r=find(ALLtracks(:,5)==j);
    frmwise{j}=[ALLtracks(r,1:3),ALLtracks(r,5)]; %obj no, x, y, frame
    fiG= imread(imagename,j);
    fj= figure(j);
    % Plot (in background)
    set(fj,'visible', 'off'), 
    imshow(fiG, 'Border', 'tight')
    for i=min(objno):max(objno)
        rr= find(frmwise{j}(:,1)==i);
        objwise{i}=[objwise{i}; frmwise{j}(rr,2:3)];% x,y
        % Overlay
        if j==frmwise{j}(rr,4)
            set(gca, 'visible', 'off')
                hold on, plot(objwise{i}(1:end,1),objwise{i}(1:end,2),...
                '-r.',...
                'Linewidth', 1,...
                'MarkerSize', 5)
            hold on, plot(objwise{i}(end,1),objwise{i}(end,2),'.b','MarkerSize', 10)
            hold on, text(objwise{i}(end,1),objwise{i}(end,2),sprintf('%i', i),...
                'Color', 'y','FontSize', 10) % tweak track display parameters
        else
            continue % add more functionality
        end
    end
    % Storing movie
    f=getframe(gcf); % converting frame to matrix
    imwrite(f.cdata, outfile, 'tif', 'Compression', 'none',...
        'WriteMode', 'append');%, 'Resolution', 1/Scaling_factor);
    delete(fj);
end
delete(w);
end
