function [Estat, Ystat, Hstat, Hstat2] = MyHistResults(SR, SSR)

% other variables can be added such as the zero-point correction

E = [SR.E_sample];  % Sample modulus

Estat.mean = mean(E);
Estat.median = median(E);
Estat.stdev = std(E);
Estat.min = min(E);
Estat.max = max(E);

YS = [SSR.Yield_Strength]; % Indentation yield strength

Ystat.mean = mean(YS);
Ystat.median = median(YS);
Ystat.stdev = std(YS);
Ystat.min = min(YS);
Ystat.max = max(YS);

H = [SSR.H_ind];  % First hardening slope

Hstat.mean = mean(H);
Hstat.median = median(H);
Hstat.stdev = std(H);
Hstat.min = min(H);
Hstat.max = max(H);

H2 = [SSR.H_ind2]; % Second hardening slope

Hstat2.mean = mean(H2);
Hstat2.median = median(H2);
Hstat2.stdev = std(H2);
Hstat2.min = min(H2);
Hstat2.max = max(H2); 

end

