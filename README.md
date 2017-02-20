Data-Driven SIMCA Tool 
===========================================

DDSimca is a Matlab tool which implements the [Data-Driven SIMCA](http://onlinelibrary.wiley.com/doi/10.1002/cem.2506/full) method. It also provides means for preprocessing and visual analysis of [chemometric](http://en.wikipedia.org/wiki/Chemometrics) data. The tool is build using object-oriented approach and consists of several Matlab classes, thus it can be applied in a Matlab script. It also provdes a graphical user interface (GUI) which simplifies the use of the tool. The tool was first presented at the [Tenth Winter Symposium on Chemometrics (WSC-10)](http://wsc.chemometrics.ru/wsc10/).


How to install
--------------

To get the latest release plase use [GitHub sources](https://github.com/yzontov/dd-simca/). You can [download](https://github.com/yzontov/dd-simca/releases) a zip-file with source and install it in your Matlab environment.
To use the tool you should set the Matlab current directory to the folder, which contains the tool main classes ("DDSGUI.m", "DDSimca.m", "DDSTask.m" and the "help" folder) or add this folder to the Matlab Path.
By default it is assumed that none of the built-in Matlab functions on the user's machine has been overloaded due to the use of a third-party toolbox.
Before you start working with the GUI you should load the data for analysis into the MATLAB workspace.