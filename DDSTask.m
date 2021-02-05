classdef DDSTask<handle
    %
    %DDSTask class is part of DDSimca Tool and
    %is intended for testing of new classes of samples 
    %using a previously created DD-SIMCA model
    %and calculation of type II error Beta
    %
    %METHODS
    %
    %Constructor
    %
    %[DDSobj] = DDSTask(Model, NewSet)
    %
    %Creates the new DDSTask object
    %Parameters: Model - DDSimca object, NewSet - matrix
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
    %[handle, N, Nplus, Nminus] = TestSamplesExtremePlot()
    %
    %The Extreme plot shows the observed vs. the expected
    %number of extreme objects for a test dataset and provides graphical means for
    %the data analysis.
    %The method has no parameters.
    %The method returns handle of the plot figure,
    %N - number of samples with weighted sum of the SD variable the OD
    %variable greater than critical,
    %Nplus - upper boundary for N,
    %Nminus - lower boundary for N
    %
    %[handle, N, Nplus, Nminus] = NewSamplesExtremePlot()
    %
    %The Extreme plot shows the observed vs. the expected
    %number of extreme objects for a new dataset and provides graphical means for
    %the data analysis.
    %The method has no parameters.
    %The method returns handle of the plot figure,
    %N - number of samples with weighted sum of the SD variable the OD
    %variable greater than critical,
    %Nplus - upper boundary for N,
    %Nminus - lower boundary for N
    %
    %PROPERTIES
    %
    %NewSet - new set (matrix)
    %
    %Model - DDSimca object
    %
    %SD - vector (1,n) with normalized squared Euclidian distances for objects from Training Set
    %
    %OD - vector (1,n) with normalized squared Mahalanobis distances for objects from Training Set
    %
    %ExternalObjects - vector, has the same length as the number of objects in the training set. '1' indicates that the corresponding object is an extreme object. 
    %
    %Transformation - transformation applied to the SD/OD on the
    %Acceptance plot, values: 'log' (default) | 'none'
    %
    %Beta - calculated type II error
    %
    %Alpha - (optional) calculated type I error
    %
    %Warning - a warning text which is shown in case the New Set contains more than one class of samples.
    %
    %CalculateBeta - (optional) flag which indicates whether the type II error should be calculated for the New Set. (default - true)
    %
    %Labels - (optional) a cellarray containing the labels of samples in the Training Set, which are shown on the Acceptance and Extreme plot . 
    %  
    %ShowLabels - Show the labels of samples in the Training Set (logical), values = true (default)|false
    %
    %AcceptancePlotTitle - Additional figure title shown on the acceptance plot
    %
    %
    %USAGE EXAMPLE
    %%Let's suppose TestSet is the matrix 
    %%containing N spectra on M wavelengths, which is used as New Set,
    %%which contains the samples not used to create the model.
    %
    %%Let's suppose Model is an object of DDSimca class 
    %%containing the DD-SIMCA model
    %
    %%create a DDSTask object for the new data set
    %NewClass = DDSTask(Model, TestSet);
    %%draw acceptance plot
    %NewClass.AcceptancePlot();
    %%check the type II error Beta
    %NewClass.Beta
    %%check whether the New Set contains more than one class of samples.
    %NewClass.Warning
    %
    %
    %SEE ALSO DDSimca
   properties
      NewSet % new set (matrix)
      Model % DDSimca object
      SD % vector (1,n) with normalized squared Euclidian distances for objects from Training Set
      OD % vector (1,n) with normalized squared Mahalanobis distances for objects from Training Set
      ExternalObjects % % vector, has the same length as the number of objects in the training set. '1' indicates that the corresponding object is an extreme object. 
      Transformation = 'log' % transformation applied to the SD/OD on the Acceptance plot, values: 'log' (default) | 'none'
      Beta % calculated type II error
      Alpha % calculated type I error
      Warning % a warning text which is shown in case the New Set contains more than one class of samples.
      CalculateBeta = true % (optional) flag which indicates whether the type II error should be calculated for the New Set. (default - true)
      Labels % (optional) a cellarray containing the labels of samples in the Training Set, which are shown on the Acceptance and Extreme plot . 
      ShowLabels = true % Show the labels of samples in the Training Set (logical), values = true (default)|false
      AcceptancePlotTitle % Additional figure title shown on the acceptance plot
      
      isPCV
      isNew
      isTest 
      
      pcvFolds
   end
   
   properties (Access = private)
      Recalc = true % control of the automatic model recalculation on paramaters change (for internal use)
   end
   
   methods
      
       
        function set.CalculateBeta(self,value) 
            %CalculateBeta get/set
            self.CalculateBeta = value;
            if value == false
                self.Warning = [];
                self.Recalc = false;
                self.Beta = [];
                self.Recalc = true;
            else
                NewSet_ = self.preprocess(self.NewSet);
                res = self.beta_error(NewSet_, 0);
                self.Recalc = false;
                self.Beta = res.beta;
                
                if isfield(res, 'warning')
                    self.Warning = res.warning;
                end
                
                self.Recalc = true;
            end
            
        end
        
        
        function set.Beta(self,value)
            %Beta get/set
            prev = self.Beta;
            self.Beta = value;
            if self.Recalc && isempty(prev) && ~isempty(value)
                NewSet_ = self.preprocess(self.NewSet);
                res = self.beta_error(NewSet_, value);
                self.Alpha = res.alpha;
                
                if isfield(res, 'alpha')
                    self.Alpha = res.alpha;
                end
            end
            
        end
       
      
      function DDSobj = DDSTask(Model, NewSet)
          %constructor 
         DDSobj.Model = Model;
         DDSobj.NewSet = NewSet;
         
         DDSobj.dds_test(NewSet, DDSobj.CalculateBeta, DDSobj.Beta);
         
      end
      
      
      function handle = AcceptancePlot(self)
          %create acceptance plot
         transform = self.Transformation;
            
            handle = figure;

            if isempty(self.AcceptancePlotTitle)
                set(handle,'name','Acceptance plot','numbertitle','off');
                title('Acceptance plot', 'FontWeight', 'bold');
            else
                plot_title = '';
                if self.isNew
                   plot_title = 'New set'; 
                end
                if self.isTest
                   plot_title = 'Test set';
                end
                if self.isPCV
                   plot_title = 'PCV set'; 
                end
                
                set(handle,'name',sprintf('Acceptance plot - %s', self.AcceptancePlotTitle),'numbertitle','off');
                title(sprintf('Acceptance plot. %s - %s', plot_title, self.AcceptancePlotTitle), 'FontWeight', 'bold', 'Interpreter', 'none');
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
            
        if ~isempty(self.Model.CriticalLevel)
            crit_levels = self.Model.CriticalLevel;
            [x,y] = DDSimca.plot_border(crit_levels, self.Model.BorderType, transform);
            plot(x, y, '-g');
        end
                OD_New = DDSimca.transform_(transform, self.OD/self.Model.OD_mean);
                SD_New = DDSimca.transform_(transform, self.SD/self.Model.SD_mean);
                extNew = self.ExternalObjects;
                %outNew = dds_result.test.outlier;
            
                %plot(SD_New, OD_New,'ob','MarkerFaceColor','b');
                plot(SD_New(extNew == 0),OD_New(extNew == 0),'og','MarkerFaceColor','g');
                plot(SD_New(extNew == 1),OD_New(extNew == 1),'or','MarkerFaceColor','r');

                if(self.ShowLabels)
                    labels = strread(num2str(1:size(self.NewSet, 1)),'%s');
                    if(~isempty(self.Labels))
                        labels = self.Labels;
                    end
                    
                     dx = 0.01; dy = 0.01; % displacement so the text does not overlay the data points
                     text(SD_New+dx, OD_New+dy, labels, 'Interpreter', 'none');
                end
            

            hold off;
            DDSimca.randomize_plot_position(handle);
      end
          
      function [handle, N, Nplus, Nminus] = TestSamplesExtremePlot(self)
          %create extreme plot
            oD = self.OD/self.Model.OD_mean;
            sD = self.SD/self.Model.SD_mean;
            Nh = self.Model.DoF_SD;
            Nv = self.Model.DoF_OD;
            
            c = Nh*sD + Nv*oD;
            c = sort(c);
            Nc = Nh + Nv;
            I = length(c);
            
            %N = zeros(1,I);
            %Nplus = zeros(1,I);
            %Nminus = zeros(1,I);
            
            n = 1:I;
            alpha = n / I;
            Ccrit = arrayfun( @(alpha_) DDSimca.chi2inv_( 1 - alpha_, Nc), alpha);
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
                title(sprintf('Extreme plot. Test set - %s', self.AcceptancePlotTitle), 'FontWeight', 'bold', 'Interpreter', 'none');
            end
            hold on;

            xlabel('Expected', 'FontWeight', 'bold');
            ylabel('Observed', 'FontWeight', 'bold');
            
            expected = 1:length(N);
            
            expected_plus2 = 1:(length(N)+2);
            exp_plot = plot(expected_plus2, expected_plus2, '-b', 'LineWidth', 2);
            
            
            for i = 1:length(expected)
                plot([expected(i),expected(i)],[Nminus(i),Nplus(i)], '-b');
            end
            
            n_plot = plot(expected, N, 'or','MarkerFaceColor','r');
            
            legend([n_plot,exp_plot],'Observed','Expected', 'Location', 'northwest');
            legend('boxon');
            
            hold off;
            DDSimca.randomize_plot_position(handle);
      end
      
      function [handle, N, Nplus, Nminus] = NewSamplesExtremePlot(self)
          %create extreme plot
            NewSet_ = self.preprocess(self.NewSet);
            
            oD = self.OD/self.Model.OD_mean;
            sD = self.SD/self.Model.SD_mean;
            Nh = self.Model.DoF_SD;
            Nv = self.Model.DoF_OD;
            
            c = Nh*sD + Nv*oD;
            c = sort(c);
            %Nc = Nh + Nv;
            %I = length(c);
            
            flag = true;
            I = size(NewSet_, 1);
            k = Nh + Nv;
            
            c1dims = (1:I)';
            c1m1 = cumsum(c)./c1dims;
            c1d1 = cumsum(c.^2);
            c1d1 = c1d1./c1dims - c1m1.^2;
            c1d1 = c1d1 .*I./(I-1);
            
            while flag
                m1 = c1m1(I);
                d1 = c1d1(I);

                M1 = d1/m1^2;
                Disc = 4 - 2*k*M1;

                if Disc < 0
                    I = I - 1;
                else
                    break;
                end
            end
            
            %N = zeros(1,I);
            %Nplus = zeros(1,I);
            %Nminus = zeros(1,I);
            
            n = 1:I;
            beta = n / I - 0.00000001;

            alpha = arrayfun(@(b) self.beta_error(NewSet_, b), beta);

            N = arrayfun(@(a) sum(c < a.Ccrit), alpha);
            
            %D = 2*sqrt(n*(1 - beta));
            Dminus = n - arrayfun(@(p,a) DDSimca.binv(I, p, a), beta, 0.025 * ones(size(n)));
            Dplus = arrayfun(@(p,a) DDSimca.binv(I, p, a), beta, 0.975 * ones(size(n))) - n;
                
            Nplus = n + Dplus;
            Nminus = n - Dminus;
            
            handle = figure;
            
            if isempty(self.AcceptancePlotTitle)
                set(handle,'name','Extreme plot','numbertitle','off');
                title('Extreme plot', 'FontWeight', 'bold');
            else
                set(handle,'name',sprintf('Extreme plot - %s', self.AcceptancePlotTitle),'numbertitle','off');
                title(sprintf('Extreme plot. New set - %s', self.AcceptancePlotTitle), 'FontWeight', 'bold', 'Interpreter', 'none');
            end
            hold on;

            xlabel('Expected', 'FontWeight', 'bold');
            ylabel('Observed', 'FontWeight', 'bold');
            
            expected = 1:length(N);
            
            expected_plus2 = 1:(length(N)+2);
            exp_plot = plot(expected_plus2, expected_plus2, '-b', 'LineWidth', 2);
            
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
       
        function dds_test(self, XTest, calc_beta, beta)
        %project the new set on to model space, find extreme ojects and
        %estimate Beta
