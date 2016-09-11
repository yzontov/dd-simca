function DDSGUI(varargin)

%variables
TrainingSet= [];
NewSet= [];

TrainingSetName= [];
NewSetName= [];

TrainingSetLabels= [];
NewSetLabels= [];

Model = [];
Task = [];

ModelName = [];

%get version year
v = version('-release');
vyear = str2double(v(1:4));

%gui
f = figure;
set(f,'Visible','off');
set(f, 'MenuBar', 'none');
set(f, 'ToolBar', 'none');
set(f,'name','DD-SIMCA Toolbox','numbertitle','off');
set(f, 'Resize', 'off');
set(f, 'Position', [100 100 600 500]);

mh = uimenu(f,'Label','Help');
uimenu(mh,'Label','Help on DDSimca class','Callback', @DDSimcaHelp_Callback);
uimenu(mh,'Label','Help on DDSTask class','Callback', @DDSTaskHelp_Callback);

if vyear < 2014
tgroup = uitabgroup('v0','Parent', f);
else
tgroup = uitabgroup('Parent', f);
end

%Model
if vyear < 2014
tab_model = uitab('v0', 'Parent', tgroup, 'Title', 'Model');
else
tab_model = uitab('Parent', tgroup, 'Title', 'Model');
end

uipanel('Parent', tab_model, 'Title', 'Data sets', 'Position', [0.02   0.84   0.46  0.16]);
uipanel('Parent', tab_model, 'Title', 'Preprocessing', 'Position', [0.02   0.71   0.46  0.12]);
uipanel('Parent', tab_model, 'Title', 'Model parameters', 'Position', [0.02   0.3   0.46  0.39]);
uipanel('Parent', tab_model, 'Title', 'Results and statistics', 'Position', [0.50   0.05   0.48  0.70]);
grpCurrentModelModel = uipanel('Parent', tab_model, 'Title', 'Current model', 'Position', [0.50   0.76   0.48  0.24]);


if(ispc)
%data
%btnTrainingSet
uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Training Set',...
    'Position', [20 420 100 30], 'callback', @btnTrainingSet_Callback);
lblTrainingSet = uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Not selected', ...
 'Position', [20 402 100 15]) ;

btnTrainingSetLabels = uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Labels',...
    'Position', [160 420 100 30], 'callback', @btnTrainingSetLabels_Callback,'Enable','off');
lblTrainingSetLabels = uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Not selected', ...
 'Position', [160 402 100 15]) ;

%preprocessing
chkCentering = uicontrol('Parent', tab_model, 'Style', 'checkbox', 'String', 'Centering',...
    'Position', [20 345 100 30], 'callback', @Input_ModelParameters);
chkScaling = uicontrol('Parent', tab_model, 'Style', 'checkbox', 'String', 'Scaling',...
    'Position', [160 345 100 30], 'callback', @Input_ModelParameters);

%model params
%lblNumPC
uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Number of Principal Components', ...
 'Position', [20 280 200 15], 'HorizontalAlignment', 'left'); 
tbNumPC = uicontrol('Parent', tab_model, 'Style', 'edit', 'String', '2',...
    'Value',1, 'Position', [180 280 100 20], 'BackgroundColor', 'white', 'callback', @Input_NumPC);

%lblAlpha
uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Type I error (alpha)', ...
 'Position', [20 250 100 15], 'HorizontalAlignment', 'left'); 
tbAlpha = uicontrol('Parent', tab_model, 'Style', 'edit', 'String', '0.01',...
    'Value',1, 'Position', [180 250 100 20], 'BackgroundColor', 'white', 'callback', @Input_Alpha);
chkAlphaAuto = uicontrol('Parent', tab_model, 'Style', 'checkbox', 'String', 'Auto',...
    'Position', [130 250 50 15], 'callback', @chkAlphaAuto_Callback, 'Value', 0);

%lblGamma
uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Outlier significance (gamma)', ...
 'Position', [20 220 100 15], 'HorizontalAlignment', 'left'); 
tbGamma = uicontrol('Parent', tab_model, 'Style', 'edit', 'String', '0.01',...
    'Value',1, 'Position', [180 220 100 20], 'BackgroundColor', 'white', 'callback', @Input_Gamma);

%lblArea
uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Type of aceptance area', ...
 'Position', [20 190 150 15], 'HorizontalAlignment', 'left'); 
ddlArea = uicontrol('Parent', tab_model, 'Style', 'popupmenu', 'String', {'chi-square','rectangle'},...
    'Value',1, 'Position', [180 180 100 30], 'BackgroundColor', 'white', 'callback', @Input_ModelParameters);

%lblEstimation
uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Method of estimation', ...
 'Position', [20 160 100 15], 'HorizontalAlignment', 'left'); 
ddlEstimation = uicontrol('Parent', tab_model, 'Style', 'popupmenu', 'String', {'classic','robust'},...
    'Value',1, 'Position', [180 150 100 30], 'BackgroundColor', 'white', 'callback', @Input_ModelParameters);

end

if(ismac)
%data
%btnTrainingSet
uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Training Set',...
    'Position', [20 410 100 30], 'callback', @btnTrainingSet_Callback);
lblTrainingSet = uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Not selected', ...
 'Position', [20 392 100 15]) ;

btnTrainingSetLabels = uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Labels',...
    'Position', [160 410 100 30], 'callback', @btnTrainingSetLabels_Callback,'Enable','off');
lblTrainingSetLabels = uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Not selected', ...
 'Position', [160 392 100 15]) ;

%preprocessing
chkCentering = uicontrol('Parent', tab_model, 'Style', 'checkbox', 'String', 'Centering',...
    'Position', [20 335 100 30], 'callback', @Input_ModelParameters);
chkScaling = uicontrol('Parent', tab_model, 'Style', 'checkbox', 'String', 'Scaling',...
    'Position', [160 335 100 30], 'callback', @Input_ModelParameters);

%model params
%lblNumPC
uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Number of Principal Components', ...
 'Position', [20 280 200 15], 'HorizontalAlignment', 'left'); 
tbNumPC = uicontrol('Parent', tab_model, 'Style', 'edit', 'String', '2',...
    'Value',1, 'Position', [180 280 80 20], 'BackgroundColor', 'white', 'callback', @Input_NumPC);

%lblAlpha
uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Type I error (alpha)', ...
 'Position', [20 250 100 15], 'HorizontalAlignment', 'left'); 
tbAlpha = uicontrol('Parent', tab_model, 'Style', 'edit', 'String', '0.01',...
    'Value',1, 'Position', [180 250 80 20], 'BackgroundColor', 'white', 'callback', @Input_Alpha);
chkAlphaAuto = uicontrol('Parent', tab_model, 'Style', 'checkbox', 'String', 'Auto',...
    'Position', [130 250 50 15], 'callback', @chkAlphaAuto_Callback, 'Value', 0);

%lblGamma
uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Outlier significance (gamma)', ...
 'Position', [20 220 100 25], 'HorizontalAlignment', 'left'); 
tbGamma = uicontrol('Parent', tab_model, 'Style', 'edit', 'String', '0.01',...
    'Value',1, 'Position', [180 220 80 20], 'BackgroundColor', 'white', 'callback', @Input_Gamma);

%lblArea
uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Type of aceptance area', ...
 'Position', [20 190 150 15], 'HorizontalAlignment', 'left'); 
ddlArea = uicontrol('Parent', tab_model, 'Style', 'popupmenu', 'String', {'chi-square','rectangle'},...
    'Value',1, 'Position', [170 190 100 20], 'BackgroundColor', 'white', 'callback', @Input_ModelParameters);

%lblEstimation
uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Method of estimation', ...
 'Position', [20 160 100 15], 'HorizontalAlignment', 'left'); 
ddlEstimation = uicontrol('Parent', tab_model, 'Style', 'popupmenu', 'String', {'classic','robust'},...
    'Value',1, 'Position', [170 160 100 20], 'BackgroundColor', 'white', 'callback', @Input_ModelParameters);

end

%Prediction
if vyear < 2014
tab_predict = uitab('v0','Parent', tgroup, 'Title', 'Prediction');
else
tab_predict = uitab('Parent', tgroup, 'Title', 'Prediction');
end

group_predict_data = uipanel('Parent', tab_predict, 'Title', 'Data set');
set(group_predict_data, 'Position', [0.02   0.84   0.46  0.16]);
uipanel('Parent', tab_predict, 'Title', 'Results and statistics', 'Position', [0.50   0.05   0.48  0.70]);
grpCurrentModelPredict = uipanel('Parent', tab_predict, 'Title', 'Current model', 'Position', [0.50   0.76   0.48  0.24]);

