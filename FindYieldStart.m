function [Plastic_window, Pop] = FindYieldStart(Stress, Strain, end_segment, E_ind, Plastic)

% checks to see if there is a pop-in based on a strain jump
% determines the indices for yield point and hardening fits


Plastic_window.max_point = NaN;
Plastic_window.max_point2 = NaN;
Plastic_window.min_point = NaN;
Plastic_window.popsuccess = NaN;        % 0 when there is a pop-in detected, 1 for no pop-in
Plastic_window.Hsuccess = NaN;          % 0 when there is enough data for the offsets used, 1 when there is not
Plastic_window.Hsuccess2 = NaN;         % 0 when there is enough data for the offsets used, 1 when there is not
Plastic_window.yield_win_indices = NaN; % yield point window indices calculated in FindYield.m

% Pop-in stresses, strains, and indices
Pop.Stress = NaN;
Pop.Strain = NaN;
Pop.index = NaN;
Pop.Stress_after = NaN;
Pop.Strain_after = NaN;
Pop.index_after = NaN;

% check for pop-in
end_search = length(Strain) - Plastic.smooth_window; % limit search so that smoothstrain.m will not give errors
pop_window = Plastic.pop_window;
change = Strain(end_segment+pop_window:end_search) - Strain(end_segment:end_search-pop_window); % change in strain between n+3 and n
% change has the same indexing as Strain only without the last three points
pindex = find(change > Plastic.pop_in, 1); %pop-in threshold, first occurence, pindex is the first point, n, in the pop-in from n:n+3
popsuccess = isempty(pindex);
Plastic_window.popsuccess = popsuccess; 

% determine min_point
if popsuccess==0 % pop-in detected
    stress_index = pindex -1 + end_segment;
    Pop.index = [stress_index:stress_index+pop_window];
    Pop.Stress = Stress(Pop.index);
    Pop.Strain = Strain(Pop.index);
    [~, k] = min(Stress(stress_index:end_search));  % find the minimum stress after the pop-in, can limit the search to right after the pop-in
    min_stress_index = k -1 + stress_index;         % put the index back to the same indexing as Stress

    dstrain = Plastic.C_dstrain * (Strain(stress_index + pop_window) - Strain(min_stress_index));
        % C_dstrain = 0, starts fit immediately after the popin
        % C_dstrain = 1, starts fit as soon as the strain is greater than the strain at the pop-in cliff
        % the initial recovery after a pop-in is very high, this may or may not
        % be desirable for the back extrapolation
    mind_point = find(Strain(min_stress_index:end_search) > (Strain(stress_index + pop_window) - dstrain), 1);  % start of back extrapolation fit
    min_point = mind_point -1 + min_stress_index;                                                               % put the indexing back to the same as Stress and Strain
    Pop.Stress_after = Stress(min_point);
    Pop.Strain_after = Strain(min_point);
    Pop.index_after = min_point;
else
    % use offset strain to find the start of the hardening fit
    f1 = E_ind .* (Strain(end_segment:end_search) - Plastic.H_offset(1));   % offset line using modulus slope
    mind_point = find ( (f1 - Stress(end_segment:end_search)) > 0, 1 );     % first point after the offset line
    min_point = mind_point -1 + end_segment;                                % put the indexing back to the same as Stress and Strain
end

% determine max_point and max_point2
f2 = E_ind .* (Strain(end_segment:end_search) - Plastic.H_offset(2));       % offset line using modulus slope
i2 = find ( (f2 - Stress(end_segment:end_search)) > 0, 1 );                 % first point after the offset line
success_i2 = isempty(i2);
Plastic_window.Hsuccess = success_i2;                                       % indicates whether there is enough data to reach the specifed offset

if success_i2 == 0; % there is enough data
    max_point = i2 -1 + end_segment;                                        % end of back extrapolation/hardening fit
    % find the last data point based on another offset strain
    f3 = E_ind .* (Strain(end_segment:end_search) - Plastic.H_offset2);     % offset line using modulus slope
    i3 = find ( (f3 - Stress(end_segment:end_search)) > 0, 1 );             % first point after the offset line
    success_i3 = isempty(i3);
    Plastic_window.Hsuccess2 = success_i3;                                  % indicates whether there is enough data to reach the specifed offset
    
    if success_i3 == 0; % there is enough data
        max_point2 = i3 - 1 + end_segment;
    else % not enough data
        max_point2 = end_search; %end of data
    end
else % not enough data
    max_point = end_search; % end of data
    max_point2 = NaN;
    Plastic_window.H_success2 = NaN;
end

% These are the indices for the two hardening fits
% H1 (min_point:max_point) and H2 (max_point:max_point2)
Plastic_window.max_point = max_point;
Plastic_window.max_point2 = max_point2;
Plastic_window.min_point = min_point;


end