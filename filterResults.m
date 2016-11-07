function [GoodR, numResults] = filterResults(FR, fil)

% fil is a cell array with a string and number
% number is always listed lower bound, upper bound
% each row is a new fil
% column 1 is the text, column 2 is the number or two number array

% all the variables which can be used are calculated and saved in
% FitResults

% pay close attention to how the rqsuared and residuals are calculated in
% rsquare.m and how rsquare.m is used. Sometimes the y-intercept is not
% used in order to measure the goodness of fit forced through the origin.

p = length(FR);
[m, ~]= size(fil);
numResults = zeros(m+1,1);
numResults(1) = p;

for ii = 1:m
    switch fil{ii,1}
        case 'R21'              % r-squared of the zero point regression
            Fit1 = [FR.Fit1];  
            GoodR = FR([Fit1.Rsquared] >= fil{ii,2}(1) & [Fit1.Rsquared] <= fil{ii,2}(2));
        case 'AAR1'             % average absolute residual of zero point regression
            Fit1 = [FR.Fit1];   
            GoodR = FR([Fit1.AverageAbsoluteResidual] >= fil{ii,2}(1) & [Fit1.AverageAbsoluteResidual] <= fil{ii,2}(2));
        case 'MAR1'             % maximum absolute residual of zero point regression
            Fit1 = [FR.Fit1];   
            GoodR = FR([Fit1.MaxAbsoluteResidual] >= fil{ii,2}(1) & [Fit1.MaxAbsoluteResidual] <= fil{ii,2}(2));
        case 'R22'              % r-squared of the modulus regression
            Fit2 = [FR.Fit2];   
            GoodR =FR([Fit2.Rsquared] >= fil{ii,2}(1) & [Fit2.Rsquared] <= fil{ii,2}(2));
        case 'AAR2'             % average absolute residual of modulus regression
            Fit2 = [FR.Fit2];   
            GoodR = FR([Fit2.AverageAbsoluteResidual] >= fil{ii,2}(1) & [Fit2.AverageAbsoluteResidual] <= fil{ii,2}(2));
        case 'MAR2'             % maximum absolute residual of modulus regression
            Fit2 = [FR.Fit2];  
            GoodR = FR([Fit2.MaxAbsoluteResidual] >= fil{ii,2}(1) & [Fit2.MaxAbsoluteResidual] <= fil{ii,2}(2));
        case 'Modulus'          % effective modulus, E_eff or E^*
            GoodR = FR([FR.E_star] >= fil{ii,2}(1) & [FR.E_star] <= fil{ii,2}(2));
        case 'R23'              % r-squared of the elastic indentation stress-strain data
            Fit3 = [FR.Fit3];
            GoodR = FR([Fit3.Rsquared] >= fil{ii,2}(1) & [Fit3.Rsquared] <= fil{ii,2}(2));
        case 'Hr'               % residual displacement, from the modulus regression
            Fit2 = [FR.Fit2];
            GoodR = FR([Fit2.y_intercept] >= fil{ii,2}(1) & [Fit2.y_intercept] <= fil{ii,2}(2));
        case 'ModLength'        % number of data points for the modulus regression
            GoodR = FR([FR.modulus_length] >= fil{ii,2}(1) & [FR.modulus_length] <= fil{ii,2}(2));
                                % only needs a lower bound
        case 'h_change'         % normalized displacement between the start of the zero-point segment and the first positive point after the zero-point correction is applied
            GoodR = FR([FR.h_change] >= fil{ii,2}(1) & [FR.h_change] <= fil{ii,2}(2));
        case 'p_change'         % normalized load between the start of the zero-point segment and the first positive point after the zero-point correction is applied
            GoodR = FR([FR.p_change] >= fil{ii,2}(1) & [FR.p_change] <= fil{ii,2}(2));
        case 'dP'               % load difference between the first modulus regression data point and the origin 
            GoodR = FR([FR.dP] >= fil{ii,2}(1) & [FR.dP] <= fil{ii,2}(2));
        case 'dH'               % displacement difference between the first modulus regression data point and the origin 
            GoodR = FR([FR.dH] >= fil{ii,2}(1) & [FR.dH] <= fil{ii,2}(2));
        case 'AAR4'             % average absolute residual between the modulus line and elastic stress-strain data
            Fit4 = [FR.Fit4];
            GoodR = FR([Fit4.AverageAbsoluteResidual] >= fil{ii,2}(1) & [Fit4.AverageAbsoluteResidual] <= fil{ii,2}(2));
        case 'MAR4'             % average absolute residual between the modulus line and elastic stress-strain data
            Fit4 = [FR.Fit4];
            GoodR = FR([Fit4.MaxAbsoluteResidual] >= fil{ii,2}(1) & [Fit4.MaxAbsoluteResidual] <= fil{ii,2}(2));
        case 'h*'               % zero-point displacement correction, from zero-point regression
            GoodR = FR([FR.h_star] >= fil{ii,2}(1) & [FR.h_star] <= fil{ii,2}(2));
        case 'P*'               % zero-point load correction, from zero-point regression   
            GoodR = FR([FR.P_star] >= fil{ii,2}(1) & [FR.P_star] <= fil{ii,2}(2));
        case 'ModStart'         % position of first data point in the modulus regression
            GoodR = FR([FR.modulus_start] >= fil{ii,2}(1) & [FR.modulus_start] <= fil{ii,2}(2));
        case 'SegStart'         % position of first data point in the zero point regression
            GoodR = FR([FR.segment_start] >= fil{ii,2}(1) & [FR.segment_start] <= fil{ii,2}(2));

    end
    numResults(ii+1) = length(GoodR);
    FR = GoodR;
end
end