Xnew = self.preprocess(XTest);
numPC = self.Model.numPC;
P = self.Model.Loadings;
D1 = self.Model.EigenMatrix;
av_sd = self.Model.SD_mean;
av_od = self.Model.OD_mean;
dcrit = self.Model.CriticalLevel;
%dout = model.level.outlier;

switch self.Model.BorderType    
    case 'rectangle'
        border_type = 0; 
    case 'chi-square'    
        border_type = 1;
end   

v_sdNew=DDSimca.sd(Xnew,P,D1,numPC);
v_odNew=DDSimca.od(Xnew,P);
v_extNew=DDSimca.extremes(v_odNew/av_od,v_sdNew/av_sd, dcrit, border_type);

self.SD = v_sdNew;
self.OD = v_odNew;
self.ExternalObjects = v_extNew;

if calc_beta
    beta_res = self.beta_error(Xnew, 0);
else
   if ~isempty(beta)
        beta_res = self.beta_error(Xnew, beta);
    end 
end

if ~isempty(beta_res)
    if isfield(beta_res, 'alpha')
        self.Alpha = beta_res.alpha;
    end

    if isfield(beta_res, 'beta')
        self.Recalc = false;
        self.Beta = beta_res.beta;
        self.Recalc = true;
    end

    if isfield(beta_res, 'warning')
        self.Warning = beta_res.warning;
    end
