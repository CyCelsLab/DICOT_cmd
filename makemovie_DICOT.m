%% 24/2/2018 Anushree, iiser pune
%% Modified 7/3/2018
%% Overlay tracks on images in real time i.e. make a tracking movie
%% Yash MOD
function makemovie_DICOT(infolder, Findex,imagename)

%% INPUT:
% Findex = frame nos. start:end
% imagename = tif time-series
% ALLtracks = tracked output matrix from 'link_cells4.m' 
% (1:obj ID, 2:x (pixels), 3:y (pixels), 4:time (specific units), 5:frame, 6:length (specific units))
%% OUTPUT:
% trackingmovie.tif = output tif movie
%% CODE:

outfile=[infolder,'/trackingmovie.tif'];
if exist(outfile, 'file')
    delete(outfile);
end

if exist([infolder, '/trajectories.txt'], 'file')
    ALLtrackstemp=importdata([infolder, '/trajectories.txt'],'\t', 1);
    ALLtracks=ALLtrackstemp.data;
else
    errordlg('Please track objects before making a movie.', 'Error');
end
% ALLtracks:  obj no, x, y, time, frame, length 
% MIGHT NEED TO CHANGE COLUMN NUMBERS, depending on output from Dhruv's
% (FluoreT)code
Null_Alltracks = [ALLtracks(:,1) ALLtracks(:,4) ALLtracks(:,3),...
    ALLtracks(:,6), ALLtracks(:,2)];
ALLtracks = Null_Alltracks; 
objno=unique(ALLtracks(:,1));
objwise=cell(1, max(objno));
frmwise=cell(1,Findex(end));
p=0;
w =waitbar(0, 'Saving movie..');
for j=Findex
    p=p+1;
    waitbar(p/numel(Findex));
    r=find(ALLtracks(:,5)==j);
    frmwise{j}=[ALLtracks(r,1:3),ALLtracks(r,5)]; %obj no, x, y, frame
    fiG= imread(imagename,j);
    fj= figure(j); 
    set(fj,'visible', 'off'), 
    imshow(fiG, 'Border', 'tight')
    
    for i=min(objno):max(objno)
        rr= find(frmwise{j}(:,1)==i);
        objwise{i}=[objwise{i}; frmwise{j}(rr,2:3)];% x,y
        
        if j==frmwise{j}(rr,4)
            set(gca, 'visible', 'off')
                hold on, plot(objwise{i}(1:end,1),objwise{i}(1:end,2),...
                '-r.',...
                'Linewidth', 1,...
                'MarkerSize', 5)

            hold on, plot(objwise{i}(end,1),objwise{i}(end,2),'.b','MarkerSize', 10)
            hold on, text(objwise{i}(end,1),objwise{i}(end,2),sprintf('%i', i),...
                'Color', 'y','FontSize', 10)
        else
            continue
        end
    end
    f=getframe(gcf); % converting frame to matrix
    imwrite(f.cdata, outfile, 'tif', 'Compression', 'none',...
        'WriteMode', 'append');%, 'Resolution', 1/Scaling_factor);
    delete(fj);
end
delete(w);
end