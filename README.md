# DICOT_cmd
Command line DIC Object Tracking (DICOT) code written inMATLAB to analyze DIC image time-series.
Instructions for use:
1. Download the entire folder
2. Open the MATLAB terminal (MATLAB 2017b and higher). To run this code you will need the Image Processing Toolbox to be installed.
3. Change directory to where you downloaded and unzipped the files. At the command line type >>DICOT_main_all
4. You will be prompted to open a TIF time-series. Since we have provided an example, click to select the time-series  stored as a multipage TIF (here: "test_image.tif").
5. Follow the popup menu to complete the filtering, segmentation and tracking.
6. All output files are stored in a sub-folder "./msg-test_image/".
7. The 4 output files generated are: 
(a) trackingmovie.TIF contains the tracked segments for visual inspection 
(b) segmentedmovie.TIF: The time series with the overlaid centers of objects detected (either using RegionMax or centroid), 
(c) trajectories.txt: It contains the trajectory information as >>[ObjID, Frame,	X,  Y,  Length (pixels), Time (frames)]. The time is in units frames, and the XY positions in units of pixels, length corresponds to the long-axis length of the object.
(d) untracked.txt: All object coordinates in x and y-coordinates with frame numbers.  
