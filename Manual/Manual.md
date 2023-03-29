# Manual of `yulinARPES`: Chen group's ARPES data process software

This manual is intended to provide a brief introduction to using yulinARPES for processing and visualizing ARPES data. It will guide you through the basic workflow of ARPES data processing and help you become familiar with the software's structure.

Please note that this manual does not cover the principles of ARPES. If you would like to learn more about ARPES, we recommend referring to review articles on the topic, such as:

1. [Sobota, J. A., He, Y., & Shen, Z. X. (2021). Angle-resolved photoemission studies of quantum materials. Reviews of Modern Physics, 93(2), 025006.](https://arxiv.org/abs/2008.02378)
2. [Liu, Chang. Electronic structure of ion arsenic high temperature superconductors studied by angle resolved photoemission spectroscopy. United States. https://doi.org/10.2172/1029553](https://www.osti.gov/biblio/1029553/)

---
## Preparetion

To use the latest version of the software, please download the latest versions of `yulinARPES` and `ARPES_OX`, and add their folders to the Matlab path. Additionally, make sure that any necessary toolboxes are installed. Once the folders have been added and the toolboxes installed, restart Matlab to ensure the changes are properly registered.

To launch the software, enter the following command into the Matlab command line:

```
data_browser_demo_v32
```

Press Enter to run the command, and the main window of the software will appear as shown below.
![Main Window](./pictures/main_window.png)

---
## Loader ARPES data

The program can load raw data into the workspace. To load data, click on 
```
Loader -> Load ARPES Data (object)
```

This will open the Loader window, as shown below:
![Loader Window](./pictures/loader.png)

You can select and load multiple files at once by using the file selection dialog.

> **What are the differences between the new and old loader?**
> 
> 1. The new loader differs from the old loader in that it loads raw data into pre-defined class objects, whereas the old loader only produces structs. By using pre-defined class objects, the new loader can integrate more information and provide processing methods for the data.
> 2. One notable improvement of the new loader is its enhanced compatibility with Dropbox. It can now access online Dropbox folders without any disruptions and selectively download desired data files.
> 3. Additionally, the new loader can remember the last path it opened, which can save users time and effort when accessing frequently-used directories.
> 
> It is recommended to use the new loader due to its added functionality, but the old loader remains available within the software for those who prefer it.

Once the loading process is finished, click on the list in the main window to refresh it. The newly-loaded data variables will then appear in the list.
![Main Window List](./pictures/main_window_list.png)

---
## Visualisation

After loading the data into the workspace, you can double-click on it to plot the data. For 3D data, it will be plotted along the z direction by default. To change this, you can right-click on the plot and select 
```
plot -> plot along x/y/z.
```

The data plot window will look like this:
![Plot](./pictures/plot.png)

You can:
- adjust the color map range by unchecking the `Auto Clim` checkbox and using the sliders to set the minimum and maximum percentages. To change the contrast, adjust the `Gamma` slider.
- change the color map by selecting a new option from the drop-down list. To flip the color map, check or uncheck the `Flip` checkbox.

If you are working with 3D data, you can also:
- change the position along the axis that you are plotting by using the top slider. Additionally, you can adjust the integration range by entering a value in the `Width` field.

### Energy and Momentum Distribution Curve (EDC/MDC)

To view the EDC and MDC of a cut, click on the `ARPES Tools` menu and select `EDC/MDC`. 
```
ARPES Tools -> EDC/MDC
```
This will open the EDC and MDC windows alongside the plot window, as shown below:
![EDCMDC](./pictures/EDCMDC.png)

You can move the solid-line crosshair to change the integration area, and move the dashed-line crosshair to change the integration range.

### Image Interpolation

If the resolution of the cut is not sufficient, you can turn on the interpolation of the plot by clicking on
```
ARPES Tools -> Interpolate
```
This will improve the visualization of the data. 

Here is an example (left without interpolation, right with interpolation):
![Interpolation](./pictures/Interpolate.png)

### Mass plot

To plot a 3D data slice by slice, you can use the Mass Plot function. First, click on `New Plot` and select `Mass Plot`.
```
New Plot -> Mass Plot
```

![mass plot](./pictures/mass_plot1.png)

Next, enter the desired number of columns, rows, and the position array. This will generate a large figure that displays the 3D data slice by slice.

![mass plot](./pictures/mass_plot2.png)

---
## K-space convertion

The latest version of the software provides a convenient and accurate way to convert raw data to k-space.

> Before converting to k-space, it's important to ensure that the data has the correct photon energy and work function. If the data was collected in the form of hdf5, this information is already included by the loader program. However, if the data was collected by the Scienta SEC program in the form of .txt or .zip files, you may need to add this information manually.
> - The photon energy and work function are stored in `data.info.photon_energy` and `data.info.workfunction`, respectively.

Now that all necessary information has been obtained, let's go through each type of data.

### Cut

Plot the cut. Click the menu
```
Plot Window -> ARPES Tools -> Crosshair
```
to enable the crosshair. Move the vertical line of the crosshair to the center of symmetry (i.e., K = 0), and then click on `ARPES Tools` and select `K-Convert (object)`.
```
Plot Window -> ARPES Tools -> K-Convert (object)
```
Wait for a moment the variable converted to k-space would appear in the main windows's list.
![kconvert cut](./pictures/kconvert_cut.png)

### Map

Plot the map along z direction, and enable the crosshair. Move the centre of the crosshair to the centre of symmetry (i.e., Kx = Kx = 0), and then click on `ARPES Tools` and select `K-Convert (object)`.
```
Plot Window -> ARPES Tools -> K-Convert (object)
```
![kconvert map](./pictures/kconvert_map.png)

### KZ

To convert a photon energy scan map to k-space, you can first plot it along either the z or x direction. If you plot it along the z direction, move the horizontal line of the crosshair to the vertical center of symmetry (i.e., Ky = 0). Alternatively, if you plot it along the x direction, move the vertical line to the horizontal center (i.e., Kx = 0).

Once the crosshair is properly positioned, click on `ARPES Tools` and select `K-Convert (object)`. 
```
Plot Window -> ARPES Tools -> K-Convert (object)
```
When prompted, input the `inner energy (V0)` of the material. This will convert the data to k-space and add it to the main window's list.

![kconvert kz](./pictures/kconvert_kz.png)

---
## Data process

Basic data process includes:
- truncate data
- normalise data
- fit fermi level and offset

### Data truncate

Truncating data means cutting a selected range of data. To do this, click on the main window's menu and select
```
Main Window -> Process -> Data truncate
```
![truncate](./pictures/truncate.png)

Next, select the target data from the main window's list, input the truncate range, and click `Truncate Data`. A new truncated data will appear in the list.

### Data normalise

Self-normalizing the data can make unclear features of the data more apparent. To do this, click on the main window's menu and select 
```
Main Window -> Process -> Self Normalization.
```
![normalise](./pictures/normalise.png)

Select the target data from the main window's list, select the normalization direction, and click `Normalize`. The normalized data will be produced.

### Fit Fermi level and offset

> Note that the `Fit Fermi Level` feature is only useful for correcting the work function and is not used to convert kinetic energy to binding energy, which is done automatically by the `K-Convert` function.

Open the window by
```
Main Window -> Tool -> Fit Fermi Level
```
![fit Fermi level](./pictures/fit_fermi_level.png)

Then, follow these steps:
1. Find the figure number of the target plot and enter it in the `Figure Number` field of the `FitFermiSurface` window. 
2. Click `Get EDC From Figure` button, and draw a square on the plot to select the integration area.
3. An EDC of the selected area will appear in the `FitFermiSurface` window. Click `Fit FS` button. 
4. Repeat steps 2-3 if the fitting is not satisfactory. When the fitting looks good enough, click `Offset Energy` button. A new variable will appear in the workspace.

## More Data Visualisation

### Brillouin zone and KZ plot

An essential aspect of ARPES data processing is overlaying the theoretical Brillouin zone on the experimental data. This overlay helps confirm the orientation of the measured sample and allows for the observation of band behaviors in different Brillouin zones.

To accomplish this, open the PlotBZ_V1 function by navigating to:
```
Main Window -> Visualization -> Plot BZ
```
![BZ](./pictures/bz.png)

Enter the crystal parameters and plot the Brillouin zone. The BZ can be displayed on the measured data or a blank figure.

For better experiment planning, you can also plot the cut positions in k-space for different photon energies. Open another window by selecting:
```
Main Window -> Visualization -> Plot cut in kz
```
![kz cut](./pictures/kz_cut.png)

Input the necessary parameters in the fields provided and click the Push it button. The line of a cut at a specific photon energy will be plotted in the target figure.

Below is an example of plotting the Brillouin zone and photon energy cuts together:
![bz cut](./pictures/bz_c.png)

Several other functions for visualizing ARPES data are provided below. These operations are designed to be user-friendly and straightforward:

### EDC MDC line plot

```
Main Window -> Visualoztion -> EDC MDC plot
```
![EDC/MDC line plot](./pictures/edcmdc_plot.png)

### Slice 3D plot

```
Main Window -> Visualoztion -> Slice 3D plot
```
![Slice 3D plot](./pictures/slice_plot.png)

### Volume with notch plot

```
Main Window -> Visualoztion -> Volume 3D plot
```
![Volume 3D plot](./pictures/volume_plot.png)

---
## Acknowledgments

This document is designed to consolidate the current data processing software manual and help new group members become familiar with it. Please note that the document is still under development and will be updated periodically.

The software and functions mentioned above are the collective contributions of numerous group members across various generations. This document serves as a valuable resource for preserving the software's usage and bringing together the knowledge and efforts of previous work.

You are encouraged to provide feedback, contribute new functions, or help maintain the software. Your input and collaboration are greatly appreciated.

---
Contact: Cheng Peng <cheng.peng@physics.ox.ac.uk>

Group web: [Chen Group | ARPES at Oxford](http://www.arpes.org.uk)