if(ispc)
%btnNewSet
uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'New Set',...
    'Position', [20 420 100 30], 'callback', @btnNewSet_Callback);
lblNewSet = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', 'Not selected', ...
 'Position', [20 402 100 15]) ;

btnNewSetLabels = uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'Labels',...
    'Position', [160 420 100 30], 'callback', @btnNewSetLabels_Callback,'Enable','off');
lblNewSetLabels = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', 'Not selected', ...
 'Position', [160 402 100 15]) ;

chkCalcAlpha = uicontrol('Parent', tab_predict, 'Style', 'checkbox', 'String', 'Calculate type I error (Alpha)',...
    'Position', [20 360 200 30], 'Value', 0, 'callback', @chkCalcAlpha_Callback, 'Visible', 'on');

%lblBeta
uicontrol('Parent', tab_predict, 'Style', 'text', 'String', 'Predefined Type II error (Beta)', ...
 'Position', [20 340 200 15], 'HorizontalAlignment', 'left', 'Visible', 'on'); 
tbBeta = uicontrol('Parent', tab_predict, 'Style', 'edit', 'String', '0.01', 'Visible', 'on','Enable','off',...
    'Value',1, 'Position', [178 340 80 20], 'BackgroundColor', 'white', 'callback', @Input_Beta);

lblWarning = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 310 250 30], 'HorizontalAlignment', 'left', 'Visible', 'on', 'ForegroundColor', [196, 84, 0]/255 );

end

if(ismac)
%btnNewSet
uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'New Set',...
    'Position', [20 410 100 30], 'callback', @btnNewSet_Callback);
lblNewSet = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', 'Not selected', ...
 'Position', [20 392 100 15]) ;

btnNewSetLabels = uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'Labels',...
    'Position', [160 410 100 30], 'callback', @btnNewSetLabels_Callback,'Enable','off');
lblNewSetLabels = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', 'Not selected', ...
 'Position', [160 392 100 15]) ;

chkCalcAlpha = uicontrol('Parent', tab_predict, 'Style', 'checkbox', 'String', 'Calculate type I error (Alpha)',...
    'Position', [20 340 200 30], 'Value', 0, 'callback', @chkCalcAlpha_Callback, 'Visible', 'on');

%lblBetaCaption
uicontrol('Parent', tab_predict, 'Style', 'text', 'String', 'Predefined Type II error (Beta)', ...
 'Position', [20 320 200 15], 'HorizontalAlignment', 'left', 'Visible', 'on'); 
tbBeta = uicontrol('Parent', tab_predict, 'Style', 'edit', 'String', '0.01', 'Visible', 'on','Enable','off',...
    'Value',1, 'Position', [178 320 80 20], 'BackgroundColor', 'white', 'callback', @Input_Beta);

lblWarning = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 300 250 30], 'HorizontalAlignment', 'left', 'Visible', 'on', 'ForegroundColor', [196, 84, 0]/255 );

end

lblBeta = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 280 150 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblSamples = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 260 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblExtremes = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 240 200 15], 'HorizontalAlignment', 'left', 'Visible', 'on');


%Options
if vyear < 2014
tab_settings = uitab('v0','Parent', tgroup, 'Title', 'Options');
else
tab_settings = uitab('Parent', tgroup, 'Title', 'Options');
end

group_set_plot = uipanel('Parent', tab_settings, 'Title', 'Plot');
set(group_set_plot, 'Position', [0.02   0.84   0.96  0.16]);

if(ispc)
%lblAxesTransform
uicontrol('Parent', tab_settings, 'Style', 'text', 'String', 'Axes transformation', ...
 'Position', [20 420 100 15]); 
ddlAxesTransform = uicontrol('Parent', tab_settings, 'Style', 'popupmenu', 'String', {'ln(1+x/x0)','none'},...
    'Value',1, 'Position', [160 410 100 30], 'BackgroundColor', 'white');

chkShowLabelsTraining = uicontrol('Parent', tab_settings, 'Style', 'checkbox', 'String', 'Show sample labels for Training Set',...
    'Position', [300 430 200 30], 'Value', 1);

chkShowLabelsNew = uicontrol('Parent', tab_settings, 'Style', 'checkbox', 'String', 'Show sample labels for New Set',...
    'Position', [300 400 200 30], 'Value', 1);
end

if(ismac)
%lblAxesTransform
uicontrol('Parent', tab_settings, 'Style', 'text', 'String', 'Axes transformation', ...
 'Position', [20 410 100 15]); 
ddlAxesTransform = uicontrol('Parent', tab_settings, 'Style', 'popupmenu', 'String', {'ln(1+x/x0)','none'},...
    'Value',1, 'Position', [160 400 100 30], 'BackgroundColor', 'white');

chkShowLabelsTraining = uicontrol('Parent', tab_settings, 'Style', 'checkbox', 'String', 'Show sample labels for Training Set',...
    'Position', [300 420 200 20], 'Value', 1);

chkShowLabelsNew = uicontrol('Parent', tab_settings, 'Style', 'checkbox', 'String', 'Show sample labels for New Set',...
    'Position', [300 400 200 20], 'Value', 1);
end

%actions 
if(ispc)
btnModelBuild = uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Build',...
    'Position', [20 100 100 30], 'callback', @btnModelBuild_Callback,'Enable','off');
btnModelGraph = uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Acceptance plot',...
    'Position', [20 60 100 30], 'callback', @btnModelGraph_Callback,'Enable','off');
btnModelGraphExtreme = uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Extreme plot',...
    'Position', [20 20 100 30], 'callback', @btnModelGraphExtreme_Callback,'Enable','off');
btnModelSave = uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Save model',...
    'Position', [160 100 100 30], 'callback', @btnModelSave_Callback,'Enable','off');
%btnModelLoad
uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Load model',...
    'Position', [160 60 100 30], 'callback', @btnModelLoad_Callback);
%btnModelClear
uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Clear',...
    'Position', [160 20 100 30], 'callback', @btnModelClear_Callback);

btnPredictBuild = uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'Decide',...
    'Position', [20 300 100 30], 'callback', @btnPredictBuild_Callback,'Enable','off');
btnPredictGraph = uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'Acceptance plot',...
    'Position', [20 260 100 30], 'callback', @btnPredictGraph_Callback,'Enable','off');
btnPredictSave = uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'Save results',...
    'Position', [160 300 100 30], 'callback', @btnPredictSave_Callback,'Enable','off');
%btnPredictLoad
uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'Load results',...
    'Position', [160 260 100 30], 'callback', @btnPredictLoad_Callback);
%btnPredictClear
uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'Clear',...
    'Position', [160 220 100 30], 'callback', @btnPredictClear_Callback);

end

if(ismac)
btnModelBuild = uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Build',...
    'Position', [20 100 100 30], 'callback', @btnModelBuild_Callback,'Enable','off');
btnModelGraph = uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Acceptance plot',...
    'Position', [20 60 100 30], 'callback', @btnModelGraph_Callback,'Enable','off');
btnModelGraphExtreme = uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Extreme plot',...
    'Position', [20 20 100 30], 'callback', @btnModelGraphExtreme_Callback,'Enable','off');
btnModelSave = uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Save model',...
    'Position', [160 100 100 30], 'callback', @btnModelSave_Callback,'Enable','off');
%btnModelLoad
uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Load model',...
    'Position', [160 60 100 30], 'callback', @btnModelLoad_Callback);
%btnModelClear
uicontrol('Parent', tab_model, 'Style', 'pushbutton', 'String', 'Clear',...
    'Position', [160 20 100 30], 'callback', @btnModelClear_Callback);

btnPredictBuild = uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'Decide',...
    'Position', [20 280 100 30], 'callback', @btnPredictBuild_Callback,'Enable','off');
btnPredictGraph = uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'Acceptance plot',...
    'Position', [20 240 100 30], 'callback', @btnPredictGraph_Callback,'Enable','off');
btnPredictSave = uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'Save results',...
    'Position', [160 280 100 30], 'callback', @btnPredictSave_Callback,'Enable','off');
%btnPredictLoad
uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'Load results',...
    'Position', [160 240 100 30], 'callback', @btnPredictLoad_Callback);
%btnPredictClear
uicontrol('Parent', tab_predict, 'Style', 'pushbutton', 'String', 'Clear',...
    'Position', [160 200 100 30], 'callback', @btnPredictClear_Callback);

end

