
function StressStrainResults = CalcStressStrainWithYield(TestData, SR, Plastic)

    StressStrainResults.contact_radius = NaN;       % contact radius, nm
    StressStrainResults.Stress = NaN;               % indentation stress, GPa
    StressStrainResults.Strain = NaN;               % indentation strain
    StressStrainResults.Yield_Strength = NaN;       % indentation yield strength, GPa
    StressStrainResults.Yield_Strain = NaN;         % indentation stain at yield, used for plots
    StressStrainResults.Hardening = NaN;            % hardening fits GPa/ nm/nm
    StressStrainResults.HardeningStartEnd = NaN;    % indicies for hardening fits
    StressStrainResults.h_new = NaN;                % zero-point corrected displacement, nm
    StressStrainResults.P_new = NaN;                % zero-point corrected load, mN
    StressStrainResults.popin_YN = NaN;             % indication if a pop-in is detected, 0 = pop-in, 1 = no pop-in
    StressStrainResults.fullH_YN = NaN;             % indication if there was enough data for the desired hardening fits, 0 = yes, 1 = no
    StressStrainResults.PopinStressStrain = NaN;    % stress and strains related to the pop-in event
    StressStrainResults.h_sample = NaN;             % the sample displacement corrected for the elastic displacment of the tip, used for indentation strain, nm
    StressStrainResults.E_ind = NaN;                % indentation modulus, GPa, not the sample or effective modulus
    StressStrainResults.H_ind = NaN;                % indentation work hardening for first fit
    StressStrainResults.H_ind2 = NaN;               % indentation work hardening for second fit
    
    
    h = TestData.Data(:,7); % displacement(nm)
    P = TestData.Data(:,8); % Load (mN)
    S = TestData.Data(:,9); % Harmonic Stiffness (mN/nm)
    % note these may or may not be harmonic corrected depending on CSM variable, see LoadTest.m

    h_star = SR.h_star;
    P_star = SR.P_star;
    
    h_new = h-h_star;  % total Displacement (nm)
    P_new = P-P_star;  % load (mN)
    StressStrainResults.h_new = h_new;
    StressStrainResults.P_new = P_new;
    
    if Plastic.Eassume == 0; % uses the modulus regression analysis value for calculation of indentation stress-strain curve
        E_star = SR.E_star;
    else % if you want to force a modulus for the calculation of the stress-strain curve, not recommended
        E_sample = Plastic.Eassume; % assumed Young's modulus, GPa
        E_star = ((1-TestData.nui^2)/TestData.Ei + (1-TestData.nus^2)/E_sample)^-1;
    end
            
    a = S./(2*E_star)*1e6;  % contact radius (nm)
    StressStrainResults.contact_radius = a;
    % he = 3/2*P_new./S;      % elastic displacement, (nm)
    % R_star = a.^2/he;       % effective radius, (nm)
    
    vi = TestData.nui; % indenter Poisson's ratio
    Ei = TestData.Ei;  % indenter Young's modulus
    
    hi = 3/4*(1-vi^2)/Ei*P_new./a.*10^6; % elastic displacement of the indenter tip (nm)
    
    h_sample = h_new - hi;                      % sample displacement corrected for the elastic displacement of the indenter tip
    StressStrainResults.h_sample = h_sample;    % used for calculation of indentation strain
    
    E_ind = (1/E_star - (1-vi^2)/Ei)^-1;        % indentation modulus (GPa)
    StressStrainResults.E_ind = E_ind;
    Stress = P_new./(pi*a.^2)*1e6;  % indentation stress, GPa
    Strain = 4/(3*pi)*h_sample./a; % indentation strain, this is strain corrected for the indenter tip displacement
    StressStrainResults.Stress = Stress;
    StressStrainResults.Strain = Strain;
    
    % Yeild calculation
    SegmentEnd = SR.segment_end; % end of zero-point and modulus regression segments
    [Plastic_window, Pop] = FindYieldStart(Stress, Strain, SegmentEnd, E_ind, Plastic);
    [yield_stress, yield_strain, Hardening, Plastic_window] = FindYield_v2(Stress, Strain, SegmentEnd, Plastic_window, E_ind, Plastic);

    StressStrainResults.Yield_Strength = yield_stress;
    StressStrainResults.Yield_Strain = yield_strain;
    StressStrainResults.YieldStartEnd = Plastic_window.yield_win_indices;
    StressStrainResults.Hardening = Hardening;
    StressStrainResults.H_ind = Hardening(1);
    StressStrainResults.H_ind2 = Hardening(3);
    StressStrainResults.HardeningStartEnd = [Plastic_window.min_point; Plastic_window.max_point; Plastic_window.max_point2];
    StressStrainResults.popin_YN = Plastic_window.popsuccess; 
    StressStrainResults.fullH_YN = [Plastic_window.Hsuccess; Plastic_window.Hsuccess2];
    StressStrainResults.PopinStressStrain = Pop; 
end