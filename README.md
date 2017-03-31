Data-Driven SIMCA Tool 
===========================================

DDSimca is a Matlab tool which implements the [Data-Driven SIMCA](http://onlinelibrary.wiley.com/doi/10.1002/cem.2506/full) method. The tool is built using object-oriented approach and consists of several Matlab classes. It can be used as a Matlab script as well as a graphical user interface (GUI).  The latter variant materially simplifies the analysis. The Tool was first presented at the [Tenth Winter Symposium on Chemometrics, WSC-10](http://wsc.chemometrics.ru/wsc10/) (P09. Zontov Y., Pomerantsev A., Rodionova O. "Software implementation of the Data-Driven SIMCA method").

What is new
-----------

In the latest release (1.1) the implementations af all main algorithms used in the Tool have been optimized to improve the performance on large data sets. Also the support of Unix systems was added in the GUI. Taking into account the diversity of existing Unix systems and users's graphical settings, some slight differences are possible in the GUI in different Unix systems.
A history of changes is available [here](NEWS.md)

How to install
--------------

To get the latest release plase use [GitHub sources](https://github.com/yzontov/dd-simca/). You can [download](https://github.com/yzontov/dd-simca/releases) the source as a zip-file and install it in your Matlab environment.
To use the Tool you should set the Matlab current directory to the folder, which contains the Tool main classes ("DDSGUI.m", "DDSimca.m", "DDSTask.m" and the "help" folder) or add this folder to the Matlab Path.
One should load the analyzed data into the MATLAB workspace for working with GUI.