%indicators
if(ispc)
%lblHasModel = uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Model created', ...
% 'Position', [160 430 100 20], 'Visible', 'off', 'ForegroundColor', [0, 153, 0]/255);  
lblHasTrainingExtremes = uicontrol('Parent', tab_model, 'Style', 'text', 'HorizontalAlignment', 'left', ...
    'String', 'Extreme objects in Training set!', 'Visible', 'off', ...
 'Position', [310 315 160 20], 'ForegroundColor', [196, 84, 0]/255);  
lblHasTrainingOutliers = uicontrol('Parent', tab_model, 'Style', 'text', 'HorizontalAlignment', 'left', ...
    'String', 'Outliers in Training set!', 'Visible', 'off', ...
 'Position', [310 300 140 20], 'ForegroundColor', [255, 0, 0]/255); 

lblCurrentAlpha = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 440 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentPC = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [400 440 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentArea = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 420 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentEstimation = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [400 420 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentPreprocessing = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 400 250 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblDOF_SD = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 380 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblDOF_OD = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [400 380 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblTrainingSetName = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 361 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');

lblCurrentAlpha2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 440 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentPC2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [400 440 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentArea2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 420 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentEstimation2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [400 420 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentPreprocessing2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 400 250 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblDOF_SD2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 380 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblDOF_OD2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [400 380 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblTrainingSetName2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 361 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');

end

if(ismac)
%lblHasModel = uicontrol('Parent', tab_model, 'Style', 'text', 'String', 'Model created', ...
% 'Position', [160 420 100 20], 'Visible', 'off', 'ForegroundColor', [0, 153, 0]/255);  
lblHasTrainingExtremes = uicontrol('Parent', tab_model, 'Style', 'text', 'HorizontalAlignment', 'left', ...
    'String', 'Extreme objects in Training set!', 'Visible', 'off', ...
 'Position', [310 310 150 20], 'ForegroundColor', [196, 84, 0]/255);  
lblHasTrainingOutliers = uicontrol('Parent', tab_model, 'Style', 'text', 'HorizontalAlignment', 'left', ...
    'String', 'Outliers in Training set!', 'Visible', 'off', ...
 'Position', [310 295 140 20], 'ForegroundColor', [255, 0, 0]/255); 

lblCurrentAlpha = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 425 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentPC = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [400 425 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentArea = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 407 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentEstimation = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [400 407 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentPreprocessing = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 389 250 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblDOF_SD = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 369 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblDOF_OD = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [400 369 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblTrainingSetName = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 350 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');

lblCurrentAlpha2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 425 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentPC2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [400 425 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentArea2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 407 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentEstimation2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [400 407 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblCurrentPreprocessing2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 389 250 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblDOF_SD2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 369 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblDOF_OD2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [400 369 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblTrainingSetName2 = uicontrol('Parent', tab_predict, 'Style', 'text', 'String', '', ...
 'Position', [310 350 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');

end

lblModelSamples = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 280 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblModelExtremes = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 260 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');
lblModelOutliers = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 240 100 15], 'HorizontalAlignment', 'left', 'Visible', 'on');

lblModelCalculatedAlpha = uicontrol('Parent', tab_model, 'Style', 'text', 'String', '', ...
 'Position', [310 220 140 15], 'HorizontalAlignment', 'left', 'Visible', 'on');



set(f,'Visible','on');

function DDSimcaHelp_Callback(~, ~)
 doc DDSimca
end

function DDSTaskHelp_Callback(~, ~)
 doc DDSTask   
end

function chkAlphaAuto_Callback(self, ~)
val = get(self, 'Value');
if val == 1
    set(tbAlpha, 'Enable', 'off');
else
    set(tbAlpha, 'Enable', 'on');
end

    set(btnModelGraph,'Enable','off');
    set(btnModelGraphExtreme,'Enable','off');
    set(btnModelSave,'Enable','off');

end

function btnModelBuild_Callback(~, ~)
   
h = waitbar(0, 'Please wait...');
try
%set(h, 'WindowStyle','modal', 'CloseRequestFcn','');

numPC = str2double(get(tbNumPC,'string'));
Model = DDSimca(TrainingSet, numPC);
Model.AcceptancePlotTitle = TrainingSetName;
waitbar(1/10, h);
Model.Gamma = str2double(get(tbGamma,'string'));
waitbar(2/10, h);
border_types = get(ddlArea,'string');
selected_type = get(ddlArea,'value');
Model.BorderType = border_types{selected_type};
waitbar(2/10, h);
estimation_methods = get(ddlEstimation,'string');
selected_method = get(ddlEstimation,'value');
Model.EstimationMethod = estimation_methods{selected_method};
waitbar(3/10, h);
if get(chkCentering,'Value') == 1
   Model.Centering = true;
else
   Model.Centering = false; 
end
waitbar(4/10, h);
if get(chkScaling,'Value') == 1
   Model.Scaling = true; 
else
   Model.Scaling = false; 
end
waitbar(5/10, h);
if get(chkScaling,'Value') == 1
   Model.Scaling = true; 
else
   Model.Scaling = false; 
end
waitbar(6/10, h);
alphaAuto = get(chkAlphaAuto, 'Value');
if alphaAuto == 1
    Model.AutoAlpha = true;
    set(lblModelCalculatedAlpha, 'string', sprintf('Calculated Alpha: %f', Model.Alpha));
else
    Model.AutoAlpha = false;
    Model.Alpha = str2double(get(tbAlpha,'string'));
    set(lblModelCalculatedAlpha, 'String', '');
end
waitbar(7/10, h);
if get(ddlAxesTransform, 'Value') == 1
    Model.Transformation = 'log';
else
    Model.Transformation = 'none';
end
waitbar(8/10, h);
%set(lblHasModel,'string','Model created');
%set(lblHasModel,'Visible','on');

if ~isempty(Model.HasExtremes) && Model.HasExtremes
set(lblHasTrainingExtremes,'Visible','on');
else
set(lblHasTrainingExtremes,'Visible','off');
end
waitbar(9/10, h);
if ~isempty(Model.HasOutliers) && Model.HasOutliers
set(lblHasTrainingOutliers,'Visible','on');
else
set(lblHasTrainingOutliers,'Visible','off');  
end

[n,~] = size(Model.TrainingSet);
set(lblModelSamples,'string', sprintf('Samples: %d', n));
set(lblModelExtremes,'string', sprintf('Extremes: %d', sum(Model.ExtremeObjects)));
set(lblModelOutliers,'string', sprintf('Outliers: %d', sum(Model.OutlierObjects)));
    
set(btnModelGraph,'Enable','on');
set(btnModelGraphExtreme,'Enable','on');
set(btnModelSave,'Enable','on');

if ~isempty(NewSet)
set(btnPredictBuild,'Enable','on');
end
waitbar(10/10, h);
%pause(.5);
delete(h);

if (~isempty(Model))
set(lblCurrentAlpha,'string', sprintf('Alpha: %f', Model.Alpha));
set(lblCurrentPC,'string', sprintf('PCs: %d', Model.numPC));
set(lblCurrentArea,'string', sprintf('Area: %s', Model.BorderType));
set(lblCurrentEstimation,'string', sprintf('Method: %s', Model.EstimationMethod));

set(lblCurrentAlpha2,'string', sprintf('Alpha: %f', Model.Alpha));
set(lblCurrentPC2,'string', sprintf('PCs: %d', Model.numPC));
set(lblCurrentArea2,'string', sprintf('Area: %s', Model.BorderType));
set(lblCurrentEstimation2,'string', sprintf('Method: %s', Model.EstimationMethod));

preproc = '';
if(Model.Centering)
   preproc = 'Centering';
end
if(Model.Scaling)
   preproc = 'Scaling'; 
end

if(Model.Centering && Model.Scaling)
   preproc = 'Autoscaling';
end

if(~Model.Centering && ~Model.Scaling)
   preproc = 'None';
end

set(lblCurrentPreprocessing,'string', sprintf('Preprocessing: %s', preproc));
set(lblCurrentPreprocessing2,'string', sprintf('Preprocessing: %s', preproc));

set(lblDOF_SD,'string', sprintf('DoF (SD): %d', Model.DoF_SD));
set(lblDOF_OD,'string', sprintf('DoF (OD): %d', Model.DoF_OD));
set(lblDOF_SD2,'string', sprintf('DoF (SD): %d', Model.DoF_SD));
set(lblDOF_OD2,'string', sprintf('DoF (OD): %d', Model.DoF_OD));
set(lblTrainingSetName,'string', sprintf('Training Set: %s', Model.AcceptancePlotTitle));
set(lblTrainingSetName2,'string', sprintf('Training Set: %s', Model.AcceptancePlotTitle));


set(grpCurrentModelModel,'Title', 'Current model');
set(grpCurrentModelPredict,'Title', 'Current model');

end

catch ME
delete(h);
warndlg(ME.message);
end
end

function btnModelGraph_Callback(~, ~)
val = get(ddlAxesTransform, 'Value');
if val == 1
    Model.Transformation = 'log';
else
    Model.Transformation = 'none';
end
if (get(chkShowLabelsTraining, 'Value'))
    if(~isempty(TrainingSetLabels))
       Model.Labels = TrainingSetLabels; 
    end
    Model.ShowLabels = true;
else
    Model.ShowLabels = false;
end

Model.AcceptancePlot();
end

function btnModelGraphExtreme_Callback(~, ~)
val = get(ddlAxesTransform, 'Value');
if val == 1
    Model.Transformation = 'log';
else
    Model.Transformation = 'none';
end
Model.ExtremePlot();
end

function btnPredictSave_Callback(~, ~)
if ~isempty(Task)

prompt = {'Enter result name:'};
dlg_title = 'Save model';
num_lines = 1;
def = {'DDS_TASK'};

answer = inputdlg(prompt,dlg_title,num_lines,def);

if ~isempty(answer)
try
assignin('base', answer{1}, Task)
catch
  errordlg('The invalid characters have been replaced. Please use only latin characters, numbers and underscore!');
  assignin('base',regexprep(answer{1}, '[^a-zA-Z0-9_]', '_'),Task);  
end
end

end
end

function btnModelSave_Callback(~, ~)
if ~isempty(Model)

prompt = {'Enter model name:'};
dlg_title = 'Save model';
num_lines = 1;
def = {'DD_SIMCA'};
answer = inputdlg(prompt,dlg_title,num_lines,def);

if ~isempty(answer)
try
assignin('base', answer{1}, Model)
catch
  errordlg('The invalid characters have been replaced. Please use only latin characters, numbers and underscore!');
  assignin('base',regexprep(answer{1}, '[^a-zA-Z0-9_]', '_'), Model);  
end
end

end
end

function chkCalcAlpha_Callback(src, ~)

val = get(src,'Value');
if val == 1
    set(tbBeta,'Enable','on');
    
    if ~isempty(Task)
        Task.CalculateBeta = false;
    end
else
    set(tbBeta,'Enable','off');
    
    if ~isempty(Task)
        Task.CalculateBeta = true;
    end
end
    
end

function btnNewSetLabels_Callback(~, ~)

 tvar = uigetvariables({'Pick a cell array of strings:'}, ...
        'InputDimensions',1, 'InputTypes',{'string'});
if ~isempty(tvar)
    labels = tvar{1};
    [n,m]=size(labels);
    
    [n1,~]=size(NewSet);
    
    if ((n ~= n1) || (n == n1 && m ~= 1))
        warndlg(sprintf('Labels should be a [%d x 1] cell array of strings', n1));
    else
       set(lblNewSetLabels,'string', sprintf('[%d x %d]', n, m));
       NewSetLabels = labels; 
       if ~isempty(Task)
           Task.Labels = labels;
       end
    end
 
end   
    
end

function btnTrainingSetLabels_Callback(~, ~)

 tvar = uigetvariables({'Pick a cell array of strings:'}, ...
        'InputDimensions',1, 'InputTypes',{'string'});
if ~isempty(tvar)
    labels = tvar{1};
    [n,m]=size(labels);
    
    [n1,~]=size(TrainingSet);
    
    if ((n ~= n1) || (n == n1 && m ~= 1))
        warndlg(sprintf('Labels should be a [%d x 1] cell array of strings', n1));
    else
        set(lblTrainingSetLabels,'string', sprintf('[%d x %d]', n, m));
        TrainingSetLabels = labels;
        if ~isempty(Model)
           Model.Labels = labels;
       end
    end
end   
     
    
end

function ClearCurrentModel()

set(btnPredictGraph,'Enable','off');
set(btnPredictSave,'Enable','off');

set(lblWarning,'String','');
set(lblBeta,'String','');

set(lblSamples,'string', '');
set(lblExtremes,'string', '');
    
set(lblHasTrainingExtremes,'Visible','off');
set(lblHasTrainingOutliers,'Visible','off');    
    
Model = [];
ModelName = [];
set(btnPredictBuild,'Enable','off');

set(grpCurrentModelModel,'Title', 'Current model');
set(grpCurrentModelPredict,'Title', 'Current model');

set(lblWarning,'String','');
set(lblBeta,'String','');

set(lblModelSamples,'string', '');
set(lblModelExtremes,'string', '');
set(lblModelOutliers,'string', '');
set(lblModelCalculatedAlpha,'string', '');

set(lblCurrentAlpha,'string', '');
set(lblCurrentPC,'string', '');
set(lblCurrentArea,'string', '');
set(lblCurrentEstimation,'string', '');
set(lblCurrentPreprocessing,'string', '');

set(lblCurrentAlpha2,'string', '');
set(lblCurrentPC2,'string', '');
set(lblCurrentArea2,'string', '');
set(lblCurrentEstimation2,'string', '');
set(lblCurrentPreprocessing2,'string', '');

set(lblDOF_SD,'string', '');
set(lblDOF_OD,'string', '');
set(lblDOF_SD2,'string', '');
set(lblDOF_OD2,'string', '');

set(lblTrainingSetName,'string', '');
set(lblTrainingSetName2,'string', '');
    
end

function LoadModel()
   set(btnModelBuild,'Enable','on');
 set(btnTrainingSetLabels,'Enable','on');
%set(lblHasModel,'string','Model loaded');
%set(lblHasModel,'Visible','on');

set(btnModelGraph,'Enable','on');
set(btnModelGraphExtreme,'Enable','on');
set(btnModelSave,'Enable','on');

if (Model.ShowLabels)
set(chkShowLabelsTraining,'Value',1);
else
set(chkShowLabelsTraining,'Value',1);     
end

if (~isempty(Model.Labels))
TrainingSetLabels = Model.Labels;
[n1, m1] = size(TrainingSetLabels);
set(lblTrainingSetLabels,'string',sprintf('[%d x %d]', n1, m1));
end
    
if ~isempty(NewSet)
set(btnPredictBuild,'Enable','on');
end

if ~isempty(Model.numPC)
set(tbNumPC,'string', num2str(Model.numPC));
else
set(tbNumPC,'string', '2');    
end

if ~isempty(Model.Alpha)
set(tbAlpha,'string', num2str(Model.Alpha));
else
set(tbAlpha,'string', '0.01');    
end

if ~isempty(Model.Gamma)
set(tbGamma,'string', num2str(Model.Gamma));
else
set(tbGamma,'string', '0.01');    
end

if ~isempty(Model.BorderType)
if strcmp(Model.BorderType, 'chi-square')
set(ddlArea,'value', 1);
else
set(ddlArea,'value', 2);
end
end

if ~isempty(Model.EstimationMethod)
if strcmp(Model.EstimationMethod, 'classic')
set(ddlEstimation,'value', 1);
else
set(ddlEstimation,'value', 2);
end
end

if Model.Centering
set(chkCentering,'Value',1)
else
set(chkCentering,'Value',0)
end

if Model.Scaling
set(chkScaling,'Value',1)
else
set(chkScaling,'Value',0)    
end

if ~isempty(Model.TrainingSet)
TrainingSet = Model.TrainingSet;
[n,m]=size(TrainingSet);
set(lblTrainingSet,'string', sprintf('[%d x %d]', n, m));
else
TrainingSet = [];
set(lblTrainingSet,'string', 'Not selected');
end

if ~isempty(Model.HasExtremes) && Model.HasExtremes
set(lblHasTrainingExtremes,'Visible','on');
else
set(lblHasTrainingExtremes,'Visible','off');
end

if ~isempty(Model.HasOutliers) && Model.HasOutliers
set(lblHasTrainingOutliers,'Visible','on');
else
set(lblHasTrainingOutliers,'Visible','off');  
end  

set(lblModelSamples,'string', sprintf('Samples: %d', n));
set(lblModelExtremes,'string', sprintf('Extremes: %d', sum(Model.ExtremeObjects)));
set(lblModelOutliers,'string', sprintf('Outliers: %d', sum(Model.OutlierObjects)));

if (~isempty(Model))
set(lblCurrentAlpha,'string', sprintf('Alpha: %f', Model.Alpha));
set(lblCurrentPC,'string', sprintf('PCs: %d', Model.numPC));
set(lblCurrentArea,'string', sprintf('Area: %s', Model.BorderType));
set(lblCurrentEstimation,'string', sprintf('Method: %s', Model.EstimationMethod));

set(lblCurrentAlpha2,'string', sprintf('Alpha: %f', Model.Alpha));
set(lblCurrentPC2,'string', sprintf('PCs: %d', Model.numPC));
set(lblCurrentArea2,'string', sprintf('Area: %s', Model.BorderType));
set(lblCurrentEstimation2,'string', sprintf('Method: %s', Model.EstimationMethod));

preproc = '';
if(Model.Centering)
   preproc = 'Centering';
end
if(Model.Scaling)
   preproc = 'Scaling'; 
end

if(Model.Centering && Model.Scaling)
   preproc = 'Autoscaling';
end

if(~Model.Centering && ~Model.Scaling)
   preproc = 'None';
end

set(lblCurrentPreprocessing,'string', sprintf('Preprocessing: %s', preproc));
set(lblCurrentPreprocessing2,'string', sprintf('Preprocessing: %s', preproc));

set(lblDOF_SD,'string', sprintf('DoF (SD): %d', Model.DoF_SD));
set(lblDOF_OD,'string', sprintf('DoF (OD): %d', Model.DoF_OD));
set(lblDOF_SD2,'string', sprintf('DoF (SD): %d', Model.DoF_SD));
set(lblDOF_OD2,'string', sprintf('DoF (OD): %d', Model.DoF_OD));
set(lblTrainingSetName,'string', sprintf('Training Set: %s', Model.AcceptancePlotTitle));
set(lblTrainingSetName2,'string', sprintf('Training Set: %s', Model.AcceptancePlotTitle));

if Model.AutoAlpha
    set(tbAlpha,'Enable','off');
    set(chkAlphaAuto,'Value',1)
    set(lblModelCalculatedAlpha, 'string', sprintf('Calculated Alpha: %f', Model.Alpha));
else
    set(tbAlpha,'Enable','on');
    set(chkAlphaAuto,'Value',0)
    set(lblModelCalculatedAlpha, 'String', '');
end

if (~isempty(Model.AcceptancePlotTitle))
TrainingSetName = Model.AcceptancePlotTitle;
end

end

end

function btnModelLoad_Callback(~, ~)

[tvar, tvarname] = uigetvariables({'Pick a DDSimca object:'}, ...
        'ValidationFcn',{@(x) isa(x, 'DDSimca')});
if ~isempty(tvar)  
Model = tvar{1};
LoadModel();
ModelName = tvarname{1};
set(grpCurrentModelModel,'Title', sprintf('Current model - %s', ModelName));
set(grpCurrentModelPredict,'Title', sprintf('Current model - %s', ModelName));

end
end

function btnModelClear_Callback(~, ~)

    set(tbNumPC,'string', '2');
set(tbAlpha,'string', '0.01');
set(tbGamma,'string', '0.01');

set(ddlArea,'value', 1);
set(ddlEstimation,'value', 1);

set(chkCentering,'Value',0);
set(chkScaling,'Value',0);

    %set(lblHasModel,'Visible','off');     


set(btnModelBuild,'Enable','off');
set(btnModelGraph,'Enable','off');
set(btnModelGraphExtreme,'Enable','off');
set(btnModelSave,'Enable','off');

set(lblTrainingSet,'string', 'Not selected'); 
TrainingSet= [];
TrainingSetLabels = [];
TrainingSetName = [];
set(lblTrainingSetLabels,'string', 'Not selected'); 
set(btnTrainingSetLabels,'Enable','off');

ClearCurrentModel();
    
end

function btnPredictBuild_Callback(~, ~)
h = waitbar(0, 'Please wait...');
try

Task = DDSTask(Model, NewSet);
Task.AcceptancePlotTitle = NewSetName;

if get(chkCalcAlpha,'Value')
    Task.CalculateBeta = ~get(chkCalcAlpha,'Value');
    Task.Beta = str2double(get(tbBeta,'string'));
end

waitbar(1/5, h);    
set(btnPredictSave,'Enable','on');
set(btnPredictSave,'Enable','on');
set(btnPredictGraph,'Enable','on');
waitbar(2/5, h);
if ~isempty(Task.Warning)
    set(lblWarning,'String', ['Warning: ' Task.Warning]);
else
    set(lblWarning,'String','');
end
waitbar(3/5, h);
if ~isempty(Task.Beta) && isempty(Task.Alpha)
    set(lblBeta,'String', ['Beta: ' num2str(Task.Beta)]);
end
    if ~isempty(Task.Alpha) && ~isempty(Task.Beta)
        set(lblBeta,'String', ['Calculated Alpha: ' num2str(Task.Alpha)]);
    end
    
    if isempty(Task.Alpha) && isempty(Task.Beta)
        set(lblBeta,'String','');
    end

waitbar(4/5, h);
[n,~] = size(Task.NewSet);
set(lblSamples,'string', sprintf('Samples: %d', n));
set(lblExtremes,'string', sprintf('External objects: %d', sum(Task.ExternalObjects)));
waitbar(5/5, h);
delete(h);
catch ME
delete(h);
warndlg(ME.message);
end
end

function btnPredictGraph_Callback(~, ~)
val = get(ddlAxesTransform, 'Value');
if val == 1
    Task.Transformation = 'log';
else
    Task.Transformation = 'none';
end
if (get(chkShowLabelsNew, 'Value'))
    if(~isempty(NewSetLabels))
       Task.Labels = NewSetLabels; 
    end
    Task.ShowLabels = true;
else
    Task.ShowLabels = false;
end
Task.AcceptancePlot();
end

function btnPredictLoad_Callback(~, ~)
[tvar, tvarname] = uigetvariables({'Pick a DDSTask object:'}, ...
        'ValidationFcn',{@(x) isa(x, 'DDSTask')});
if ~isempty(tvar)
Task = tvar{1};
set(btnPredictGraph,'Enable','on');
set(btnPredictSave,'Enable','on');
set(btnNewSetLabels,'Enable','on');

%if(Task.CalculateBeta)
%set(chkCalcAlpha,'Value',1);
if ~isempty(Task.Warning)
    set(lblWarning,'String', ['Warning: ' Task.Warning]);
else
    set(lblWarning,'String','');
end

if ~isempty(Task.Beta) && isempty(Task.Alpha)
    set(lblBeta,'String', ['Beta: ' num2str(Task.Beta)]);
end
    if ~isempty(Task.Alpha) && ~isempty(Task.Beta)
        if ~isempty(Task.Beta)
            set(tbBeta,'String', num2str(Task.Beta));
        end
        set(lblBeta,'String', ['Calculated Alpha: ' num2str(Task.Alpha)]);
        set(chkCalcAlpha, 'value', 1);
        set(tbBeta,'Enable', 'on');
    end
    
    if isempty(Task.Alpha) && isempty(Task.Beta)
        set(lblBeta,'String','');
        set(tbBeta,'Enable', 'off');
    end

%else
    %set(chkCalcAlpha,'Value',0);
%end

NewSet = Task.NewSet;
[n,m]=size(NewSet);
set(lblNewSet,'string', sprintf('[%d x %d]', n, m));
Model = Task.Model;
if ~isempty(Model)
LoadModel();
set(btnPredictBuild,'Enable','on');
ModelName = sprintf('%s.Model',tvarname{1});
set(grpCurrentModelModel,'Title', sprintf('Current model - %s', ModelName));
set(grpCurrentModelPredict,'Title', sprintf('Current model - %s', ModelName));
end

[n,~] = size(Task.NewSet);
set(lblSamples,'string', sprintf('Samples: %d', n));
set(lblExtremes,'string', sprintf('External objects: %d', sum(Task.ExternalObjects)));

if (Task.ShowLabels)
set(chkShowLabelsNew,'Value',1);
else
set(chkShowLabelsNew,'Value',1);     
end

if (~isempty(Task.Labels))
NewSetLabels = Task.Labels;
[n1, m1] = size(NewSetLabels);
set(lblNewSetLabels,'string', sprintf('[%d x %d]', n1, m1));
end

if (~isempty(Task.AcceptancePlotTitle))
NewSetName = Task.AcceptancePlotTitle;
end

end
end

function btnTrainingSet_Callback(~, ~)

[tvar, tvarname] = uigetvariables({'Pick a matrix:'}, ...
        'InputDimensions',2, 'InputTypes',{'numeric'});
if ~isempty(tvar)
    training_set = cell2mat(tvar);
    [n,m]=size(training_set);
    set(lblTrainingSet,'string', sprintf('[%d x %d]', n, m));
    TrainingSet = training_set;
    set(btnModelBuild,'Enable','on');
    set(btnTrainingSetLabels,'Enable','on');
    
    TrainingSetLabels = [];
    set(lblTrainingSetLabels,'string', 'Not selected'); 
    TrainingSetName = tvarname{1};
    
    set(btnModelGraph,'Enable','off');
    set(btnModelGraphExtreme,'Enable','off');
    set(btnModelSave,'Enable','off');
    
    ClearCurrentModel();
end
end

function btnNewSet_Callback(~, ~)

[tvar, tvarname] = uigetvariables({'Pick a matrix:'}, ...
        'InputDimensions',2, 'InputTypes',{'numeric'});
if ~isempty(tvar)
    new_set = cell2mat(tvar);
    [n,m]=size(new_set);
    set(lblNewSet,'string', sprintf('[%d x %d]', n, m));
    NewSet = new_set;
    set(btnNewSetLabels,'Enable','on');
    if ~isempty(Model)
    set(btnPredictBuild,'Enable','on');
    set(btnPredictSave,'Enable','off');
    set(btnPredictGraph,'Enable','off');
    end
    
    NewSetLabels = [];
    set(lblNewSetLabels,'string', 'Not selected'); 
    NewSetName = tvarname{1};
end
end

function btnPredictClear_Callback(~, ~)

set(btnPredictBuild,'Enable','off');
set(btnPredictGraph,'Enable','off');
set(btnPredictSave,'Enable','off');
set(lblNewSet,'string', 'Not selected'); 
NewSet= [];
Task = [];

set(lblWarning,'String','');
set(lblBeta,'String','');

set(lblSamples,'string', '');
set(lblExtremes,'string', '');

NewSetLabels = [];
NewSetName = [];
set(lblNewSetLabels,'string', 'Not selected'); 
set(btnNewSetLabels,'Enable','off');
set(tbBeta,'String', '0.01');
set(tbBeta,'Enable', 'off');
set(chkCalcAlpha,'value', 0);
end

function Input_NumPC(src, ~)
str=get(src,'String');
if(~isempty(TrainingSet))

XTest = TrainingSet;
if get(chkCentering,'Value') == 1
mean_ = mean(TrainingSet);
XTest = bsxfun(@minus, XTest, mean_);
end

if get(chkScaling,'Value') == 1
temp = std(TrainingSet,0,1);
temp(temp == 0) = 1;
std_ = temp;
XTest = bsxfun(@rdivide, XTest, std_);
end

[~,D,~] = svd(XTest);

vmax = rank(D);

val = str2double(str);
if isempty(val) || isnan(val)
    set(src,'string','2');
    warndlg('Input must be numerical');
else
    if val < 1 || val > vmax
       set(src,'string','2');
       warndlg(sprintf('Number of Principal Components should be greater than 0 and less than %d!', vmax+1));
    else
       set(btnModelGraph,'Enable','off');
       set(btnModelGraphExtreme,'Enable','off');
       set(btnModelSave,'Enable','off');
       
       ClearCurrentModel();
    end
end

else
    set(src,'string','2');
    warndlg('You should select the Training Set first!');
end

end

function Input_Alpha(src, ~)
str=get(src,'String');
val = str2double(str);
if isempty(val) || isnan(val)
    set(src,'string','0.01');
    warndlg('Input must be numerical');
else
    if val <= 0 || val >= 1
       set(src,'string','0.01');
       warndlg('Type I error (Alpha) should be greater than 0 and less than 1!');
    else
       set(btnModelGraph,'Enable','off');
       set(btnModelGraphExtreme,'Enable','off');
       set(btnModelSave,'Enable','off');
       
       ClearCurrentModel();
    end
end
end

function Input_Gamma(src, ~)
str=get(src,'String');
val = str2double(str);
if isempty(val) || isnan(val)
    set(src,'string','0.01');
    warndlg('Input must be numerical');
else
    if val <= 0 || val >= 1
       set(src,'string','0.01');
       warndlg('Outlier significance (Gamma) should be greater than 0 and less than 1!');
    else
       set(btnModelGraph,'Enable','off');
       set(btnModelGraphExtreme,'Enable','off');
       set(btnModelSave,'Enable','off');
       
       ClearCurrentModel();
    end    
end
end

function Input_ModelParameters(src, ~)
val = get(src,'Value');
if ~isempty(val) && ~isnan(val)
    set(btnModelGraph,'Enable','off');
    set(btnModelGraphExtreme,'Enable','off');
    set(btnModelSave,'Enable','off');
    
    ClearCurrentModel();
end
end

function Input_Beta(src, ~)
str=get(src,'String');
val = str2double(str);
if isempty(val) || isnan(val)
     set(src,'string','0.01');
     warndlg('Input must be numerical!');
else
     if val <= 0 || val >= 1
        set(src,'string','0.01');
        warndlg('Type II error (Beta) should be greater than 0 and less than 1!'); 
     end
end
end

end





function [varout,varoutnames] = uigetvariables(prompts,varargin)
% uigetvariables   Open variable selection dialog box
%
% VARS = uigetvariables(PROMPTS) creates a dialog box that returns
% variables selected from the base workspace. PROMPTS is a cell array of
% strings, with one entry for each variable you would like the user to
% select.  VARS is a cell array containing the selected variables.  Each
% element of VARS corresponds with the selection for the same element of
% PROMPTS.
%
% If the user hits CANCEL, dismisses the dialog, or doesn't select a value
% for any of the variables, VARS is an empty cell array. If the user does
% not select a variable for a given prompt (but not all promptes), the
% value in VARS for that prompt is an empty array.
%
% [VARS, VARNAMES] = uigetvariables(PROMPTS) also returns the names of the
% selected variables. VARNAMES is a cell string the same length as VARS,
% with empty strings corresponding to empty values of VARS.
%
% VARS = uigetvariables(PROMPTS,'ParameterName',ParameterValue) specifies an
% optional parameter value. Enter parameters as one or more name-value
% pairs. 
%
% Specify zero or more of the following name/value pairs when calling
% uigetvariables:
%
% 'Introduction'       Introductory String.   Default: No introduction (empty)
%
% A string of introductory text to guide the user in making selections in
% the dialog. The text is wrapped automatically to fit in the dialog.
%
%
% 'InputTypes'         Restrict variable types.  Default: No restrictions ('any')
%
% A cell array of strings of the same length as PROMPTS, each entry
% specifies the allowable type of variables for each prompt. InputTypes
% restricts the types of the variables which can be selected for each
% prompt.  
%
% The elements of TYPES may be any of the following:
%     any        Any type. Use this if you don't care.
%     numeric    Any numeric type, as determined by isnumeric
%     logical    Logical
%     string     String or cell array of strings
%
%
% 'InputDimensions'    Restrict variable dimensionality.  Default: No restrictions (Inf)
%
% A numeric array of the same length as PROMPTS, with each element specifying the
% required dimensionality of the variables for the corresponding element of
% PROMPTS. NDIMENSIONS works a little different from ndims, in that it
% allows you to distinguish among scalars, vectors, and matrices.
% 
% Allowable values are:
%
%      Value         Meaning
%      ------------  ----------
%      Inf           Any size.  Use this if you don't care, or want more than one allowable size
%      0             Scalar  (1x1)
%      1             Vector  (1xN or Nx1)
%      2             Matrix  (NxM)
%      3 or higher   Specified number of dimensions
%
%
% 'SampleData'         Sample data.  Default: No sample data
%
% A cell array of the same length as PROMPTS, with each element specifying
% the value of sample data for the corresponding prompt. When SampleData is
% specified, the dialog includes a button that allows the user to use your
% sample data instead of having to provide their own data.  This can make
% it easier for users to get a feel for how to use your app.  
%
%
% 'ValidationFcn'      Validation function, to restrict allowed variables.  Default: No restrictions
%
% ValidationFcn is a cell array of function handles of the same length as
% PROMPTS, or a single function handle.   If VALFCN is a single function
% handle, it is applied to every prompt.  Use a cell array of function
% handles to specify a unique validation function for each prompt. The
% validation function handles are used to validation functions which are
% used to determine which variables are valid for each prompt.  The
% validation functions must return true if a variable passes the validation
% or false if the variable does not.  Syntax of the validation functions
% must be:      TF = VALFCN(variable)
%
%
% Examples
%
% % Put some sample data in your base workspace:
% scalar1 = 1;
% str1 = 'a string';
% cellstr1 = {'a string';'in a cell'};cellstr2 = {'another','string','in','a','cell'};    
% cellstr3 = {'1','2';,'3','4'}
% vector1 = rand(1,10); vector2 = rand(5,1);
% array1  = rand(5,5); array2 = rand(5,5); array3 = rand(10,10);
% threed1 = rand(3,4,5);
% fourd1 = rand(1,2,3,4);
%
% % Select any two variables from entire workspace
% tvar = uigetvariables({'Please select any variable','And another'});
%
% % Return the names of the selected variables, too.
% [tvar, tvarnames] = uigetvariables({'Please select any variable','And another'});
% 
% % Include introductory text
% tvar = uigetvariables({'Please select any variable','And another'}, ...
%        'Introduction',['Here are some very detailed directions about '...
%        'how you should use this dialog.  Pick some variables.']);
% 
% % Control type of variables
% tvar = uigetvariables({'Pick a number:','Pick a string:','Pick another number:'}, ...
%        'InputTypes',{'numeric','string','numeric'});
% 
% % Control size of variables.
% tvar = uigetvariables({'Pick a scalar:','Pick a vector:','Pick a matrix:'}, ...
%        'InputDimensions',[0 1 2]);
% 
% % Control type and size of variables
% tvar = uigetvariables({'Pick a scalar:','Pick a string','Pick a 4D array'}, ...
%        'InputTypes',{'numeric','string','numeric'}, ...
%        'InputDimensions',[0 Inf 4]);
%
% tvar = uigetvariables({'Pick a scalar:','Pick a string vector','Pick a 3D array'}, ...
%        'InputTypes',{'numeric','string','numeric'}, ...
%        'InputDimensions',[0 1 3]);
% 
% % Include sample data
% sampleX = 1:10;
% sampleY = 10:-1:1;
% tvar = uigetvariables({'x:','y:'}, ...
%        'SampleData',{sampleX,sampleY});
%
% % Custom validation functions (Advanced)
% tvar = uigetvariables({'Pick a number:','Any number:','One more, please:'}, ...
%        'Introduction','Use a custom validation function to require every input to be numeric', ...
%        'ValidationFcn',@isnumeric);
%
% tvar = uigetvariables({'Pick a number:','Pick a cell string:','Pick a 3D array:'}, ...
%        'ValidationFcn',{@isnumeric,@iscellstr,@(x) ndims(x)==3});
% 
% % No variable found
% tvar = uigetvariables('Pick a 6D numeric array:','What if there is no valid data?','ValidationFcn',@(x) isnumeric(x)&&ndims(x)==6);
%
% % Specify defaults
% x = 2;
% y = 3;
% tvar = uigetvariables({'Please select any variable','And another'}', ...
%        'SampleData',{x,y});

% Michelle Hirsch
% Michelle.Hirsch@mathworks.com

% Copyright (c) 2013, The MathWorks, Inc.
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the The MathWorks, Inc. nor the names
%       of its contributors may be used to endorse or promote products derived
%       from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

% Input parsing
% Use inputParser to:
% * Manage Name-Value Pairs
% * Do some first-pass input validation
isStringOrCellString = @(c) iscellstr(c);
%isStringOrCellString = @(c) iscellstr(c)||ischar(c);
p = inputParser;
p.CaseSensitive = false;

v = version('-release');
vyear = str2double(v(1:4));

addRequired(p,'prompts',isStringOrCellString);

if vyear < 2014
addParamValue(p,'Introduction','',@ischar);
addParamValue(p,'InputTypes',[],isStringOrCellString);
addParamValue(p,'InputDimensions',[],@isnumeric);
addParamValue(p,'ValidationFcn',[],@(c) iscell(c)|| isa(c,'function_handle'));
addParamValue(p,'SampleData',[])
else
addParameter(p,'Introduction','',@ischar);
addParameter(p,'InputTypes',[],isStringOrCellString);
addParameter(p,'InputDimensions',[],@isnumeric);
addParameter(p,'ValidationFcn',[],@(c) iscell(c)|| isa(c,'function_handle'));
addParameter(p,'SampleData',[])    
end

parse(p,prompts,varargin{:})

intro = p.Results.Introduction;
types = p.Results.InputTypes;
ndimensions = p.Results.InputDimensions;
sampleData = p.Results.SampleData;
valfcn = p.Results.ValidationFcn;

% Allow for single prompt as string
if ~iscell(prompts)
    prompts = {prompts};
end
nPrompts = length(prompts);

% Default ndimensions is Inf
if isempty(ndimensions)
    % User didn't specify any dimensions
    ndimensions = inf(1,nPrompts);
end

% Did user specify SampleData
if ~isempty(sampleData)
    
    % Allow for single prompt case as not cell
    if ~iscell(sampleData)
        sampleData = {sampleData};
    end
    includeSampleData = true;
else
    includeSampleData = false;
end


%% Process Validation functions
% Three options:
% * Nothing
% * Convenience string
% * Function handle
if isempty(types) && isempty(valfcn)
    % User didn't specify any validation

    types = cellstr(repmat('any',nPrompts,1)); % This will get converted later

    specifiedValidationFcn = false;
elseif ~isempty(types)
    % User specified types.  Assume didn't specify valfcn

    % Allow for single prompt with single type as a string
    if ischar(types)  
        types = {types};
    end
    
    specifiedValidationFcn = false;
elseif ~isempty(valfcn)
    % User specified validation function

    % If specified as a single function handle, repeat for each input
    if ~iscell(valfcn)
        temp = cell(nPrompts,1);
        temp = cellfun(@(f) valfcn,temp,'UniformOutput',false);
        valfcn = temp;
    end
    
    specifiedValidationFcn = true;
end




%% 
% If the user didn't specify the validation function, we will build it for them.  
if ~specifiedValidationFcn
      
    % Base validation functions to choose from:
    isscalarfcn = @(var) numel(var)==1;
    isvectorfcn = @(var) length(size(var))==2&&any(size(var)==1)&&~isscalarfcn(var);
    isndfcn     = @(var,dim) ndims(var)==dim && ~isscalar(var) && ~isvectorfcn(var);
    
    isanyfcn = @(var) true;                 % What an optimistic function! :)
    isnumericfcn = @(var) isnumeric(var);
    islogicalfcn = @(var) islogical(var);
    isstringfcn = @(var) iscellstr(var);%@(var) ischar(var) | iscellstr(var);
    istablefcn = @(var) istable(var);

    valfcn = cell(1,nPrompts);
    
    for ii=1:nPrompts
        
        switch types{ii}
            case 'any'
                valfcn{ii} = isanyfcn;
            case 'numeric'
                valfcn{ii} = isnumericfcn;
            case 'logical'
                valfcn{ii} = islogicalfcn;
            case 'string'
                valfcn{ii} = isstringfcn;
            case 'table'
                valfcn{ii} = istablefcn;
            otherwise
                valfcn{ii} = isanyfcn;
        end
                
        switch ndimensions(ii)
            case 0    % 0 - scalar
                valfcn{ii} = @(var) isscalarfcn(var) & valfcn{ii}(var);
            case 1    % 1 - vector
                valfcn{ii} = @(var) isvectorfcn(var) & valfcn{ii}(var);
            case Inf  % Inf - Any shape
                valfcn{ii} = @(var) isanyfcn(var) & valfcn{ii}(var);
            otherwise % ND
                valfcn{ii} = @(var) isndfcn(var,ndimensions(ii)) & valfcn{ii}(var);
        end
    end
end


%% Get list of variables in base workspace
allvars = evalin('base','whos');
nVars = length(allvars);
varnames = {allvars.name};
vartypes = {allvars.class};
varsizes = {allvars.size};


% Convert variable sizes from numbers:
% [N M], [N M P], ... etc
% to text:
% NxM, NxMxP
varsizes = cellfun(@mat2str,varsizes,'UniformOutput',false);
%too lazy for regexp.  Strip off brackets
varsizes = cellfun(@(s) s(2:end-1),varsizes,'UniformOutput',false);
% replace blank with x
varsizes = strrep(varsizes,' ','x');

vardisplay = strcat(varnames,' (',varsizes,{' '},vartypes,')');

%% Build list of variables for each prompt
% Also include one that's prettied up a bit for display, which has an extra
% first entry saying '(select one)'.  This allows for no selection, for
% optional input arguments.
validVariables = cell(nPrompts,1);
validVariablesDisplay = cell(nPrompts,1);     

for ii=1:nPrompts
    % turn this into cellfun once I understand what I'm doing.
    assignin('base','validationfunction_',valfcn{ii})
    validVariables{ii} = cell(nVars,1);
    validVariablesDisplay{ii} = cell(nVars+1,1);
    t = false(nVars,1);
    for jj = 1:nVars
        t(jj) = evalin('base',['validationfunction_(' varnames{jj} ');']);
    end
    if any(t)   % Found at least one variable
        validVariables{ii} = varnames(t);
        validVariablesDisplay{ii} = vardisplay(t);
        validVariablesDisplay{ii}(2:end+1) = validVariablesDisplay{ii};
        validVariablesDisplay{ii}{1} = '(select one)';
    else
        validVariables{ii} = '(no valid variables)';
        validVariablesDisplay{ii} = '(no valid variables)';
    end
    
    evalin('base','clear validationfunction_')
end


%% Compute layout
voffset = 1;  % Vertical offset
hoffset = 2;  % Horizontal offset
nudge = .1;
maxStringLength = max(cellfun(@(s) length(s),prompts));
componentWidth = max([maxStringLength, 50]);
componentHeight = 1;

% Buttons
buttonHeight = 1.8;
buttonWidth = 16;


% Wrap intro string.  Need to do this now to include height in dialog.
% Could use textwrap, which comes with MATLAB, instead of linewrap. This would just take a
% bit more shuffling around with the order I create and size things.
if ~isempty(intro)
    intro = linewrap(intro,componentWidth);
    introHeight = length(intro);    % Intro is now an Nx1 cell string
else
    introHeight = 0;
end


dialogWidth = componentWidth + 2*hoffset;
dialogHeight = 2*nPrompts*(componentHeight+voffset) + buttonHeight + voffset + introHeight;

if includeSampleData  % Make room for the use sample data button
    dialogHeight = dialogHeight + 2*voffset*buttonHeight;
end


% Component positions, starting from bottom of figure
popuppos = [hoffset 2*voffset+buttonHeight componentWidth componentHeight];
textpos = popuppos; textpos(2) = popuppos(2)+componentHeight+nudge;

%% Build figure
hFig = dialog('Units','Characters','WindowStyle','modal','Name','Select variable(s)','CloseRequestFcn',@nestedCloseReq);
 
pos = get(hFig,'Position');
set(hFig,'Position',[pos(1:2) dialogWidth dialogHeight])
uicontrol('Parent',hFig,'style','Pushbutton','Callback',@nestedCloseReq,'String','OK',    'Tag','OK','Units','characters','Position',[dialogWidth-2*hoffset-2*buttonWidth .5*voffset buttonWidth buttonHeight]);
uicontrol('Parent',hFig,'style','Pushbutton','Callback',@nestedCloseReq,'String','Cancel','Tag','Cancel','Units','characters','Position',[dialogWidth-hoffset-buttonWidth  .5*voffset buttonWidth buttonHeight]);


for ii=nPrompts:-1:1
    uicontrol('Parent',hFig,'Style','text',     'Units','char','Position',textpos, 'String',prompts{ii},'HorizontalAlignment','left');
    hPopup(ii) = uicontrol('Parent',hFig,'Style','popupmenu','Units','char','Position',popuppos,'String',validVariablesDisplay{ii},'UserData',validVariables{ii});
    
    % Set up positions for next go round
    popuppos(2) = popuppos(2) + 1.5*voffset + 2*componentHeight;
    textpos(2) = textpos(2) + 1.5*voffset + 2*componentHeight;
end

if includeSampleData
    uicontrol('Parent',hFig, ...
        'style','Pushbutton', ...
        'Callback',@nestedCloseReq, ...   
        'String','Use Sample Data',    ...
        'Tag','UseSampleData', ...
        'Units','characters', ...
        'Position',[hoffset popuppos(2) dialogWidth-2*hoffset buttonHeight]); % Steal the vertical position from popup position settign.
end

if ~isempty(intro)
    intropos = [hoffset dialogHeight-introHeight-1 componentWidth introHeight+.5];
    uicontrol('Parent',hFig,'Style','text','Units','Characters','Position',intropos, 'String',intro,'HorizontalAlignment','left');
end

uiwait(hFig)


    function nestedCloseReq(obj,~)
        % How did I get here?
        % If pressed OK, get variables.  Otherwise, don't.
        
        if strcmp(get(obj,'type'),'uicontrol') && strcmp(get(obj,'Tag'),'OK')
            
            for ind=1:nPrompts
                str = get(hPopup(ind),'UserData');  % Store real variable name here
                val = get(hPopup(ind),'Value')-1;   % Remove offset to account for '(select one)' as initial entry
                
                if val==0 % User didn't select anything
                    varout{ind} = [];
                    varoutnames{ind} = '';
                elseif strcmp(str,'(no valid variables)')
                    varout{ind} = [];
                    varoutnames{ind} = '';
                else
                    varout{ind} = evalin('base',str{val});
                    varoutnames{ind} = str{val}; % store name of selected workspace variable
                end
                
            
            end
            
            % if user clicked OK, but didn't select any variable, give same
            % return as if hit cancel
            if all(cellfun(@isempty,varout))
                varout = {};
                varoutnames = {};
            end
        elseif strcmp(get(obj,'type'),'uicontrol') && strcmp(get(obj,'Tag'),'UseSampleData')
            % Put sample data in return.  Return empty names
            varout = sampleData;
            varoutnames = cell(size(sampleData)); varoutnames(:) = {''};
            
        else  % Cancel - return empty
            varout = {};
            varoutnames = {};
        end
        
        delete(hFig)
        
    end
end

function c = linewrap(s, maxchars)
%LINEWRAP Separate a single string into multiple strings
%   C = LINEWRAP(S, MAXCHARS) separates a single string into multiple
%   strings by separating the input string, S, on word breaks.  S must be a
%   single-row char array. MAXCHARS is a nonnegative integer scalar
%   specifying the maximum length of the broken string.  C is a cell array
%   of strings.
%
%   C = LINEWRAP(S) is the same as C = LINEWRAP(S, 80).
%
%   Note: Words longer than MAXCHARS are not broken into separate lines.
%   This means that C may contain strings longer than MAXCHARS.
%
%   This implementation was inspired a blog posting about a Java line
%   wrapping function:
%   http://joust.kano.net/weblog/archives/000060.html
%   In particular, the regular expression used here is the one mentioned in
%   Jeremy Stein's comment.
%
%   Example
%       s = 'Image courtesy of Joe and Frank Hardy, MIT, 1993.'
%       c = linewrap(s, 40)
%
%   See also TEXTWRAP.

% Steven L. Eddins
% $Revision: 1.7 $  $Date: 2006/02/08 16:54:51 $

% http://www.mathworks.com/matlabcentral/fileexchange/9909-line-wrap-a-string
% Copyright (c) 2009, The MathWorks, Inc.
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without 
% modification, are permitted provided that the following conditions are 
% met:
% 
%     * Redistributions of source code must retain the above copyright 
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright 
%       notice, this list of conditions and the following disclaimer in 
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the The MathWorks, Inc. nor the names 
%       of its contributors may be used to endorse or promote products derived 
%       from this software without specific prior written permission.
%       
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
% POSSIBILITY OF SUCH DAMAGE.

narginchk(1, 2);

bad_s = ~ischar(s) || (ndims(s) > 2) || (size(s, 1) ~= 1);      %#ok<ISMAT>
if bad_s
   error('S must be a single-row char array.');
end

if nargin < 2
   % Default value for second input argument.
   maxchars = 80;
end

% Trim leading and trailing whitespace.
s = strtrim(s);

% Form the desired regular expression from maxchars.
exp = sprintf('(\\S\\S{%d,}|.{1,%d})(?:\\s+|$)', maxchars, maxchars);

% Interpretation of regular expression (for maxchars = 80):
% '(\\S\\S{80,}|.{1,80})(?:\\s+|$)'
%
% Match either a non-whitespace character followed by 80 or more
% non-whitespace characters, OR any sequence of between 1 and 80
% characters; all followed by either one or more whitespace characters OR
% end-of-line.

tokens = regexp(s, exp, 'tokens').';

% Each element if the cell array tokens is single-element cell array 
% containing a string.  Convert this to a cell array of strings.
get_contents = @(f) f{1};
c = cellfun(get_contents, tokens, 'UniformOutput', false);

% Remove trailing whitespace characters from strings in c.  This can happen
% if multiple whitespace characters separated the last word on a line from
% the first word on the following line.
c = deblank(c);

end


