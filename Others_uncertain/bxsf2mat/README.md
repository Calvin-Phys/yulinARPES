# bxsf2mat
This matlab GUI allows you to easily plot band structures that were saved in the XCrysDen .bxsf format.
The GUI was written with GUIDE and is therefore a bit messy. Future releases should provide a purely programatic code. If you would like to help, you are welcome to join the development team.

INSTALLATION
1. Download the repo and add it to your MATLAB path
2. Download matGeom library https://github.com/mattools/matGeom and add it to your MATLAB path

USAGE
This is a quick and dirty description, please extend it if you find the tool useful.
1. start the program by calling quick_bxsf
2. Load the .bxsf file. Make sure that the length of the interpolation vector (given in Angstrom) reaches the the boundary of one Brillouin zone
3. press "plot 3D iso energy surface" to plot the 3D Fermi surface. You can further define other energies than the Fermi energy.
4. for cutting a 2D equal enery surface, press "cut plane kz", which defines the kz plane along which you want to plot subsequently. After defining the kz plane, you can either plot 2D equal energy surfaces via "plot eq energy contours" or band dispersions via "plot E vs k\\".
5. If you want to plot multiple 2D equal energy surfaces or band dispersions simultaniously, you can use "plot contours for multiple kz" and "plot E vs k for multiple kz".

LICENSE
MIT License

Copyright (c) 2017 Niels B.M. Schroeter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
