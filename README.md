Data-Driven SIMCA Tool 
===========================================

DDSimca is a Matlab tool which implements the [Data-Driven SIMCA](http://onlinelibrary.wiley.com/doi/10.1002/cem.2506/full) method. The tool is built using object-oriented approach and consists of several Matlab classes. It can be used as a Matlab script as well as a graphical user interface (GUI).  The latter variant materially simplifies the analysis. The Tool was first presented at the [Tenth Winter Symposium on Chemometrics, WSC-10](http://wsc.chemometrics.ru/wsc10/) (P09. Zontov Y., Pomerantsev A., Rodionova O. "Software implementation of the Data-Driven SIMCA method").

Cite As
-----------

Y.V. Zontov, O.Ye. Rodionova, S.V. Kucheryavskiy, A.L. Pomerantsev,
DD-SIMCA – A MATLAB GUI tool for data driven SIMCA approach, Chemometrics and Intelligent Laboratory Systems, Volume 167, 2017,
Pages 23-28, ISSN 0169-7439, DOI:[10.1016/j.chemolab.2017.05.010](https://doi.org/10.1016/j.chemolab.2017.05.010).

What is new
-----------

In the latest release (1.3) an option to generate [Procrustes cross-validation](https://github.com/svkucheryavski/pcv/) dataset has been implemented.
A history of changes is available [here](NEWS.md)

How to install
--------------

To get the latest release plase use [GitHub sources](https://github.com/yzontov/dd-simca/). You can [download](https://github.com/yzontov/dd-simca/releases) the source as a zip-file and install it in your Matlab environment.
To use the Tool you should set the Matlab current directory to the folder, which contains the Tool main classes ("DDSGUI.m", "DDSimca.m", "DDSTask.m" and the "help" folder) or add this folder to the Matlab Path.
One should load the analyzed data into the MATLAB workspace for working with GUI.