end
        end
        
        
        function result = beta_error(self, X1, beta)
            % beta_error -  function, returns type II error for Test set
            %----------------------------------------------
            
            %Init
            NumPC = self.Model.numPC;
            P = self.Model.Loadings;
            L = self.Model.EigenMatrix;
            h0 = self.Model.SD_mean;
            v0 = self.Model.OD_mean;
            Nh = self.Model.DoF_SD;
            Nv = self.Model.DoF_OD;
            
            if ~isempty(self.Model.Alpha) && beta == 0
                alpha = self.Model.Alpha;
            else
                alpha = 0;
                if beta == 0
                    error('Both alpha and beta errors are not specified!');
                end
            end
            
            %Step 0
            %Calculate  T' and  E'
            %T1 = X1*P;
            %E1 = X1 - T1*P';
            
            %Calculate  hi' and vi'
            sd1 = DDSimca.sd(X1,P,L,NumPC)/h0;
            od1 = DDSimca.od(X1,P)/v0;
            
            %Calculate  ci'
            c1 = Nh*sd1 + Nv*od1;
            
            %Order c' such that c1'<= c2'<=.... <= cI''
            c1 = sort(c1);
            
            flag = true;
            I1 = size(X1, 1);
            k = Nh + Nv;
            
            c1dims = (1:I1)';
            c1m1 = cumsum(c1)./c1dims;
            c1d1 = cumsum(c1.^2);
            c1d1 = c1d1./c1dims - c1m1.^2;
            c1d1 = c1d1 .*I1./(I1-1);
            
            while flag
                %Step 1
                %Calculate  m' and d'
                m1 = c1m1(I1);
                d1 = c1d1(I1);
                
                %Calculate  M1 and Disc
                M1 = d1/m1^2;
                Disc = 4 - 2*k*M1;
                
                %Step 2
                if Disc < 0
                    %warning('The test set is splitted into several subclasses!');
                    result.warning = 'The New Set contains more than one class of external objects!';
                    I1 = I1 - 1;
                else
                    break;
                end
            end
            
            %Step 3
            %Calculate  x
            x = (2 + sqrt(Disc))/M1;
            
            %Calculate  s and  c'0
            s = x - k;
            c0 = m1/x;
            
            %Calculate:  h, q, p, Mz, Sz
            h = 1 - 2*(k + s)*(k + 3*s)/3/(k + 2*s)^2;
            q = (h - 1)*(1 - 3*h);
            p = (k + 2*s)/(k + s)^2;
            Mz = 1 + h*p*(h - 1 - 0.5*(2 - h)*q*p);
            Sz = h*sqrt(2*p)*(1 + 0.5*q*p);
            
            %Step 4
            %If alpha is given then calculate beta
            if alpha ~= 0
                Ccrit = DDSimca.chi2inv_(1-alpha, Nh + Nv);
                z = Ccrit/c0;
                beta = DDSimca.normcdf_(((z/(k + s))^h - Mz)/Sz);
                
                if beta < 1e-8
                    beta = 0;
                end
                
                result.beta = beta;
            else
                %If beta is given then calculate Ccrit, and calculate alpha
                if beta ~= 0
                    Zb = DDSimca.norminv_(beta);
                    Ccrit = c0*(k + s)*(Sz*Zb + Mz)^(1/h);
                    alpha = 1 - DDSimca.chi2cdf_(Ccrit, k);
                    
                    if alpha < 1e-8
                        alpha = 0;
                    end
                    
                    result.alpha = alpha;
                    result.Ccrit = Ccrit;
                    %result.levelCritical = Ccrit;
                end
            end
            % end of beta_error function
        end

        
        function res = preprocess(self, XTest1)
            %apply preprocessing defind by the model to the new set
            XTest = XTest1;
            if ~isempty(self.Model.TrainingSet_mean)
                XTest = bsxfun(@minus, XTest, self.Model.TrainingSet_mean);
            end
            if ~isempty(self.Model.TrainingSet_std)
                XTest = bsxfun(@rdivide, XTest, self.Model.TrainingSet_std);
            end
            res = XTest;
        end

   end


end