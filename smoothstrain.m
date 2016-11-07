function y = smoothstrain(mnpt, mxpt, S, jj)

% function applies moving average to variable S over mnpt:maxpt
% assuming S has data to the left and right of mnpt and mxpt which can be
% used in the calculation of moving average

% j is +/- window for average
sumab = 0;
for ii = 1:jj
    sa = S(mnpt+ii:mxpt+ii);    % S(mnpt:mxpt) shifted by +ii
    sb = S(mnpt-ii:mxpt-ii);    % S(mnpt:mxpt) shifted by -ii
    scount = sa + sb;           % sum of S shifts
    sumab = scount + sumab;     % sum up S shifts for each iteration
end

y = (S(mnpt:mxpt) + sumab)/ (2*jj+1);
% avearge of S
