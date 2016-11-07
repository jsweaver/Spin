function [yield_stress, yield_strain, har, Plastic_window] = FindYield_v2(Stress, strain, segment_end, Plastic_window, E_ind, Plastic)

% calculates the yield point based on two outcomes:
% Outcome 1 (when a pop-in is detected): the intersection of a back extrapolated linear fit in the post elastic regime with an offset modulus line. 
% Outcome 2 (no pop-in detected): different options are avaialbe for the offset yield strength
%
% also calculates linear work hardening fits

plastic_start = Plastic_window.min_point;
plastic_end = Plastic_window.max_point;
plastic_end2 = Plastic_window.max_point2;

% smoothed for hardening/back extrapolation fit
SStrain = smoothstrain(plastic_start, plastic_end, strain, Plastic.smooth_window);
% Strain should be the same size as strain

% 1st hardening/ back extrapolation linear fit
p = mypolyfit(SStrain, Stress(plastic_start:plastic_end),1);
a = p(1); % hardening slope
b = p(2); % y-intercept

% 2nd hardening fit
if isnan(Plastic_window.Hsuccess2) == 0;
    SStrain2 = smoothstrain(plastic_end, plastic_end2, strain, Plastic.smooth_window);
    p2 = mypolyfit(SStrain2, Stress(plastic_end:plastic_end2),1);
    a2 = p2(1); % hardening slope
    b2 = p2(2); % y-intercept
else
    a2 = NaN;
    b2 = NaN;
end

har = [a, b, a2, b2]; % linear hardening fits


if Plastic_window.popsuccess==0 % pop-in occured, use back extrapolated method
    % intersection of offset line and back extrapolated line
    yield_strain = (E_ind*Plastic.YS_offset + p(2)) / (E_ind - p(1));
    yield_stress = E_ind*(yield_strain - Plastic.YS_offset);
    Plastic_window.yield_win_indices = [NaN NaN];
    
else % no pop-in, 
    % use the modulus slope and YS_window to define two offset lines (f1 and f2) which
    % are used for the Yind calculation
    c1 = 1 - Plastic.YS_window(1);  c2 = 1 + Plastic.YS_window(2); 
    f1 = E_ind .* (strain(segment_end:end) - c1 * Plastic.YS_offset);
    f2 = E_ind .* (strain(segment_end:end) - c2 * Plastic.YS_offset);

    windmin = find ( (f1 - Stress(segment_end:end)) < 0, 1, 'Last');
    windmax = find ( (f2 - Stress(segment_end:end)) < 0, 1, 'Last');

    in1 = segment_end + windmin - 1;
    in2 = segment_end + windmax - 1;
    
    Yield_Strain = strain (in1 : in2); % all values in the window
    Yield_Stress = Stress (in1 : in2);
    Plastic_window.yield_win_indices = [in1 in2];
    
    % different methods for determining offset yield strength
    switch Plastic.method
        case 'max'      % maximum stress inside the window
            yield_strain = max (Yield_Strain); 
            yield_stress = max (Yield_Stress);
        case 'median'   % median stress inside the window       
            yield_strain = median (Yield_Strain); 
            yield_stress = median (Yield_Stress);
        case 'linear'   % linear fit fo data inside window and intersection with YS offset line
            p3 = mypolyfit(Yield_Strain, Yield_Stress,1);
            xx = strain(segment_end:end);
            intX(1) = (p3(2) + E_ind*(Plastic.YS_offset))/(E_ind - p3(1));
            intX(2) = p3(1)*intX(1) + p3(2);
            yield_strain = intX(1); 
            yield_stress = intX(2);
        case 'mean'     % mean stress inside the window
            yield_strain = mean (Yield_Strain); 
            yield_stress = mean (Yield_Stress);
    end
    
end

end