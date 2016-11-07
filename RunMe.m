% This script is used to change variables and run the main functions for the analysis 
% Please see ReadMe.txt before begining
% Errors often occur when...
    % 1)trying to load data that doesn't exist or is in the wrong format
    % 2)there are no answers left over after filtering
    
%% Step 1. Load data and perform zero-point and modulus regression analyses for a large array of segments
clc
folder = [];      % e.g., 'C:\folder\subfolder\', requires \ at the end
file = 'Example_Test.xlsx'; % use appropriate .xls or .xlsx
                            % excel file should have segment type, time, displacement, load, harmonics
                            % stiffness, harmonic displacement, and harmonic load in that order
tnum = '1';                 % used for saving and reading the test number
sheet = ['Test 00', tnum];  % name of sheet in file, add or remove a zero depending on tnum

seg_sizes = [20:20:500]; % an array of segment sizes for which to analyze, use a minimum number for speed
SearchSegEnd = 1500;                % cut off no. of data points, analyzes data up to this value 
                                    % SearchSegEnd must be <= EndLoadSegment Marker in raw data or an error will occur

Rind = 100000;        % indenter radius in nm, ie. 100000 (100um), 16500 (16.5um)
vs = 0.3;           % sample Poisson ratio, only matters if you want to compute the sample modulus
skip = [0.3 0.1];   % aborts and skips over any analysis with Fit1 R2 < skip(1) AND length(Fit2)/length(Fit1) < skip(2)
                    % modulus also has to be real value
CSM = 0;            % choose whether to apply CSM corrections (CSM = 1) or not (CSM = 0) or just Pact and hact (CSM = 2)
                    % these are based on Vachhani et al. (2013) Acta Materialia http://dx.doi.org/10.1016/j.actamat.2013.03.005

% Zero-point and modulus regression analysis of a single test
[TestData, FitResults] = Driver([folder, file], sheet, Rind, vs, seg_sizes, skip, CSM, SearchSegEnd);
    % Fit Results contains all the regression analyses
    % TestData contains the raw and CSM corrected data

%% Step 2. Filter down FitResults based on different criteron

% see filterResults.m for a full list of Filt 'variables' and [value formats]
% anything you want can be added as long as it is saved in FitResults
Filt ={...
    'Modulus', [300 340];...
    'R21', [0.7 1.0];...
    'R22', [0.7 1.0] ;...
    'R23', [0.7 1.0];...
%     'P*', 0.1;... 
%     'h*', 15;...
    'dP', [-0.5 0.5];... 
    'dH', [-0.5 0.5];... 
    'h_change', [-0.7 0.7];....
    };

bins = 20; % number of bins for the historgram plots

% Plastic contains all the parameters for determing yield strength (Yind) and
% hardening fits. These are not standardized. See FindYieldStart.m and
% FindYield_v2.m for details of variables and calculations.

Plastic.method = 'linear';          % method for finding Yind, see FindYield_v2.m for details and options
Plastic.YS_offset = 0.002;          % offset strain for Yind
Plastic.H_offset = [0.003 0.02];    % offset strains for first hardneing fit
Plastic.H_offset2 = 0.25;           % max offset strain for 2nd hardening fit (start of fit is the end of the first hardening fit)
Plastic.YS_window = [0 4];          % +/- faction of YS_offset in which to calc median stress and strain
Plastic.pop_in = Inf;               % threshold strain burst to consider a pop-in, use Inf to ignore this
                                    % if a pop-in is recorded, Yind is then determined from a back-extrapolation,
Plastic.pop_window = 3;             % number of data points for calculating strain burst (i.e. n+3 - n)
Plastic.C_dstrain = 0;              % tuning variable for the start of the back-extrapolation after a pop-in
Plastic.smooth_window = 0;          % +/- number of points for movering average on strain, used for hardening fits, use 0 to ignore

BEuler=[0 0 0]';                    % bunge-euler angles, shows up on plots, useful when doing single grain indents

Plastic.Eassume = 0;                % forced Young's modulus for determing the contact radius, use 0 to ignore
                                    % this will alter the indentation stress-strain curve, only recomended for troubleshooting

% Filters through FitResults and plots histograms of SearchResults and 3-D interactive plot for selecting an answer
[SearchResults, npoints, HistSearchResults] = SearchExplorer(TestData, FitResults, Filt, Plastic, BEuler, bins);

% 3-D interactive plot instructions
    % click on any point in Figure (1), then click on the "Plot ISS Analysis" button to see the answer
    % recording this answer, click on "Save FR & ISS"
    % recording all the answer, click on "Save All ISS" 
%% Step 2.2 after you have NewFilt

[SearchResults, npoints, HistSearchResults] = SearchExplorer(TestData, FitResults, NewFilt, Plastic, BEuler, bins);


%% Step 3. Save your work as .mat and .png
% you must 
    % (1) Calculate the stress-strain curves for all the SearchResults you see as acceptable answers. Click on the "Save All ISS" button in Figure 1
    % (2) Select, calculate, and plot a single representative answer. Click on "Save FR & ISS" button to save the currently selected data point. 
    %     Keep the plot for this answer up, Click on "Plot ISS Analysis"
    %     and close all the other figures.

% computes the statistics of the indentation properties for the SearchResults
[Estat, Ystat, Hstat, Hstat2] = MyHistResults(SearchResults, Stress_Strain_Search_Results)

% save workspace and the ISS plot in the same folder as the raw data
% caution!!! this will overwrite data if files with the same name already exists
save([folder,'Analysis ' tnum])           % saves your entire workspace
set(gcf,'PaperPositionMode','auto')       % makes the plots full screen
saveas(gcf,[folder, 'ISS ' tnum], 'png')  % grabs the current plot, close others you don't want
