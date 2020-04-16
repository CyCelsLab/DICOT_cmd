function DICOT_seg_overlay(test_image,kernel_choice, user_choice)
%% Imported from miGloop.m
%DICT_SEG_OVERLAY displays segmentation output of SOG Filter 
imgig = imfilter(test_image,kernel_choice, 'replicate', 'same');
imgig_adjust  = imadjust(imgig); 
bw_filter  = im2bw(imadjust(imgig_adjust), graythresh(imgig_adjust)^0.5);
if strcmpi(user_choice, 'N')
    region_props_coords = regionprops(bw_filter, 'Centroid'); 
elseif strcmpi(user_choice, 'Y')
    intersect_image = test_image.*uint8(bw_filter);
    regional_max_image = imregionalmax(intersect_image);
    region_props_coords = regionprops(regional_max_image, 'Centroid');
end 
Coords2overlay = cat(1, region_props_coords.Centroid); 
figure(1), imshow(test_image); hold on 
plot(Coords2overlay(:,1), Coords2overlay(:,2),'r.', 'MarkerSize', 10);
hold off 
end

