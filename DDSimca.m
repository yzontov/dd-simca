classdef  DDSimca<handle
    %
    %DDSimca class is the implementation of DD-SIMCA
    %method in Matlab scripting language and is part of
    %DD-SIMCA Tool.
    %
    %The software was successfully tested on MATLAB R2010a and R2015b
    %on Microsoft Windows and R2014b on Mac OS.
    %The Tool relies on own implementation of various statistical
    %functions and thus may be used without the MATLAB Statistics Toolbox.
    %
    %The parameters of the model is initially calculated in the constructor
    %when the DDSimca object is created. The model is being automatically
    %rebuilt when one of the following parameters is changed in the calling
    %procedure: TrainingSet, Centering, Scaling, Alpha, Gamma, BorderType,
    %EstimationMethod
    %
    %METHOD
    %Data Driven SIMCA (DD-SIMCA) is a method for
    %the disjoint class modeling
    %that develops a well-known SIMCA approach.
    %The distinctive feature of DD-SIMCA is possibility
    %to introduce (calculate) the misclassification
    %errors theoretically.
    %
    %SIMCA is based on the Principal Component Analysis (PCA)
    %that is applied to the target class training datamatrix.
    %For each object from the training set two distances are
    %calculated.
    %
    %They are the score distance (SD) and the orthogonal
    %distance (OD). The SD characterizes a sample position
    %within the score space, and OD represents the distance
    %of the sample to the score space.
    %It was shown that the distributions of both distances
    %are well approximated by the scaled chi-squared
    %distribution.
    %
    %The scaling factors and numbers of the degrees
    %of freedom (DoF) of these distributions
    %are considered unknown and are estimated using
    %the distance samples obtained from the training set.
    %Given the type I error Alpha the acceptance area
    %may be calculated.
    %
    %In case an alternative class is available,
    %we project it on the PC space and calculate
    %the SD and OD for the alternative class.
    %By using this approach, it is possible to plot
    %every sample and the acceptance area in the
    %coordinates of SD against OD.
    %
    %Additional transformation (e.g. ln(1 + x/x0))
    %may be applied to the axes for better readability
    %of the plot.
    %
    %
    %METHODS
    %
    %Constructor
    %
    %[DDSobj] = DDSimca(TrainingSet,numPC)
    %
    %Creates the new DDSimca object
    %Parameters: TrainingSet - matrix, numPC - number of Principal
    %Components
    %
    %
    %[handle] = AcceptancePlot()
    %
    %The Acceptance plot provides a graphical representation of the
    %decision area, regular samples, extremes and outliers in a
    %user-friendly manner.
    %The method has no parameters.
    %The method returns handle of the plot figure.
    %
    %
    %[handle, N, Nplus, Nminus] = ExtremePlot()
    %
    %The Extreme plot shows the observed vs. the expected
    %number of extreme objects and provides graphical means for
    %the data analysis.
    %The method has no parameters.
    %The method returns handle of the plot figure,
    %N - number of samples with weighted sum of the SD variable the OD
    %variable greater than critical,
    %Nplus - upper boundary for N,
    %Nminus - lower boundary for N
    %
    %
    %PROPERTIES
    %
    %OD - vector (1,n) with normalized squared Euclidian distances for objects from Training Set
    %
    %SD - vector (1,n) with normalized squared Mahalanobis distances for objects from Training Set
    %
    %ExtremeObjects - vector, has the same length as the number of objects in the training set. '1' indicates that the corresponding object is an extreme object.
    %
    %OutlierObjects - vector, has the same length as the number of objects in the training set. '1' indicates that the corresponding object is an outlier object.
    %
    %TrainingSet - training set (matrix)
    %
    %numPC - number of principal components
    %
    %Scores - scores matrix
    %
    %Loadings - loadings matrix
    %
    %EigenMatrix - matrix of eigenvalues from the SVD decomposition
    %
    %SD_mean - mean of normalized squared Mahalanobis distances (SD) for objects
    % from the Training Set
    %
    %OD_mean - mean of normalized squared Euclidian distances (OD) for objects
    % from the Training Set
    %
    %DoF_SD - number of Degrees of Freedom of chi-square distribution of SD
    %
    %DoF_OD - number of Degrees of Freedom of chi-square distribution of OD
    %
    %CriticalLevel - offset values for extreme border
    %
    %OutlierLevel - offset values for outlier border
    %
    %BorderType - the border type in SIMCA plot,
    %values: 'chi-square' (default) | 'rectangle'
    %
    %Centering - Preprocessing of the (Centering)
    %
    %Scaling - Preprocessing (Scaling)
    %
    %Alpha - significance level (type I error)(scalar),
    %must be in the range (0,1]. 
    %
    %Gamma - outlier level (scalar), must be in the range (0,1]
    %
    %Transformation - transformation applied to the SD/OD on the Acceptance
    %plot, values: 'log' (default) | 'none'
    %
    %TrainingSet_mean - mean values of the Training Set (used for preprocessing of Test Set or New Set in the DDSTask class)
    %
    %TrainingSet_std - standard deviation of the Training Set (used for preprocessing of Test Set or New Set)
    %
    %EstimationMethod - type of calculation of SIMCA parameters (string), values: 'classic' (default) | 'robust'; 'classic' - method of moments, 'robust' - robust methods
    %
    %HasExtremes - extreme objects indicator
    %
    %HasOutliers - outlier objects indicator
    %
    %AutoAlpha %automatically calculata significance level (type I error,
    %Alpha) (logical), values = false (default)|true
    %
    %Labels - (optional) a cellarray containing the labels of samples in the Training Set, which are shown on the Acceptance and Extreme plot . 
    %    
    %ShowLabels - Show the labels of samples in the Training Set (logical),
    %values = false (default)|true
    %
    %AcceptancePlotTitle - Additional figure title shown on the acceptance plot
    %
    %
    %USAGE EXAMPLE
    %%Let's suppose TrainingSet is the matrix
    %%containing N spectra on M wavelengths,
    %%which is used as Trainig Set for the model.
    %
    %
    %numPC = 2;% number of principal components
    %
    %
    %%create initial the DD-SIMCA model object
    %Model = DDSimca(TrainingSet, numPC);
    %
    %
    %%tune the model parameters
    %Model.Centering = true; %apply preprocessing
    %Model.Alpha = 0.01; %indicate significance level
    %Model.Gamma = 0.001;%indicate outlier level
    %
    %
    %draw acceptance plot
    %Model.AcceptancePlot();
    %draw extreme plot
    %Model.ExtremePlot();
    %NewClass = DDSTask(Model, TestSet);
    %NewClass.AcceptancePlot();
    %NewClass.Beta
    %NewClass.Warning
    %
    %
    %SEE ALSO DDSTask
    
    properties
        OD % vector (1,n) with normalized squared Euclidian distances for objects from Training Set
        SD % vector (1,n) with normalized squared Mahalanobis distances for objects from Training Set
        ExtremeObjects % vector, has the same length as the number of objects in the training set. '1' indicates that the corresponding object is an extreme object.
        OutlierObjects % vector, has the same length as the number of objects in the training set. '1' indicates that the corresponding object is an outlier object.
        TrainingSet % training set (matrix)
        numPC = 2%number of principal components
        Scores %scores matrix
        Loadings %loadings matrix
        EigenMatrix % matrix of eigenvalues from the SVD decomposition
        SD_mean % mean of normalized squared Mahalanobis distances (SD) for objects
        % from the Training Set
        OD_mean % mean of normalized squared Euclidian distances (OD) for objects
        % from the Training Set
        DoF_SD % number of Degrees of Freedom of chi-square distribution of SD
        DoF_OD % number of Degrees of Freedom of chi-square distribution of OD
        CriticalLevel % offset values for extreme border
        OutlierLevel % offset values for outlier border
        BorderType = 'chi-square'% the border type in SIMCA plot, values: 'chi-square' (default) | 'rectangle'
        
        Centering = false% (boolean) Preprocessing (Centering)
        Scaling = false% (boolean) Preprocessing (Scaling)
        
        Alpha = 0.01% significance level (type I error)(scalar), must be in the range (0,1]. 
        Gamma % outlier level (scalar), must be in the range (0,1]
        
        Transformation = 'log' % transformation applied to the SD/OD on the Acceptance plot, values: 'log' (default) | 'none'
        
        TrainingSet_mean % mean values of the Training Set (used for preprocessing of Test Set or New Set in the DDSTask class)
        TrainingSet_std % standard deviation of the Training Set (used for preprocessing of Test Set or New Set)
        
        EstimationMethod = 'classic' %type of calculation of SIMCA parameters (string), values: 'classic' (default) | 'robust'; 'classic' - method of moments, 'robust' - robust methods
        
        AutoAlpha = false %automatically calculata significance level (type I error, Alpha)(logical), values = false (default)|true
        
        Labels % (optional) a cellarray containing the labels of samples in the Training Set, which are shown on the Acceptance and Extreme plot . 
        
        ShowLabels = true % Show the labels of samples in the Training Set (logical), values = true (default)|false
        AcceptancePlotTitle % Additional figure title shown on the acceptance plot
    end
    
    properties (Access = private)
        TrainingSet_ % a copy of Training Set for internal use
        Recalc = true % control of the automatic model recalculation on paramaters change (for internal use)
    end
    
    properties (Dependent = true)
        
        HasExtremes % extreme objects indicator
        HasOutliers % outlier objects indicator
        
    end
    
    methods
        
        function value = get.HasExtremes(self)
            %HasExtremes get/set
            
            value = sum(self.ExtremeObjects) > 0;
        end
        
        function value = get.HasOutliers(self)
            %HasOutliers get/set
            
            value = sum(self.OutlierObjects) > 0;
        end
        
        function set.TrainingSet(self,value)
            %TrainingSet get/set
            
            self.TrainingSet = value;
            self.TrainingSet_ = value;
            
            if self.Centering == true
                self.TrainingSet_mean = mean(self.TrainingSet_);
                self.TrainingSet_ = bsxfun(@minus, self.TrainingSet_, self.TrainingSet_mean);
            end
            
            if self.Scaling == true
                temp = std(self.TrainingSet_,0,1);
                temp(temp == 0) = 1;
                self.TrainingSet_std = temp;
                self.TrainingSet_ = bsxfun(@rdivide, self.TrainingSet_, temp);
            end
            
            self.dds_process();
        end
        
        function set.Centering(self,value)
            %Centering get/set
            
            self.Centering = value;
            
            self.TrainingSet_ = self.TrainingSet;
            
            if self.Centering == true
                self.TrainingSet_mean = mean(self.TrainingSet_);
                self.TrainingSet_ = bsxfun(@minus, self.TrainingSet_, self.TrainingSet_mean);
            end
            
            if self.Scaling == true
                temp = std(self.TrainingSet_,0,1);
                temp(temp == 0) = 1;
                self.TrainingSet_std = temp;
                self.TrainingSet_ = bsxfun(@rdivide, self.TrainingSet_, self.TrainingSet_std);
            end
            
            self.dds_process();
        end
        
        function set.Scaling(self,value)
            %Scaling get/set
            
            self.Scaling = value;
            
            self.TrainingSet_ = self.TrainingSet;
            
            if self.Centering == true
                self.TrainingSet_mean = mean(self.TrainingSet_);
                self.TrainingSet_ = bsxfun(@minus, self.TrainingSet_, self.TrainingSet_mean);
            end
            
            if self.Scaling == true
                temp = std(self.TrainingSet_,0,1);
                temp(temp == 0) = 1;
                self.TrainingSet_std = temp;
                self.TrainingSet_ = bsxfun(@rdivide, self.TrainingSet_, self.TrainingSet_std);
            end
            
            self.dds_process();
        end
        
        function set.Alpha(self,value)
            %Alpha get/set
            
            self.Alpha = value;
            
            if self.Recalc == true
                self.dds_process();
            end
            
        end
        
        function set.AutoAlpha(self,value)
            %AutoAlpha get/set
            
            self.AutoAlpha = value;
            
            if self.Recalc == true && (value == true || value == false && ~isempty(self.Alpha))
                self.dds_process();
            end
            
        end
        
        function set.Gamma(self,value)
            %Gamma get/set
            self.Gamma = value;
            
            self.dds_process();
        end
        
        function set.BorderType(self,value)
            %BorderType get/set
            
            self.BorderType = value;
            
            self.dds_process();
        end
        
        function set.EstimationMethod(self,value)
            %EstimationMethod get/set
            
            self.EstimationMethod = value;
            
            self.dds_process();
        end
        
        function DDSobj = DDSimca(TrainingSet,numPC)
            %constructor
            
            DDSobj.TrainingSet = TrainingSet;
            DDSobj.TrainingSet_ = TrainingSet;
            
            DDSobj.numPC = numPC;
            
            DDSobj.dds_process();
        end
        
        function handle = AcceptancePlot(self)
            %create and show acceptance plot
            
            transform = self.Transformation;
            
            handle = figure;
            
            if isempty(self.AcceptancePlotTitle)
                set(handle,'name','Acceptance plot','numbertitle','off');
                title('Acceptance plot. Training set', 'FontWeight', 'bold');
            else
                set(handle,'name',sprintf('Acceptance plot - %s', self.AcceptancePlotTitle),'numbertitle','off');
                title(sprintf('Acceptance plot. Training set - %s', self.AcceptancePlotTitle), 'FontWeight', 'bold', 'Interpreter', 'none');
            end
            
            hold on;

            xlabel('h/h_0', 'FontWeight', 'bold');
            ylabel('v/v_0', 'FontWeight', 'bold');
            
            switch transform
                case 'sqrt'
                    xlabel('(h/h_0)^1^/^2', 'FontWeight', 'bold');
                    ylabel('(v/v_0)^1^/^2', 'FontWeight', 'bold');
                case 'log'
                    xlabel('log(1 + h/h_0)', 'FontWeight', 'bold');
                    ylabel('log(1 + v/v_0)', 'FontWeight', 'bold');
            end
            
            crit_levels = self.CriticalLevel;
            
            [x,y] = DDSimca.plot_border(crit_levels, self.BorderType, transform);
            
            plot(x, y, '-g');
            if ~isempty(self.OutlierLevel)
                out_levels = self.OutlierLevel;
                [x,y] = DDSimca.plot_border(out_levels, self.BorderType, transform);
                
                plot(x, y, '-r');
            end
            
            oD = DDSimca.transform_(transform, self.OD/self.OD_mean);
            sD = DDSimca.transform_(transform, self.SD/self.SD_mean);
            
            if ~isempty(self.OutlierObjects)
                extTraining = self.ExtremeObjects;
                outTraining = self.OutlierObjects;
                regular = plot(sD(~(extTraining + outTraining)),oD(~(extTraining + outTraining)),'og','MarkerFaceColor','g');
                extreme = plot(sD(extTraining == 1),oD(extTraining == 1),'s','Color',[1 0.65 0],'MarkerFaceColor',[1 0.65 0]);
                outlier = plot(sD(outTraining == 1),oD(outTraining == 1),'rs','MarkerFaceColor','r');
                if sum(extTraining == 1) > 0 && sum(outTraining == 1) > 0
                    legend([regular, extreme, outlier],'regular','extremes','outliers');
                end
                if sum(extTraining == 1) > 0 && sum(outTraining == 1) == 0
                    legend([regular, extreme],'regular','extremes');
                end
                if sum(extTraining == 1) == 0 && sum(outTraining == 1) > 0
                    legend([regular, outlier],'regular','outliers');
                end
                if sum(extTraining == 1) == 0 && sum(outTraining == 1) == 0
                    legend(regular,'regular');
                end
            else
                extTraining = self.ExtremeObjects;
                regular = plot(sD(extTraining == 0),oD(extTraining == 0),'og','MarkerFaceColor','g');
                extreme = plot(sD(extTraining == 1),oD(extTraining == 1),'s','Color',[1 0.65 0],'MarkerFaceColor',[1 0.65 0]);
                if sum(extTraining == 1) > 0
                    legend([regular, extreme],'regular','extremes');
                end
                if sum(extTraining == 1) == 0
                    legend(regular,'regular');
                end
            end
            
            legend('boxon');
            
            if(self.ShowLabels)
                    labels = strread(num2str(1:size(self.TrainingSet, 1)),'%s');
                    if(~isempty(self.Labels))
                        labels = self.Labels;
                    end
                    
                     dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points
                     text(sD+dx, oD+dy, labels, 'Interpreter', 'none');
            end
            
            hold off;
            DDSimca.randomize_plot_position(handle);
        end
        
        function [handle, N, Nplus, Nminus] = ExtremePlot(self)
            %create extreme plot
            oD = self.OD/self.OD_mean;
            sD = self.SD/self.SD_mean;
            Nh = self.DoF_SD;
            Nv = self.DoF_OD;
            
            c = Nh*sD + Nv*oD;
            c = sort(c);
            Nc = Nh + Nv;
            I = length(c);
            
            %N = zeros(1,I);
            %Nplus = zeros(1,I);
            %Nminus = zeros(1,I);
            
            n = 1:I;
            alpha = n / I;
            Ccrit = arrayfun( @(alpha_) self.chi2inv_( 1 - alpha_, Nc), alpha);
            N = arrayfun( @(Ccrit_) sum(c >= Ccrit_), Ccrit);
            
            %D = 2*sqrt(n*(1-alpha));
            Dminus = n - arrayfun(@(p,a) DDSimca.binv(I, p, a), alpha, 0.025 * ones(size(n)));
            Dplus = arrayfun(@(p,a) DDSimca.binv(I, p, a), alpha, 0.975 * ones(size(n))) - n;
            
            Nplus = n + Dplus;
            Nminus = n - Dminus;
            
            
            handle = figure;
            
            if isempty(self.AcceptancePlotTitle)
                set(handle,'name','Extreme plot','numbertitle','off');
                title('Extreme plot', 'FontWeight', 'bold');
            else
                set(handle,'name',sprintf('Extreme plot - %s', self.AcceptancePlotTitle),'numbertitle','off');
                title(sprintf('Extreme plot. Training set - %s', self.AcceptancePlotTitle), 'FontWeight', 'bold', 'Interpreter', 'none');
            end
            hold on;

            xlabel('Expected', 'FontWeight', 'bold');
            ylabel('Observed', 'FontWeight', 'bold');
            
            expected = 1:length(N);
            exp_plot = plot(expected, expected, '-b', 'LineWidth', 2);
            
            for i = 1:length(expected)
                plot([expected(i),expected(i)],[Nminus(i),Nplus(i)], '-b');
            end
            
            n_plot = plot(expected, N, 'or','MarkerFaceColor','r');
            
            legend([n_plot,exp_plot],'Observed','Expected', 'Location', 'northwest');
            legend('boxon');
            
            hold off;
            DDSimca.randomize_plot_position(handle);
        end
    end
    
    methods (Access = private)
        
        function dds_process(self)
            %create the model and calculate all the parameters
            gamma = [];
            X = self.TrainingSet_;
            NumPC = self.numPC;
            if ~isempty(self.Gamma)
                gamma = self.Gamma;
            end
            
            n = size(X, 1);
            [P,D1]= self.decomp (X, NumPC);
            
            switch self.BorderType
                case 'rectangle'
                    border_type = 0;
                case 'chi-square'
                    border_type = 1;
            end
            
            % calculation of OD and SD for a training set
            v_sdT=DDSimca.sd(X,P(:,1:NumPC),D1,NumPC);
            v_odT=DDSimca.od(X,P(:,1:NumPC));
            switch self.EstimationMethod
                % Classical estimators
                case 'classic'
                    [av_sd,DoF_sd]=self.momentest(v_sdT);
                    [av_od,DoF_od]=self.momentest(v_odT);
                    % Robust estimators
                case 'robust'
                    [av_sd,DoF_sd]=self.robustest(v_sdT);
                    [av_od,DoF_od]=self.robustest(v_odT);
            end
            v_sdT_=v_sdT/av_sd;
            v_odT_=v_odT/av_od;
            
            %extreme borders for OD and SD; array of extreme objects
            
            if self.AutoAlpha == true
                alphaError = self.alpha_error(DoF_sd*v_sdT_+DoF_od*v_odT_, DoF_sd+DoF_od);
                
                self.Recalc = false;
                self.Alpha = alphaError;
                self.Recalc = true;
                
            else
                alphaError = self.Alpha;
            end
            
            dcrit=self.border(DoF_od, DoF_sd, border_type, alphaError);
            v_extT=DDSimca.extremes(v_odT_,v_sdT_,dcrit, border_type);
            
            dout = [];
            v_outT = [];
            if ~isempty(gamma)
                %outlier borders for OD and SD; array of outlier objects
                alpha_out=1-((1-gamma)^(1/n));
                dout=self.border(DoF_od, DoF_sd, border_type, alpha_out);
                v_outT=self.extremes(v_odT_,v_sdT_, dout, border_type);
            end
            
            self.Loadings = P(:,1:NumPC);
            self.Scores = X*self.Loadings;
            self.EigenMatrix = D1;
            self.OD_mean = av_od;
            self.SD_mean = av_sd;
            self.DoF_OD = DoF_od;
            self.DoF_SD = DoF_sd;
            self.CriticalLevel = dcrit;
            self.OutlierLevel = dout;
            self.SD = v_sdT;
            self.OD = v_odT;
            self.ExtremeObjects = v_extT;
            self.OutlierObjects = v_outT;
            
        end
        
        function dbord=border(~,DoF_od, DoF_sd, border_type, error)
            % calculate critical values dbord(1) for score distance and dbord(2) for
            % orthogonal distance
            %border_type=0 : application of rectangle border
            %border_type=1: application of triangle border
            %----------------------------------------------
            if (border_type==0)
                sd_Crit=DDSimca.chi2inv_(sqrt(1-error),DoF_sd)/DoF_sd;
                od_Crit=DDSimca.chi2inv_(sqrt(1-error),DoF_od)/DoF_od;
            end
            if (border_type==1)
                d_Crit=DDSimca.chi2inv_(1-error,DoF_sd+DoF_od);
                sd_Crit=d_Crit/DoF_sd;
                od_Crit=d_Crit/DoF_od;
            end
            dbord(1)=sd_Crit;
            dbord(2)=od_Crit;
            % end of dbord function
        end
        
        function [P,D1]= decomp (~,X, numPC)
            % decomp - PCA decomposition based on X matrix with numPC components
            %----------------------------------------------
            [~,D,P] = svd(X);
            D1=D(1:numPC,1:numPC);
            % end of decomp function
        end
        
        function [aver, DoF]= momentest(~,v_uT)
            % momentest -estimation of DoF by method of moments, and estimation of% mean value
            %----------------------------------------------
            aver=mean(v_uT);
            DoF=round(2*(aver/std(v_uT))^2);
            if (DoF < 1)
                DoF = 1;
            end
            %temp
            if (DoF > 250)
                DoF = 250;
            end
            % end of momentest function
        end
        
        function [aver, DoF]= robustest(~,v_uT)
            % robustest - estimation of mean and DoF in a robust manner
            %----------------------------------------------
            M=median(v_uT);
            R=DDSimca.iqr_(v_uT);
            %R = iqr(v_uT);
            %R = quantile(v_uT, 0.75) - quantile(v_uT, 0.25);
            DF=R/M;
            if (DF > 2.685592117)
                DoF=1;
            elseif (DF < 0.194565995)
                DoF=100;
            else
                DoF = round(exp((1.380948*log(2.68631 / DF)) ^ 1.185785));
            end
            R1=double(DoF);
            
            dChi = DDSimca.chi2inv_(0.75,R1)-DDSimca.chi2inv_(0.25,R1);
            dChm = DDSimca.chi2inv_(0.5,R1);
            
            aver=0.5*R1*(M/dChm + R/dChi);
            
            %temp
            if (DoF > 250)
                DoF = 250;
            end
            
            % end of robustest function
        end
        
        function res = ismatrix_(~,a)
            %Determine whether input is a matrix.
            %for compatibility with earlier matlab versions
            
            [n,p] = size(a);
            if n > 1 && p > 1 && isa(a, 'double')
                res = true;
            else
                res = false;
            end
        end
        
        function alpha = alpha_error(~,c,k)
            %auto calculate alpha, if it is not defined
            Ccrit = max(c) + 0.0001;
            alpha = 1 - DDSimca.chi2cdf_(Ccrit, k);
        end
        
    end
    
    methods (Static)
        
        function randomize_plot_position(h)
           %Randomize plot position
           %Used by ExtremePlot and AcceptancePlot methods
           %
           % h - figure handle
           
           screen = get( 0, 'Screensize' );
           screen_width = screen(3);
           screen_height = screen(4);

            pos = get(h, 'Position'); 
            plot_width = pos(3);
            plot_height = pos(4);

            x = randi(screen_width - plot_width,1,1);
            y = randi(screen_height - plot_height - 100,1,1);
            set(h, 'Position', [x, y, plot_width, plot_height]); 
        end
        
        function r = quartile(x, q, mode)
            %Calculate Quartile
            %
            % x - vector
            % q - quartile (1,2 or 3)
            % mode - calculation algorithm (1,2,3 or 'excel')
            
            y = sort(x);
            n = length(x);
            
            if strcmp(mode, 'excel') == 0
                l1 = y(y<median(y));
                h1 = y(y>median(y));
                l2 = y(y<=median(y));
                h2 = y(y>=median(y));
                
                if mod(n,2) ~= 0
                    switch mode
                        case 1
                            q1 = median(l1);
                            q3 = median(h1);
                        case 2
                            q1 = median(l2);
                            q3 = median(h2);
                        case 3
                            q1 = (median(l1) + median(l2))/2;
                            q3 = (median(h1) + median(h2))/2;
                    end
                else
                    l = y(1:n/2);
                    h = y(n/2+1:end);
                    q1 = median(l);
                    q3 = median(h);
                end
                
                switch q
                    case 1
                        r = q1;
                    case 2
                        r = median(y);
                    case 3
                        r = q3;
                end
            else
                k=(q/4)*(n-1)+1;
                i=floor(k);
                f=k-i;
                r = y(i)+ f*(y(i+1)-y(i));
            end
            
            
        end
        function iqr = iqr_(x)
            % Compute Interquartile Range (IQR)
            
            iqr = DDSimca.quartile(x, 3,'excel') - DDSimca.quartile(x, 1,'excel');
        end
        
        function x = binv(n,p,a)
            %Inverse of the binomial cumulative distribution function
            %n - number of trials
            %x - number of events
            %p - event probability
            %a - criterion value

            tt = 0:n;
            p = cumsum(arrayfun(@(t) (factorial(n)/(factorial(t)*factorial(n-t)))*p^t*(1-p)^(n-t), tt));
            x = min(tt(p > a));

        end
        
        function r = chi2cdf_(val, dof)
            %Chi-square cumulative distribution function.
            
            %if exist('chi2cdf', 'file')
            %    r = chi2cdf(val, dof);
            %else
            %If Statistics Toolbox is absent
            x1 = val;
            n = dof;
            
            if n<=0 || x1<0
                error('!!!');
            end
            
            if n > 140
                x=sqrt(2*x1)-sqrt(2*n-1);
                P=DDSimca.normcdf_(x);
                r = P;
                return;
            end
            
            x=sqrt(x1);
            if mod(n,2) == 0
                %if n is even
                a=1;
                P=0;
                for i=1:(n-2)/2
                    a = a*x*x/(i*2);
                    P = P + a;
                end
                P = P + 1;
                P = P*exp(-x*x/2);
            else
                %if n is odd
                a=x;
                P=x;
                for i=2:(n-1)/2
                    a = a*x*x/(i*2-1);
                    P = P + a;
                end
                if n==1
                    P=0;
                else
                    P = P*exp(-x*x/2)*2/sqrt(2*pi);
                end
                P = P + 2*(1-DDSimca.normcdf_(x));
            end
            r = 1-P;
        end
        
        function r = chi2inv_(p, dof)
            %Inverse of the chi-square cumulative distribution function (cdf).
            
            %if exist('chi2inv', 'file')
            %    r = chi2inv(p, dof);
            %else
            %If Statistics Toolbox is absent
            n = dof;
            
            if n<=0 || p<0 || p>1
                error('wrong probability value!!');
            end
            
            if p==0
                r = 0;
                return;
            end
            
            if p==1
                r = inf;
                return;
            end
            
            z = DDSimca.norminv_(p);
            dTemp1=2/9/n;
            dTemp=1-dTemp1+z*sqrt(dTemp1);
            
            if dTemp>0
                dTemp1=dTemp*dTemp*dTemp;
                f=n*dTemp1;
            else
                dTemp1=z+sqrt(2*n-1);
                dTemp=dTemp1*dTemp1;
                f=0.5*dTemp;
            end
            if(f < 0)
                error('!!!');
            end
            
            p1 = DDSimca.chi2cdf_(f, n);
            if (abs(p1 - p) < 1e-8)
                r = f;
                return;
            end
            h = 0.01;
            if p1>p
                h=-0.01;
            end
            
            flag = true;
            while flag
                
                z=f+h;
                if z<=0
                    break;
                end
                h = h*2;
                p1=DDSimca.chi2cdf_(z,n);
                
                flag = (p1-p)*h<0;
            end
            
            if (abs(p1 - p) < 1e-8)
                r = z;
                return;
            end
            
            if z<=0
                z=0;
            end
            
            if f<z
                x1=f;
                x2=z;
            else
                x1=z;
                x2=f;
            end
            
            for i=0:50000
                f=(x1+x2)/2.0;
                p1=DDSimca.chi2cdf_(f,n);
                
                if abs(p1-p)<0.001*p*(1-p)&& abs(x1-x2)<0.0001*abs(x1)/(abs(x1)+abs(x2))
                    break;
                end
                
                if p1<p
                    x1=f;
                else
                    x2=f;
                end
            end
            
            r = f;
        end
        
        function r = normcdf_(x)
            %Normal cumulative distribution function (cdf).
            
            %if exist('normcdf', 'file')
            %    r = normcdf(x);
            %else
            %If Statistics Toolbox is absent
            t = 1 /(1 + abs(x)*0.2316419);
            P = 1 - (exp(-x*x/2)/sqrt(2*pi))*t*((((1.330274429*t-1.821255978)*t+1.781477937)*t-0.356563782)*t+0.31938153);
            if x <= 0
                P = 1 - P;
            end
            r = P;
        end
        
        function r = norminv_(P)
            %Inverse of the normal cumulative distribution function (cdf).
            
            %if exist('norminv', 'file')
            %    r = norminv(val);
            %else
            %If Statistics Toolbox is absent
            if P>=1 || P<=0
                error('!!!');
            end
            
            q=P;
            if P>=0.5
                q=1-P;
            end
            t=sqrt(log(1/(q*q)));
            t2=t*t;
            t3=t2*t;
            xp=t-(2.515517+t*0.802853+t2*0.010328)/(1+t*1.432788+t2*0.189269+t3*0.001308);
            if P>=0.5
                r = xp;
            else
                r = -xp;
            end
            
        end
        
        function samp_out = extremes(v_od,v_sd, dbord, border_type)
            %form vector with "1" if a sample located out of the acceptance area and "0" for
            %regular samples
            %----------------------------------------------
            sd_Crit = dbord(1);
            od_Crit = dbord(2);

            switch border_type
                case 0
                    v_samp = (v_sd > sd_Crit) | (v_od > od_Crit);    
                case 1
                    od_Cur = od_Crit * ( 1 - v_sd / sd_Crit );    
                    v_samp = (v_sd > sd_Crit) | (v_od > od_Cur);
            end
            samp_out = v_samp;
            % end of samp_out function
        end
        
        function v_sd = sd(X,P,D,numPC)
            % sd - Scores distance function, returns v_sd- vector of score distances for specified PCs
            %----------------------------------------------
            n = size(X, 1);
            T = X*P;
            v_lambd = diag(D);
            v_work = zeros(n,numPC);
            for k=1:numPC
                v_work(:,k) = T(:,k)/v_lambd(k);
            end
            v_sd = sum(v_work.^2, 2);
            % end of sd function
        end
        
        function v_od = od(X,P)
            % od - orthogonal distance function, returns v_od- ve
            %vector of orthogonal distances for specified PCs
            %----------------------------------------------
            [n,p] = size(X);
            isDataBigEnough = n*p > 10^7;
            if  isDataBigEnough && gpuDeviceCount > 0
                Xg = gpuArray(X);
                Pg = gpuArray(P);
                E = Xg*(eye(p,p,'gpuArray')-Pg*Pg');
                v_odg = sum(E.^2,2)/p;
                v_od = gather(v_odg);
            else
                E = X*(eye(p,p)-P*P');
                v_od = sum(E.^2,2)/p;
            end
            % end of od function
        end
        
        function res = transform_(mode, input)
            %transformation for SD and OD (used by plot_border method)
            res = input;
            switch mode
                case 'sqrt'
                    res = sqrt(input);
                case 'log'
                    res = log(1 + input);
            end
        end
        
        function res = transform_reverse(mode, input)
            %inverse transformation for SD and OD (used by plot_border method)
            res = input;
            switch mode
                case 'sqrt'
                    res = input^2;
                case 'log'
                    res = exp(input)-1;
            end
        end
        
        function [x, y] = plot_border(dcrit, border_type, transform)
            %draws the border of acceptance area
            
            sd_Crit=dcrit(1);
            od_Crit=dcrit(2);
            
            x = linspace(0, DDSimca.transform_(transform, sd_Crit));
            n=length(x);
            y=zeros(size(x));
            
            switch border_type
                case 'rectangle'
                    for k=1:n
                        if( x(k) < DDSimca.transform_(transform, sd_Crit) || x(k) < 0)
                            y(k)=od_Crit;
                        else
                            y(k)=0;
                        end
                    end
                case 'chi-square'
                    for k=1:n
                        if( x(k) > DDSimca.transform_(transform, sd_Crit) || x(k) < 0)
                            y(k)=0;
                        else
                            %y(k)=od_Crit/sd_Crit*(sd_Crit-x(k));
                            y(k)=od_Crit/sd_Crit*(sd_Crit - DDSimca.transform_reverse(transform, x(k)));
                            
                            if(y(k) < 0)
                                y(k) = 0;
                            end
                        end
                        
                    end
            end
            
            y = DDSimca.transform_(transform, y);
        end
    end
end