function savestats = DICOT_segmentation(filename,Findex,kernel_choice,outfolder,distUnit)
%stats = DICOT_SEGMENTATION generates a quick overlay of segmentated objects on the image
%
%   stats = DICOT_SEGMENTATION(FILENAME, INDEX, KERNEL, OUTFOLDER, PIXEL_UNIT) segmente the image time-series and returns statistics from segmentation. The statistics are stored in a file with following TAB "\t" delimited format,
%
%       | Frame | ObjID | X | Y | Length |
%
%       Frame - frame in which object is detected
%       ObjID - ID of detected object in the frame
%       X, Y - respective X, Y centroids of detected object
%       Length - length of detected object (major axis)
%
%   FILENAME input image filename
%   INDEX number of frames to segment from time-series
%   KERNEL a 2-D kernel array
%   OUTFOLDER folder name for storing statistics
%   PIXEL_UNIT unit of scale
%
% See also MAKEMOVIE_DICOT

% DICOT (CyCelS lab, IISER Pune)

% _init_
ki =kernel_choice; 
listLen= cell(1,max(Findex));
savestats=[];
outfile=[outfolder, '/segmentedmovie.tif'];
if exist(outfile, 'file')
    delete(outfile);
end

for image_no=1:Findex
    % Read Image(i)
    img1=imread(filename,image_no);
    % ===== Segmentation =====
    img=img1;
    figure('Visible', 'off')
    imshow(imadjust(img1),'Border', 'tight')
    set(gcf,'NumberTitle','off', 'Name', 'Segmentation: miG');
    % Image Filtering
    imgig = imfilter(img,ki,'replicate','same');
    imgig = imadjust(imgig); % filtered Image is contrast adjusted
    % Threshold parameter
    imgig = im2bw(imgig,graythresh(imgig)^0.5); % default 0.5
    % Get stats 
    stat = regionprops(imgig,'Area','Centroid','PixelList','MajorAxisLength','MinorAxisLength','Perimeter');
    scen = cat(1,stat.Centroid);
    frameno=(ones(size(scen,1),1))*image_no;
    listLen{image_no}=[frameno,zeros(size(scen,1),1),scen,frameno];
    % Display image with objects
    figure('Visible', 'off'),imshow(imadjust(img1),'Border', 'tight'),hold on,...
        if ~isempty(scen)
        plot(scen(:,1),scen(:,2),'r.', 'MarkerSize', 8),...
        end
    % Store tracked images
    f=getframe(gcf);
    imwrite(f.cdata, outfile, 'tif', 'Compression', 'none',...
        'WriteMode', 'append');
    % pooling stats
    if ~isempty(stat) % empty stats causes crash
        [stat(1:length(stat)).Frame]=deal(image_no);
        savestats=[savestats; stat];
    end
end
try
    conlistLen = cat(1, listLen{:});%1:frame no, 2:obj no, 3:x, 4:y, 5:length
catch
    disp('Some Frames had no detected objects, therefore concatenation does not works')
end
% ===== Store stats =====
fid =fopen([outfolder,'/untracked.txt'], 'w');
fprintf(fid, ['Frame	ObjID	X	Y	Length (', distUnit, ')\r\n']);
fclose(fid);
dlmwrite([outfolder,'/untracked.txt'], conlistLen, '-append',...
    'delimiter', '\t','newline', 'pc','precision', '%.3f');
end
