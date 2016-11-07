function [h, SearchResults, num_points] = MyPlotSearch(FR, filt)

%% Filter FR
[SearchResults, num_points] = filterResults(FR, filt);

Fit4 = [SearchResults.Fit4];

%% 3D scatter plot w/ colorbar (4 variabless)
% x y z, color
% maybe use 'patch' for large dataset plots
% the variables used for scatter3 must match the variables in SearchExplorer.m 
% e.g. index = find(p(1) == [Fit4.AverageAbsoluteResidual] & p(2) == [FR.E_star] & p(3) == [FR.h_change], 1, 'first');

h = scatter3([Fit4.AverageAbsoluteResidual], [SearchResults.E_star], [SearchResults.h_change],10, [Fit4.MaxAbsoluteResidual], 'filled');
cmap=[1 0 0; 1 1 0; 0 1 0; 0 1 1; 0 0 1];
colormap(cmap);
t = colorbar;
set(get(t,'ylabel'),'string','Fit4 Max Abs Residual','FontWeight', 'Bold');
grid on;  
xlabel('Fit4 Average Abs Residual', 'FontWeight', 'Bold');
ylabel('E_e_f_f', 'FontWeight', 'Bold');
zlabel('h-change', 'FontWeight', 'Bold');
axis square;

end