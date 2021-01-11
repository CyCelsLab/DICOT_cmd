# DICOT_cmd
Command line DIC Object Tracking ([DICOT](https://github.com/CyCelsLab/DICOT_cmd)) code written in MATLAB to analyze DIC image time-series.  
Authors: @athale , @anushreec , @ykjawale , @dhruv

![GitHub release](https://img.shields.io/github/v/release/ykjawale/DICOT_cmd?style=for-the-badge)

[DICOT GUI](https://github.com/CyCelsLab/DICOT), with a GUI also available

### Reference
__Quantifying Intracellular Particle Flows by DIC Object Tracking (DICOT)__  
A. R. Chaphalkar, Y. K. Jawale, D. Khatri, and C. A. Athale  
DOI: [10.1016/j.bpj.2020.12.013](https://doi.org/10.1016/j.bpj.2020.12.013)  

### Instructions for use:
1. Download the entire folder
2. Open the MATLAB terminal (MATLAB 2017b and higher). To run this code you will need the Image Processing Toolbox to be installed.
3. Change directory to where you downloaded and unzipped the files. At the command line type,
```
>> DICOT_main_all
```
4. You will be prompted to open a TIF time-series. Use provided test file, click to select the time-series  stored as a multipage TIF [test_image](./test_image.tif).
5. Follow the popup menu to complete the `filtering`, `segmentation` and `tracking`.
6. All output files are stored in a sub-folder [./DICOT_test_image/](./DICOT_test_image/).
7. Following output files will be generated, 
    - _trackingmovie.TIF_ contains the tracked segments for visual inspection 
    - _segmentedmovie.TIF_ The time series with the overlaid centers of objects detected (either using RegionMax or centroid), 
    - _trajectories.txt_ It contains the trajectory information as,  
    `ObjID, Frame,	X,  Y,  Length (pixels), Time (frames)`  
    The `time` is in _frame number_ unit, and the `XY` positions in _pixel_ unit, `length` corresponds to the long-axis length of the object.
    - _untracked.txt_ All object coordinates in x and y-coordinates with frame numbers.  
