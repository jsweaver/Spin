# Spin
Spherical nanoindentation stress-strain analysis

## Please read [Spherical Nanoindentation Stress-Strain Analysis in MATLAB.pdf](https://github.com/jsweaver/Spin/blob/master/Spherical%20Nanoindentation%20Stress-Strain%20Analysis%20in%20MATLAB.pdf) for an introduction to the code. ##

## Helpful References: ##

(1) Kalidindi and Pathak. (2008) Acta Materialia.                     http://dx.doi.org/10.1016/j.actamat.2008.03.036  
(2) Vachhani et al. (2013) Acta Materialia.                           http://dx.doi.org/10.1016/j.actamat.2013.03.005  
(3) Pathak and Kalidindi. (2015) Materials Science and Engineering R. http://dx.doi.org/10.1016/j.mser.2015.02.001  
(4) Weaver et al. (2016) Acta Materialia. (Supplemental Material)     http://dx.doi.org/10.1016/j.actamat.2016.06.053  

## Purpose and Intended Use: ##

The main reason for writing this code was to make the determination of the zero-point correction and indentation stress-strain curves more robust by semi-automating the analysis, developing metrics for determining appropriate answers, and providing some estimate of the uncertainty 

of the appropriate answer including measurements from the indentation stress-strain curve (e.g. indentation yield strength). 

The intended use is that the user would select a representative answer for each test and include the statistics of multiple appropriate answers for one test when determining the final answer, values, or properties. 

## Short Discription of Functions ##

**RunME.m** - load, analyze, plot, save data with this script. Most of the parameters which require adjusting are set in this script.

**LoadTest.m** - imports nanoindentation in excel format. Important to set/check the indenter properties, the "End of Test" marker, and correct columns of raw data. CSM corrections are also calculated in here.

**smoothstrain.m** - applies a moving average to the hardening fit stress-strain data. Not always used.

**filterResults.m** - cuts down the results based on different criteria. A new criterion can be added by coping the 'case' logic used for other variables.

**CalcStressStrainWithYield.m** - here is where the indentation stress-strain curve is calculated

**FindYield_v2.m** - function for determining the yield point and hardening slopes.

**FindYieldStart.m** - function for determining if a pop-in occurs and some markers needed for determining the yield point

**MyPlotSearch.m** - plotting function for the 3-D scatter plot of the results. In order to change the axes of the 3-D plot, modify this code and in SearchExplorer.m

**NIAnalyzeSearch.m** - this function does the zero=point and modulus regression analyses. It gets called many times so try not to add more to it. A speed up in computation might come from better coding with this function and the sub functions it calls.

**MyHistSearch.m** - plotting function for histograms of relevant variables in the results. Viewing this data can be helpful for updating the filter to determine the results.

**SearchExplorer.m** - interactive plotting function for the 3D scatter plot for the results. *Important* - the scaling of the indentation stress-strain curve plot is done manually because it always causes problems. Find the variables: mstrain and mstress and adjust accordingly.

**subslider.m** - creates a subplot of historgrams for many vairables. A NewFilt variable can be created based on the slider values of all the variables in the plot.

**MyHistResults.m** - spits out the statistics for indentation properties for the saved analyses.

Shouldn't have to touch these...

**Driver.m**  
**SingleSearchAllSegments.m**  
**mypolyfit.m**  
**rsquare.m**  
