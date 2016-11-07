function [TestData] = LoadTest(filename, sheet, radius, vs, skip, CSM)

[num, txt] = xlsread(filename, sheet);

TestData.Filename = filename;
TestData.Sheet = sheet;
TestData.StiffnessSegmentStart = NaN;
TestData.LoadSegmentEnd = NaN;
TestData.Data = NaN;
TestData.IndenterRadius = radius;
TestData.nui = 0.07; % Poisson's ratio of indenter, 0.07 for diamond
TestData.Ei = 1140; % Young's modulus of indenter, 1140 GPa for diamond
TestData.nus = vs;
TestData.skip = skip;

if isempty(num)
    warning('%s contains no data', sheet);
    return
end

% Finds where unloading starts
HoldSegmentII = size(num, 1); 
for ii=1:size(txt,1) 
    if strcmpi(txt(ii), 'Hold Segment Type') == 1 % e.g., 'End Of Loading Marker' the exact text depends on the version of NanoSuite
        HoldSegmentII=ii-2; 
        break; 
    end
end

T = num(1:HoldSegmentII, 1:6); % num columns 1:6 are loaded

TestData.LoadSegmentEnd = HoldSegmentII;
if CSM == 1; % apply CSM corrections
    h = T(:,2) + T(:,5).*sqrt(2);           % displacement(nm)
    P = T(:,3) + T(:,6).*sqrt(2).*10^-3;    % Load (mN)
    S0 = T(:,4);                            % Harmonic Stiffness (N/m)
    S1 = S0./1e6;                           % To convert S from N/m into mN/nm
    K = 0.6524;
    m = 1.5;
    S2 = 1/sqrt(2*pi).*P./T(:,5).*(1/K)^(1/m) .* (1 - (1 - 2*sqrt(2).*T(:,5).*S1./P).^(1/m));
    
    % find the last imaginary data point for S2.
    im = imag(S2);
    imd = find(im~=0,1,'last');
    if isempty(imd) == 1
        imd = 0;
    end
    TestData.StiffnessSegmentStart = imd +1;
    
    T(1:end, 7:9) = [h, P, S2];
end

if CSM == 0; % no CSM corrections
    TestData.StiffnessSegmentStart = 1;
    T(1:end, 7:8) = T(:, 2:3);
    T(1:end, 9) = T(:,4)./1e6;  % To convert S from N/m into mN/nm
end

if CSM == 2; % only h and P CSM corrections
    TestData.StiffnessSegmentStart = 1;
    h = T(:,2) + T(:,5).*sqrt(2);           % displacement(nm)
    P = T(:,3) + T(:,6).*sqrt(2).*10^-3;    % Load (mN)
    S0 = T(:,4);                            % Harmonic Stiffness (N/m)
    S1 = S0./1e6;                           % To convert S from N/m into mN/nm
    T(1:end, 7:9) = [h, P, S1];
end

TestData.Data = T;

end



