function savestats = DICOT_segmentation(filename,Findex,kernel_choice,outfolder,distUnit)
% DICOT_SEGMENTATION, combined verison of code written by Yash, for granule
% segmentation using SOG (Scaling of Gaussian function)
% Output are centorid coordinates of detected objects
% Last update: 20/03/2020
%% Generating kernel with user defined parameters
ki =kernel_choice; 
listLen= cell(1,max(Findex));
savestats=[];
outfile=[outfolder, '/segmentedmovie.tif'];
if exist(outfile, 'file') %ARC 5/2/2018
    delete(outfile);
end
% ksiz

for image_no=1:Findex
    %% Read in current Image
    img1=imread(filename,image_no);
    %% Segmentation
    img=img1;
    figure('Visible', 'off')
    imshow(imadjust(img1),'Border', 'tight')
    set(gcf,'NumberTitle','off', 'Name', 'Segmentation: miG');
    % Image Filtering
    imgig = imfilter(img,ki,'replicate','same');
    imgig = imadjust(imgig); % filter Image is adjusted?
    % Threshold, default graythresh^0.5
    imgig = im2bw(imgig,graythresh(imgig)^0.5);
    %% Store output 
    stat = regionprops(imgig,'Area','Centroid','PixelList','MajorAxisLength','MinorAxisLength','Perimeter');
    scen = cat(1,stat.Centroid);
    frameno=(ones(size(scen,1),1))*image_no;
    listLen{image_no}=[frameno,zeros(size(scen,1),1),scen,frameno];
    figure('Visible', 'off'),imshow(imadjust(img1),'Border', 'tight'),hold on,...
        if ~isempty(scen)
        plot(scen(:,1),scen(:,2),'r.', 'MarkerSize', 8),...
        end
    %hold off
    f=getframe(gcf);
    imwrite(f.cdata, outfile, 'tif', 'Compression', 'none',...
        'WriteMode', 'append');
    if ~isempty(stat) % empty stats causes crash
        [stat(1:length(stat)).Frame]=deal(image_no);
        
        savestats=[savestats; stat];
    end
    
    % figure,imshow(imgig);
end
try
    conlistLen = cat(1, listLen{:});%1:frame no, 2:obj no, 3:x, 4:y, 5:length
catch
    disp('Some Frames had no detected objects, therefore concatenation does not works')
end
% write detection date
fid =fopen([outfolder,'/untracked.txt'], 'w');
fprintf(fid, ['Frame	ObjID	X	Y	Length (', distUnit, ')\r\n']);
fclose(fid);
dlmwrite([outfolder,'/untracked.txt'], conlistLen, '-append',...
    'delimiter', '\t','newline', 'pc','precision', '%.3f');

end

