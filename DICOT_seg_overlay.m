function DICOT_seg_overlay(test_image,kernel_choice, user_choice)
%DICOT_SEG_OVERLAY generates a quick overlay of segmentated objects on the image
%
%   DICOT_SEG_OVERLAY(IMG, KERNEL, CHOICE) generates a image overlay of detected objects from segmentation on the provided image. It is a parameter optimization function (as a whole-part of main function) which continues untill user is satisfied with the segmentation.
%
%   IMG input 2-D image array
%   KERNEL input 2-D kernel for segmentation
%   CHOICE parameters optimized, [Y] "yes, continue" or [N] "no, repeat"
%
% See also MAKEMOVIE_DICOT

% DICOT (CyCelS lab, IISER Pune)

% ===== Filters the image time-series =====
imgig = imfilter(test_image,kernel_choice, 'replicate', 'same');
imgig_adjust  = imadjust(imgig); 
bw_filter  = im2bw(imadjust(imgig_adjust), graythresh(imgig_adjust)^0.5); % 0.5 is default fixed THRESHOLD_SEGMENTATION power
% ===== Optimize(loop) =====
if strcmpi(user_choice, 'N')
    region_props_coords = regionprops(bw_filter, 'Centroid'); 
elseif strcmpi(user_choice, 'Y')
    intersect_image = test_image.*uint8(bw_filter);
    regional_max_image = imregionalmax(intersect_image);
    region_props_coords = regionprops(regional_max_image, 'Centroid');
end
% create overlay
Coords2overlay = cat(1, region_props_coords.Centroid); 
figure(1), imshow(test_image); hold on 
plot(Coords2overlay(:,1), Coords2overlay(:,2),'r.', 'MarkerSize', 10);
hold off 
end
