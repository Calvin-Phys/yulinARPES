# Basic Data Structrue and Loader for ARPES Data from Beamlines

This project aims to build the basic ARPES data structures and loaders in Matlab, providing elementary data process capabilities. The data types were written in Matlab `class`, intergrating the data and data process operations.

Main Features:
- Load data file `DataLoader/loader_UI.m`
- Basic data process
    - Display
    - K-space convert
    - Set contrast
    - Truncate
    - Smooth / Second Derivative

Data types included:
- Cut / Corelevel `DataType/OxA_CUT.m`
- Map `DataType/OxA_MAP.m`
- Photon energy scan (Kz) `DataType/OxA_KZ.m`
- Real space scan `DataType/OxA_RSImage.m`

Supported Beamlines:
- Diamond Light Sourse io5 `DataLoader/load_DLS_io5.m`
- Swiss Light Source ULTRA/ADRESS `DataLoader/load_PSI_ULTRA.m`
- Elettra Spectromicroscopy `DataLoader/load_Elettra_Spectromicroscopy.m`
- Beamlines with Scienta Omicron Analyser `DataLoader/load_scienta_txt_fast.m`, `DataLoader/load_scienta_zip_fast.m`
- Bessy One-Square .ibw `load_Bessy_IBW.m`

Usage / Getting Started:
- This package is still under development.
- It is meant to be become a basic component of the early ARPES data process software `yulinARPES`.


---
Contact: Cheng Peng <cheng.peng@physics.ox.ac.uk>

Group web: [Chen Group | ARPES at Oxford](http://www.arpes.org.uk)

